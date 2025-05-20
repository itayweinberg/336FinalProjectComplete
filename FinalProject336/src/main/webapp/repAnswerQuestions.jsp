<%@ page import="java.sql.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, javax.servlet.*, javax.servlet.http.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Answer Customer Questions</title>
</head>
<body>
    <h1>Answer Customer Questions</h1>

    <div class="search-form">
        <form method="get" action="repAnswerQuestions.jsp">
            <label for="keyword">Search Questions and Answers:</label>
            <input type="text" id="keyword" name="keyword" value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
            <input type="submit" value="Search">
        </form>
    </div>
	
    <div class="qa-section">
    
<%
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/336AirlineProject", "root", "mysqlpassword");
	
	String keyword = request.getParameter("keyword");
	PreparedStatement filteredQAs;
		
	if (keyword != null && !keyword.trim().isEmpty()) {
		filteredQAs = con.prepareStatement("SELECT id, question, answer FROM QA WHERE question LIKE ? OR answer LIKE ?");
		String SQLkeyword = "%" + keyword + "%";
		filteredQAs.setString(1, SQLkeyword);
		filteredQAs.setString(2, SQLkeyword);
	} else {
		filteredQAs = con.prepareStatement("SELECT id, question, answer FROM QA");
	}
		
	ResultSet QAiterator = filteredQAs.executeQuery();
	    			
	int qaIDtoEdit = -1;
	int qaIDtoDelete = -1;
	
	String editClicked = request.getParameter("editID");
	String saveClicked = request.getParameter("saveID");
	String deleteClicked = request.getParameter("deleteID");
	
	if (editClicked != null) {
		qaIDtoEdit = Integer.parseInt(editClicked);
	}
	
	if (deleteClicked != null) {
		qaIDtoDelete = Integer.parseInt(deleteClicked);
		PreparedStatement deleteQuery = con.prepareStatement("DELETE FROM QA WHERE id = ?");
		deleteQuery.setInt(1, qaIDtoDelete);
		deleteQuery.executeUpdate();
		deleteQuery.close();
		
		if (keyword != null && !keyword.trim().isEmpty()) {
			filteredQAs = con.prepareStatement("SELECT id, question, answer FROM QA WHERE question LIKE ? OR answer LIKE ?");
			String SQLkeyword = "%" + keyword + "%";
			filteredQAs.setString(1, SQLkeyword);
			filteredQAs.setString(2, SQLkeyword);
		} else {
			filteredQAs = con.prepareStatement("SELECT id, question, answer FROM QA");
		}

		QAiterator = filteredQAs.executeQuery();
	}
	
	if (saveClicked != null) {
		int qaIDtoSave = Integer.parseInt(saveClicked);
		String editedAnswer = request.getParameter("editedAnswer");
		
		PreparedStatement updatedQuery = con.prepareStatement("UPDATE QA SET answer = ? WHERE id = ?");
		updatedQuery.setString(1, editedAnswer);
		updatedQuery.setInt(2, qaIDtoSave);
		updatedQuery.executeUpdate();
		updatedQuery.close();
		
		if (keyword != null && !keyword.trim().isEmpty()) {
			filteredQAs = con.prepareStatement("SELECT id, question, answer FROM QA WHERE question LIKE ? OR answer LIKE ?");
			String SQLkeyword = "%" + keyword + "%";
			filteredQAs.setString(1, SQLkeyword);
			filteredQAs.setString(2, SQLkeyword);
		} else {
			filteredQAs = con.prepareStatement("SELECT id, question, answer FROM QA");
		}

		QAiterator = filteredQAs.executeQuery();
		
	}
	
	while (QAiterator.next()) {
		int qaID = QAiterator.getInt("id");
	   	String q = QAiterator.getString("question");
		String a = QAiterator.getString("answer");
%>
	   	<div class="qa">
	   		
	   		<form method="post" action="repAnswerQuestions.jsp">
	   			
                <p> <input type="hidden" name="deleteID" value="<%= qaID %>"> <input type="submit" value="Delete"> <strong>Q: </strong><%=q%></p>
           
            </form>
	   		
	   		 <% if (qaIDtoEdit == qaID) { %>
	   		   
            	<form method="post" action="repAnswerQuestions.jsp">
            	
                	<p> <input type="hidden" name="saveID" value="<%= qaID %>"> <textarea name="editedAnswer" rows="2" cols="100"><%= a %></textarea><br> <input type="submit" value="Save"> </p>
                	
            	</form>

	   		<% } else { %>
	   		
	   			<form method="post" action="repAnswerQuestions.jsp">
	   			
                	<p> <input type="hidden" name="editID" value="<%=qaID %>"> <input type="submit" value="Edit"> <strong>A: </strong><%=a%></p>
           
            	</form>
	   		<% } %>
	   		
	   	</div>
	   	
<% 
	}
		
	QAiterator.close();
	filteredQAs.close();
	con.close();
		
%>	

	<br><a href="repHome.jsp">Back to Representative Dashboard</a>

</body>
</html>