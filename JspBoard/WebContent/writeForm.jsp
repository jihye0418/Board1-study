<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<title>게시판</title>
<link href="style.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="script.js"></script>
</head>
   
<%
//본 페이지를 열개 되는 방법은 2가지 경우가 있다.
//list.jsp에서 신규 글쓰기 or content.jsp에서 답변글쓰기
int num = 0, ref = 1,re_step=0, re_level=0; //num이 0이야? -> 신규 글쓰기네
//writePro.jsp => insertArticle()



//content.jsp
if(request.getParameter("num")!=null){ //num의 값을 전달 받았다면->음수와 0이 아님
	num = Integer.parseInt(request.getParameter("num")); //넘어온 parameter값을 정수로 변환시켜 정수에 담는다. (게시물번호)
	ref = Integer.parseInt(request.getParameter("ref")); //(그룹번호)
	re_step = Integer.parseInt(request.getParameter("re_step"));
	re_level = Integer.parseInt(request.getParameter("re_level"));
	System.out.println("content.jsp에서 넘어온 매개변수 값 확인");
	System.out.println("num =" + num + ", ref=>" + ref + ", re_step=>" + re_step + ", re_level" + re_level);
}
%>
   
   
<body bgcolor="#e0ffff">  
<center><b>글쓰기</b>
<br>

<!-- onsubmit ="return 호출할 함수명() ->필수로 입력해야 하는 부분을 작성했는지 안했는지 체크한다.writeSave()에서 false가 안나오면 writePro.jsp로 이동한다. -->
<form method="post" name="writeform" action="writePro.jsp" onsubmit="return writeSave()">
  <!-- ★파라미터 값을 전달하는 방법4가지 중요★ -->
  
  <input type="hidden" name="num" value="<%=num %>"> <!-- 게시물번호는 직접 입력하지 않고 자동으로 입력되야 하니까 hidden -->
  <input type="hidden" name="ref" value="<%=ref %>">
  <input type="hidden" name="re_step" value="<%=re_step %>">
  <input type="hidden" name="re_level" value="<%=re_level %>">


<table width="400" border="1" cellspacing="0" cellpadding="0"  bgcolor="#e0ffff" align="center">
   <tr>
    <td align="right" colspan="2" bgcolor="#b0e0e6">
	    <a href="list.jsp"> 글목록</a> 
   </td>
   </tr>
   <tr>
    <td  width="70"  bgcolor="#b0e0e6" align="center">이 름</td>
    <td  width="330">
       <input type="text" size="10" maxlength="10" name="writer"></td>
  </tr>
  <tr>
    <td  width="70"  bgcolor="#b0e0e6" align="center" >제 목</td>
    <td  width="330">
       <input type="text" size="40" maxlength="50" name="subject"></td>
  </tr>
  <tr>
    <td  width="70"  bgcolor="#b0e0e6" align="center">Email</td>
    <td  width="330">
       <input type="text" size="40" maxlength="30" name="email" ></td>
  </tr>
  <tr>
    <td  width="70"  bgcolor="#b0e0e6" align="center" >내 용</td>
    <td  width="330" >
     <textarea name="content" rows="13" cols="40"></textarea> </td>
  </tr>
  <tr>
    <td  width="70"  bgcolor="#b0e0e6" align="center" >비밀번호</td>
    <td  width="330" >
     <input type="password" size="8" maxlength="12" name="passwd"> 
	 </td>
  </tr>
<tr>      
 <td colspan=2 bgcolor="#b0e0e6" align="center"> 
  <input type="submit" value="글쓰기" >  
  <input type="reset" value="다시작성">
  <input type="button" value="목록보기" OnClick="window.location='list.jsp'">
</td></tr></table>    
</form>      
</body>
</html>