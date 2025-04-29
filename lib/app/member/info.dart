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
import 'package:lelabo_app1/app/layout/mainapp.dart';
import 'package:lelabo_app1/app/member/login.dart';

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
  int mno = 0;             // 회원번호     // 30;
  String memail = "";      // 이메일      // "qwe@qwe.com";
  String mname = "";       // 이름(닉네임) // "김리원";

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

    if (token != null && token.isNotEmpty) { // 전역변수에(로그인) 토큰이 존재하면
      // 로그인 상태인 경우
      setState(() {
        isLogin = true;
        print("로그인 중");
        onInfo(token); // 로그인 중일때 로그인 회원 정보 요청 함수 실행
      });
    } else {
      // - 비로그인 상태인 경우 페이지 전환 및 이동
      // - Navigator.pushReplacement(context,MaterialPageRoute(builer: (context)=>이동할위젯명()));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }
  }

  // [3-4] 로그인 상태일 때 서버로부터 회원 정보 요청 , 로그인 중일때 실행
  void onInfo(token) async {
    try {
      // [*] Dio 에서 Headers 정보를 보내는 방법 , Options
      Dio dio = Dio();
      // - 방법1 : dio.options.headers['속성명']=값;
      // - 방법2 : dio.get(options:{headers:{'속성명':값}})
      // - 토큰을 Authorization 헤더에 추가
      dio.options.headers['Authorization'] = token;

      final response = await dio.get("http://192.168.40.5/member/info"); // 정보 요청 API 호출 , 환경에 따라서 주소 설정
      final data = response.data;
      print(data); // 응답 데이터 콘솔 출력

      if (data != '') {
        // - 로그인 회원정보가 존재하면
        // - 서버에서 받은 회원 정보 상태 변수에 저장
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
    final prefs = await SharedPreferences.getInstance(); // - 저장소 호출
    final token = prefs.getString('token');              // - 토큰 꺼냄(전역 변수에서 토큰을 꺼내기)

    if (token == null) return; // 토큰 없으면 종료

    Dio dio = Dio();
    dio.options.headers['Authorization'] = token;        // -  로그아웃 요청 시 토큰 포함
    final response = dio.get("http://192.168.40.5/member/logout"); // - 서버 로그아웃 요청 , 환경에 따라서 주소 설정

    await prefs.remove('token'); // SharedPreferences에서 토큰 제거

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainApp())); // 페이지 전환 및 이동
  }

  // [4] UI 구성 메서드
  @override
  Widget build(BuildContext context) { // fs

    // [*] 만약에 로그인상태가 확인 되기 전 , 대기 화면 표현
    if(isLogin==null){ // - 만약에 비로그인 이면
      return Scaffold(// CircularProgressIndicator () : 로딩 화면 제공 위젯
        body: Center(child: CircularProgressIndicator(),),
      );
    }
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