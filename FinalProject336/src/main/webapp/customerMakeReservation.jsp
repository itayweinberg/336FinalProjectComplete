<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Make Reservation</title>
</head>
<body>
<h2>Make Reservation</h2>

        <form action="customerMakeReservation.jsp" method="POST">
            <label for="flightNum">Enter flight number:</label>
            <input type="text" id="flightNum" name="flightNum"><br><br>
            <label for="cost">Enter cost:</label>
            <input type="text" id="cost" name="cost"><br><br>
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
		String flightNum = request.getParameter("flightNum");
		if (flightNum != null && !flightNum.isEmpty()) {
			String accountNum = "";
			String customerName = "";
			String costStr = request.getParameter("cost");
			String depDateStr = "";
			String destination = "";
			String arrDateStr = "";
			String flightClass = request.getParameter("flightClass");
			String seatsAvailableStr = "";
	
		    String username = (String) session.getAttribute("user");
			
		    Connection con = null;
	    	PreparedStatement ps1 = null;
	    	PreparedStatement ps2 = null;
	    	PreparedStatement ps3 = null;
	    	PreparedStatement ps4 = null;
		    Statement stmt = null;
	        ResultSet rs1 = null;
	        ResultSet rs2 = null;
	        ResultSet rs3 = null;
	        ResultSet rs4 = null;
	        
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");
	        
	        String query1 = "SELECT Account_Number FROM Account WHERE Username = ?";
	        ps1 = con.prepareStatement(query1);
	        ps1.setString(1, username);
	        rs1 = ps1.executeQuery();
	        if (rs1.next()) {
	            accountNum = rs1.getString("Account_Number");
	        } else {
	            out.println("<p>Error: Couldn't find account with username " + username + "</p>");
	        }
	        rs1.close();
	        ps1.close();
	        
	        String query2 = "SELECT First_Name, Last_Name FROM Account WHERE Username = ?";
	        ps2 = con.prepareStatement(query2);
	        ps2.setString(1, username);
	        rs2 = ps2.executeQuery();
	        if (rs2.next()) {
	    		customerName = rs2.getString("First_Name") + " " + rs2.getString("Last_Name");
	        } else {
	            out.println("<p>Error: Couldn't find account with username " + username + "</p>");
	        }
			rs2.close();
			ps2.close();
			
			String query3 = "SELECT Departure_Date, Arrival_Airport_ID, Arrival_Date, Seats_Available FROM Flight_Boards WHERE Flight_Number = ?";
	        ps3 = con.prepareStatement(query3);
	        ps3.setString(1, flightNum);
	        rs3 = ps3.executeQuery();
	        if (rs3.next()) {
	            depDateStr = rs3.getString("Departure_Date");
	            destination = rs3.getString("Arrival_Airport_ID");
	            arrDateStr = rs3.getString("Arrival_Date");
	            seatsAvailableStr = rs3.getString("Seats_Available");
	        } else {
	            out.println("<p>Error: Couldn't find flight with flight number " + flightNum + "</p>");
	        }
			rs3.close();
			ps3.close();
	
	        if (accountNum != null && !accountNum.isEmpty()
	        && flightNum != null && !flightNum.isEmpty()
	        && customerName != null && !customerName.isEmpty()
	        && costStr != null && !costStr.isEmpty()
	        && depDateStr != null && !depDateStr.isEmpty()
	        && destination != null && !destination.isEmpty()
	        && arrDateStr != null && !arrDateStr.isEmpty() 
	        && flightClass != null && !flightClass.isEmpty() 
	        && seatsAvailableStr != null && !seatsAvailableStr.isEmpty() 
	        ) {
	        	
	            float cost = Float.parseFloat(costStr);
	            java.sql.Date depDate = java.sql.Date.valueOf(depDateStr);
	            java.sql.Date arrDate = java.sql.Date.valueOf(arrDateStr);
	            int seatsAvailable = Integer.parseInt(seatsAvailableStr);
	
		    	try {
		    		if (seatsAvailable == 0) {
		    			String waitlistChoice = request.getParameter("enterWaitlist");
		    		    if (waitlistChoice == null) {
%>
			    	        <form action="customerMakeReservation.jsp" method="POST">
			    	        <input type="hidden" name="flightNum" value="<%= flightNum %>"/>
        					<input type="hidden" name="cost" value="<%= costStr %>"/>
        					<input type="hidden" name="flightClass" value="<%= flightClass %>"/>
			    			<div id="enterWaitlist">
			    				Unfortunately, this flight is full. Would you like to enter the waiting list?
			    	    		<select name="enterWaitlist">
			    	        		<option value="Yes">Yes</option>
			    	        		<option value="No">No</option>
			    	    		</select><br>
			    			</div>
			                <input type="submit" value="Submit">
			            	</form>
<%
						} else if ("Yes".equals(waitlistChoice)) {
		            	    String queryWaitlist = "INSERT INTO Waiting_List (Flight_Number, Account_Number) VALUES (?, ?)";
		            	    PreparedStatement psWaitlist = con.prepareStatement(queryWaitlist);
		            	    psWaitlist.setString(1, flightNum);
		            	    psWaitlist.setString(2, accountNum);
		            	    out.println("You're now in the waitlist. We'll let you know when there's an open spot for you!");
		            	    int rsWaitlist = psWaitlist.executeUpdate();
		            	    psWaitlist.close();
		            	} else if ("No".equals(waitlistChoice)) {
		            		out.println("Got it, sorry for the inconvenience!");
		            	}
		    		}
		    		
		    		else {
		    		
						String query4 = "INSERT INTO Reservations (Account_Number, Flight_Number, Customer_Name, Cost, Departure_Date, Destination, Arrival_Date, Class) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
		
		                ps4 = con.prepareStatement(query4);
		                ps4.setString(1, accountNum);
		                ps4.setString(2, flightNum);
		                ps4.setString(3, customerName);
		                ps4.setFloat(4, cost);
		                ps4.setDate(5, depDate);
		                ps4.setString(6, destination);
		                ps4.setDate(7, arrDate);
		                ps4.setString(8, flightClass);
		                ps4.executeUpdate();
		                    
		                stmt = con.createStatement();
		                rs4 = stmt.executeQuery("SELECT * FROM Reservations");
		
		                out.println("<h3>Here's the updated table:</h3>");
		                out.println("<table border='1'>");
		                out.println("<tr><th>Account Number</th><th>Flight Number</th><th>Customer Name</th><th>Cost</th><th>Departure Date</th><th>Destination</th><th>Arrival Date</th><th>Class</th></tr>");
		
		                while (rs4.next()) {
		                    String Account_Number = rs4.getString("Account_Number");
		                    String Flight_Number = rs4.getString("Flight_Number");
		                    String Customer_Name = rs4.getString("Customer_Name");
		                    String Cost = rs4.getString("Cost");
		                    String Departure_Date = rs4.getString("Departure_Date");
		                    String Destination = rs4.getString("Destination");
		                    String Arrival_Date = rs4.getString("Arrival_Date");
		                    String Class = rs4.getString("Class");
		
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
		    		}
		
		            } catch (Exception e) {
		                out.println("<p>Error: " + e.getMessage() + "</p>");
		            } finally {
		                try {
		                    if (rs4 != null) rs4.close();
		                    if (ps4 != null) ps4.close();
		                    if (con != null) con.close();
		                } catch (SQLException e) {
		                    out.println("<p>Error: " + e.getMessage() + "</p>");
		                }
		            }
		        }
		}
        %>
        
    <br><a href="customerHome.jsp">Back to Customer Dashboard</a>

</body>
</html>