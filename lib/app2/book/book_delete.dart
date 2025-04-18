import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class BookDeletePage extends StatefulWidget {
  final int aid; // 도서 고유번호
  const BookDeletePage({Key? key, required this.aid}) : super(key: key);

  @override
  State<BookDeletePage> createState() => _BookDeletePageState();
}

class _BookDeletePageState extends State<BookDeletePage> {
  final TextEditingController pwdCtrl = TextEditingController();
  final Dio dio = Dio();

  Future<void> deleteBook() async {
    try {
      final response = await dio.delete(
        "http://192.168.40.5:8080/ab/abdelete",
        queryParameters: {
          "aid": widget.aid,
          "apwd": pwdCtrl.text,
        },
      );

      if (response.statusCode == 200 && response.data == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("도서가 삭제되었습니다.")));
        Navigator.pop(context, true); // ✅ 삭제 성공 시 true 반환
      } else {
        throw Exception("삭제 실패");
      }
    } catch (e) {
      print("삭제 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("삭제 실패. 비밀번호를 확인하세요.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("도서 삭제"),
        backgroundColor: Colors.red.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("정말 삭제하시겠습니까?", style: TextStyle(fontSize: 16)),
            TextField(
              controller: pwdCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: "비밀번호 입력"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: deleteBook,
              child: Text("삭제하기"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            )
          ],
        ),
      ),
    );
  }
}