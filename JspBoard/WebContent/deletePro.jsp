<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.sql.Timestamp, kjh.board.*"%>

<%
	//hidden객체 중에서 pageNum,num은 필드가 아니어서 setter Method를 호출하지 않기 때문에 직접 입력 받는 구문이 필요하다.
	String pageNum = request.getParameter("pageNum"); //게시물이 있는 페이지
	int num = Integer.parseInt(request.getParameter("num")); //게시물 번호
	String passwd = request.getParameter("passwd"); //암호
	BoardDAO dbPro = new BoardDAO(); //메서드 호출 -> deleteArticle 호출
	int check = dbPro. deleteArticle(num,passwd);//암호 찾고 암호 확인하는 절차 때문에 필요하다. 
	if (check == 1) { //글 삭제를 성공했다면
%>
<meta http-equiv="Refresh" content="0;url=list.jsp?pageNum=<%=pageNum%>">
<%} else {%>
<script>
	alert("비밀번호가 맞지않습니다.\n다시 확인 요망!");
	history.back();
</script>
<%}%>