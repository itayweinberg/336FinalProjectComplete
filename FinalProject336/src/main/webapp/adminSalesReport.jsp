<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sales Report</title>
</head>
<body>
    <h2>Sales Report</h2>

<form action="adminSalesReport.jsp" method="POST">
    <label for="month">Choose a month:</label>
    <select name="month" id="month">
        <option value="1">January</option>
        <option value="2">February</option>
        <option value="3">March</option>
        <option value="4">April</option>
        <option value="5">May</option>
        <option value="6">June</option>
        <option value="7">July</option>
        <option value="8">August</option>
        <option value="9">September</option>
        <option value="10">October</option>
        <option value="11">November</option>
        <option value="12">December</option>
    </select><br><br>
    <input type="submit" value="Generate Report">
</form>

<%
    String month = request.getParameter("month");
	if (month != null && !month.isEmpty()) {
	    Connection con = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");
	
	        String query = "SELECT MONTH(Departure_Date) as Month, SUM(Flight_Revenue) as Total_Revenue FROM Flight_Boards GROUP BY Month HAVING Month = ?";
	        String[] monthNames = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
            int monthNum = Integer.parseInt(month);
            String monthName = monthNames[monthNum-1];
	
	        ps = con.prepareStatement(query);
	        ps.setString(1, month);
	        rs = ps.executeQuery();
	        
	        if (rs.next()) {
	            double totalRevenue = rs.getDouble("Total_Revenue");
	            out.println("<h3>Total revenue for " + monthName + ": $" + totalRevenue + "</h3>");
	        } else {
	            out.println("<h3>No sales were made in " + monthName + "</h3>");
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
    %>

    <br><a href="adminHome.jsp">Back to Admin Dashboard</a>

</body>
</html>