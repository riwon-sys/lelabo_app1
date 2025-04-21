/*  mainapp.dart | rw 25-04-21 생성
    - 앱 전체 레이아웃 구조를 담당하는 StatefulWidget입니다.
    - AppBar(상단바), BottomNavigationBar(하단탭), 각 본문 페이지를 탭 방식으로 관리합니다.
    - 탭 선택에 따라 Info(내정보), Login(로그인), Signup(회원가입) 화면으로 전환됩니다.
    - 화면 전환은 상태 변수(selectedIndex)에 따라 위젯 리스트(pages)에서 결정됩니다.
    - 로고 이미지는 로컬 assets/images 경로에서 불러오며, pubspec.yaml 설정이 필요합니다.
*/

// [1] 외부 패키지 import
import 'package:flutter/material.dart';                           // 기본 Flutter 위젯
import 'package:lelabo_app1/app/member/info.dart';                // 내정보 페이지
import 'package:lelabo_app1/app/member/login.dart';               // 로그인 페이지
import 'package:lelabo_app1/app/member/signup.dart';              // 회원가입 페이지

// [2] 메인앱 클래스 정의 (상태 기반 위젯)
class MainApp extends StatefulWidget { // CS
  @override
  State<StatefulWidget> createState() {
    return _MainAppState(); // 상태 관리용 클래스 반환
  }
} // CE

// [3] 실제 상태를 관리하는 클래스
class _MainAppState extends State<MainApp> { // CS

  // [3-1] 페이지 위젯 리스트 (탭에 따라 본문 변경)
  List<Widget> pages = [
    Text("홈 페이지"),
    Info(),    // 게시물1 → 내정보 화면 대체
    Login(),   // 게시물2 → 로그인 화면 대체
    Signup(),  // 내정보(회원가입)
  ];

  // [3-2] 페이지 상단 제목 리스트
  List<String> pageTitle = [
    '홈',
    '게시물1',
    '게시물2',
    '내정보(회원가입)',
  ];

  // [3-3] 현재 선택된 탭 인덱스 저장용 상태 변수
  int selectedIndex = 0;

  // [4] 화면 렌더링 메서드
  @override
  Widget build(BuildContext context) { // fs
    return Scaffold( // 전체 레이아웃 틀

      // [4-1] 상단 AppBar 구성
      appBar: AppBar(
        title: Row(
          children: [
            // (1) 로컬 이미지 로고
            Image(
              image: AssetImage('assets/images/logo.jpg'), // pubspec.yaml 등록 필요
              height: 50,
              width: 50,
            ),
            SizedBox(width: 20), // 이미지와 제목 사이 간격
            Text(pageTitle[selectedIndex]), // 현재 탭 제목
          ],
        ),
        backgroundColor: Colors.white, // 앱바 배경색
      ), // AppBar end

      // [4-2] 본문 영역
      body: pages[selectedIndex], // 현재 선택된 인덱스의 페이지 반환

      // [4-3] 하단 탭 네비게이션 구성
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() { selectedIndex = index; }), // 탭 클릭 시 상태 변경
        currentIndex: selectedIndex,   // 현재 선택된 인덱스 유지
        type: BottomNavigationBarType.fixed, // 고정형 (4개 이상 탭 대응)
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: '게시물1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: '게시물2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내정보(회원가입)',
          ),
        ],
      ), // BottomNavigationBar end

    ); // Scaffold end
  } // fe

} // CE