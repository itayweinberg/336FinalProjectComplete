<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Flight Search</title>
</head>
<body>
	<h2>Flight Search</h2>
	
	<form action="customerFlightSearch.jsp" method="post">
		<div id="oneWayOrRoundTripDiv">
			<select name="oneWayOrRoundTrip" id="oneWayOrRoundTrip">
				<option value="one way">One Way</option>
				<option value="round trip">Round Trip</option>
			</select>
		</div>
		<div id="departFromDiv" style="display: inline-block;">
			Depart From: <input type="text" name="depart" list="airports"
				placeholder="Depart From"></input>
		</div>
		<div id="arriveAtDiv" style="display: inline-block;">
			Arrive At: <input type="text" name="arrive" list="airports"
				placeholder="Arrive At"></input>
		</div>
		<div id="departDateDiv">
			Depart <input type="date" name="departDate"> <span
				id="returnDateSpan"> Return <input type="date"
				name="returnDate" id="returnDate">
			</span>
		</div>
		<div id="flexibility">
			Flexibility (+/- 3 Days)? <input type="checkbox" name="flexibility"
				value="yes">
		</div>	
		<div id="minPrice" style="display: inline-block;">
			Enter Minimum Price: <input type="number" name="minPrice"><br>
		</div>
		<div id="maxPrice" style="display: inline-block;">
			Enter Maximum Price: <input type="number" name="maxPrice"><br>
		</div>
		<div id="maxStops">
			Choose Maximum Stops:
    		<select name="maxStops">
    		    <option value="">None</option>
        		<option value="0">0</option>
        		<option value="1">1</option>
        		<option value="2">2</option>
    		</select><br>
		</div>
   		<div id="filterAirline">
    		Choose Airline:
    		<select name="filterAirline">
    		    <option value="">None</option>
        		<option value="AA">American Airlines (AA)</option>
        		<option value="DA">Delta Airlines (DA)</option>
        		<option value="UA">United Airlines (UA)</option>
    		</select><br>
		</div>
		<div style="display: flex;">
    		<div id="minDepTime">
        		Enter Earliest Departure Time: <input type="time" name="minDepTime">
    		</div>
    		<div id="maxDepTime">
        		Enter Latest Departure Time: <input type="time" name="maxDepTime">
    		</div>
		</div>
		<div style="display: flex;">
    		<div id="minArrTime">
        		Enter Earliest Arrival Time: <input type="time" name="minArrTime">
    		</div>
    		<div id="maxArrTime">
        		Enter Latest Arrival Time: <input type="time" name="maxArrTime">
    		</div>
		</div>
		<div id="sortBy">
			Sort by:
			<select name="sortBy">
				<option value="none">None</option>
				<option value="cost lowest">Cost (lowest)</option>
				<option value="cost highest">Cost (highest)</option>
				<option value="departure time earliest">Departure Time (earliest)</option>
				<option value="departure time latest">Departure Time (latest)</option>
				<option value="arrival time earliest">Arrival Time (earliest)</option>
				<option value="arrival time latest">Arrival Time (latest)</option>
				<option value="duration shortest">Duration (shortest)</option>
				<option value="duration longest">Duration (longest)</option>
			</select>
		</div>
		<div id="search">
			<input type="submit" value="search">
		</div>
	</form>
	
	<%
		String oneWayOrRoundTrip = request.getParameter("oneWayOrRoundTrip");
		String depart = request.getParameter("depart");
		String arrive = request.getParameter("arrive");
		String departDateStr = request.getParameter("departDate");
		String returnDateStr = request.getParameter("returnDate");
		String flexibility = request.getParameter("flexibility");
		String minPrice = request.getParameter("minPrice");
		String maxPrice = request.getParameter("maxPrice");
		String maxStops = request.getParameter("maxStops");
		String filterAirline = request.getParameter("filterAirline");
		String minDepTime = request.getParameter("minDepTime");
		String maxDepTime = request.getParameter("maxDepTime");
		String minArrTime = request.getParameter("minArrTime");
		String maxArrTime = request.getParameter("maxArrTime");
		String sortBy = request.getParameter("sortBy");

		if (oneWayOrRoundTrip != null && depart != null && arrive != null && departDateStr != null && !depart.isEmpty() && !arrive.isEmpty()) {
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject?useSSL=false&serverTimezone=UTC", "root", "mysqlpassword");
			
			try {
				LocalDate departDate = LocalDate.parse(departDateStr);
				LocalDate earliestDepartDate = departDate;
				LocalDate latestDepartDate = departDate;

				if ("yes".equals(flexibility)) {
					earliestDepartDate = departDate.minusDays(3);
					latestDepartDate = departDate.plusDays(3);
				}

				String query1 = "SELECT * FROM Flight_Boards WHERE Departure_Airport_ID = ? AND Arrival_Airport_ID = ? AND Departure_Date BETWEEN ? AND ?";
				List<Object> parameters1 = new ArrayList<>();

				parameters1.add(depart);
				parameters1.add(arrive);
				parameters1.add(java.sql.Date.valueOf(earliestDepartDate));
				parameters1.add(java.sql.Date.valueOf(latestDepartDate));

				if (minPrice != null && !minPrice.isEmpty()) {
					query1 += " AND (Flight_Revenue / Tickets_Sold) >= ?";
					parameters1.add(Float.parseFloat(minPrice));
				}
				if (maxPrice != null && !maxPrice.isEmpty()) {
					query1 += " AND (Flight_Revenue / Tickets_Sold) <= ?";
					parameters1.add(Float.parseFloat(maxPrice));
				}
				if (maxStops != null && !maxStops.isEmpty()) {
					query1 += " AND Stops <= ?";
					parameters1.add(Integer.parseInt(maxStops));
				}
				if (filterAirline != null && !filterAirline.isEmpty()) {
					query1 += " AND Airline_ID = ?";
					parameters1.add(filterAirline);
				}
				if (minDepTime != null && !minDepTime.isEmpty()) {
					query1 += " AND Departure_Time >= ?";
					parameters1.add(java.sql.Time.valueOf(minDepTime));
				}
				if (maxDepTime != null && !maxDepTime.isEmpty()) {
					query1 += " AND Departure_Time <= ?";
					parameters1.add(java.sql.Time.valueOf(maxDepTime));
				}
				if (minArrTime != null && !minArrTime.isEmpty()) {
					query1 += " AND Arrival_Time >= ?";
					parameters1.add(java.sql.Time.valueOf(minArrTime));
				}
				if (maxArrTime != null && !maxArrTime.isEmpty()) {
					query1 += " AND Arrival_Time <= ?";
					parameters1.add(java.sql.Time.valueOf(maxArrTime));
				}
				
				if (sortBy != null && !sortBy.isEmpty()) {
					if ("none".equals(sortBy)) {
						query1 += "";
					} else if ("cost lowest".equals(sortBy)) {
				        query1 += " ORDER BY (Flight_Revenue / Tickets_Sold) ASC";
				    } else if ("cost highest".equals(sortBy)) {
				        query1 += " ORDER BY (Flight_Revenue / Tickets_Sold) DESC";
					} else if ("departure time earliest".equals(sortBy)) {
				        query1 += " ORDER BY Departure_Time ASC";
				    } else if ("departure time latest".equals(sortBy)) {
				        query1 += " ORDER BY Departure_Time DESC";
				    } else if ("arrival time earliest".equals(sortBy)) {
				        query1 += " ORDER BY Arrival_Time ASC";
				    } else if ("arrival time latest".equals(sortBy)) {
				        query1 += " ORDER BY Arrival_Time DESC";
				    } else if ("duration shortest".equals(sortBy)) {
				        query1 += " ORDER BY Duration ASC";
				    } else if ("duration longest".equals(sortBy)) {
				        query1 += " ORDER BY Duration DESC";
				    }
				}
				
				ps = con.prepareStatement(query1);
				for (int i = 0; i < parameters1.size(); i++) {
				    ps.setObject(i + 1, parameters1.get(i));
				}
				rs = ps.executeQuery();
				
                out.println("<h3>Here are your departing flights:</h3>");
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
                if (rs != null) rs.close();
                if (ps != null) ps.close();
			
				if ("round trip".equals(oneWayOrRoundTrip) && returnDateStr != null && !returnDateStr.isEmpty()) {
					LocalDate returnDate = LocalDate.parse(returnDateStr);
					LocalDate earliestReturnDate = returnDate;
					LocalDate latestReturnDate = returnDate;
					if ("yes".equals(flexibility)) {
						earliestReturnDate = returnDate.minusDays(3);
						latestReturnDate = returnDate.plusDays(3);
					}
					String query2 = "SELECT * FROM Flight_Boards WHERE Departure_Airport_ID = ? AND Arrival_Airport_ID = ? AND Departure_Date BETWEEN ? AND ?";
					List<Object> parameters2 = new ArrayList<>();

					parameters2.add(arrive);
					parameters2.add(depart);
					parameters2.add(java.sql.Date.valueOf(earliestDepartDate));
					parameters2.add(java.sql.Date.valueOf(latestDepartDate));

					if (minPrice != null && !minPrice.isEmpty()) {
						query2 += " AND (Flight_Revenue / Tickets_Sold) >= ?";
						parameters2.add(Float.parseFloat(minPrice));
					}
					if (maxPrice != null && !maxPrice.isEmpty()) {
						query2 += " AND (Flight_Revenue / Tickets_Sold) <= ?";
						parameters2.add(Float.parseFloat(maxPrice));
					}
					if (maxStops != null && !maxStops.isEmpty()) {
						query2 += " AND Stops <= ?";
						parameters2.add(Integer.parseInt(maxStops));
					}
					if (filterAirline != null && !filterAirline.isEmpty()) {
						query2 += " AND Airline_ID = ?";
						parameters2.add(filterAirline);
					}
					if (minDepTime != null && !minDepTime.isEmpty()) {
						query2 += " AND Departure_Time >= ?";
						parameters2.add(java.sql.Time.valueOf(minDepTime));
					}
					if (maxDepTime != null && !maxDepTime.isEmpty()) {
						query2 += " AND Departure_Time <= ?";
						parameters2.add(java.sql.Time.valueOf(maxDepTime));
					}
					if (minArrTime != null && !minArrTime.isEmpty()) {
						query2 += " AND Arrival_Time >= ?";
						parameters2.add(java.sql.Time.valueOf(minArrTime));
					}
					if (maxArrTime != null && !maxArrTime.isEmpty()) {
						query2 += " AND Arrival_Time <= ?";
						parameters2.add(java.sql.Time.valueOf(maxArrTime));
					}
					
					if (sortBy != null && !sortBy.isEmpty()) {
						if ("none".equals(sortBy)) {
							query2 += "";
						} else if ("cost lowest".equals(sortBy)) {
					        query2 += " ORDER BY (Flight_Revenue / Tickets_Sold) ASC";
					    } else if ("cost highest".equals(sortBy)) {
					        query2 += " ORDER BY (Flight_Revenue / Tickets_Sold) DESC";
						} else if ("departure time earliest".equals(sortBy)) {
					        query2 += " ORDER BY Departure_Time ASC";
					    } else if ("departure time latest".equals(sortBy)) {
					        query2 += " ORDER BY Departure_Time DESC";
					    } else if ("arrival time earliest".equals(sortBy)) {
					        query2 += " ORDER BY Arrival_Time ASC";
					    } else if ("arrival time latest".equals(sortBy)) {
					        query2 += " ORDER BY Arrival_Time DESC";
					    } else if ("duration shortest".equals(sortBy)) {
					        query2 += " ORDER BY Duration ASC";
					    } else if ("duration longest".equals(sortBy)) {
					        query2 += " ORDER BY Duration DESC";
					    }
					}
					
					ps = con.prepareStatement(query2);
					for (int i = 0; i < parameters2.size(); i++) {
					    ps.setObject(i + 1, parameters2.get(i));
					}
					rs = ps.executeQuery();

	                out.println("<h3>Here are your returning flights:</h3>");
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

	<script>
		const dropdownSelect = document.getElementById("oneWayOrRoundTrip");
		const returnDate = document.getElementById("returnDateSpan");
		const returnDateInput = document.getElementById("returnDate");

		function updateDropdown() {
			if (dropdownSelect.value == "one way") {
				returnDate.style.display = "none";
				returnDateInput.value = "";
			} else if (dropdownSelect.value == "round trip") {
				returnDate.style.display = "inline-block";
			}
		}

		dropdownSelect.addEventListener('change', updateDropdown);

		updateDropdown();
	</script>

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
	
    <br><a href="customerHome.jsp">Back to Customer Dashboard</a>

</body>
</html>