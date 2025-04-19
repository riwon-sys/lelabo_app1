/*  review_form.dart | rw 25-04-19 통합 구성 (등록 + 수정)
    - 등록과 수정을 isEdit 여부로 구분
    - PUT / POST 전송 모두 처리
*/

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReviewFormPage extends StatefulWidget {
  final int aid; // 도서 ID (등록용)
  final Map<String, dynamic>? review; // null이면 등록, 값이 있으면 수정
  const ReviewFormPage({Key? key, required this.aid, this.review}) : super(key: key);

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final titleCtrl = TextEditingController();
  final writerCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  final newPwdCtrl = TextEditingController();
  File? imageFile;
  final Dio dio = Dio();
  late bool isEdit;

  @override
  void initState() {
    super.initState();
    isEdit = widget.review != null;
    if (isEdit) {
      final r = widget.review!;
      titleCtrl.text = r['rtitle'] ?? '';
      writerCtrl.text = r['rwriter'] ?? '';
      contentCtrl.text = r['rcontent'] ?? '';
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => imageFile = File(picked.path));
  }

  Future<void> submit() async {
    if (titleCtrl.text.isEmpty || contentCtrl.text.isEmpty || writerCtrl.text.isEmpty || pwdCtrl.text.isEmpty) return;

    final formData = FormData.fromMap({
      "rtitle": titleCtrl.text,
      "rwriter": writerCtrl.text,
      "rcontent": contentCtrl.text,
      "rpwd": pwdCtrl.text,
      if (!isEdit) "aid": widget.aid.toString(),
      if (isEdit) "rno": widget.review!['rno'].toString(),
      if (isEdit && newPwdCtrl.text.isNotEmpty) "newPwd": newPwdCtrl.text,
      if (imageFile != null) "file": await MultipartFile.fromFile(imageFile!.path),
    });

    try {
      final res = await dio.request(
        isEdit ? "http://192.168.40.5:8080/rb/rbupdate" : "http://192.168.40.5:8080/rb/rbpost",
        data: formData,
        options: Options(method: isEdit ? "PUT" : "POST"),
      );
      if (res.statusCode == 200) Navigator.pop(context, true);
    } catch (e) {
      print("리뷰 ${isEdit ? '수정' : '등록'} 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "리뷰 수정" : "리뷰 등록"),
        backgroundColor: Colors.green.shade800,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleCtrl, decoration: InputDecoration(labelText: "제목")),
            TextField(controller: writerCtrl, decoration: InputDecoration(labelText: "작성자")),
            TextField(controller: contentCtrl, decoration: InputDecoration(labelText: "내용"), maxLines: 3),
            TextField(controller: pwdCtrl, decoration: InputDecoration(labelText: isEdit ? "기존 비밀번호" : "비밀번호"), obscureText: true),
            if (isEdit)
              TextField(controller: newPwdCtrl, decoration: InputDecoration(labelText: "새 비밀번호 (선택)"), obscureText: true),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: pickImage,
              icon: Icon(Icons.image),
              label: Text("이미지 선택"),
            ),
            if (imageFile != null) Image.file(imageFile!, height: 100),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submit,
              child: Text(isEdit ? "리뷰 수정하기" : "리뷰 등록하기"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            )
          ],
        ),
      ),
    );
  }
}