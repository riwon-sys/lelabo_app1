/*  mainapp.dart | rw 25-04-18 생성
    - 하단 탭이 포함된 앱 메인 구조입니다.
    - 각 탭에 따라 book_list, book_form, review_form을 전환합니다.
*/

import 'package:flutter/material.dart';
import '../book/book_list.dart';       // 홈 화면 (책 목록)
import '../book/book_form.dart';       // 책 등록 화면
import '../review/review_form.dart';   // 리뷰 등록 화면

class MainApp extends StatefulWidget { // CS
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
} // CE

class _MainAppState extends State<MainApp> { // CS
  int _currentIndex = 0; // 현재 선택된 탭 인덱스

  // 각 탭에 연결된 화면 리스트
  final List<Widget> _pages = [
    BookListPage(),     // 홈 탭
    BookFormPage(),     // 책 등록 탭
    ReviewFormPage(aid: 1), // 리뷰 등록 탭 (aid는 임시값)
  ];

  @override
  Widget build(BuildContext context) { // fs
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: '책 등록'),
          BottomNavigationBarItem(icon: Icon(Icons.comment), label: '리뷰 등록'),
        ],
      ),
    );
  } // fe
} // CE