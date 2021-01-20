<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/gallery/private/ajax_form.jsp</title>
<jsp:include page="../../include/resource.jsp"></jsp:include>
<style>
	#con{
		margin-top:5rem;
	}
	.form-group{
		width:20rem;
	}
</style>
</head>
<body>
<jsp:include page="../../include/blogbasic.jsp"></jsp:include>
<div class="container" id="con">
	<form action="insert.jsp" method="post" id="insertForm">
		<input type="hidden" name="imagePath" id="imagePath" />
		<div class="form-group">
			<label for="caption">설명</label>
			<input class="form-control" type="text" name="caption" id="caption" />
		</div>
	</form>
	<form action="ajax_upload.jsp" method="post" id="ajaxForm" enctype="multipart/form-data">
		<div>
			<label for="image">이미지</label>
			<input type="file" name="image" id="image"
			accept=".jpg, .jpeg, .png, .JPG, .JPEG" />
		</div>
	</form>
	<div class="form-inline mb-5 justify-content-start">
		<button class="btn btn-success btn-xs" id="submitBtn">등록</button>
	</div>
	<jsp:include page="../../include/blogfooter.jsp"></jsp:include>
</div>
<script src="${pageContext.request.contextPath}/js/jquery-3.5.1.js"></script>
<!-- jquery form 플러그인 javascript 로딩 -->
<script src="${pageContext.request.contextPath}/js/jquery.form.min.js"></script>
<script>
	//form 플러그인을 이용해서 form이 ajax 전송(페이지 전환없이)되도록 한다.
	$("#ajaxForm").ajaxForm(function(data){
		//data는 {imagePath:"업로드된 이미지경로"} 형태의 object 이다.
		//console.log(data);
		//로딩할 이미지의 경로 구성
		let src="${pageContext.request.contextPath}"+data.imagePath;
		//img 요소의 src 속성으로 지정을 해서 이미지를 표시한다.
		$(".img-wrapper img").attr("src",src);
		// 업로드 경로를 insertForm에 input type="hidden" 에 value로 넣어준다.
		$("#imagePath").val(data.imagePath);
	});
	//이미지를 선택하면 강제로 폼 전송 시키기
	$("#image").on("change",function(){
		$("#ajaxForm").submit();
	});
	//버튼을 누르면 insertForm 강제 제출해서 이미지 정보가 저장 되도록 한다.
	$("#submitBtn").on("click",function(){
		$("#insertForm").submit();
	});
</script>
</body>
</html>