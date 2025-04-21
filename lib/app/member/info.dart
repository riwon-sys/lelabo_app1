/*  info.dart | rw 25-04-21 생성
    - 로그인된 사용자의 정보를 조회하고 로그아웃할 수 있는 StatefulWidget입니다.
    - 앱이 시작될 때 SharedPreferences에 저장된 JWT 토큰을 확인해 로그인 여부를 판단합니다.
    - 로그인 상태이면 서버로부터 회원 정보(mno, memail, mname)를 요청하여 출력합니다.
    - 로그아웃 시 서버에 요청을 보내고, SharedPreferences에서 토큰을 삭제합니다.
    - HTTP 요청은 Dio 패키지를 사용하며, 로그인 상태 관리는 상태 변수로 처리합니다.
*/

// [1] 외부 패키지 import
import 'package:dio/dio.dart';                           // HTTP 요청 처리 Dio 패키지
import 'package:flutter/material.dart';                  // Flutter 기본 위젯 패키지
import 'package:shared_preferences/shared_preferences.dart'; // 전역 저장소 SharedPreferences

// [2] 상태 기반 위젯 클래스 정의
class Info extends StatefulWidget { // CS
  @override
  State<StatefulWidget> createState() {
    return _InfoState(); // State 객체 반환
  }
} // CE

// [3] 로그인 상태 관리 및 정보 처리 클래스
class _InfoState extends State<Info> { // CS

  // [3-1] 회원 상태 변수 선언
  int mno = 0;             // 회원번호
  String memail = "";      // 이메일
  String mname = "";       // 이름(닉네임)

  // [3-2] 위젯 시작 시 호출되는 생명주기 메서드
  @override
  void initState() {
    loginCheck(); // 로그인 여부 확인 함수 호출
  }

  // [3-3] 로그인 여부를 확인하는 함수
  bool? isLogin; // null 허용 → 로그인 상태 알 수 없을 경우도 고려
  void loginCheck() async {
    final prefs = await SharedPreferences.getInstance();    // SharedPreferences 객체 호출
    final token = prefs.getString('token');                 // 저장된 토큰 추출

    if (token != null && token.isNotEmpty) {
      // 로그인 상태인 경우
      setState(() {
        isLogin = true;
        print("로그인 중");
        onInfo(token); // 회원 정보 요청 함수 실행
      });
    } else {
      // 비로그인 상태인 경우
      setState(() {
        isLogin = false;
        print("비로그인 중");
      });
    }
  }

  // [3-4] 로그인 상태일 때 서버로부터 회원 정보 요청
  void onInfo(token) async {
    try {
      Dio dio = Dio();

      // 토큰을 Authorization 헤더에 추가
      dio.options.headers['Authorization'] = token;

      final response = await dio.get("http://localhost:8080/member/info"); // 정보 요청 API 호출
      final data = response.data;
      print(data); // 응답 데이터 콘솔 출력

      if (data != '') {
        // 서버에서 받은 회원 정보 상태 변수에 저장
        setState(() {
          memail = data['memail'];
          mname = data['mname'];
          mno = data['mno'];
        });
      }
    } catch (e) {
      print(e); // 예외 발생 시 에러 출력
    }
  }

  // [3-5] 로그아웃 처리 함수
  void logout() async {
    final prefs = await SharedPreferences.getInstance(); // 저장소 호출
    final token = prefs.getString('token');              // 토큰 꺼냄

    if (token == null) return; // 토큰 없으면 종료

    Dio dio = Dio();
    dio.options.headers['Authorization'] = token;        // 로그아웃 요청 시 토큰 포함
    final response = dio.get("http://localhost:8080/member/logout"); // 서버 로그아웃 요청

    await prefs.remove('token'); // SharedPreferences에서 토큰 제거
  }

  // [4] UI 구성 메서드
  @override
  Widget build(BuildContext context) { // fs
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(30),  // 바깥 여백
        padding: EdgeInsets.all(30), // 안쪽 여백
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
          children: [

            // [UI-1] 회원번호 출력
            Text("회원번호 : $mno"),
            SizedBox(height: 20),

            // [UI-2] 이메일 출력
            Text("아이디(이메일) : $memail"),
            SizedBox(height: 20),

            // [UI-3] 이름 출력
            Text("이름(닉네임) : $mname"),
            SizedBox(height: 20),

            // [UI-4] 로그아웃 버튼
            ElevatedButton(
              onPressed: logout,
              child: Text("로그아웃"),
            ),
          ],
        ),
      ),
    );
  } // fe

} // CE