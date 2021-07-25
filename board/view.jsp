<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.koreait.db.Dbconn"%>

<%
	String b_idx = request.getParameter("b_idx");
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String sql ="";
	
	String b_regdate = "";
	String b_userid = "";
	String b_title = "";
	String b_content = "";
	int b_like = 0;
	int b_hit = 0;
	
	 try {
	      conn = Dbconn.getConnection();
	      if (conn != null) {
	    	  sql = "update tb_board set b_hit = b_hit + 1 where b_idx=?";
	    	  pstmt = conn.prepareStatement(sql);  
	    	  pstmt.setString(1, b_idx);
	    	  pstmt.executeUpdate();
	    	  
	    	  sql="select b_idx,b_userid,b_title,b_content,b_regdate,b_like,b_hit from tb_board where b_idx=?";
	    	  pstmt = conn.prepareStatement(sql);
	    	  pstmt.setString(1, b_idx);
	    	  rs = pstmt.executeQuery();
	    	  
	    	  if(rs.next()){
	    		  b_userid = rs.getString("b_userid");
	    		  b_title = rs.getString("b_title");
	    		  b_content = rs.getString("b_content");
	    		  b_regdate = rs.getString("b_regdate");
	    		  b_like = rs.getInt("b_like");
	    		  b_hit = rs.getInt("b_hit");
	    	  }
	    		  
	    	  }
	    	  
	      }catch(Exception e){
	    	  e.printStackTrace();
	      }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글보기</title>
</head>
<body>
	<h2>글보기</h2>
	<table border="1" width="800">
		<tr>
			<td>제목</td><td><%=b_title%></td>
		</tr>
		<tr>
			<td>날짜</td><td><%=b_regdate%></td>
		</tr>
		<tr>
			<td>작성자</td><td><%=b_userid%></td>
		</tr>
		<tr>
			<td>조회수</td><td><%=b_hit%></td>
		</tr>
		<tr>
			<td>좋아요</td><td id='likeup'><%=b_like%></td>
		</tr>
		<tr>
			<td>내용</td><td><%=b_content%></td>
		</tr>
		<tr>
			<td colspan="2">
			
	<%
		if(b_userid.equals((String)session.getAttribute("userid"))){
			%>
			<input type="button" value="수정" onclick="location.href='./edit.jsp?b_idx=<%=b_idx%>'">
			<input type="button" value = "삭제" onclick="location.href='./delete.jsp?b_idx=<%=b_idx%>'">
<% 
		}
	
	%>		
			<input type="button" value = "좋아요" onclick="likeit()">
			<input type="button" value = "리스트" onclick="location.href='./list.jsp'">
			</td>
		</tr>
	</table>
	


<script>
   	'user strict'
   	function likeit(){
   		const xhr = new XMLHttpRequest();// xhr객체를 만듦 
   		xhr.opn('GET','likeup.jsp?b_idx='<%=b_idx%>,true); //겟방식으로 전달할건데 데이터를, likeup.jsp쪽으로 보낼거임 idx를, 비동기로
   		xhr.send();//데이터 전달
   		xhr.onreadystatechange = function(){ //상태값에따라서 계속 콜백으로 이함수가 자동으로 호출될거임
   			if(xhr.readyState== XHLHttpRequest.DONE && xhr.status ==200){//혹시 xhr.readyState값이 완료가 되었니? 그리고 페이지는 제대로 있어? 라고 물어봐서 그렇다하면,
   				document.getElementById('likeup').innerHTML = xhr.responseText;//받은 데이터를 likeup을 찾아 그안에 써줌 
   			}
   		}
   	}
   
   
   
   
   
   
   </script>