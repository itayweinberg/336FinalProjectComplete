<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add, Edit, or Delete Users</title>
</head>
<body>
    <h2>Add, Edit, or Delete Users</h2>

    <form action="adminEditUser.jsp" method="POST">
        <label for="choice">Would you like to add, edit information, or delete a customer representative or customer?</label>
        <select name="choice" id="choice">
            <option value="Add">Add</option>
            <option value="Edit">Edit</option>
            <option value="Delete">Delete</option>
        </select><br><br>
        <input type="submit" value="Modify Database">
    </form>


<%
    String choice = request.getParameter("choice");

    if (choice != null && !choice.isEmpty()) {
        if (choice.equals("Add")) {
%>
            <form action="adminEditUser.jsp" method="POST">
                <input type="hidden" name="choice" value="Add"/>
                <label for="accountNum">Enter account number:</label>
                <input type="text" id="accountNum" name="accountNum"><br><br>
                <label for="firstName">Enter first name:</label>
                <input type="text" id="firstName" name="firstName"><br><br>
                <label for="lastName">Enter last name:</label>
                <input type="text" id="lastName" name="lastName"><br><br>
                <label for="username">Enter username:</label>
                <input type="text" id="username" name="username"><br><br>
                <label for="password">Enter password:</label>
                <input type="text" id="password" name="password"><br><br>
                <label for="ssn">Enter ssn:</label>
                <input type="text" id="ssn" name="ssn"><br><br>
                <div id="role">
					Choose role:
		    		<select name="role">
		        		<option value="Customer">Customer</option>
		        		<option value="Representative">Representative</option>
		    		</select><br>
				</div>
                <input type="submit" value="Submit">
            </form>

<%
            String accountNum = request.getParameter("accountNum");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String ssn = request.getParameter("ssn");
            String role = request.getParameter("role");

            if (accountNum != null && !accountNum.isEmpty()
            && firstName != null && !firstName.isEmpty()
            && lastName != null && !lastName.isEmpty()
            && username != null && !username.isEmpty()
            && password != null && !password.isEmpty()
            && ssn != null && !ssn.isEmpty()
            && role != null && !role.isEmpty() ) {

                Connection con = null;
                PreparedStatement ps = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

                    String query = "INSERT INTO Account (Account_Number, First_Name, Last_Name, Username, Password, SSN, Role) VALUES (?, ?, ?, ?, ?, ?, ?)";

                    ps = con.prepareStatement(query);
                    ps.setString(1, accountNum);
                    ps.setString(2, firstName);
                    ps.setString(3, lastName);
                    ps.setString(4, username);
                    ps.setString(5, password);
                    ps.setString(6, ssn);
                    ps.setString(7, role);
                    ps.executeUpdate();
                    
                    stmt = con.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM Account");

                    out.println("<h3>Here's the updated table:</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Account Number</th><th>First Name</th><th>Last Name</th><th>Username</th><th>Password</th><th>SSN</th><th>Role</th></tr>");

                    while (rs.next()) {
                        String Account_Number = rs.getString("Account_Number");
                        String First_Name = rs.getString("First_Name");
                        String Last_Name = rs.getString("Last_Name");
                        String Username = rs.getString("Username");
                        String Password = rs.getString("Password");
                        String SSN = rs.getString("SSN");
                        String Role = rs.getString("Role");

                        out.println("<tr>");
                        out.println("<td>" + Account_Number + "</td>");
                        out.println("<td>" + First_Name + "</td>");
                        out.println("<td>" + Last_Name + "</td>");
                        out.println("<td>" + Username + "</td>");
                        out.println("<td>" + Password + "</td>");
                        out.println("<td>" + SSN + "</td>");
                        out.println("<td>" + Role + "</td>");
                        out.println("</tr>");
                    }

                    out.println("</table>");

                } catch (Exception e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (con != null) con.close();
                    } catch (SQLException e) {
                        out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
                    }
                }
            }

        } else if (choice.equals("Edit")) {
%>
            <form action="adminEditUser.jsp" method="POST">
            	<input type="hidden" name="choice" value="Edit"/>
                <label for="accountNum">Enter account number:</label>
                <input type="text" id="accountNum" name="accountNum"><br><br>
                <label for="firstName">Enter first name:</label>
                <input type="text" id="firstName" name="firstName"><br><br>
                <label for="lastName">Enter last name:</label>
                <input type="text" id="lastName" name="lastName"><br><br>
                <label for="username">Enter username:</label>
                <input type="text" id="username" name="username"><br><br>
                <label for="password">Enter password:</label>
                <input type="text" id="password" name="password"><br><br>
                <label for="ssn">Enter ssn:</label>
                <input type="text" id="ssn" name="ssn"><br><br>
                <div id="role">
					Choose role:
		    		<select name="role">
		        		<option value="Customer">Customer</option>
		        		<option value="Representative">Representative</option>
		    		</select><br>
				</div>
                <input type="submit" value="Submit">
            </form>

<%
            String accountNum = request.getParameter("accountNum");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String ssn = request.getParameter("ssn");
            String role = request.getParameter("role");

            if (accountNum != null && !accountNum.isEmpty()
            && firstName != null && !firstName.isEmpty()
            && lastName != null && !lastName.isEmpty()
            && username != null && !username.isEmpty()
            && password != null && !password.isEmpty()
            && ssn != null && !ssn.isEmpty()
            && role != null && !role.isEmpty() ) {

                Connection con = null;
                PreparedStatement ps = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

                    String query = "UPDATE Account SET First_Name = ?, Last_Name = ?, Username = ?, Password = ?, SSN = ?, Role = ? WHERE Account_Number = ?";
                    ps = con.prepareStatement(query);
                    ps.setString(1, firstName);
                    ps.setString(2, lastName);
                    ps.setString(3, username);
                    ps.setString(4, password);
                    ps.setString(5, ssn);
                    ps.setString(6, role);
                    ps.setString(7, accountNum);
                    ps.executeUpdate();
                    
                    stmt = con.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM Account");
                    
                    out.println("<h3>Here's the updated table:</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Account Number</th><th>First Name</th><th>Last Name</th><th>Username</th><th>Password</th><th>SSN</th><th>Role</th></tr>");

                    while (rs.next()) {
                        String Account_Number = rs.getString("Account_Number");
                        String First_Name = rs.getString("First_Name");
                        String Last_Name = rs.getString("Last_Name");
                        String Username = rs.getString("Username");
                        String Password = rs.getString("Password");
                        String SSN = rs.getString("SSN");
                        String Role = rs.getString("Role");

                        out.println("<tr>");
                        out.println("<td>" + Account_Number + "</td>");
                        out.println("<td>" + First_Name + "</td>");
                        out.println("<td>" + Last_Name + "</td>");
                        out.println("<td>" + Username + "</td>");
                        out.println("<td>" + Password + "</td>");
                        out.println("<td>" + SSN + "</td>");
                        out.println("<td>" + Role + "</td>");
                        out.println("</tr>");
                    }

                    out.println("</table>");

                } catch (Exception e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (con != null) con.close();
                    } catch (SQLException e) {
                        out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
                    }
                }
            }

        } else if (choice.equals("Delete")) {
%>
            <form action="adminEditUser.jsp" method="POST">
            	<input type="hidden" name="choice" value="Delete"/>
                <label for="custName">Enter account number:</label>
                <input type="text" id="accountNum" name="accountNum"><br><br>
                <input type="submit" value="Submit">
            </form>

<%
            String accountNum = request.getParameter("accountNum");

            if (accountNum != null && !accountNum.isEmpty()) {
                Connection con = null;
                PreparedStatement ps = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

                    String query1 = "DELETE FROM Reservations WHERE Account_Number = ?";
                    ps = con.prepareStatement(query1);
                    ps.setString(1, accountNum);
                    ps.executeUpdate();
                    ps.close();
                    
                    String query2 = "DELETE FROM Account WHERE Account_Number = ?";
                    ps = con.prepareStatement(query2);
                    ps.setString(1, accountNum);
                    ps.executeUpdate();
                    
                    stmt = con.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM Account");

                    out.println("<h3>Here's the updated table:</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Account Number</th><th>First Name</th><th>Last Name</th><th>Username</th><th>Password</th><th>SSN</th><th>Role</th></tr>");

                    while (rs.next()) {
                        String Account_Number = rs.getString("Account_Number");
                        String First_Name = rs.getString("First_Name");
                        String Last_Name = rs.getString("Last_Name");
                        String Username = rs.getString("Username");
                        String Password = rs.getString("Password");
                        String SSN = rs.getString("SSN");
                        String Role = rs.getString("Role");

                        out.println("<tr>");
                        out.println("<td>" + Account_Number + "</td>");
                        out.println("<td>" + First_Name + "</td>");
                        out.println("<td>" + Last_Name + "</td>");
                        out.println("<td>" + Username + "</td>");
                        out.println("<td>" + Password + "</td>");
                        out.println("<td>" + SSN + "</td>");
                        out.println("<td>" + Role + "</td>");
                        out.println("</tr>");
                    }

                    out.println("</table>");

                } catch (Exception e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (con != null) con.close();
                    } catch (SQLException e) {
                        out.println("<p>Error: " + e.getMessage() + "</p>");
                    }
                }
            }
        }
    }
    %>

    <br><a href="adminHome.jsp">Back to Admin Dashboard</a>

</body>
</html>