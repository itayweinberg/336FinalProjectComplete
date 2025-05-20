<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Revenue</title>
</head>
<body>
    <h2>View Revenue</h2>

    <form action="adminViewRevenue.jsp" method="POST">
        <label for="choice">Will you be entering a flight number, airline ID, or customer name?</label>
        <select name="choice" id="choice">
            <option value="Flight Number">Flight Number</option>
            <option value="Airline ID">Airline ID</option>
            <option value="Customer Name">Customer Name</option>
        </select><br><br>
        <input type="submit" value="Generate Summary">
    </form>

<%
    String choice = request.getParameter("choice");

    if (choice != null && !choice.isEmpty()) {
        if (choice.equals("Flight Number")) {
%>
            <form action="adminViewRevenue.jsp" method="POST">
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

                    String query = "SELECT Flight_Number, Flight_Revenue FROM Flight_Boards WHERE Flight_Number = ?";

                    ps = con.prepareStatement(query);
                    ps.setString(1, flightNum);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        double totalRevenue = rs.getDouble("Flight_Revenue");
                        out.println("<h3>Total Revenue for Flight Number " + flightNum + ": $" + totalRevenue + "</h3>");
                    } else {
                        out.println("<p>Couldn't find any flights with number " + flightNum + "</p>");
                    }

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

        } else if (choice.equals("Airline ID")) {
%>
            <form action="adminViewRevenue.jsp" method="POST">
            	<input type="hidden" name="choice" value="Airline ID"/>
                <label for="airlineID">Enter airline ID:</label>
                <input type="text" id="airlineID" name="airlineID"><br><br>
                <input type="submit" value="Submit">
            </form>

<%
            String airlineID = request.getParameter("airlineID");

            if (airlineID != null && !airlineID.isEmpty()) {
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

                    String query = "SELECT Airline_ID, SUM(Flight_Revenue) AS Total_Revenue FROM Flight_Boards WHERE Airline_ID = ? GROUP BY Airline_ID";
                    ps = con.prepareStatement(query);
                    ps.setString(1, airlineID);
                    rs = ps.executeQuery();
                    
                    if (rs.next()) {
                        double totalRevenue = rs.getDouble("Total_Revenue");
                        out.println("<h3>Total Revenue for Airline " + airlineID + ": $" + totalRevenue + "</h3>");
                    } else {
                        out.println("<p>Couldn't find any airlines with ID " + airlineID + "</p>");
                    }

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

        } else if (choice.equals("Customer Name")) {
%>
            <form action="adminViewRevenue.jsp" method="POST">
            	<input type="hidden" name="choice" value="Customer Name"/>
                <label for="custName">Enter customer name:</label>
                <input type="text" id="custName" name="custName"><br><br>
                <input type="submit" value="Submit">
            </form>

<%
            String custName = request.getParameter("custName");

            if (custName != null && !custName.isEmpty()) {
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

                    String query = "SELECT Customer_Name, SUM(Cost) AS Total_Revenue FROM Reservations WHERE Customer_Name = ? GROUP BY Customer_Name";
                    ps = con.prepareStatement(query);
                    ps.setString(1, custName);
                    rs = ps.executeQuery();

			     	if (rs.next()) {
                        double totalRevenue = rs.getDouble("Total_Revenue");
                        out.println("<h3>Total Revenue for Customer " + custName + ": $" + totalRevenue + "</h3>");
                    } else {
                        out.println("<p>Couldn't find any customers with name " + custName + "</p>");
                    }

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