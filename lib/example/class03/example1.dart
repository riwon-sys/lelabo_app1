// 플러터 : dart언어(google) 기반의 프레임 워크
// dart 언어 클래스  : 첫 글자 대문자 시작
// dart 언어 인스턴스생성 : 클래스명()
// 위젯 : 화면을 그려내는 최소의 단위, 클래스기반(첫글자를 대문자로해야함)
// - 위젯 사용법 ==================================================
     // 1. 위젯명 : 클래스명과 동일하게 첫글자가 대문자이다.
     // 2. () : 클래스명뒤에 생성자 처럼 초기값 대입하는 매개변수 자리
          // java : new Member( "유" , 40 );
          // dart : Member( name : "유재석" , age : 40 );
     // 위젯 안에 위젯 vs 객체 안에 객체
     // 3. 위젯명 ( 속성명 : 위젯명 ( 속성명 : 위젯명() ) );
          // 속성 : 각 위젯들이 정의한 속성명들이 존재한다( 매개변수명 )
     // 4. 위젯 트리 ( 위젯 구조 )
/*
*  MyApp ( StatelessWidget ) : 상태 없는 위젯 ( 화면 )
*    -> build
*       -> MaterialApp
*          -> home
*             -> Scaffold
*                -> appBar
*                   -> AppBar
*                      -> Text
*                   -> body
*                      -> Text
*                   -> bottomNavigationBar
*                      -> Text
*/
import 'package:flutter/material.dart';
// [1].
void main(){
  print("콘솔 출력");

  // 디바이스 선택 후 실행 : web , app
  runApp( MyApp2() );
  //runApp(최초로 실행할 ; Material | runApp( 클래스명() )
} // fe

// [2]. 클래스 생성
class MyApp1 extends StatelessWidget{ // MyApp1 에 처음 빨간줄 뜨는 이유는 바로 하단에 @override 미입력해서
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();
    return MaterialApp( // 뼈대
        home: Scaffold( // 레이아웃
          // 속성명 : 위젯명( )
          appBar: AppBar(title:Text("상단메뉴")), // 상단메뉴
          body: Text("본문"), // 본문
          bottomNavigationBar: BottomAppBar(child:Text("하단메뉴"),), // 하단메뉴
        )   

        ); // 클래스지만 클래스라고 하지않고 위젯 이라고함
  }// w e

} // c e



// [3]. 상태 없는 위젯이란 ? StatelessWidget : 고정된(불변) UI
class MyApp2 extends StatelessWidget{
  int count = 0; // 값 변수
  void increment() {
    count ++;
    print ( count );
  }
  // 증가 함수
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp( // 모든 위젯을 감싼 뼈대 역할의 위젯
      home: Scaffold( // 레이ㅏ웃을 구성하는 위젯
        appBar: AppBar(title: Text("상단 텍스트"),), // 상단바를 제공하는 위젯
        body: Center( // 가로 가운데 정렬을 하기위한 센터 위젯
          child: Column( // 센터 안에 자식의 컬럼 이 들어있다.
            children: [
              Text("본문 텍스트 : $count") ,
              // OutlinedButton(onPressed: onPressed, child: child) // 미리 꾸며진 버튼도 있음
              TextButton( // 텍스트 형식의 버튼 위젯
                  onPressed:increment , // onclick , 버튼을 클릭했을때 auto-increment 형식을 실행 하겠다.
                  child: Text("클릭"))
            ],
            // children 여러명의 자식들
            // Column( children : [ 위젯1() , 위젯2() , 위젯3() ] ) ;
          ), // 세로배치를 해주는
          
        ), // 가로/세로 가운데 정렬
      ),
    );
  }
}