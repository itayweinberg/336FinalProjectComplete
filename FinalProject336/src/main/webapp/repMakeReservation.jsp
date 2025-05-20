<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Make Flight Reservations for Customers</title>
</head>
<body>
	<h2>Make Flight Reservations for Customers</h2>
	
    	<form action="repMakeReservation.jsp" method="POST">
            <label for="accountNum">Enter account number:</label>
            <input type="text" id="accountNum" name="accountNum"><br><br>
            <label for="flightNum">Enter flight number:</label>
            <input type="text" id="flightNum" name="flightNum"><br><br>
            <label for="customerName">Enter customer name:</label>
            <input type="text" id="customerName" name="customerName"><br><br>
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
	Connection con = null;
	PreparedStatement ps1 = null;
	PreparedStatement ps2 = null;
	PreparedStatement ps3 = null;
	PreparedStatement ps4 = null;
	Statement stmt = null;
	ResultSet rs1 = null;
	ResultSet rs2 = null;
	ResultSet rs3 = null;
	
	String accountNum = request.getParameter("accountNum");
	String flightNum = request.getParameter("flightNum");
	String customerName = request.getParameter("customerName");
	String costStr = request.getParameter("cost");
	String depDateStr = "";
	String destination = "";
	String arrDateStr = "";
	String flightClass = request.getParameter("flightClass");
		
	if (accountNum != null && !accountNum.isEmpty()
	&& flightNum != null && !flightNum.isEmpty()
    && customerName != null && !customerName.isEmpty()
    && costStr != null && !costStr.isEmpty()
    && flightClass != null && !flightClass.isEmpty() 
	) {
		Class.forName("com.mysql.cj.jdbc.Driver");
		con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");
		
		String query1 = "SELECT Departure_Date, Arrival_Airport_ID, Arrival_Date FROM Flight_Boards WHERE Flight_Number = ?";
		ps1 = con.prepareStatement(query1);
		ps1.setString(1, flightNum);
		rs1 = ps1.executeQuery();

		if (rs1.next()) {
		    depDateStr = rs1.getString("Departure_Date");
		    destination = rs1.getString("Arrival_Airport_ID");
		    arrDateStr = rs1.getString("Arrival_Date");
		} else {
		    out.println("<p>Error: Couldn't find flight number " + flightNum + " on the flight board</p>");
		}
		rs1.close();
		ps1.close();

        if (depDateStr != null && !depDateStr.isEmpty()
        && destination != null && !destination.isEmpty()
        && arrDateStr != null && !arrDateStr.isEmpty() 
        ) {
        	
            float cost = Float.parseFloat(costStr);
            java.sql.Date depDate = java.sql.Date.valueOf(depDateStr);
            java.sql.Date arrDate = java.sql.Date.valueOf(arrDateStr);

            String query2 = "SELECT Seats_Available FROM Flight_Boards WHERE Flight_Number = ?";
            ps2 = con.prepareStatement(query2);
            ps2.setString(1, flightNum);
            rs2 = ps2.executeQuery();
            
            if (rs2.next()) {
                int seatsAvailable = rs2.getInt("Seats_Available");
                if (seatsAvailable == 0) {
                	out.println("<p>Error: Sorry, this flight is full. No seats available for your customer.</p>");
                }
                else {
        	    	try {
						String query3 = "INSERT INTO Reservations (Account_Number, Flight_Number, Customer_Name, Cost, Departure_Date, Destination, Arrival_Date, Class) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                        ps3 = con.prepareStatement(query3);
                        ps3.setString(1, accountNum);
                        ps3.setString(2, flightNum);
                        ps3.setString(3, customerName);
                        ps3.setFloat(4, cost);
                        ps3.setDate(5, depDate);
                        ps3.setString(6, destination);
                        ps3.setDate(7, arrDate);
                        ps3.setString(8, flightClass);
                        ps3.executeUpdate();
                        
                        String query4 = "UPDATE Flight_Boards SET Seats_Available = Seats_Available - 1 WHERE Flight_Number = ?";
                        ps4 = con.prepareStatement(query4);
                        ps4.setString(1, flightNum);
                        ps4.executeUpdate();
                        ps4.close();
                            
                        stmt = con.createStatement();
                        rs3 = stmt.executeQuery("SELECT * FROM Reservations");

                        out.println("<h3>Here's the updated table:</h3>");
                        out.println("<table border='1'>");
                        out.println("<tr><th>Account Number</th><th>Flight Number</th><th>Customer Name</th><th>Cost</th><th>Departure Date</th><th>Destination</th><th>Arrival Date</th><th>Class</th></tr>");

                        while (rs3.next()) {
                            String Account_Number = rs3.getString("Account_Number");
                            String Flight_Number = rs3.getString("Flight_Number");
                            String Customer_Name = rs3.getString("Customer_Name");
                            String Cost = rs3.getString("Cost");
                            String Departure_Date = rs3.getString("Departure_Date");
                            String Destination = rs3.getString("Destination");
                            String Arrival_Date = rs3.getString("Arrival_Date");
                            String Class = rs3.getString("Class");

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
                            if (rs1 != null) rs1.close();
                            if (rs2 != null) rs2.close();
                            if (rs3 != null) rs3.close();
                            if (ps1 != null) ps1.close();
                            if (ps2 != null) ps2.close();
                            if (ps3 != null) ps3.close();
                            if (ps4 != null) ps4.close();
                            if (con != null) con.close();
                        } catch (SQLException e) {
                            out.println("<p>Error: " + e.getMessage() + "</p>");
                        }
                    }
                }
            }
        }
	}
        %>
        
    <br><a href="repHome.jsp">Back to Representative Dashboard</a>

</body>
</html>