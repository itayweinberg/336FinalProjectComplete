<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.time.LocalDate" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Past Flights</title>
</head>
<body>
    <h2>View Past Flights</h2>

<%
    String accountNum = "";
    String username = (String) session.getAttribute("user");

    Connection con = null;
    PreparedStatement ps1 = null;
    PreparedStatement ps2 = null;
    ResultSet rs1 = null;
    ResultSet rs2 = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

        String query1 = "SELECT Account_Number FROM Account WHERE Username = ?";
        ps1 = con.prepareStatement(query1);
        ps1.setString(1, username);
        rs1 = ps1.executeQuery();

        if (rs1.next()) {
            accountNum = rs1.getString("Account_Number");
            String query2 = "SELECT * FROM Reservations WHERE Account_Number = ? AND Departure_Date < CURDATE() ORDER BY Departure_Date DESC";
            ps2 = con.prepareStatement(query2);
            ps2.setString(1, accountNum);
            rs2 = ps2.executeQuery();

            out.println("<h3>Here are your past flight reservations:</h3>");
            out.println("<table border='1'>");
            out.println("<tr><th>Account Number</th><th>Flight Number</th><th>Customer Name</th><th>Cost</th><th>Departure Date</th><th>Destination</th><th>Arrival Date</th><th>Class</th></tr>");

            while (rs2.next()) {
                out.println("<tr>");
                out.println("<td>" + rs2.getString("Account_Number") + "</td>");
                out.println("<td>" + rs2.getString("Flight_Number") + "</td>");
                out.println("<td>" + rs2.getString("Customer_Name") + "</td>");
                out.println("<td>" + rs2.getString("Cost") + "</td>");
                out.println("<td>" + rs2.getString("Departure_Date") + "</td>");
                out.println("<td>" + rs2.getString("Destination") + "</td>");
                out.println("<td>" + rs2.getString("Arrival_Date") + "</td>");
                out.println("<td>" + rs2.getString("Class") + "</td>");
                out.println("</tr>");
            }

            out.println("</table>");
        } else {
            out.println("<p>Error: Couldn't find account with username " + username + "</p>");
        }
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (rs1 != null) rs1.close();
            if (rs2 != null) rs2.close();
            if (ps1 != null) ps1.close();
            if (ps2 != null) ps2.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
%>

	<br><a href="customerHome.jsp">Back to Customer Dashboard</a>
	
</body>
</html>