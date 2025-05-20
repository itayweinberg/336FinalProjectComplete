<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Most Active Flights</title>
</head>
<body>
    <h2>Most Active Flights</h2>

    <%
    Connection con = null;
    Statement st = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

        String query = "SELECT Flight_Number, Tickets_Sold FROM Flight_Boards ORDER BY Tickets_Sold DESC";

        st = con.createStatement();
        rs = st.executeQuery(query);

        out.println("<table border='1'>");
        out.println("<tr><th>Flight Number</th><th>Tickets Sold</th></tr>");

        while (rs.next()) {
            String flightNum = rs.getString("Flight_Number");
            int ticketsSold = rs.getInt("Tickets_Sold");

            out.println("<tr>");
            out.println("<td>" + flightNum + "</td>");
            out.println("<td>" + ticketsSold + "</td>");
            out.println("</tr>");
        }

        out.println("</table>");

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (st != null) st.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
    %>

    <br><a href="adminHome.jsp">Back to Admin Dashboard</a>

</body>
</html>
