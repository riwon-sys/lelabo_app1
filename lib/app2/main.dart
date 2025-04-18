/*  main.dart | rw 25-04-15 생성
   - 플러터 애플리케이션의 시작점이며, 실행 진입 파일입니다.
   - runApp() 함수를 통해 앱 전체를 구동하며, 첫 진입 위젯으로 MyApp을 호출합니다.
*/

import 'package:flutter/material.dart';                   // 기본 플러터 위젯 기능 import
import 'package:lelabo_app1/app2/layout/myapp.dart';       // 앱 전체를 구성하는 MyApp 클래스 import

void main() { // fs
  // runApp(): 앱에서 가장 처음 실행되는 함수
  // MyApp(): 앱의 전체 구조(MaterialApp)를 포함하는 최상위 위젯
  runApp(MyApp());
} // fe
