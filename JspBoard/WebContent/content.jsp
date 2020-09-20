<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import = "kjh.board.*, java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
<head>
<title>게시판</title>
<link href="style.css" rel="stylesheet" type="text/css">
</head>
<%
//list.jsp에서 content.jsp?num=3&pageNum=1; -> 1페이지에서 게시글 3번을 보여줘~~라는 요청이 왔다면
int num = Integer.parseInt(request.getParameter("num"));
//getArticle에서 (int num)을 했기 때문에 형변환을 해줬기 때문 (메서드의 매개변수의 자료형 때문에 변환시킴. -> 계산 때문)
String pageNum = request.getParameter("pageNum");
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");

//레코드를 전체를 가져와야 한다. (일반메서드)
BoardDAO dbPro = new BoardDAO(); //-> 메서드 호출 목적
BoardDTO article = dbPro.getArticle(num);

//링크 문자열의 길이를 줄이기 위해서 (안해도 되지만!) 변수를 만듦
int ref = article.getRef(); //article의 ref를 int형 변수 ref에 담음
int re_step = article.getRe_step();
int re_level = article.getRe_level();
%>
<body bgcolor="#e0ffff">  
<center><b>글내용 보기</b>
<br>
<form>
<table width="500" border="1" cellspacing="0" cellpadding="0"  bgcolor="#e0ffff" align="center">  
  <tr height="30"><!-- 있는 데이터 정보를 보여주기 위함. -->
    <td align="center" width="125" bgcolor="#b0e0e6">글번호</td>
    <td align="center" width="125" align="center"><%=article.getNum() %></td>
    <td align="center" width="125" bgcolor="#b0e0e6">조회수</td>
    <td align="center" width="125" align="center"><%=article.getReadcount() %></td>
  </tr>
  <tr height="30">
    <td align="center" width="125" bgcolor="#b0e0e6">작성자</td>
    <td align="center" width="125" align="center"><%=article.getWriter() %></td>
    <td align="center" width="125" bgcolor="#b0e0e6" >작성일</td>
    <td align="center" width="125" align="center"><%=sdf.format(article.getRegdate()) %></td>
  </tr>
  <tr height="30">
    <td align="center" width="125" bgcolor="#b0e0e6">글제목</td>
    <td align="center" width="375" align="center" colspan="3"><%=article.getSubject() %></td>
  </tr>
  <tr>
    <td align="center" width="125" bgcolor="#b0e0e6">글내용</td>
    <td align="left" width="375" colspan="3"><pre><%=article.getContent() %></pre></td>
  </tr>
  <tr height="30">      
    <td colspan="4" bgcolor="#b0e0e6" align="right" > 
	  <input type="button" value="글수정" 
       onclick="document.location.href='updateForm.jsp?num=<%=article.getNum() %>&pageNum=<%=pageNum%>'">
       <!-- 방금 내가 선택한 글을 수정해야 함. -->
	   &nbsp;&nbsp;&nbsp;&nbsp;
	  <input type="button" value="글삭제" 
       onclick="document.location.href='deleteForm.jsp?num=<%=article.getNum() %>&pageNum=<%=pageNum%>'">
	   &nbsp;&nbsp;&nbsp;&nbsp;
      <input type="button" value="답글쓰기" 
       onclick="document.location.href='writeForm.jsp?num=<%=num %>&ref=<%=ref %>&re_step=<%=re_step %>&re_level=<%=re_level%>'">
	   &nbsp;&nbsp;&nbsp;&nbsp;
       <input type="button" value="글목록" 
       onclick="document.location.href='list.jsp?pageNum=<%=pageNum%>'">
       <!-- article은 테이블의 필드만 해당된다.  -->
    </td>
  </tr>
</table>    
</form>      
</body>
</html>      
