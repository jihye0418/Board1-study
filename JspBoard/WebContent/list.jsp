<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="kjh.board.*, java.util.*, java.text.SimpleDateFormat" %>
<%!
	int pageSize = 3; //numPerPage (PageSize) - 페이지당 보여주는 게시물 수
	int blockSize = 3; //pagePerBlock  - 블럭당 보여주는 페이지 수
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm"); //게시물 작성 날짜 포멧 변경 (연,월,일 시,분)
%>
<%
	//게시판을 맨 처음 실행시키면 무조건 1페이지부터 출력
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null){//페이지를 선택할 수 없다면
		pageNum ="1"; //1페이지를 보여줘라   (현재 작성한 것은 문자기 때문에 숫자로 변경할 필요가 있다.)
	}
	int currentPage = Integer.parseInt(pageNum);//현재 페이지(=nowPage)
	
	//------------한 페이지당 보여줄 게시글의 번호--------------
	int startRow = (currentPage-1)*pageSize + 1; //board테이블의 시작 레코드번호
	int endRow = currentPage*pageSize;
	//-------------------------------------------------------
	int count = 0; //총 레코드 수
	int number = 0; //beginPerPage(페이지당 맨 처음에 보여주는 게시물 번호)
	List articleList = null; //화면에 출력할 레코드 데이터
	
	
	BoardDAO dbPro = new BoardDAO(); //메서드 호출 목적
	count = dbPro.getArticleCount();//객체를 얻어와서 count변수에 저장  --> select count(*) from board;를 한 것.
	System.out.println("현재 레코드수(count)=>" + count);
	
	if(count>0){//데이터가 한개라도 있으면 출력해야 한다.
		articleList = dbPro.getArticles(startRow, pageSize); //★endRow가 아닌 거 조심!! 
		                                        //(시작레코드번호, 담을 개수)!!!!!! 
		System.out.println("articleList=>" + articleList); //NullPointerException인지 아닌지 확인해보자.
	}
	//currentPage : 현재 페이지
	number = count-(currentPage-1)*pageSize;//number => 페이지당 맨 처음에 보여주는 게시물 번호
	System.out.println("페이지별 number=>" + number);
	%>
<!DOCTYPE html>
<html>
<head>
<title>게시판</title>
<link href="style.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#e0ffff">
<center><b>글목록(전체 글:<%=count%>)</b>
<table width="700">
<tr>
    <td align="right" bgcolor="#b0e0e6">
    <a href="writeForm.jsp">글쓰기</a>
    </td>
</tr>
</table>

<%
	//테이블에 데이터가 없을 수도 있다.
if(count == 0){%>
	<table border="1" width="700" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td align="center">게시판에 저장된 글이 없습니다.</td>
		</tr>
	</table>
<%}else{%>
  <table border="1" width="700" cellpadding="0" cellspacing="0" align="center"> 
	<tr height="30" bgcolor="#b0e0e6"> 
		<td align="center"  width="50"  >번  호</td> 
		<td align="center"  width="250" >제  목</td> 
		<td align="center"  width="100" >작성자</td>
		<td align="center"  width="150" >작성일</td> 
		<td align="center"  width="50" >조  회</td> 
		<td align="center"  width="100" >IP</td>    
	</tr>
	
	<!-- --------------------------실제적으로 레코드를 출력시키는 부분---------------------------------------------- -->
	<%
	for(int i = 0; i<articleList.size();i++){
	  BoardDTO article = (BoardDTO)articleList.get(i); //BoardDTO에 저장한 변수를 article로 저장
	%>
	
	<tr height="30"><!-- 하나씩 감소하면서 출력하는 게시물번호 -->
		<td align="center"  width="50" >
			<%=number-- %>
		</td>
		<td  width="250" >
		
		<!-- 답변글인 경우 먼저 답변이미지를 부착시키는 부분 -->
		<%
		   int wid = 0; //공백을 계산하기 위한 변수
		   if(article.getRe_level() > 0){//level은 들여쓰기의 크기
		  	 wid = 7*(article.getRe_level()); //답변글은 원글보다 7픽셀정도 들여쓰기가 된다. 답변의 답변글은 원글보다 14픽셀정도 들여쓰기가 된다.
		%>
		  <img src="images/level.gif" width="<%=wid %>" height="16">
		  <img src="images/re.gif">
		<%}else{ %>
		  <img src="images/level.gif" width="<%=wid %>" height="16">  
		 <%} %>        
		 
		 <!-- 게시판(num)에서는 항상 게시물번호, pageNum(페이지번호)는 따라다닌다. -->
		  <a href="content.jsp?num=<%=article.getNum()%>&pageNum=<%=currentPage%>">글제목</a> 
		  
		  <!-- 조회수가 어느 정도 나오면 뒤에 이미지를 넣어줘라 -->
		  <%if(article.getReadcount() >= 20){ //조회수가 20 이상인 경우 %>
		  	<img src="images/hot.gif" border="0"  height="16">
		  <%} %>
        </td>
		<td align="center"  width="100"> 
		  <a href="mailto:<%=article.getEmail()%>"><%=article.getWriter()%></a>
		 </td>
		 <td align="center"  width="150"><%=sdf.format(article.getRegdate())%></td>
		 <td align="center"  width="50"><%=article.getReadcount()%></td>
		 <td align="center" width="100" ><%=article.getIp()%></td>
	</tr>
<%} //--for문%>
</table>
<%} %>


<!-- --------------------------페이징처리-------------------------- -->
<%
	//DB상의 테이블의 레코드를 페이지에 나눠서 출력시켜주는 방법
	if(count>0){//레코드가 1개라도 있으면 페이징이 생긴다.
		//1. 총 페이지수 구하기
		int pageCount = count/pageSize+(count%pageSize==0?0:1);
		//ex. 122게시글/한페이지당10게시글이라면
		//122/10 = 12.2 + 1                (count%pageSize==0?0:1 -> 나머지가 없다면 + 0을 하고 나머지가잇으면 +1을 해라)
		//-> 13.2가 되는데 int형이기 때문에 13이 된다.
		
		//2. 시작페이지
		int startPage = 0; //디폴트값;
		if(currentPage%blockSize != 0){ //현재 페이지의 블럭 사이즈가 0이 아니라면 // 1~9페이지, 11~19페이지...
			startPage = currentPage/blockSize*blockSize+1;
		}else{ // 10페이지, 20페이지, 30페이지, 40~~
			startPage = ((currentPage/blockSize)-1)*blockSize+1;
		//ex) 현재페이지가 10페이지라면 블럭당 보여주는 페이지도 10이라고 가정해서 계산을 해보면
		//((10/10)-1)*10+1 => 1    -> 1페이지에서는 게시글이 1번부터 시작한다.
		
		//현재페이지가 20이라면
		//((20/10)-1)*10+1 => 11    -> 2페이지에서는 게시글이 11번부터 시작한다.
		}
		int endPage = startPage + blockSize -1; 
		//1페이지라면 마지막에 오는 게시글은 10번이다. 
		System.out.println("startPage=" + startPage + ", endPage" + endPage);
		
		//블럭별로 구분해서 링크 걸어 출력하기
		if(endPage > pageCount) endPage=pageCount; //마지막페이지 = 총페이지수
		
		//이전블럭
		if(startPage > blockSize){ %>
			<a href="list.jsp?pageNum=<%=startPage-blockSize%>">[이전]</a>
		<%}
		
		//현재블럭
		for(int i = startPage; i <= endPage; i++){%>
			<a href="list.jsp?pageNum=<%=i%>">[<%=i %>]</a>
		<%}
		
		//다음블럭
		if(endPage < pageCount){%>
			<a href="list.jsp?pageNum=<%=startPage+blockSize%>">[다음]</a>
	<% 
	}
}
%>

</center>
</body>
</html>