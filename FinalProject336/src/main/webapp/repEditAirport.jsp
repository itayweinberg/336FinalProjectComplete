<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add, Edit, Delete Information For Airport</title>
</head>
<body>
	<h2>Add, Edit, Delete Information For Airport</h2>

    <form action="repEditAirport.jsp" method="POST">
        <label for="choice">Would you like to add, edit information, or delete an airport?</label>
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
            <form action="repEditAirport.jsp" method="POST">
                <input type="hidden" name="choice" value="Add"/>
                <label for="airportID">Enter airport ID:</label>
                <input type="text" id="airportID" name="airportID"><br><br>
                <label for="city">Enter city:</label>
                <input type="text" id="city" name="city"><br><br>
                <label for="state">Enter state:</label>
                <input type="text" id="state" name="state"><br><br>
                <input type="submit" value="Submit">
            </form>

<%
            String airportID = request.getParameter("airportID");
			String city = request.getParameter("city");
			String state = request.getParameter("state");
			
            if (airportID != null && !airportID.isEmpty()
            && city != null && !city.isEmpty()
            && state != null && !state.isEmpty()
            ) {
            	
    	    	Connection con = null;
    	    	PreparedStatement ps = null;
      	    	Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

                    String query = "INSERT INTO Airport (Airport_ID, City, State) VALUES (?, ?, ?)";
                    ps = con.prepareStatement(query);
                    ps.setString(1, airportID);
                    ps.setString(2, city);
                    ps.setString(3, state);
                    ps.executeUpdate();

                    stmt = con.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM Airport");

                    out.println("<h3>Here's the updated table:</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Airport ID</th><th>City</th><th>State</th></tr>");

                    while (rs.next()) {
                        String Airport_ID = rs.getString("Airport_ID");
                        String City = rs.getString("City");
                        String State = rs.getString("State");

                        out.println("<tr>");
                        out.println("<td>" + Airport_ID + "</td>");
                        out.println("<td>" + City + "</td>");
                        out.println("<td>" + State + "</td>");
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
                        out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
                    }
                }
            }

        } else if (choice.equals("Edit")) {
%>
            <form action="repEditAirport.jsp" method="POST">
                <input type="hidden" name="choice" value="Edit"/>
                <label for="airportID">Enter airport ID:</label>
                <input type="text" id="airportID" name="airportID"><br><br>
                <label for="city">Enter city:</label>
                <input type="text" id="city" name="city"><br><br>
                <label for="state">Enter state:</label>
                <input type="text" id="state" name="state"><br><br>
                <input type="submit" value="Submit">
            </form>

<%
			String airportID = request.getParameter("airportID");
			String city = request.getParameter("city");
			String state = request.getParameter("state");

			if (airportID != null && !airportID.isEmpty()
			&& city != null && !city.isEmpty()
			&& state != null && !state.isEmpty()
			) {
            	            	
    	    	Connection con = null;
    	    	PreparedStatement ps = null;
      	    	Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

                    String query = "UPDATE Airport SET City = ?, State = ? WHERE Airport_ID = ?";
                    ps = con.prepareStatement(query);
                    ps.setString(1, city);
                    ps.setString(2, state);
                    ps.setString(3, airportID);
                    ps.executeUpdate();

                    stmt = con.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM Airport");

                    out.println("<h3>Here's the updated table:</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Airport ID</th><th>City</th><th>State</th></tr>");

                    while (rs.next()) {
                        String Airport_ID = rs.getString("Airport_ID");
                        String City = rs.getString("City");
                        String State = rs.getString("State");

                        out.println("<tr>");
                        out.println("<td>" + Airport_ID + "</td>");
                        out.println("<td>" + City + "</td>");
                        out.println("<td>" + State + "</td>");
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
                        out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
                    }
                }
            }
        } else if (choice.equals("Delete")) {
        	%>
            <form action="repEditAirport.jsp" method="POST">
                <input type="hidden" name="choice" value="Delete"/>
                <label for="airportID">Enter airport ID:</label>
                <input type="text" id="airportID" name="airportID"><br><br>
                <input type="submit" value="Submit">
            </form>

<%
            String airportID = request.getParameter("airportID");
			
            if (airportID != null && !airportID.isEmpty()
            ) {
            	            	
    	    	Connection con = null;
    	    	PreparedStatement ps1 = null;
    	    	PreparedStatement ps2 = null;
    	    	PreparedStatement ps3 = null;
    	    	PreparedStatement ps4 = null;
    	    	PreparedStatement ps5 = null;
      	    	Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");
                    
                    String query1 = "DELETE FROM Reservations WHERE Flight_Number IN (SELECT Flight_Number FROM Flight_Boards WHERE Departure_Airport_ID = ? OR Arrival_Airport_ID = ?)";
                    ps1 = con.prepareStatement(query1);
                    ps1.setString(1, airportID);
                    ps1.setString(2, airportID);
                    ps1.executeUpdate();
                    
                 	String query2 = "DELETE FROM Waiting_List WHERE Flight_Number IN (SELECT Flight_Number FROM Flight_Boards WHERE Departure_Airport_ID = ? OR Arrival_Airport_ID = ?)";
                    ps2 = con.prepareStatement(query2);
                    ps2.setString(1, airportID);
                    ps2.setString(2, airportID);
                    ps2.executeUpdate();
                    
                    String query3 = "DELETE FROM Airline_Company_Airport WHERE Airport_ID = ?";
                    ps3 = con.prepareStatement(query3);
                    ps3.setString(1, airportID);
                    ps3.executeUpdate();
                    
                    String query4 = "DELETE FROM Flight_Boards WHERE Departure_Airport_ID = ? OR Arrival_Airport_ID = ?";
                    ps4 = con.prepareStatement(query4);
                    ps4.setString(1, airportID);
                    ps4.setString(2, airportID);
                    ps4.executeUpdate();
                    
                    String query5 = "DELETE FROM Airport WHERE Airport_ID = ?";
                    ps5 = con.prepareStatement(query5);
                    ps5.setString(1, airportID);
                    ps5.executeUpdate();

                    stmt = con.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM Airport");

                    out.println("<h3>Here's the updated table:</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Airport ID</th><th>City</th><th>State</th></tr>");

                    while (rs.next()) {
                        String Airport_ID = rs.getString("Airport_ID");
                        String City = rs.getString("City");
                        String State = rs.getString("State");

                        out.println("<tr>");
                        out.println("<td>" + Airport_ID + "</td>");
                        out.println("<td>" + City + "</td>");
                        out.println("<td>" + State + "</td>");
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
                        if (ps4 != null) ps4.close();
                        if (ps5 != null) ps5.close();
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