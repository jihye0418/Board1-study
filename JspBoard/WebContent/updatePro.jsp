<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.sql.Timestamp, kjh.board.*"%>

<%
	//한글처리
request.setCharacterEncoding("utf-8");
%>

<jsp:useBean id="article" class="kjh.board.BoardDTO" />

<jsp:setProperty name="article" property="*" />

<%
	//hidden객체 중에서 pageNum은 필드가 아니어서 setter Method를 호출하지 않기 때문에 직접 입력 받는 구문이 필요하다.
	String pageNum = request.getParameter("pageNum");
	BoardDAO dbPro = new BoardDAO(); //메서드 호출
	int check = dbPro.updateArticle(article);//암호 찾고 암호 확인하는 절차 때문에 필요하다. 
	if (check == 1) { //글 수정이 성공했다면
%>
<meta http-equiv="Refresh" content="0;url=list.jsp?pageNum=<%=pageNum%>">
<%} else {%>
<script>
	alert("비밀번호가 맞지않습니다.\n다시 확인 요망!");
	history.back();
</script>
<%}%>