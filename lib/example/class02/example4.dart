import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main (){ // 프로그램의 진입점
  // 메뉴 상단에 'select device'에서 web 선택후 실행
  // 'device manager' 해당하는 디바이스 실행
  // runApp(MyApp1()); // 가장 기본적인 앱 출력 클래스 runApp(출력클래스() );
  runApp(MyApp2());
} // f end

// (1) 간단한 화면 만들기, class 클래스명 extends
// StatelessWidget : 상태가 없는 인터페이스
// -> 하나의 추상메소드를 제공한다.
class MyApp1 extends StatelessWidget{ // 고정 화면을 만드는 기본 위젯 제공 클래스
  // 컨트롤 + 스페이스바 : build 함수 재정의(오버라이딩)
  @override
  Widget build(BuildContext context) {
    // 기존 코드 지우고 return 출력할 위젯
    return MaterialApp(home :Text("안녕하세요 플러터 , 리로드 "));
  } //fe
} // ce

class MyApp2 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        appBar: AppBar(title:Text("여기는 상단메뉴")), // 상단 메뉴바
        body: Center(child: Text("여기는 본문")), // 본문
        bottomNavigationBar: BottomAppBar(child: Text("여기는 하단 메뉴")) // 하단 메뉴바
      ),
    );


  }
}