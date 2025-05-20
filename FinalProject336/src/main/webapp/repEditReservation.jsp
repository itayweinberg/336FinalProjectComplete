<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Flight Reservations</title>
</head>
<body>
	<h2>Edit Flight Reservations</h2>

        <form action="repEditReservation.jsp" method="POST">
            <input type="hidden" name="choice" value="Add"/>
            <label for="accountNum">Enter account number:</label>
            <input type="text" id="accountNum" name="accountNum"><br><br>
            <label for="flightNum">Enter flight number:</label>
            <input type="text" id="flightNum" name="flightNum"><br><br>
            <label for="customerName">Enter customer name:</label>
            <input type="text" id="customerName" name="customerName"><br><br>
            <label for="cost">Enter cost:</label>
            <input type="text" id="cost" name="cost"><br><br>
            <label for="depDate">Enter departure date:</label>
            <input type="text" id="depDate" name="depDate"><br><br>
            <label for="destination">Enter destination:</label>
            <input type="text" id="destination" name="destination"><br><br>
            <label for="arrDate">Enter arrival date:</label>
            <input type="text" id="arrDate" name="arrDate"><br><br>
			<div id="flightClass">
				Choose flight class:
	    		<select name="flightClass">
	        		<option value="Economy">Economy</option>
	        		<option value="Business">Business</option>
	        		<option value="First">First</option>
	    		</select><br>
			</div>
			<input type="submit" value="Submit">
        </form>

<%
		String accountNum = request.getParameter("accountNum");
		String flightNum = request.getParameter("flightNum");
		String customerName = request.getParameter("customerName");
		String costStr = request.getParameter("cost");
		String depDateStr = request.getParameter("depDate");
		String destination = request.getParameter("destination");
		String arrDateStr = request.getParameter("arrDate");
		String flightClass = request.getParameter("flightClass");

        if (accountNum != null && !accountNum.isEmpty()
        && flightNum != null && !flightNum.isEmpty()
        && customerName != null && !customerName.isEmpty()
        && costStr != null && !costStr.isEmpty()
        && depDateStr != null && !depDateStr.isEmpty()
        && destination != null && !destination.isEmpty()
        && arrDateStr != null && !arrDateStr.isEmpty()
        && flightClass != null && !flightClass.isEmpty()
        ) {
        	
            float cost = Float.parseFloat(costStr);
            java.sql.Date depDate = java.sql.Date.valueOf(depDateStr);
            java.sql.Date arrDate = java.sql.Date.valueOf(arrDateStr);

	    	Connection con = null;
	    	PreparedStatement ps = null;
  	    	Statement stmt = null;
            ResultSet rs = null;

	    	try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

                String query = "UPDATE Reservations SET Customer_Name = ?, Cost = ?, Departure_Date = ?, Destination = ?, Arrival_Date = ?, Class = ? WHERE Account_Number = ? AND Flight_Number = ?";

                ps = con.prepareStatement(query);
                ps.setString(1, customerName);
                ps.setFloat(2, cost);
                ps.setDate(3, depDate);
                ps.setString(4, destination);
                ps.setDate(5, arrDate);
                ps.setString(6, flightClass);
                ps.setString(7, accountNum);
                ps.setString(8, flightNum);
                ps.executeUpdate();
                    
                stmt = con.createStatement();
                rs = stmt.executeQuery("SELECT * FROM Reservations");

                out.println("<h3>Here's the updated table:</h3>");
                out.println("<table border='1'>");
                out.println("<tr><th>Account Number</th><th>Flight Number</th><th>Customer Name</th><th>Cost</th><th>Departure Date</th><th>Destination</th><th>Arrival Date</th><th>Class</th></tr>");

                while (rs.next()) {
                    String Account_Number = rs.getString("Account_Number");
                    String Flight_Number = rs.getString("Flight_Number");
                    String Customer_Name = rs.getString("Customer_Name");
                    String Cost = rs.getString("Cost");
                    String Departure_Date = rs.getString("Departure_Date");
                    String Destination = rs.getString("Destination");
                    String Arrival_Date = rs.getString("Arrival_Date");
                    String Class = rs.getString("Class");

                    out.println("<tr>");
                    out.println("<td>" + Account_Number + "</td>");
                    out.println("<td>" + Flight_Number + "</td>");
                    out.println("<td>" + Customer_Name + "</td>");
                    out.println("<td>" + Cost + "</td>");
                    out.println("<td>" + Departure_Date + "</td>");
                    out.println("<td>" + Destination + "</td>");
                    out.println("<td>" + Arrival_Date + "</td>");
                    out.println("<td>" + Class + "</td>");
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