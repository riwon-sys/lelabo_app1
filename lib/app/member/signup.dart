/*  signup.dart | rw 25-04-15 생성
   - 회원가입 화면을 구성하는 StatefulWidget입니다.
   - 사용자가 이메일, 비밀번호, 이름을 입력하면 JSON으로 서버(Spring)로 전송하여 회원가입 처리합니다.
   - HTTP 요청은 Dio 패키지를 사용하며, 각 입력 필드는 TextEditingController로 관리합니다.
*/

import 'package:dio/dio.dart';                          // 서버에 HTTP 요청을 보내기 위한 dio 라이브러리 import
import 'package:flutter/material.dart';                 // 플러터 UI 구성에 필요한 위젯들 import

// [1] 회원가입 화면은 상태(State)가 필요하므로 StatefulWidget 사용
class Signup extends StatefulWidget { // CS

  // [1-1] 상태를 생성해서 연결해주는 메서드 (필수 오버라이딩 메서드)
  @override
  State<StatefulWidget> createState() {
    return _SignupState();                              // 이 위젯의 실제 상태 클래스를 반환
  }

} // CE

// [2] 실제 사용자 입력, 요청 처리, UI 상태 변경이 발생하는 State 클래스
class _SignupState extends State<Signup> { // CS

  // [2-1] 각 입력 필드를 제어하기 위한 컨트롤러 선언
  TextEditingController emailControl = TextEditingController(); // 이메일 입력값을 읽고 수정할 수 있는 컨트롤러
  TextEditingController pwdControl = TextEditingController();   // 비밀번호 입력용 컨트롤러
  TextEditingController nameControl = TextEditingController();  // 이름(닉네임) 입력용 컨트롤러

  // [2-2] '회원가입' 버튼 클릭 시 호출되는 함수
  void onSignup() async { // fs

    // (1) 입력된 값을 기반으로 JSON 형식의 데이터 구성
    final sendData = {
      'memail': emailControl.text,   // 이메일 필드 입력값
      'mpwd': pwdControl.text,       // 비밀번호 필드 입력값
      'mname': nameControl.text,     // 닉네임 필드 입력값
    };
    print(sendData);                 // 콘솔에 전송 데이터 출력 (디버깅용)

    // (2) Dio를 이용하여 HTTP POST 요청 실행
    try {
      Dio dio = Dio();              // Dio 객체 생성
      final response = await dio.post(
        "http://localhost:8080/member/signup", // Spring 서버의 회원가입 API 주소
        data: sendData,                        // 전송할 JSON 데이터
      );
      final data = response.data;              // 서버로부터 받은 응답 데이터

      // (3) 응답 결과에 따라 성공 여부 출력
      if (data) {
        print("회원가입 성공");                 // 서버에서 true 응답 시
      } else {
        print("회원가입 실패");                 // 서버에서 false 응답 시
      }

    } catch (e) {
      print(e);                                // 네트워크 오류 또는 예외 발생 시 콘솔 출력
    }

  } // fe

  // [3] 화면에 표시될 실제 위젯 구성
  @override
  Widget build(BuildContext context) { // fs

    // Scaffold: 전체 화면 기본 뼈대를 구성하는 위젯 (앱바, 바디 등 포함 가능)
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),            // 내부 여백 (상하좌우 30)
        margin: EdgeInsets.all(30),             // 외부 여백 (상하좌우 30)

        // Column: 입력창, 버튼 등 세로 방향으로 나열
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
          children: [

            // [3-1] 이메일 입력창
            TextField(
              controller: emailControl,                     // 연결된 컨트롤러로 입력값 제어
              decoration: InputDecoration(
                labelText: "이메일",                         // 입력창 라벨 텍스트
                border: OutlineInputBorder(),               // 외곽 테두리 스타일 적용
              ),
            ),

            SizedBox(height: 20), // 위젯 간 간격 설정

            // [3-2] 비밀번호 입력창
            TextField(
              controller: pwdControl,                       // 비밀번호 컨트롤러 연결
              obscureText: true,                            // 입력값 가리기 (●●● 형태)
              decoration: InputDecoration(
                labelText: "비밀번호",                       // 라벨
                border: OutlineInputBorder(),               // 외곽선 적용
              ),
            ),

            SizedBox(height: 20),

            // [3-3] 닉네임(이름) 입력창
            TextField(
              controller: nameControl,                      // 이름 입력 제어 컨트롤러
              decoration: InputDecoration(
                labelText: "닉네임",                         // 라벨
                border: OutlineInputBorder(),               // 외곽선
              ),
            ),

            SizedBox(height: 20),

            // [3-4] 회원가입 버튼
            ElevatedButton(
              onPressed: onSignup,                          // 클릭 시 onSignup() 실행
              child: Text("회원가입"),                        // 버튼 텍스트
            ),

            // [3-5] 로그인 안내 텍스트 버튼 (현재 동작 없음)
            TextButton(
              onPressed: () => {},                          // 클릭 시 아무 동작 없음 (TODO: 구현 예정)
              child: Text("이미 가입된 사용자 이면 _로그인"),
            ),

          ],
        ),
      ),
    );

  } // fe

} // CE