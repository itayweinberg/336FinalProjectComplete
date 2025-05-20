<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Waitlist</title>
</head>
<body>
	<h2>View Waitlist</h2>

<%
	String accountNum = "";
	String username = (String) session.getAttribute("user");
	
	Connection con = null;
	PreparedStatement ps1 = null;
	PreparedStatement ps2 = null;
	PreparedStatement ps3 = null;
	ResultSet rs1 = null;
	ResultSet rs2 = null;
	ResultSet rs3 = null;

	try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

        String query1 = "SELECT Account_Number FROM Account WHERE Username = ?";
        ps1 = con.prepareStatement(query1);
        ps1.setString(1, username);
        rs1 = ps1.executeQuery();
        
        if (rs1.next()) {
            accountNum = rs1.getString("Account_Number");
            String query2 = "SELECT Flight_Number, Request_Date FROM Waiting_List WHERE Account_Number = ? AND" +
            	" (Flight_Number, Account_Number) NOT IN (SELECT Flight_Number, Account_Number FROM Waiting_List_Notifications)";
            ps2 = con.prepareStatement(query2);
            ps2.setString(1, accountNum);
            rs2 = ps2.executeQuery();
            
            if (rs2.next()) {
	            out.println("<h3>Here are the flights that you're currently on the waitling list for:</h3>");
	            out.println("<table border='1'>");
	            out.println("<tr><th>Flight Number</th><th>Request Date</th></tr>");
	            do {
	                out.println("<tr>");
	                out.println("<td>" + rs2.getString("Flight_Number") + "</td>");
	                out.println("<td>" + rs2.getString("Request_Date") + "</td>");
	                out.println("</tr>");
	            } while (rs2.next());
	            out.println("</table>");
            } else {
	            out.println("<p>You're currently not on any waiting lists.</p>");
            }
            
            String query3 = "SELECT Flight_Number, Notification_Date FROM Waiting_List_Notifications WHERE Account_Number = ?";
            ps3 = con.prepareStatement(query3);
            ps3.setString(1, accountNum);
            rs3 = ps3.executeQuery();
            
            if (rs3.next()) {
	            out.println("<h3>Due to reservation cancellations, you now have an available seat for the following flights:</h3>");
	            out.println("<table border='1'>");
	            out.println("<tr><th>Flight Number</th><th>Notification Date</th></tr>");
	            do {
	                out.println("<tr>");
	                out.println("<td>" + rs3.getString("Flight_Number") + "</td>");
	                out.println("<td>" + rs3.getString("Notification_Date") + "</td>");
	                out.println("</tr>");
	            } while (rs3.next());
	            out.println("</table>");
            } else {
	            out.println("<p>Unfortunately, no spots have been freed for you yet.</p>");
            }
        } 
	} catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (rs1 != null) rs1.close();
            if (ps1 != null) ps1.close();
            if (rs2 != null) rs2.close();
            if (ps2 != null) ps2.close();
            if (rs3 != null) rs3.close();
            if (ps3 != null) ps3.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
%>

	<br><a href="customerHome.jsp">Back to Customer Dashboard</a>

</body>
</html>