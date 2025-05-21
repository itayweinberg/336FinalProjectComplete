<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Flights at Given Airport</title>
</head>
<body>
    <h2>View Flights At a Given Airport</h2>
    
    <form action="repViewAirports.jsp" method="POST">
        Airport ID: <input type="text" name="airportID" list="airports"><br/>
        <input type="submit" value="View Flights">
    </form>

    <datalist id="airports">
        <option value="ATL" label="Atlanta, GA"></option>
        <option value="LAX" label="Los Angeles, CA"></option>
        <option value="DFW" label="Dallas, TX"></option>
        <option value="DEN" label="Denver, CO"></option>
        <option value="ORD" label="Chicago, IL"></option>
        <option value="JFK" label="New York City, NY"></option>
        <option value="MCO" label="Orlando, FL"></option>
        <option value="LAS" label="Las Vegas, NV"></option>
        <option value="CLT" label="Charlotte, NC"></option>
        <option value="MIA" label="Miami, FL"></option>
        <option value="SEA" label="Seattle and Tacoma, WA"></option>
        <option value="EWR" label="Newark, NJ"></option>
        <option value="SFO" label="San Francisco, CA"></option>
        <option value="PHX" label="Phoenix, AZ"></option>
        <option value="IAH" label="Houston, TX"></option>
        <option value="BOS" label="Boston, MA"></option>
        <option value="FLL" label="Fort Lauderdale, FL"></option>
        <option value="MSP" label="Minneapolis and Saint Paul, MN"></option>
        <option value="LGA" label="New York City, NY"></option>
        <option value="DTW" label="Detroit, MI"></option>
        <option value="PHL" label="Philadelphia, PA"></option>
        <option value="SLC" label="Salt Lake City, UT"></option>
        <option value="BWI" label="Baltimore and Washington, D.C., MD"></option>
        <option value="DCA" label="Washington, D.C., VA"></option>
        <option value="SAN" label="San Diego, CA"></option>
        <option value="IAD" label="Washington, D.C., VA"></option>
        <option value="TPA" label="Tampa, FL"></option>
        <option value="BNA" label="Nashville, TN"></option>
        <option value="AUS" label="Austin, TX"></option>
        <option value="MDW" label="Chicago, IL"></option>
    </datalist>

<%
    String airportID = request.getParameter("airportID");

    if (airportID != null && !airportID.isEmpty()) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");

            String query = "SELECT * FROM Flight_Boards WHERE Departure_Airport_ID = ? OR Arrival_Airport_ID = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, airportID);
            ps.setString(2, airportID);
            rs = ps.executeQuery();

            out.println("<h3>Flights for airport: " + airportID + "</h3>");
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
%>

    <br><a href="repHome.jsp">Back to Representative Dashboard</a>

</body>
</html>