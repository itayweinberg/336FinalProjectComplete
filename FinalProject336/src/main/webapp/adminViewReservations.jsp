<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Reservations</title>
</head>
<body>
    <h2>View Reservations</h2>

    <form action="adminViewReservations.jsp" method="POST">
        <label for="choice">Will you be entering a flight number or a customer name?</label>
        <select name="choice" id="choice">
            <option value="Flight Number">Flight Number</option>
            <option value="Customer Name">Customer Name</option>
        </select><br><br>
        <input type="submit" value="Generate List">
    </form>

<%
    String choice = request.getParameter("choice");

    if (choice != null && !choice.isEmpty()) {
        if (choice.equals("Flight Number")) {
%>
            <form action="adminViewReservations.jsp" method="POST">
                <input type="hidden" name="choice" value="Flight Number"/>
                <label for="flightNum">Enter flight number:</label>
                <input type="text" id="flightNum" name="flightNum"><br><br>
                <input type="submit" value="Submit">
            </form>

<%
            String flightNum = request.getParameter("flightNum");
            if (flightNum != null && !flightNum.isEmpty()) {
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

                    String query = "SELECT * FROM Reservations WHERE Flight_Number = ?";
                    ps = con.prepareStatement(query);
                    ps.setString(1, flightNum);
                    rs = ps.executeQuery();

                    out.println("<h3>Reservations for Flight Number " + flightNum + "</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Account Number</th><th>Flight Number</th><th>Customer_Name</th><th>Cost</th><th>Departure Date</th><th>Destination</th><th>Arrival Date</th><th>Class</th></tr>");

                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getString("Account_Number") + "</td>");
                        out.println("<td>" + rs.getString("Flight_Number") + "</td>");
                        out.println("<td>" + rs.getString("Customer_Name") + "</td>");
                        out.println("<td>" + rs.getFloat("Cost") + "</td>");
                        out.println("<td>" + rs.getDate("Departure_Date") + "</td>");
                        out.println("<td>" + rs.getString("Destination") + "</td>");
                        out.println("<td>" + rs.getDate("Arrival_Date") + "</td>");
                        out.println("<td>" + rs.getString("Class") + "</td>");
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

        } else if (choice.equals("Customer Name")) {
%>
            <form action="adminViewReservations.jsp" method="POST">
            	<input type="hidden" name="choice" value="Customer Name"/>
                <label for="customerName">Enter customer name:</label>
                <input type="text" id="customerName" name="customerName"><br><br>
                <input type="submit" value="Submit">
            </form>

<%
            String customerName = request.getParameter("customerName");

            if (customerName != null && !customerName.isEmpty()) {
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

                    String query = "SELECT * FROM Reservations WHERE Customer_Name = ?";
                    ps = con.prepareStatement(query);
                    ps.setString(1, customerName);
                    rs = ps.executeQuery();

                    out.println("<h3>Reservations for Customer " + customerName + "</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Account Number</th><th>Flight Number</th><th>Customer_Name</th><th>Cost</th><th>Departure Date</th><th>Destination</th><th>Arrival Date</th><th>Class</th></tr>");

                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getString("Account_Number") + "</td>");
                        out.println("<td>" + rs.getString("Flight_Number") + "</td>");
                        out.println("<td>" + rs.getString("Customer_Name") + "</td>");
                        out.println("<td>" + rs.getFloat("Cost") + "</td>");
                        out.println("<td>" + rs.getDate("Departure_Date") + "</td>");
                        out.println("<td>" + rs.getString("Destination") + "</td>");
                        out.println("<td>" + rs.getDate("Arrival_Date") + "</td>");
                        out.println("<td>" + rs.getString("Class") + "</td>");
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