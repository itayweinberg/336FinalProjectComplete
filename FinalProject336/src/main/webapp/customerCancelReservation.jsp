<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cancel Reservation</title>
</head>
<body>
	<h2>Cancel Reservation</h2>

	<form action="customerCancelReservation.jsp" method="POST">
        <label for="flightNum">Enter flight number of flight you'd like to cancel:</label>
        <input type="text" id="flightNum" name="flightNum"><br><br>
        <input type="submit" value="Submit">
    </form>

<%
	String flightNum = request.getParameter("flightNum");
	if (flightNum != null && !flightNum.isEmpty()) {
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
				String query2 = "SELECT * FROM Reservations WHERE Account_Number = ? AND Flight_Number = ? AND Class IN ('Business', 'First')";
	            ps2 = con.prepareStatement(query2);
	            ps2.setString(1, accountNum);
	            ps2.setString(2, flightNum);
	            rs2 = ps2.executeQuery();
		
	            if (rs2.next()) {
		            out.println("<h3>Here's your reservation for flight " + flightNum + ":</h3>");
		            out.println("<table border='1'>");
		            out.println("<tr><th>Account Number</th><th>Flight Number</th><th>Customer Name</th><th>Cost</th><th>Departure Date</th><th>Destination</th><th>Arrival Date</th><th>Class</th></tr>");

		            do {
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
		            } while (rs2.next());
		            out.println("</table>");

	    			String cancelChoice = request.getParameter("cancelReservation");
	    		    if (cancelChoice == null) {
%>
		    	        <form action="customerCancelReservation.jsp" method="POST">
		    	        <input type="hidden" name="flightNum" value="<%= flightNum %>"/>
		    			<div id="cancelReservation">
		    				Would you like to cancel this reservation?
		    	    		<select name="cancelReservation">
		    	        		<option value="Yes">Yes</option>
		    	        		<option value="No">No</option>
		    	    		</select><br>
		    			</div>
		                <input type="submit" value="Submit">
		            	</form>
<%
					} else if ("Yes".equals(cancelChoice)) {
	            	    String query3 = "DELETE FROM Reservations WHERE Flight_Number = ? AND Account_Number = ?";
	            	    PreparedStatement ps3 = con.prepareStatement(query3);
	            	    ps3.setString(1, flightNum);
	            	    ps3.setString(2, accountNum);
	            	    ps3.executeUpdate();
	            	    ps3.close();
	            	    out.println("Your reservation has been cancelled successfully. You'll receive your refund shortly.");
	            	    
	            	    String query4 = "UPDATE Flight_Boards SET Seats_Available = Seats_Available + 1 WHERE Flight_Number = ?";
	            	    PreparedStatement ps4 = con.prepareStatement(query4);
	            	    ps4.setString(1, flightNum);
	            	    ps4.executeUpdate();
	            	    ps4.close();
	            	    
	            	    String query5 = "SELECT Account_Number FROM Waiting_List WHERE Flight_Number = ? ORDER BY Request_Date ASC LIMIT 1";
	            	    PreparedStatement ps5 = con.prepareStatement(query5);
	            	    ps5.setString(1, flightNum);
	            	    ResultSet rs5 = ps5.executeQuery();
	            	    if (rs5.next()) {
	            	        String accountToNotify = rs5.getString("Account_Number");
	            	        String query6 = "INSERT INTO Waiting_List_Notifications (Flight_Number, Account_Number) VALUES (?, ?)";
	            	        PreparedStatement ps6 = con.prepareStatement(query6);
	            	        ps6.setString(1, flightNum);
	            	        ps6.setString(2, accountToNotify);
	            	        ps6.executeUpdate();
	            	        ps6.close();
	            	        out.println("<p>We've notified " + accountToNotify + " that this flight now has an available seat.</p>");
	            	    } else {
	            	        out.println("<p>No customers are currently on the waiting list for this flight.</p>");
	            	    }
	            	    ps5.close();
	            	    rs5.close();
					} else if ("No".equals(cancelChoice)) {
	            	    out.println("Enjoy your upcoming flight!");
					}
	            } else {
		            out.println("<p>Error: Couldn't find a reservation under your name for flight " + flightNum + " where you're business or first class</p>");
	            }
	        } else {
	            out.println("<p>Error: Couldn't find account with username " + username + "</p>");
	        }
	    } catch (Exception e) {
	        out.println("<p>Error: " + e.getMessage() + "</p>");
	    } finally {
	        try {
	            if (rs1 != null) rs1.close();
	            if (ps1 != null) ps1.close();
	            if (rs2 != null) rs2.close();
	            if (ps2 != null) ps2.close();
	            if (con != null) con.close();
	        } catch (SQLException e) {
	            out.println("<p>Error: " + e.getMessage() + "</p>");
	        }
	    }
	}
%>

    <br><a href="customerHome.jsp">Back to Customer Dashboard</a>

</body>
</html>