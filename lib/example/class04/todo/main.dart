// main.dart :  앱 실행의 최초 파일

// [1]. main함수를 이용한 앱 실행
import 'package:flutter/material.dart';

// rw 25-04-09 생성
import 'package:lelabo_app1/example/class04/todo/home.dart';   // home.dart 파일 import
import 'package:lelabo_app1/example/class04/todo/write.dart';  // write.dart 파일 import
import 'package:lelabo_app1/example/class04/todo/update.dart'; // update.dart 파일 import
import 'package:lelabo_app1/example/class04/todo/detail.dart';   // detail.dart 파일 import | rw 25-04-10

void main ()
{
 runApp( MyApp() ); // 롸우터를 갖는 위젯이 최소 화면
}

// [2]. 롸우터를 갖는 클래스
class MyApp extends StatelessWidget { // 상태 없는 위젯
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 상단 debug 배너 제거 (선택)
      initialRoute: "/home", // 앱 실행 시 초기 경로 설정

      // 일반 routes 방식은 Write(), Home() 등 매개변수 없는 경우에만 사용
      routes: {
        "/home": (context) => Home(),
        "/write": (context) => Write(),
        "/detail": (context) => Detail(),
      },

      // arguments 전달이 필요한 경우에는 아래의 onGenerateRoute를 사용
      onGenerateRoute: (settings) {
        if (settings.name == "/update") {
          final todo = settings.arguments as Map<String, dynamic>; // 전달받은 todo 꺼내기
          return MaterialPageRoute(
            builder: (context) => Update(todo: todo), // 필수 매개변수 전달
          );
        }
        return null;
      },
    );
  }
}