<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Flight Waiting List</title>
</head>
<body>
    <h2>View Flight Waiting List</h2>

    <form action="repViewWaitlist.jsp" method="POST">
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

            String query = "SELECT * FROM Waiting_List WHERE Flight_Number = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, flightNum);
            rs = ps.executeQuery();

            out.println("<h3>Waitlist for Flight " + flightNum + ":</h3>");
            out.println("<table border='1'>");
            out.println("<tr><th>Flight Number</th><th>Account Number</th><th>Request Date</th></tr>");

            while (rs.next()) {
                String fNum = rs.getString("Flight_Number");
                String accountNum = rs.getString("Account_Number");
                Timestamp requestDate = rs.getTimestamp("Request_Date");

                out.println("<tr>");
                out.println("<td>" + fNum + "</td>");
                out.println("<td>" + accountNum + "</td>");
                out.println("<td>" + requestDate + "</td>");
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
%>

    <br><a href="repHome.jsp">Back to Representative Dashboard</a>
    
</body>
</html>