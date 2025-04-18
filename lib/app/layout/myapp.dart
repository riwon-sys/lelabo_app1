/*  myapp.dart | rw 25-04-15 생성
   - 앱 전체를 감싸는 MaterialApp을 구성하는 루트 위젯입니다.
   - 테마, 타이틀, 초기 화면(home)을 설정합니다.
*/

import 'package:flutter/material.dart';                     // 플러터 기본 위젯 import
import 'package:lelabo_app1/app/layout/mainapp.dart';       // 앱 본문(MainApp)을 구성하는 파일 import

class MyApp extends StatelessWidget { // CS

  // StatelessWidget → 상태가 없는 위젯
  // 앱 구조만 정의하고 상태 변화는 없음

  @override
  Widget build(BuildContext context) { // fs
    // MaterialApp: 앱의 전체 스타일, 구조, 테마를 설정하는 최상위 위젯
    return MaterialApp(
      title: "더조은앱",                                    // 앱 탭(윈도우) 이름 설정
      theme: ThemeData(                                     // 앱 전체에 적용될 테마 설정
        scaffoldBackgroundColor: Colors.white,              // Scaffold 배경색 흰색으로 설정
      ),
      home: MainApp(),                                      // 앱 실행 시 가장 먼저 보여줄 화면(MainApp)
    );
  } // fe

} // CE