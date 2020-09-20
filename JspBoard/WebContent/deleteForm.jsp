<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
	//content.jsp에서 삭제 버튼을 눌렀을 때 deleteForm.jsp로 넘어가고 게시글 번호가 넘어온다.
	//deleteForm.jsp?num=2&pageNum=1 ---> get방식
	int num = Integer.parseInt(request.getParameter("num")); //"2" -> 2 (문자 -> 숫자)
	String pageNum = request.getParameter("pageNum");
	System.out.println("deleteForm.jsp의 num, pageNum 확인");
	System.out.println("num=" + num + "pageNum=" + pageNum);
%>
<html>
<head>
<title>삭제폼</title>
<link href="style.css" rel="stylesheet" type="text/css">

<script language="JavaScript">      
 
  function deleteSave(){	
	if(document.delForm.passwd.value==''){
	alert("먼저 비밀번호를 입력하세요.");
	document.delForm.passwd.focus();
	return false;
 }
}    
   
</script>
</head>

<body bgcolor="#e0ffff">
<center>
	<b>글삭제</b>
	<br>
	<form method="POST" name="delForm"  action="deletePro.jsp" 
	   onsubmit="return deleteSave()"> 
	 <table border="1" align="center" cellspacing="0" cellpadding="0" width="360">
	  <tr height="30">
	     <td align=center  bgcolor="#b0e0e6">
	       <b>비밀번호를 입력해주세요.</b></td>
	  </tr>
	  <tr height="30">
	     <td align=center >비밀번호 :   
	       <input type="password" name="passwd" size="8" maxlength="12">
		   <input type="hidden" name="num" value="<%=num %>">
		   									<!-- num => 게시물번호 -->
		   <input type="hidden" name="pageNum" value="<%=pageNum %>">
		   									<!-- pageNum=> 게시물이 있는 페이지 번호 -->
		   <!-- 입력받지 않고도 게시물번호, 게시물이 있는 페이지 번호를 넘길 수 있어야하며, 비밀번호는 입력받은 값을 넘겨야 한다. -->
		 </td>
	 </tr>
	 <tr height="30">
	    <td align=center bgcolor="#b0e0e6">
	      <input type="submit" value="글삭제" >
	      <input type="button" value="글목록" 
	       onclick="document.location.href='list.jsp?pageNum=<%=pageNum%>'">     
	   </td>
	 </tr>  
	</table> 
	</form>
</center>
</body>
</html> 
