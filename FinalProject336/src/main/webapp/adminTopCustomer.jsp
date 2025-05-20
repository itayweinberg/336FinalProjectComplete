<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Top Customer</title>
</head>
<body>
    <h2>Top Customer</h2>

    <%
    Connection con = null;
    Statement st = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

        String query = "SELECT Account_Number, SUM(Cost) AS Total_Revenue FROM Reservations GROUP BY Account_Number ORDER BY Total_Revenue DESC LIMIT 1";

        st = con.createStatement();
        rs = st.executeQuery(query);

        while (rs.next()) {
            String accountNum = rs.getString("Account_Number");
            double totalRevenue = rs.getDouble("Total_Revenue");

            out.println("<h3>The top customer is " + accountNum + ", who generated a total revenue of $" + totalRevenue + "</h3>");
        }

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