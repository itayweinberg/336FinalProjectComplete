<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add, Edit, Delete Information For Flight</title>
</head>
<body>
	<h2>Add, Edit, Delete Information For Flight</h2>

    <form action="repEditFlight.jsp" method="POST">
        <label for="choice">Would you like to add, edit information, or delete a flight?</label>
        <select name="choice" id="choice">
            <option value="Add">Add</option>
            <option value="Edit">Edit</option>
            <option value="Delete">Delete</option>
        </select><br><br>
        <input type="submit" value="Modify Database">
    </form>

<%
    String choice = request.getParameter("choice");

    if (choice != null && !choice.isEmpty()) {
        if (choice.equals("Add")) {
%>
            <form action="repEditFlight.jsp" method="POST">
                <input type="hidden" name="choice" value="Add"/>
				<label for="flightNum">Enter flight number:</label>
				<input type="text" id="flightNum" name="flightNum"><br><br>
				<label for="airlineID">Enter airline ID:</label>
				<input type="text" id="airlineID" name="airlineID"><br><br>
				<label for="aircraftID">Enter aircraft ID:</label>
				<input type="text" id="aircraftID" name="aircraftID"><br><br>
				<label for="depAirportID">Enter departure airport ID:</label>
				<input type="text" id="depAirportID" name="depAirportID"><br><br>
				<label for="depDate">Enter departure date:</label>
				<input type="text" id="depDate" name="depDate"><br><br>
				<label for="depTime">Enter departure time:</label>
				<input type="text" id="depTime" name="depTime"><br><br>
				<label for="arrAirportID">Enter arrival airport ID:</label>
				<input type="text" id="arrAirportID" name="arrAirportID"><br><br>
				<label for="arrDate">Enter arrival date:</label>
				<input type="text" id="arrDate" name="arrDate"><br><br>
				<label for="arrTime">Enter arrival time:</label>
				<input type="text" id="arrTime" name="arrTime"><br><br>
				<label for="duration">Enter flight duration:</label>
				<input type="text" id="duration" name="duration"><br><br>
				<label for="stops">Enter number of stops:</label>
				<input type="text" id="stops" name="stops"><br><br>
				<label for="flightRevenue">Enter flight revenue: $</label>
				<input type="text" id="flightRevenue" name="flightRevenue"><br><br>
				<label for="ticketsSold">Enter tickets sold:</label>
				<input type="text" id="ticketsSold" name="ticketsSold"><br><br>
				<label for="seatsAvailable">Enter seats available:</label>
				<input type="text" id="seatsAvailable" name="seatsAvailable"><br><br>
        		<label for="operationDay">Select operation day:</label>
        		<select name="operationDay" id="operationDay">
            	    <option value="Monday">Monday</option>
            	    <option value="Tuesday">Tuesday</option>
            	    <option value="Wednesday">Wednesday</option>
            	    <option value="Thursday">Thursday</option>
            	    <option value="Friday">Friday</option>
            	    <option value="Saturday">Saturday</option>
            	    <option value="Sunday">Sunday</option>
        		</select><br><br>
                <input type="submit" value="Submit">
            </form>

<%
			String flightNum = request.getParameter("flightNum");
			String airlineID = request.getParameter("airlineID");
			String aircraftID = request.getParameter("aircraftID");
			String depAirportID = request.getParameter("depAirportID");
			String depDateStr = request.getParameter("depDate");
			String depTimeStr = request.getParameter("depTime");
			String arrAirportID = request.getParameter("arrAirportID");
			String arrDateStr = request.getParameter("arrDate");
			String arrTimeStr = request.getParameter("arrTime");
			String durationStr = request.getParameter("duration");
			String stopsStr = request.getParameter("stops");
			String flightRevenueStr = request.getParameter("flightRevenue");
			String ticketsSoldStr = request.getParameter("ticketsSold");
			String seatsAvailableStr = request.getParameter("seatsAvailable");
			String operationDay = request.getParameter("operationDay");
			
			if (flightNum != null && !flightNum.isEmpty()
			&& airlineID != null && !airlineID.isEmpty()
			&& aircraftID != null && !aircraftID.isEmpty()
			&& depAirportID != null && !depAirportID.isEmpty()
			&& depDateStr != null && !depDateStr.isEmpty()
			&& depTimeStr != null && !depTimeStr.isEmpty()
			&& arrAirportID != null && !arrAirportID.isEmpty()
			&& arrDateStr != null && !arrDateStr.isEmpty()
			&& arrTimeStr != null && !arrTimeStr.isEmpty()
			&& durationStr != null && !durationStr.isEmpty()
			&& stopsStr != null && !stopsStr.isEmpty()
			&& flightRevenueStr != null && !flightRevenueStr.isEmpty()
			&& ticketsSoldStr != null && !ticketsSoldStr.isEmpty()
			&& seatsAvailableStr != null && !seatsAvailableStr.isEmpty()
			&& operationDay != null && !operationDay.isEmpty()
			) {
				
				java.sql.Date depDate = java.sql.Date.valueOf(depDateStr);
				java.sql.Time depTime = java.sql.Time.valueOf(depTimeStr);
				java.sql.Date arrDate = java.sql.Date.valueOf(arrDateStr);
				java.sql.Time arrTime = java.sql.Time.valueOf(arrTimeStr);
				java.sql.Time duration = java.sql.Time.valueOf(durationStr);
				int stops = Integer.parseInt(stopsStr);
				float flightRevenue = Float.parseFloat(flightRevenueStr);
				int ticketsSold = Integer.parseInt(ticketsSoldStr);
				int seatsAvailable = Integer.parseInt(seatsAvailableStr);
				
    	    	Connection con = null;
    	    	PreparedStatement ps = null;
      	    	Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

                    String query = "INSERT INTO Flight_Boards (Flight_Number, Airline_ID, Aircraft_ID, Departure_Airport_ID, Departure_Date, Departure_Time, Arrival_Airport_ID, Arrival_Date, Arrival_Time, Duration, Stops, Flight_Revenue, Tickets_Sold, Seats_Available, Operation_Day) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    ps = con.prepareStatement(query);
                    ps.setString(1, flightNum);
                    ps.setString(2, airlineID);
                    ps.setString(3, aircraftID);
                    ps.setString(4, depAirportID);
                    ps.setDate(5, depDate);
                    ps.setTime(6, depTime);
                    ps.setString(7, arrAirportID);
                    ps.setDate(8, arrDate);
                    ps.setTime(9, arrTime);
                    ps.setTime(10, duration);
                    ps.setInt(11, stops);
                    ps.setFloat(12, flightRevenue);
                    ps.setInt(13, ticketsSold);
                    ps.setInt(14, seatsAvailable);
                    ps.setString(15, operationDay);
                    ps.executeUpdate();
                    
                    stmt = con.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM Flight_Boards");

                    out.println("<h3>Here's the updated table:</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Flight Number</th><th>Airline ID</th><th>Aircraft ID</th><th>Departure Airport ID</th><th>Departure Date</th><th>Departure Time</th><th>Arrival Airport ID</th><th>Arrival Date</th><th>Arrival Time</th><th>Duration</th><th>Stops</th><th>Flight Revenue</th><th>Tickets Sold</th><th>Seats Available</th><th>Operation Day</th></tr>");

                    while (rs.next()) {
                        String Flight_Number = rs.getString("Flight_Number");
                        String Airline_ID = rs.getString("Airline_ID");
                        String Aircraft_ID = rs.getString("Aircraft_ID");
                        String Departure_Airport_ID = rs.getString("Departure_Airport_ID");
                        String Departure_Date = rs.getString("Departure_Date");
                        String Departure_Time = rs.getString("Departure_Time");
                        String Arrival_Airport_ID = rs.getString("Arrival_Airport_ID");
                        String Arrival_Date = rs.getString("Arrival_Date");
                        String Arrival_Time = rs.getString("Arrival_Time");
                        String Duration = rs.getString("Duration");
                        String Stops = rs.getString("Stops");
                        String Flight_Revenue = rs.getString("Flight_Revenue");
                        String Tickets_Sold = rs.getString("Tickets_Sold");
                        String Seats_Available = rs.getString("Seats_Available");
                        String Operation_Day = rs.getString("Operation_Day");

                        out.println("<tr>");
                        out.println("<td>" + Flight_Number + "</td>");
                        out.println("<td>" + Airline_ID + "</td>");
                        out.println("<td>" + Aircraft_ID + "</td>");
                        out.println("<td>" + Departure_Airport_ID + "</td>");
                        out.println("<td>" + Departure_Date + "</td>");
                        out.println("<td>" + Departure_Time + "</td>");
                        out.println("<td>" + Arrival_Airport_ID + "</td>");
                        out.println("<td>" + Arrival_Date + "</td>");
                        out.println("<td>" + Arrival_Time + "</td>");
                        out.println("<td>" + Duration + "</td>");
                        out.println("<td>" + Stops + "</td>");
                        out.println("<td>" + Flight_Revenue + "</td>");
                        out.println("<td>" + Tickets_Sold + "</td>");
                        out.println("<td>" + Seats_Available + "</td>");
                        out.println("<td>" + Operation_Day + "</td>");
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

        } else if (choice.equals("Edit")) {
%>
            <form action="repEditFlight.jsp" method="POST">
                <input type="hidden" name="choice" value="Edit"/>
				<label for="flightNum">Enter flight number:</label>
				<input type="text" id="flightNum" name="flightNum"><br><br>
				<label for="airlineID">Enter airline ID:</label>
				<input type="text" id="airlineID" name="airlineID"><br><br>
				<label for="aircraftID">Enter aircraft ID:</label>
				<input type="text" id="aircraftID" name="aircraftID"><br><br>
				<label for="depAirportID">Enter departure airport ID:</label>
				<input type="text" id="depAirportID" name="depAirportID"><br><br>
				<label for="depDate">Enter departure date:</label>
				<input type="text" id="depDate" name="depDate"><br><br>
				<label for="depTime">Enter departure time:</label>
				<input type="text" id="depTime" name="depTime"><br><br>
				<label for="arrAirportID">Enter arrival airport ID:</label>
				<input type="text" id="arrAirportID" name="arrAirportID"><br><br>
				<label for="arrDate">Enter arrival date:</label>
				<input type="text" id="arrDate" name="arrDate"><br><br>
				<label for="arrTime">Enter arrival time:</label>
				<input type="text" id="arrTime" name="arrTime"><br><br>
				<label for="duration">Enter flight duration:</label>
				<input type="text" id="duration" name="duration"><br><br>
				<label for="stops">Enter number of stops:</label>
				<input type="text" id="stops" name="stops"><br><br>
				<label for="flightRevenue">Enter flight revenue: $</label>
				<input type="text" id="flightRevenue" name="flightRevenue"><br><br>
				<label for="ticketsSold">Enter tickets sold:</label>
				<input type="text" id="ticketsSold" name="ticketsSold"><br><br>
				<label for="seatsAvailable">Enter seats available:</label>
				<input type="text" id="seatsAvailable" name="seatsAvailable"><br><br>
        		<label for="operationDay">Select operation day:</label>
        		<select name="operationDay" id="operationDay">
            	    <option value="Monday">Monday</option>
            	    <option value="Tuesday">Tuesday</option>
            	    <option value="Wednesday">Wednesday</option>
            	    <option value="Thursday">Thursday</option>
            	    <option value="Friday">Friday</option>
            	    <option value="Saturday">Saturday</option>
            	    <option value="Sunday">Sunday</option>
        		</select><br><br>
                <input type="submit" value="Submit">
            </form>

<%
			String flightNum = request.getParameter("flightNum");
			String airlineID = request.getParameter("airlineID");
			String aircraftID = request.getParameter("aircraftID");
			String depAirportID = request.getParameter("depAirportID");
			String depDateStr = request.getParameter("depDate");
			String depTimeStr = request.getParameter("depTime");
			String arrAirportID = request.getParameter("arrAirportID");
			String arrDateStr = request.getParameter("arrDate");
			String arrTimeStr = request.getParameter("arrTime");
			String durationStr = request.getParameter("duration");
			String stopsStr = request.getParameter("stops");
			String flightRevenueStr = request.getParameter("flightRevenue");
			String ticketsSoldStr = request.getParameter("ticketsSold");
			String seatsAvailableStr = request.getParameter("seatsAvailable");
			String operationDay = request.getParameter("operationDay");

			if (flightNum != null && !flightNum.isEmpty()
			&& airlineID != null && !airlineID.isEmpty()
			&& aircraftID != null && !aircraftID.isEmpty()
			&& depAirportID != null && !depAirportID.isEmpty()
			&& depDateStr != null && !depDateStr.isEmpty()
			&& depTimeStr != null && !depTimeStr.isEmpty()
			&& arrAirportID != null && !arrAirportID.isEmpty()
			&& arrDateStr != null && !arrDateStr.isEmpty()
			&& arrTimeStr != null && !arrTimeStr.isEmpty()
			&& durationStr != null && !durationStr.isEmpty()
			&& stopsStr != null && !stopsStr.isEmpty()
			&& flightRevenueStr != null && !flightRevenueStr.isEmpty()
			&& ticketsSoldStr != null && !ticketsSoldStr.isEmpty()
			&& seatsAvailableStr != null && !seatsAvailableStr.isEmpty()
			&& operationDay != null && !operationDay.isEmpty()
			) {
	
				java.sql.Date depDate = java.sql.Date.valueOf(depDateStr);
				java.sql.Time depTime = java.sql.Time.valueOf(depTimeStr);
				java.sql.Date arrDate = java.sql.Date.valueOf(arrDateStr);
				java.sql.Time arrTime = java.sql.Time.valueOf(arrTimeStr);
				java.sql.Time duration = java.sql.Time.valueOf(durationStr);
				int stops = Integer.parseInt(stopsStr);
				float flightRevenue = Float.parseFloat(flightRevenueStr);
				int ticketsSold = Integer.parseInt(ticketsSoldStr);
				int seatsAvailable = Integer.parseInt(seatsAvailableStr);
	
				Connection con = null;
				PreparedStatement ps = null;
  				Statement stmt = null;
    			ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

                    String query = "UPDATE Flight_Boards SET Airline_ID = ?, Aircraft_ID = ?, Departure_Airport_ID = ?, Departure_Date = ?, Departure_Time = ?, Arrival_Airport_ID = ?, Arrival_Date = ?, Arrival_Time = ?, Duration = ?, Stops = ?, Flight_Revenue = ?, Tickets_Sold = ?, Seats_Available = ?, Operation_Day = ? WHERE Flight_Number = ?";
                    ps = con.prepareStatement(query);
                    ps.setString(1, airlineID);
                    ps.setString(2, aircraftID);
                    ps.setString(3, depAirportID);
                    ps.setDate(4, depDate);
                    ps.setTime(5, depTime);
                    ps.setString(6, arrAirportID);
                    ps.setDate(7, arrDate);
                    ps.setTime(8, arrTime);
                    ps.setTime(9, duration);
                    ps.setInt(10, stops);
                    ps.setFloat(11, flightRevenue);
                    ps.setInt(12, ticketsSold);
                    ps.setInt(13, seatsAvailable);
                    ps.setString(14, operationDay);
                    ps.setString(15, flightNum);
                    ps.executeUpdate();
                    
                    stmt = con.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM Flight_Boards");

                    out.println("<h3>Here's the updated table:</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Flight Number</th><th>Airline ID</th><th>Aircraft ID</th><th>Departure Airport ID</th><th>Departure Date</th><th>Departure Time</th><th>Arrival Airport ID</th><th>Arrival Date</th><th>Arrival Time</th><th>Duration</th><th>Stops</th><th>Flight Revenue</th><th>Tickets Sold</th><th>Seats Available</th><th>Operation Day</th></tr>");

                    while (rs.next()) {
                        String Flight_Number = rs.getString("Flight_Number");
                        String Airline_ID = rs.getString("Airline_ID");
                        String Aircraft_ID = rs.getString("Aircraft_ID");
                        String Departure_Airport_ID = rs.getString("Departure_Airport_ID");
                        String Departure_Date = rs.getString("Departure_Date");
                        String Departure_Time = rs.getString("Departure_Time");
                        String Arrival_Airport_ID = rs.getString("Arrival_Airport_ID");
                        String Arrival_Date = rs.getString("Arrival_Date");
                        String Arrival_Time = rs.getString("Arrival_Time");
                        String Duration = rs.getString("Duration");
                        String Stops = rs.getString("Stops");
                        String Flight_Revenue = rs.getString("Flight_Revenue");
                        String Tickets_Sold = rs.getString("Tickets_Sold");
                        String Seats_Available = rs.getString("Seats_Available");
                        String Operation_Day = rs.getString("Operation_Day");

                        out.println("<tr>");
                        out.println("<td>" + Flight_Number + "</td>");
                        out.println("<td>" + Airline_ID + "</td>");
                        out.println("<td>" + Aircraft_ID + "</td>");
                        out.println("<td>" + Departure_Airport_ID + "</td>");
                        out.println("<td>" + Departure_Date + "</td>");
                        out.println("<td>" + Departure_Time + "</td>");
                        out.println("<td>" + Arrival_Airport_ID + "</td>");
                        out.println("<td>" + Arrival_Date + "</td>");
                        out.println("<td>" + Arrival_Time + "</td>");
                        out.println("<td>" + Duration + "</td>");
                        out.println("<td>" + Stops + "</td>");
                        out.println("<td>" + Flight_Revenue + "</td>");
                        out.println("<td>" + Tickets_Sold + "</td>");
                        out.println("<td>" + Seats_Available + "</td>");
                        out.println("<td>" + Operation_Day + "</td>");
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

        } else if (choice.equals("Delete")) {
        	%>
            <form action="repEditFlight.jsp" method="POST">
                <input type="hidden" name="choice" value="Delete"/>
                <label for="flightNum">Enter flight number:</label>
                <input type="text" id="flightNum" name="flightNum"><br><br>
                <input type="submit" value="Submit">
            </form>

<%
            String flightNum = request.getParameter("flightNum");
			
            if (flightNum != null && !flightNum.isEmpty()
            ) {
            	            	
    	    	Connection con = null;
    	    	PreparedStatement ps1 = null;
    	    	PreparedStatement ps2 = null;
    	    	PreparedStatement ps3 = null;
      	    	Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");
                    
                    String query1 = "DELETE FROM Waiting_List WHERE Flight_Number = ?";
                    ps1 = con.prepareStatement(query1);
                    ps1.setString(1, flightNum);
                    ps1.executeUpdate();
                    
                    String query2 = "DELETE FROM Reservations WHERE Flight_Number = ?";
                    ps2 = con.prepareStatement(query2);
                    ps2.setString(1, flightNum);
                    ps2.executeUpdate();
                    
                    String query3 = "DELETE FROM Flight_Boards WHERE Flight_Number = ?";
                    ps3 = con.prepareStatement(query3);
                    ps3.setString(1, flightNum);
                    ps3.executeUpdate();

                    stmt = con.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM Flight_Boards");

                    out.println("<h3>Here's the updated table:</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Flight Number</th><th>Airline ID</th><th>Aircraft ID</th><th>Departure Airport ID</th><th>Departure Date</th><th>Departure Time</th><th>Arrival Airport ID</th><th>Arrival Date</th><th>Arrival Time</th><th>Duration</th><th>Stops</th><th>Flight Revenue</th><th>Tickets Sold</th><th>Seats Available</th><th>Operation Day</th></tr>");

                    while (rs.next()) {
                        String Flight_Number = rs.getString("Flight_Number");
                        String Airline_ID = rs.getString("Airline_ID");
                        String Aircraft_ID = rs.getString("Aircraft_ID");
                        String Departure_Airport_ID = rs.getString("Departure_Airport_ID");
                        String Departure_Date = rs.getString("Departure_Date");
                        String Departure_Time = rs.getString("Departure_Time");
                        String Arrival_Airport_ID = rs.getString("Arrival_Airport_ID");
                        String Arrival_Date = rs.getString("Arrival_Date");
                        String Arrival_Time = rs.getString("Arrival_Time");
                        String Duration = rs.getString("Duration");
                        String Stops = rs.getString("Stops");
                        String Flight_Revenue = rs.getString("Flight_Revenue");
                        String Tickets_Sold = rs.getString("Tickets_Sold");
                        String Seats_Available = rs.getString("Seats_Available");
                        String Operation_Day = rs.getString("Operation_Day");

                        out.println("<tr>");
                        out.println("<td>" + Flight_Number + "</td>");
                        out.println("<td>" + Airline_ID + "</td>");
                        out.println("<td>" + Aircraft_ID + "</td>");
                        out.println("<td>" + Departure_Airport_ID + "</td>");
                        out.println("<td>" + Departure_Date + "</td>");
                        out.println("<td>" + Departure_Time + "</td>");
                        out.println("<td>" + Arrival_Airport_ID + "</td>");
                        out.println("<td>" + Arrival_Date + "</td>");
                        out.println("<td>" + Arrival_Time + "</td>");
                        out.println("<td>" + Duration + "</td>");
                        out.println("<td>" + Stops + "</td>");
                        out.println("<td>" + Flight_Revenue + "</td>");
                        out.println("<td>" + Tickets_Sold + "</td>");
                        out.println("<td>" + Seats_Available + "</td>");
                        out.println("<td>" + Operation_Day + "</td>");
                        out.println("</tr>");
                    }

                    out.println("</table>");

                } catch (Exception e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (ps1 != null) ps1.close();
                        if (ps2 != null) ps2.close();
                        if (ps3 != null) ps3.close();
                        if (con != null) con.close();
                    } catch (SQLException e) {
                        out.println("<p>Error: " + e.getMessage() + "</p>");
                    }
                }
            }
        }
    }
%>

	<br><a href="repHome.jsp">Back to Representative Dashboard</a>

</body>
</html>