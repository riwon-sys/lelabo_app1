/*  myapp.dart | rw 25-04-18 생성
    - 앱 전체 라우팅을 정의하는 MaterialApp 루트입니다.
*/

import 'package:flutter/material.dart';
import 'package:lelabo_app1/app2/layout/mainapp.dart'; // 하단탭 구조 포함된 메인 앱

class MyApp extends StatelessWidget { // CS
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) { // fs
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // 우측 상단 Debug 배너 제거
      title: 'Book Recommendation App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: MainApp(),  // 하단 탭 포함된 레이아웃으로 시작
    );
  } // fe
} // CE