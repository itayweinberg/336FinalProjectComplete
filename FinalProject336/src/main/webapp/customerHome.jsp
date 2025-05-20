<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Welcome Customer</title>
</head>
<body>
	<h1>What Would You Like To Do?</h1>
	<form action="customerCancelReservation.jsp" method="get">
		<button type="submit">Cancel Your Reservation</button>
	</form>
	<form action="customerFlightSearch.jsp" method="get">
		<button type="submit">Search For Flights</button>
	</form>
	<form action="customerUpcomingFlights.jsp" method="get">
		<button type="submit">View Upcoming Flights</button>
	</form>
	<form action="customerMakeReservation.jsp" method="get">
		<button type="submit">Make Reservations</button>
	</form>
	<form action="customerPastFlights.jsp" method="get">
		<button type="submit">View Past Flights</button>
	</form>
	<form action="customerQA.jsp" method="get">
		<button type="submit">Q&A</button>
	</form>
	<form action="customerViewWaitlist.jsp" method="get">
		<button type="submit">View Waitlist</button>
	</form>

	<a href='logout.jsp'>Log Out</a>

</body>
</html>