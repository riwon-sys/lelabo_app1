/*  login.dart | rw 25-04-21 생성
    - 로그인 화면을 구성하는 StatefulWidget입니다.
    - 사용자가 이메일과 비밀번호를 입력하면 Spring 서버에 JSON 형식으로 POST 요청을 보냅니다.
    - 서버로부터 JWT 토큰을 응답받으면 shared_preferences를 통해 로컬에 저장합니다.
    - Dio 패키지로 HTTP 요청을 처리하고, TextEditingController로 입력값을 제어합니다.
*/

// [1] 필요한 외부 패키지 import
import 'package:dio/dio.dart';                           // Dio: HTTP 요청 처리 패키지
import 'package:flutter/material.dart';                  // 기본 위젯 포함된 Flutter 패키지
import 'package:shared_preferences/shared_preferences.dart'; // 로컬 저장소 패키지 (토큰 저장용)
import 'package:lelabo_app1/app/layout/mainapp.dart';
import 'package:lelabo_app1/app/member/signup.dart';

// [2] 상태를 가지는 Stateful 위젯 정의
class Login extends StatefulWidget { // CS
  @override
  State<StatefulWidget> createState() {
    return _LoginState(); // (1) 로그인 상태를 관리할 State 클래스 반환
  }
} // CE

// [3] 실제 상태 관리 로직 클래스 정의
class _LoginState extends State<Login> { // CS

  // (1) 이메일/비밀번호 입력 컨트롤러 선언
  TextEditingController emailControl = TextEditingController(); // 이메일 입력용
  TextEditingController pwdControl = TextEditingController();   // 비밀번호 입력용

  // [4] 로그인 처리 메서드 정의
  void onLogin() async { // fs
    try {
      Dio dio = Dio(); // (1) HTTP 요청용 Dio 객체 생성

      // (2) 사용자가 입력한 이메일/비밀번호를 JSON 형식으로 준비
      final sendData = {
        "memail": emailControl.text,
        "mpwd": pwdControl.text,
      };

      // (3) Spring 서버로 POST 요청 전송
      final response = await dio.post(
        "http://192.168.40.5/member/login", // 로그인 API 주소
        data: sendData,
      );

      final data = response.data; // (4) 서버 응답 데이터 추출

      // (5) 응답값이 비어있지 않다면 로그인 성공
      if (data != '') {
        // (6) SharedPreferences 객체 호출
        final prefs = await SharedPreferences.getInstance();
        // (7) 응답받은 토큰 값을 전역 저장소에 저장
        await prefs.setString('token', data);

        // [*] 로그인 성공시 페이지 전환
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainApp()),
        );

      }else {
        print("로그인 실패");
      }

    } catch (e) {
      print(e); // (8) 예외 발생 시 에러 메시지 출력
    }
  } // fe

  // [5] 로그인 화면 UI 구성
  @override
  Widget build(BuildContext context) { // fs
    return Scaffold( // 전체 화면 기본 구조 제공
      body: Container( // 여백 제공하는 박스 위젯
        padding: EdgeInsets.all(30), // 내부 여백
        margin: EdgeInsets.all(30),  // 외부 여백
        child: Column( // 하위 요소들  세로축 위젯
          mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬(현재 축인(Column) 기준으로 정렬
          children: [ // 하위 요소들 위젯

            // (1) 이메일 입력 필드
            TextField(
              controller: emailControl,
              decoration: InputDecoration(
                labelText: "이메일",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20), // 여백

            // (2) 비밀번호 입력 필드
            TextField(
              controller: pwdControl,
              obscureText: true, // 입력값 숨김 처리
              decoration: InputDecoration(
                labelText: "비밀번호",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // (3) 로그인 버튼
            ElevatedButton(
              onPressed: onLogin, // 클릭 시 로그인 시도
              child: Text("로그인"),
            ),

            SizedBox(height: 20),

            // (4) 회원가입으로 이동 안내
            TextButton(
              onPressed: () => {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context)=>Signup())
                )
              }, child: Text("처음 방문이면 _회원가입")
            )
          ],
        ),
      ),
    );
  } // fe
} // CE