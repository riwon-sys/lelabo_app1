/*  book_form.dart | rw 25-04-18 생성
   - 추천 도서 등록 또는 수정 화면입니다.
   - 책 제목, 저자, 내용, 비밀번호, 이미지 첨부 가능
*/

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BookFormPage extends StatefulWidget { // CS
  const BookFormPage({super.key});

  @override
  State<BookFormPage> createState() => _BookFormPageState();
} // CE

class _BookFormPageState extends State<BookFormPage> { // CS
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController writerCtrl = TextEditingController();
  final TextEditingController contentCtrl = TextEditingController();
  final TextEditingController pwdCtrl = TextEditingController();
  File? imageFile;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Future<void> submitBook() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final dio = Dio();
      final formData = FormData.fromMap({
        "atitle": titleCtrl.text,
        "awriter": writerCtrl.text,
        "acontent": contentCtrl.text,
        "apwd": pwdCtrl.text,
        if (imageFile != null)
          "file": await MultipartFile.fromFile(imageFile!.path),
      });

      final response = await dio.post("http://192.168.40.5:8080/ab/abpost", data: formData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("도서가 등록되었습니다.")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print("등록 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) { // fs
    return Scaffold(
      appBar: AppBar(title: Text("도서 등록하기"), backgroundColor: Colors.green.shade800),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleCtrl,
                decoration: InputDecoration(labelText: "책 제목"),
                validator: (val) => val!.isEmpty ? "제목을 입력하세요" : null,
              ),
              TextFormField(
                controller: writerCtrl,
                decoration: InputDecoration(labelText: "저자"),
                validator: (val) => val!.isEmpty ? "저자를 입력하세요" : null,
              ),
              TextFormField(
                controller: contentCtrl,
                decoration: InputDecoration(labelText: "소개"),
                maxLines: 3,
                validator: (val) => val!.isEmpty ? "소개를 입력하세요" : null,
              ),
              TextFormField(
                controller: pwdCtrl,
                decoration: InputDecoration(labelText: "비밀번호"),
                obscureText: true,
                validator: (val) => val!.isEmpty ? "비밀번호를 입력하세요" : null,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: pickImage,
                    icon: Icon(Icons.image),
                    label: Text("이미지 선택"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                  SizedBox(width: 10),
                  if (imageFile != null)
                    Text("이미지 선택됨")
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: submitBook,
                  child: Text("등록"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              )
            ],
          ),
        ),
      ),
    );
  } // fe
} // CE