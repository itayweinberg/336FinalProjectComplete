<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
String firstName = request.getParameter("firstName");
String lastName = request.getParameter("lastName");
String username = request.getParameter("username");
String password = request.getParameter("password");
String ssn = request.getParameter("ssn");
String role = request.getParameter("role");

String accountPrefix = "";
if (role.equals("Customer")){
	accountPrefix = "C";
} else if (role.equals("Representative")){
	accountPrefix = "R";
} else if (role.equals("Administrator")){
	accountPrefix = "A";
}

try {
	Class.forName("com.mysql.jdbc.Driver");

	String connectionRoot = "root";
	String connectionPassword = "mysqlpassword";

	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject", connectionRoot, connectionPassword);
	
	PreparedStatement countPs = con.prepareStatement("select count(*) from account where role = ?" );
	countPs.setString(1, role);
	ResultSet rs = countPs.executeQuery();
	
	int count = 0;
	if (rs.next()){
		count = rs.getInt(1);
	}
	
	String accountNumber = accountPrefix + (count + 1);
	out.println(accountNumber);
	
	PreparedStatement ps = con.prepareStatement("INSERT INTO Account (Account_Number, First_Name, Last_Name, Username, Password, SSN, Role )" + 
	"VALUES (?, ?, ?, ?, ?, ?, ?)");
	
	ps.setString(1, accountNumber);
	ps.setString(2, firstName);
	ps.setString(3, lastName);	
	ps.setString(4, username);	
	ps.setString(5, password);	
	ps.setString(6, ssn);
	ps.setString(7, role);
	ps.executeUpdate();
	
	con.close();
	response.sendRedirect("login.jsp");
	
	} catch (Exception e) {
		out.println(e.getMessage());
	}
%>