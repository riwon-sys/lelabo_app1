// write.dart : 등록 화면 파일 | rw 25-04-09 생성
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// 상태 있는 위젯 만들기

class Write extends StatefulWidget{
  @override
  _WriteState createState() {
    // TODO: implement createState
   return _WriteState();
  }
}
class _WriteState extends State< Write >{
  // 1. 텍스트 입력창에 사용되는 컨트롤러 객체 선언 , 목적 : 입력받은 값 가져오기
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  // 2. dio 와 자바와 통신하기

  Dio dio = Dio();
  void todosave()async{
    try{
      final sendData ={
        "title" : titleController.text , // 제목
        "content" :contentController.text, // 내용
        "done":"false" // 상태
      };
      final response =await dio.post("http://192.168.40.5:8080/class04/todos" , data : sendData);
      final data = response.data;
      if(data != null){
        Navigator.pushNamed(context,"/home"); // 라우터 이용한 "/" 메인페이지 이동
      }
    }catch(e){print(e);}
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar( title: Text("할일 등록 화면"),),
      body: Center(
        child: Column(
          children: [

            Text("할일을 등록해보세요."), // 텍스트 위젯 제목
            SizedBox( height: 30,),
            TextField(
              controller: titleController , // title 입력받은 텍스트 입력 위젯
              decoration: InputDecoration(labelText: "TODO TITLE"),
              maxLength: 255, // 입력 글자 수 제한
            ),

            SizedBox(height: 30,),
            TextField(
              controller: contentController , // content 입력받은 텍스트 입력 위젯
              decoration: InputDecoration(labelText: "TODO CONTENT"),
              maxLines: 3, // 기본 줄수 제한 수
            ),
            SizedBox(height: 30,),
            OutlinedButton(onPressed: todosave , child: Text("CLICK"))
          ], // 위젯들
        ),
      ),
    );
  } // build end
} // class end
