/*  review_form.dart | rw 25-04-18 재구성
   - 리뷰 등록 화면입니다.
   - 사용자가 제목, 작성자, 내용, 비밀번호 입력 + 이미지 업로드 가능합니다.
   - Dio를 통해 /rb/rbpost (POST) 요청으로 서버에 등록합니다.
*/

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReviewFormPage extends StatefulWidget {
  final int aid; // 책 고유번호
  const ReviewFormPage({Key? key, required this.aid}) : super(key: key);

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final _formKey = GlobalKey<FormState>();
  final titleCtrl = TextEditingController();
  final writerCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  File? imageFile;

  // 이미지 선택 함수
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  // 리뷰 등록 요청 함수
  Future<void> submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      FormData formData = FormData.fromMap({
        "rtitle": titleCtrl.text,
        "rwriter": writerCtrl.text,
        "rcontent": contentCtrl.text,
        "rpwd": pwdCtrl.text,
        "aid": widget.aid,
        if (imageFile != null)
          "file": await MultipartFile.fromFile(imageFile!.path),
      });

      final dio = Dio();
      final response = await dio.post("http://192.168.40.5:8080/rb/rbpost", data: formData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("리뷰가 등록되었습니다.")));
        Navigator.pop(context);
      } else {
        throw Exception("등록 실패");
      }
    } catch (e) {
      print("등록 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("리뷰 등록에 실패했습니다.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("리뷰 등록"),
        backgroundColor: Colors.green.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleCtrl,
                decoration: InputDecoration(labelText: "리뷰 제목"),
                validator: (val) => val!.isEmpty ? "제목을 입력하세요" : null,
              ),
              TextFormField(
                controller: writerCtrl,
                decoration: InputDecoration(labelText: "작성자"),
                validator: (val) => val!.isEmpty ? "작성자를 입력하세요" : null,
              ),
              TextFormField(
                controller: contentCtrl,
                decoration: InputDecoration(labelText: "리뷰 내용"),
                maxLines: 4,
                validator: (val) => val!.isEmpty ? "내용을 입력하세요" : null,
              ),
              TextFormField(
                controller: pwdCtrl,
                decoration: InputDecoration(labelText: "비밀번호"),
                obscureText: true,
                validator: (val) => val!.isEmpty ? "비밀번호를 입력하세요" : null,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: pickImage,
                child: Text("이미지 선택"),
              ),
              if (imageFile != null) Image.file(imageFile!, height: 100),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitReview,
                child: Text("리뷰 등록하기"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}