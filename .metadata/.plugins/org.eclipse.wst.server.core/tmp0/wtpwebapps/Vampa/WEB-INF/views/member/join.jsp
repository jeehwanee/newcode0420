<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/resources/css/member/join.css">
<script
  src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
</head>
<body>

<div class="wrapper">
	<form id="join_form" method="post">
	<div class="wrap">
			<div class="subjecet">
				<span>회원가입</span>
			</div>
			<div class="id_wrap">
				<div class="id_name">아이디</div>
				<div class="id_input_box">
					<input class="id_input" name="memberId">
				</div>
				<span class="id_input_re_1">사용 가능한 아이디입니다.</span>
				<span class="id_input_re_2">해당 아이디가 이미 존재합니다.</span>
			</div>
			<div class="pw_wrap">
				<div class="pw_name">비밀번호</div>
				<div class="pw_input_box">
					<input class="pw_input" name="memberPw">
				</div>
			</div>
			<div class="pwck_wrap">
				<div class="pwck_name">비밀번호 확인</div>
				<div class="pwck_input_box">
					<input class="pwck_input" name="memberPw">
				</div>
			</div>
			<div class="user_wrap">
				<div class="user_name">이름</div>
				<div class="user_input_box">
					<input class="user_input" name="memberName">
				</div>
			</div>
			<div class="mail_wrap">
				<div class="mail_name">이메일</div> 
				<div class="mail_input_box">
					<input class="mail_input" name="memberMail">
				</div>
				<div class="mail_check_wrap">
					<div class="mail_check_input_box" id="mail_check_input_box_false">
						<input class="mail_check_input" disabled="disabled">
					</div>
					<div class="mail_check_button">
						<span>인증번호 전송</span>
					</div>
					<div class="clearfix"></div>
					<span id="mail_check_input_box_warn"></span>
				</div>
			</div>
			<div class="address_wrap">
				<div class="address_name">주소</div>
				<div class="address_input_1_wrap">
					<div class="address_input_1_box">
						<input class="address_input_1" name="memberAddr1">
					</div>
					<div class="address_button">
						<span>주소 찾기</span>
					</div>
					<div class="clearfix"></div>
				</div>
				<div class ="address_input_2_wrap">
					<div class="address_input_2_box">
						<input class="address_input_2" name="memberAddr2">
					</div>
				</div>
				<div class ="address_input_3_wrap">
					<div class="address_input_3_box">
						<input class="address_input_3" name="memberAddr3">
					</div>
				</div>
			</div>
			<div class="join_button_wrap">
				<input type="button" class="join_button" value="가입하기">
			</div>
		</div>
	</form>
</div>
<!-- 
회원가입 클릭 시 회원가입 기능이 작동하도록 jquery코드 추가
84번째 줄의 "가입하기"버튼 <input type="button" class="join_button" value="가입하기"> 클릭 시 
form태그의 속성 action이 추가되고(url경로), form태그가 서버에 제출이 된다는 의미. 제출방식은 form태그의 POST형식
 -->
<script>

var code = ""; //Controller(MemberController.java의 mailCheckGET()메소드)로부터 전달받은 인증번호 저장
$(document).ready(function(){
	//회원가입 버튼(회원가입 기능 작동)
	$(".join_button").click(function(){
		$("#join_form").attr("action", "/member/join");
		$("#join_form").submit();
	});
});

/*
 * 아이디 중복성 검사
 */
$('.id_input').on("propertychange change keyup paste input", function(){
	var memberId = $('.id_input').val(); // .id_input에 입력되는 값을 memberId에 저장
	var data = {memberId : memberId} // 컨트롤에 넘길 데이터 이름 : 데이터(.id_input에 입력된 값)
	
	$.ajax({
		type: "post",
		url: "/member/memberIdChk",
		data: data,
		success: function(result){
			if(result != 'fail'){
				$('.id_input_re_1').css("display","inline-block");
				$('.id_input_re_2').css("display","none");
			} else{
				$('.id_input_re_2').css("display","inline-block");
				$('.id_input_re_1').css("display","none");
			}
		} //success 종료
	}); //ajax 종료
}); //function 종료

/*
 * 인증번호 이메일 전송
 */
$(".mail_check_button").click(function(){ //.mail_check_button태그를 갖는 것을 .click 클릭하면 function() 함수 실행
	
	var email = $(".mail_input").val(); //사용자가 입력한 이메일
	var checkBox = $(".mail_check_input"); //인증번호 입력란
	var boxWrap = $(".mail_check_input_box"); //인증번호 입력란 박스
	$.ajax({//이메일 인증번호 전송을 요청하는 ajax
		type:"GET", //url을 통해 데이터를 보낼 수 있도록 GET 방식으로 요청 , url명은 Controller의 매핑에 맞게 mailCheck로 설정
		url:"mailCheck?email=" + email, //? 쿼리 요청 시 입력된 email을 집어넣음
		success:function(data){// ajax 성공 시 해당 함수 실행
			checkBox.attr("disabled", false); //입력란에 입력가능하도록 속성을 변경 disabled -> false
			boxWrap.attr("id", "mail_check_input_box_true"); //입력란의 색상이 변경되도록 회색-> 흰색이 되도록
			code = data;
		}
	});
});

/*
 * 인증번호 비교
 */
$(".mail_check_input").blur(function(){
	var inputCode = $(".mail_check_input").val();//사용자 입력 코드
	var checkResult = $("#mail_check_input_box_warn"); //비교 결과 span태그의 일치, 불일치
	
    if(inputCode == code){                            // 일치할 경우
        checkResult.html("인증번호가 일치합니다.");
        checkResult.attr("class", "correct");        
    } else {                                            // 일치하지 않을 경우
        checkResult.html("인증번호를 다시 확인해주세요.");
        checkResult.attr("class", "incorrect");
    }
});
</script>

</body>
</html>