 // dart 언어는 단일 스레드 기반

 // [*] 사용법
 // 1. DIO 객체 생성 , java:new(클래스명()  vs dart : 클래스명()
 // 2. 파일 상단에 import 'package:dio/dio.dart';
 import 'package:dio/dio.dart';

final dio =Dio(); // final : 상수키워드
void main(){ // main 함수가 스레드를 갖고 시작하는 코드의 시작점.
  print('dart start');

  getHttp();
  postHttp();
}

// [*] 사용법
 // (1) 비동기통신 get
 void getHttp() async {
   try {
     // 1. dio객체를 이용한 자바와의 통신방법
     final response = await dio.get(
         "http://localhost:8080/class03/task/course");
     // 2. 응답확인
     print(response.data);
   }catch(e){print(e);}
 }
 // (2) 비동기통신 post
 void postHttp() async{
   try {
   // 1. 보내려고 하는 내용물 JSON(Dart map)
   final sendData ={"cname": "자바의정석",
     "ctec": "남궁민",
     "cdate": "2025-03-01~25-06-30"};
   // 2. dio객체를 이용한 자바와의 통신방법
   final a = 3+3;
   final response = await dio.post("http://localhost:8080/class03/task/course",data:sendData);
   // 3. 응답 확인
   print(response.data);
   }catch(e){print(e);}
}