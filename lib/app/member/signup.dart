/*  signup.dart | rw 25-04-15 생성
    - 회원가입 화면을 구성하는 StatefulWidget입니다.
    - 사용자가 이메일, 비밀번호, 이름을 입력하면 JSON 형식으로 Spring 서버에 POST 요청을 보냅니다.
    - HTTP 요청은 Dio 패키지를 사용하며, 입력 필드는 TextEditingController로 관리됩니다.
*/

// [1] 필요한 외부 패키지 import
import 'package:dio/dio.dart';             // (1) HTTP 통신을 위한 Dio 패키지
import 'package:flutter/material.dart';    // (2) Flutter의 기본 UI 위젯 패키지

// [2] 상태를 가지는 위젯 클래스 정의
class Signup extends StatefulWidget { // CS
  @override
  State<StatefulWidget> createState() {
    return _SignupState(); // (1) 실제 상태 로직을 담당할 State 클래스 반환
  }
} // CE

// [3] State 클래스 정의 - 회원가입 동작과 화면 상태 관리
class _SignupState extends State<Signup> { // CS

  // (1) 입력값을 받기 위한 TextEditingController 3종 선언
  // - 사용자가 입력한 이메일, 비밀번호, 이름을 저장하고 추출하는 데 사용됨
  TextEditingController emailControl = TextEditingController(); // 이메일 입력 제어
  TextEditingController pwdControl = TextEditingController();   // 비밀번호 입력 제어
  TextEditingController nameControl = TextEditingController();  // 이름 입력 제어

  // [4] 회원가입 버튼 클릭 시 실행될 메서드 정의
  void onSignup() async { // fs
    // (1) 사용자 입력값을 Map 형식으로 정리해 서버에 전송할 준비
    final sendData = {
      'memail': emailControl.text, // 이메일 필드 값 추출
      'mpwd': pwdControl.text,     // 비밀번호 필드 값 추출
      'mname': nameControl.text,   // 이름 필드 값 추출
    };
    print(sendData); // (2) 실제 전달할 데이터 출력 (디버깅 용도)

    // (2) try-catch로 예외 처리하며 서버에 POST 요청 실행
    try {
      Dio dio = Dio(); // dio 객체 생성
      final response = await dio.post(
        "http://localhost:8080/member/signup", // (3) Spring 서버의 회원가입 API 주소
        data: sendData,                        // (4) JSON 형태로 서버에 보낼 데이터
      );

      final data = response.data; // 응답 데이터 추출
      if (data) {
        print("회원가입 성공"); // true일 경우 성공 처리
      } else {
        print("회원가입 실패"); // false일 경우 실패 처리
      }
    } catch (e) {
      print(e); // (5) 오류 발생 시 콘솔에 에러 출력
    }
  } // fe

  // [5] 실제 UI 구성 메서드 (build)
  @override
  Widget build(BuildContext context) { // fs
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30), // (1) 내부 여백 설정
        margin: EdgeInsets.all(30),  // (2) 외부 여백 설정
        child: Column(               // (3) 위에서 아래로 배치하는 컬럼 위젯
          mainAxisAlignment: MainAxisAlignment.center, // (4) 세로 중앙 정렬
          children: [ // (5) 실제 입력 필드와 버튼 등 자식 위젯들 정의

            // (6) 이메일 입력 필드
            TextField(
              controller: emailControl, // 위에서 선언한 컨트롤러 연결
              decoration: InputDecoration(
                labelText: "이메일",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20), // 입력 필드 사이 여백

            // (7) 비밀번호 입력 필드
            TextField(
              controller: pwdControl,
              obscureText: true, // 입력값 가리기 처리
              decoration: InputDecoration(
                labelText: "비밀번호",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // (8) 닉네임 입력 필드
            TextField(
              controller: nameControl,
              decoration: InputDecoration(
                labelText: "닉네임",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // (9) 회원가입 버튼
            ElevatedButton(
              onPressed: onSignup, // 클릭 시 onSignup 실행
              child: Text("회원가입"),
            ),

            // (10) 로그인 안내 버튼
            TextButton(
              onPressed: () => {}, // 현재는 빈 함수 (추후 구현 가능)
              child: Text("이미 가입된 사용자 이면 _로그인"),
            ),
          ],
        ),
      ),
    );
  } // fe

} // CE