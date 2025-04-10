// update.dart : 할일 수정 화면 | rw 25-04-09 생성

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Update extends StatefulWidget {
  final Map<String, dynamic> todo; // 수정할 대상 todo 객체를 전달받기 위한 필드

  Update({required this.todo}); // 생성자에서 필수 매개변수로 전달받음

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  // 1. 입력 필드를 위한 컨트롤러 선언
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // 2. dio 객체 생성
  Dio dio = Dio();

  // 3. 전달받은 데이터를 초기화 시점에 입력창에 넣기
  @override
  void initState() {
    super.initState();
    titleController.text = widget.todo['title'];    // 제목 미리 채우기
    contentController.text = widget.todo['content']; // 내용 미리 채우기
  }

  // 4. 수정 요청 함수
  void todoUpdate() async {
    try {
      final sendData = {
        "id": widget.todo['id'],                 // 수정 대상 id
        "title": titleController.text,           // 수정된 제목
        "content": contentController.text,       // 수정된 내용
        "done": widget.todo['done'],             // 기존 상태 유지
      };

      final response = await dio.put(
        "http://192.168.40.5:8080/class04/todos", // Spring 서버에 PUT 요청
        data: sendData,
      );

      final data = response.data;
      if (data != null) {
        // Navigator.pushNamed → 페이지가 쌓이므로 pop으로 돌아가기 권장
        Navigator.pop(context, true); // 현재 페이지 닫기
      }
    } catch (e) {
      print(e);
    }
  }

  // 5. 화면 UI 구성
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("할일 수정 화면")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("할일을 수정해보세요.", style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),

            // 제목 입력 필드
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "TODO TITLE",
                border: OutlineInputBorder(),
              ),
              maxLength: 255,
            ),
            SizedBox(height: 20),

            // 내용 입력 필드
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: "TODO CONTENT",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 30),

            // 수정 버튼
            Center(
              child: OutlinedButton(
                onPressed: todoUpdate,
                child: Text("수정하기"),
              ),
            )
          ],
        ),
      ),
    );
  }
}