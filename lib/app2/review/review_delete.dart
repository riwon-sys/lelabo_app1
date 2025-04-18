/*  review_delete.dart | rw 25-04-18 재구성
   - 리뷰 삭제를 위한 화면입니다.
   - 사용자가 비밀번호를 입력하여 삭제 요청을 보냅니다.
   - Dio로 /rb/rbdelete 호출, aid와 rno를 함께 전달합니다.
*/

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReviewDeletePage extends StatefulWidget {
  final int rno;   // 리뷰 고유번호
  final int aid;   // 책 고유번호 (상세 페이지로 돌아가기 위함)
  const ReviewDeletePage({Key? key, required this.rno, required this.aid}) : super(key: key);

  @override
  State<ReviewDeletePage> createState() => _ReviewDeletePageState();
}

class _ReviewDeletePageState extends State<ReviewDeletePage> {
  final TextEditingController pwdCtrl = TextEditingController();
  final Dio dio = Dio();

  Future<void> deleteReview() async {
    try {
      final response = await dio.delete(
        "http://192.168.40.5:8080/rb/rbdelete",
        queryParameters: {
          "rno": widget.rno,
          "rpwd": pwdCtrl.text,
        },
      );

      if (response.statusCode == 200 && response.data == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("리뷰가 삭제되었습니다.")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      print("삭제 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("리뷰 삭제 실패. 비밀번호를 확인하세요.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("리뷰 삭제"),
        backgroundColor: Colors.red.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("비밀번호를 입력하세요", style: TextStyle(fontSize: 16)),
            TextField(
              controller: pwdCtrl,
              decoration: InputDecoration(labelText: "비밀번호"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: deleteReview,
              child: Text("삭제하기"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}