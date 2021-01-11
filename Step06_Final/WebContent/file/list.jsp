<%@page import="java.net.URLEncoder"%>
<%@page import="test.file.dao.FileDao"%>
<%@page import="test.file.dto.FileDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//로그인된 아이디가 있는지 읽어와 본다.
	String id=(String)session.getAttribute("id");
%>
<%
	//한 페이지에 몇개씩 표시할 것인지
	final int PAGE_ROW_COUNT=5;
	//하단 페이지를 몇개씩 표시할 것인지
	final int PAGE_DISPLAY_COUNT=5;
	
	//보여줄 페이지의 번호를 일단 1이라고 초기값 지정
	int pageNum=1;
	//페이지 번호가 파라미터로 전달되는지 읽어와 본다.
	String strPageNum=request.getParameter("pageNum");
	//만일 페이지 번호가 파라미터로 넘어 온다면
	if(strPageNum != null){
		//숫자로 바꿔서 보여줄 페이지 번호로 지정한다.
		pageNum=Integer.parseInt(strPageNum);
	}
	//보여줄 페이지의 시작 ROWNUM
	int startRowNum=1+(pageNum-1)*PAGE_ROW_COUNT;
	//보여줄 페이지의 끝 ROWNUM
	int endRowNum=pageNum*PAGE_ROW_COUNT;
	//startRowNum 과 endRowNum  을 CafeDto 객체에 담고
	FileDto dto=new FileDto();
	dto.setStartRowNum(startRowNum);
	dto.setEndRowNum(endRowNum);
	
	//글목록 불러오기
	String keyword=request.getParameter("keyword");
	String condition=request.getParameter("condition");
	if(keyword==null){
		keyword="";
		condition="";
	}
	String encodedK=URLEncoder.encode(keyword);
	
	List<FileDto> list=null;
	
	if(condition.equals("writer")){
		dto.setWriter(keyword);
		list=FileDao.getInstance().getListW(dto);
	}
	
	int startPageNum=1+((pageNum-1)/PAGE_DISPLAY_COUNT)*PAGE_DISPLAY_COUNT;
	int endPageNum=startPageNum+PAGE_DISPLAY_COUNT-1;
	
	//전체 row의 갯수
	int totalRow=FileDao.getInstance().getCount();
	
	//전체 페이지의 갯수 구하기
	int totalPageCount=(int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
	
	//끝 페이지 번호가 이미 전체 페이지 갯수보다 크게 계산되었다면 잘못된 값이다.
	if(endPageNum>totalPageCount){
		endPageNum=totalPageCount; //보정해준다.
	}
	
%>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/file/list.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
</head>
<body>
<jsp:include page="../include/navbar.jsp">
	<jsp:param value="file" name="thisPage"/>
</jsp:include>
<div class="container">
	<nav>
		<ul class="breadcrumb">
			<li class="breadcrumb-item">
				<a href="${pageContext.request.contextPath }/">Home</a>
			</li>
			<li class="breadcrumb-item active">자료실목록</li>
		</ul>
	</nav>
	<a href="private/upload_form.jsp">업로드 하러가기</a>
	<h1>자료실 목록 입니다.</h1>
	<table class="table table-striped">
		<thead class="table-dark">
			<tr>
				<th>번호</th>
				<th>작성자</th>
				<th>제목(설명)</th>
				<th>파일명</th>
				<th>크기</th>
				<th>등록일</th>
				<th>삭제</th>
			</tr>
		</thead>
		<tbody>
		<%for(FileDto tmp:list){ %>
			<tr>
				<td><%=tmp.getNum() %></td>
				<td><%=tmp.getWriter() %></td>
				<td><%=tmp.getTitle() %></td>
				<td><a href="download.jsp?num=<%=tmp.getNum()%>"><%=tmp.getOrgFileName() %></a></td>
				<td><%=tmp.getFileSize() %></td>
				<td><%=tmp.getRegdate() %></td>
				<td>
				<%if(tmp.getWriter().equals(id)){ %>
					<a href="javascript:deleteConfirm(<%=tmp.getNum()%>)">삭제</a>
				<%} %>
				</td>
			</tr>
		<%} %>
		</tbody>
	</table>
	<nav>
	  <ul class="pagination justify-content-center">
	  	<%if(startPageNum!=1){ %>
		  	<li class="page-item">
		  		<a class="page-link"href="list.jsp?pageNum=<%=startPageNum-1%>">Prev</a>
		  	</li>	  	
	  	<%}else{ %>
	  		<li class="page-item disabled">
		  		<a class="page-link" href="javascript:">Prev</a>
		  	</li>
	  	<%} %>
	  	<%for(int i=startPageNum; i<=endPageNum; i++) {%>
    		<%if(i==pageNum){ %>
    			<li class="page-item active">
		    		<a class="page-link" href="list.jsp?pageNum=<%=i %>"><%=i %></a>
		    	</li>	
    		<%}else{ %>
    			<li class="page-item">
		    		<a class="page-link" href="list.jsp?pageNum=<%=i %>"><%=i %></a>
		    	</li>
		    <%} %>
	    <%} %>
	    <%if(endPageNum<totalPageCount){ %>
		    <li class="page-item">
		    	<a class="page-link" href="list.jsp?pageNum=<%=endPageNum+1%>">Next</a>
		    </li>	    
	    <%}else{ %>
	    	<li class="page-item disabled">
		    	<a class="page-link" href="javascript:">Next</a>
		    </li>
	    <%} %>
	  </ul>
	</nav>
	<form action="list.jsp" method="get">
		<label for="condition">검색조건</label>
		<select name="condition" id="condition">
			<option value="title_filename">제목+파일명</option>
			<option value="title">제목</option>
			<option value="writer">작성자</option>
		</select>
		<input type="text" name="keyword" placeholder="검색어..." />
		<button type="submit">검색</button>
	</form>
</div>
<script>
	function deleteConfirm(num){
		let isDelete=confirm(num+"번 파일을 삭제 하시겠습니까?");
		if(isDelete){
			location.href="private/delete.jsp?num="+num;
		}	
	}
</script>
</body>
</html>