<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add, Edit, Delete Information For Aircraft</title>
</head>
<body>
	<h2>Add, Edit, Delete Information For Aircraft</h2>
	
    <form action="repEditAircraft.jsp" method="POST">
        <label for="choice">Would you like to add, edit information, or delete an aircraft?</label>
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
            <form action="repEditAircraft.jsp" method="POST">
                <input type="hidden" name="choice" value="Add"/>
                <label for="aircraftID">Enter aircraft ID:</label>
                <input type="text" id="aircraftID" name="aircraftID"><br><br>
                <label for="seats">Enter number of seats:</label>
                <input type="text" id="seats" name="seats"><br><br>
    			<label for="operationDays">Select operation days:</label><br>
    			<input type="checkbox" name="operationDays" value="Monday"> Monday<br>
    			<input type="checkbox" name="operationDays" value="Tuesday"> Tuesday<br>
    			<input type="checkbox" name="operationDays" value="Wednesday"> Wednesday<br>
    			<input type="checkbox" name="operationDays" value="Thursday"> Thursday<br>
    			<input type="checkbox" name="operationDays" value="Friday"> Friday<br>
    			<input type="checkbox" name="operationDays" value="Saturday"> Saturday<br>
    			<input type="checkbox" name="operationDays" value="Sunday"> Sunday<br><br>
                <input type="submit" value="Submit">
            </form>

<%
            String aircraftID = request.getParameter("aircraftID");
			String seatsStr = request.getParameter("seats");
			String[] operationDaysArr = request.getParameterValues("operationDays");
			String operationDays = "";
			if (operationDaysArr != null) {
			    operationDays = String.join(",", operationDaysArr);
			}
			
            if (aircraftID != null && !aircraftID.isEmpty()
            && seatsStr != null && !seatsStr.isEmpty()
            && operationDays != null && !operationDays.isEmpty()
            ) {
            	
            	int seats = Integer.parseInt(seatsStr);
            	
    	    	Connection con = null;
    	    	PreparedStatement ps = null;
      	    	Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

                    String query = "INSERT INTO Aircraft (Aircraft_ID, Seats, Operation_Days) VALUES (?, ?, ?)";
                    ps = con.prepareStatement(query);
                    ps.setString(1, aircraftID);
                    ps.setInt(2, seats);
                    ps.setString(3, operationDays);
                    ps.executeUpdate();

                    stmt = con.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM Aircraft");

                    out.println("<h3>Here's the updated table:</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Aircraft ID</th><th>Seats</th><th>Operation Days</th></tr>");

                    while (rs.next()) {
                        String Aircraft_ID = rs.getString("Aircraft_ID");
                        String Seats = rs.getString("Seats");
                        String Operation_Days = rs.getString("Operation_Days");

                        out.println("<tr>");
                        out.println("<td>" + Aircraft_ID + "</td>");
                        out.println("<td>" + Seats + "</td>");
                        out.println("<td>" + Operation_Days + "</td>");
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
            <form action="repEditAircraft.jsp" method="POST">
                <input type="hidden" name="choice" value="Edit"/>
                <label for="aircraftID">Enter aircraft ID:</label>
                <input type="text" id="aircraftID" name="aircraftID"><br><br>
                <label for="seats">Enter number of seats:</label>
                <input type="text" id="seats" name="seats"><br><br>
    			<label for="operationDays">Select operation days:</label><br>
    			<input type="checkbox" name="operationDays" value="Monday"> Monday<br>
    			<input type="checkbox" name="operationDays" value="Tuesday"> Tuesday<br>
    			<input type="checkbox" name="operationDays" value="Wednesday"> Wednesday<br>
    			<input type="checkbox" name="operationDays" value="Thursday"> Thursday<br>
    			<input type="checkbox" name="operationDays" value="Friday"> Friday<br>
    			<input type="checkbox" name="operationDays" value="Saturday"> Saturday<br>
    			<input type="checkbox" name="operationDays" value="Sunday"> Sunday<br><br>
                <input type="submit" value="Submit">
            </form>

<%
            String aircraftID = request.getParameter("aircraftID");
			String seatsStr = request.getParameter("seats");
			String[] operationDaysArr = request.getParameterValues("operationDays");
			String operationDays = "";
			if (operationDaysArr != null) {
			    operationDays = String.join(",", operationDaysArr);
			}
			
            if (aircraftID != null && !aircraftID.isEmpty()
            && seatsStr != null && !seatsStr.isEmpty()
            && operationDays != null && !operationDays.isEmpty()
            ) {
            	
            	int seats = Integer.parseInt(seatsStr);
            	
    	    	Connection con = null;
    	    	PreparedStatement ps = null;
      	    	Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

                    String query = "UPDATE Aircraft SET Seats = ?, Operation_Days = ? WHERE Aircraft_ID = ?";
                    ps = con.prepareStatement(query);
                    ps.setInt(1, seats);
                    ps.setString(2, operationDays);
                    ps.setString(3, aircraftID);
                    ps.executeUpdate();

                    stmt = con.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM Aircraft");

                    out.println("<h3>Here's the updated table:</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Aircraft ID</th><th>Seats</th><th>Operation Days</th></tr>");

                    while (rs.next()) {
                        String Aircraft_ID = rs.getString("Aircraft_ID");
                        String Seats = rs.getString("Seats");
                        String Operation_Days = rs.getString("Operation_Days");

                        out.println("<tr>");
                        out.println("<td>" + Aircraft_ID + "</td>");
                        out.println("<td>" + Seats + "</td>");
                        out.println("<td>" + Operation_Days + "</td>");
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
            <form action="repEditAircraft.jsp" method="POST">
                <input type="hidden" name="choice" value="Delete"/>
                <label for="aircraftID">Enter aircraft ID:</label>
                <input type="text" id="aircraftID" name="aircraftID"><br><br>
                <input type="submit" value="Submit">
            </form>

<%
            String aircraftID = request.getParameter("aircraftID");
			
            if (aircraftID != null && !aircraftID.isEmpty()
            ) {
            	            	
    	    	Connection con = null;
    	    	PreparedStatement ps1 = null;
    	    	PreparedStatement ps2 = null;
    	    	PreparedStatement ps3 = null;
    	    	PreparedStatement ps4 = null;
    	    	PreparedStatement ps5 = null;
      	    	Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

                    String query1 = "DELETE FROM Waiting_List WHERE Flight_Number IN (SELECT Flight_Number FROM Flight_Boards WHERE Aircraft_ID = ?)";
                    ps1 = con.prepareStatement(query1);
                    ps1.setString(1, aircraftID);
                    ps1.executeUpdate();
                    
                    String query2 = "DELETE FROM Reservations WHERE Flight_Number IN (SELECT Flight_Number FROM Flight_Boards WHERE Aircraft_ID = ?)";
                    ps2 = con.prepareStatement(query2);
                    ps2.setString(1, aircraftID);
                    ps2.executeUpdate();
                    
                    String query3 = "DELETE FROM Flight_Boards WHERE Aircraft_ID = ?";
                    ps3 = con.prepareStatement(query3);
                    ps3.setString(1, aircraftID);
                    ps3.executeUpdate();
                    
                    String query4 = "DELETE FROM Airline_Company_Aircraft WHERE Aircraft_ID = ?";
                    ps4 = con.prepareStatement(query4);
                    ps4.setString(1, aircraftID);
                    ps4.executeUpdate();
                    
                    String query5 = "DELETE FROM Aircraft WHERE Aircraft_ID = ?";
                    ps5 = con.prepareStatement(query5);
                    ps5.setString(1, aircraftID);
                    ps5.executeUpdate();

                    stmt = con.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM Aircraft");

                    out.println("<h3>Here's the updated table:</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Aircraft ID</th><th>Seats</th><th>Operation Days</th></tr>");

                    while (rs.next()) {
                        String Aircraft_ID = rs.getString("Aircraft_ID");
                        String Seats = rs.getString("Seats");
                        String Operation_Days = rs.getString("Operation_Days");

                        out.println("<tr>");
                        out.println("<td>" + Aircraft_ID + "</td>");
                        out.println("<td>" + Seats + "</td>");
                        out.println("<td>" + Operation_Days + "</td>");
                        out.println("</tr>");
                    }

                    out.println("</table>");

                } catch (Exception e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (ps1 != null) ps1.close();
                        if (ps2 != null) ps2.close();
                        if (ps3 != null) ps3.close();
                        if (ps4 != null) ps4.close();
                        if (ps5 != null) ps4.close();
                        if (con != null) con.close();
                    } catch (SQLException e) {
                        out.println("<p>Error: " + e.getMessage() + "</p>");
                    }
                }
            }
        }
    }
%>

	<br><a href="repHome.jsp">Back to Representative Dashboard</a>

</body>
</html>