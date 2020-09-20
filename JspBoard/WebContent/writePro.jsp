<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import = "java.sql.Timestamp, kjh.board.*"%>

<%
	//한글처리
	request.setCharacterEncoding("utf-8");
	//BoardDTO에서 SetterMethod 5개 호출 + hidden 4개 호출 + readcount(1개)
%>   

<jsp:useBean id="article" class="kjh.board.BoardDTO" />

<jsp:setProperty name="article" property="*" />

<%
  //작성날짜, 원격 ip구조만 언어로써 처리
  Timestamp temp = new Timestamp(System.currentTimeMillis());
  article.setRegdate(temp); //오늘 날짜, 시간을 계산해서 저장
  article.setIp(request.getRemoteAddr()); //원격 ip주소 가지고 옴
  BoardDAO dbPro = new BoardDAO(); //메서드 호출
  dbPro.insertArticle(article);//한꺼번에 받아서 낸부적으로 getter -> 필드별로 저장
  response.sendRedirect("list.jsp");
%>