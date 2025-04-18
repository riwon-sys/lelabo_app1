/*  mainapp.dart | rw 25-04-15 생성
   - 앱 전체 화면의 구조(레이아웃)를 담당하는 StatefulWidget입니다.
   - AppBar, BottomNavigationBar, 각 페이지 본문을 탭 형식으로 관리합니다.
*/

import 'package:flutter/material.dart';                         // 플러터 기본 위젯 import
import 'package:lelabo_app1/app/member/signup.dart';            // 회원가입(Signup) 페이지 import

class MainApp extends StatefulWidget { // CS
  @override
  State<StatefulWidget> createState() {
    return _MainAppState();                                      // 상태 관리용 클래스 반환
  }
} // CE

class _MainAppState extends State<MainApp> { // CS

  // [1] 본문으로 출력할 위젯들을 리스트에 저장 (index로 선택)
  List<Widget> pages = [
    Text("홈 페이지"),                                           // 첫 번째 페이지
    Text("게시물1 페이지"),                                      // 두 번째 페이지
    Text("게시물2 페이지"),                                      // 세 번째 페이지
    Signup(),                                                   // 네 번째 페이지: 회원가입 화면
  ];

  // [2] 각 페이지에 해당하는 상단 제목 리스트
  List<String> pageTitle = [
    '홈',
    '게시물1',
    '게시물2',
    '내정보(회원가입)',
  ];

  // [3] 현재 선택된 페이지 번호를 저장하는 상태 변수
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) { // fs
    // Scaffold: 화면 전체의 틀을 구성하는 위젯
    return Scaffold(

      // [4] 상단 앱바 구성
        appBar: AppBar(
          title: Row(
            children: [
              Image(                                                  // 앱 로고 이미지
                image: AssetImage('assets/images/logo.jpg'),          // 로컬 이미지 경로 지정
                height: 50,
                width: 50,
              ),
              SizedBox(width: 20),                                     // 제목과 로고 사이 여백
              Text(pageTitle[selectedIndex]),                          // 현재 선택된 제목 표시
            ],
          ),
          backgroundColor: Colors.white,                               // 앱바 배경색
        ), // 앱바 end

        // [5] 본문 영역: 현재 선택된 인덱스에 해당하는 위젯 표시
        body: pages[selectedIndex],

        // [6] 하단 네비게이션 바
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => setState(() { selectedIndex = index; }),  // 탭 클릭 시 상태 변경
          currentIndex: selectedIndex,                                // 현재 선택된 탭 유지
          type: BottomNavigationBarType.fixed,                        // 고정된 크기로 표시 (4개 이상 가능)
          items: [                                                    // 탭 항목 구성
            BottomNavigationBarItem( // [1] 홈 탭 아이템
              icon: Icon(Icons.home),                    // 홈 아이콘
              label: '홈',                               // 탭 제목 텍스트
            ),

            BottomNavigationBarItem( // [2] 게시물1 탭 아이템
              icon: Icon(Icons.forum),                   // 포럼(말풍선) 아이콘
              label: '게시물1',                          // 탭 제목 텍스트
            ),

            BottomNavigationBarItem( // [3] 게시물2 탭 아이템
              icon: Icon(Icons.forum),                   // 포럼(말풍선) 아이콘 (재사용)
              label: '게시물2',                          // 탭 제목 텍스트
            ),

            BottomNavigationBarItem( // [4] 내정보(회원가입) 탭 아이템
              icon: Icon(Icons.person),                  // 사람 모양 아이콘
              label: '내정보(회원가입)',                  // 탭 제목 텍스트
            ),
          ],
        ) // 바텀 네비게이션 end

    ); // Scaffold end
  } // fe

} // CE