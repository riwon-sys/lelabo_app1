import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BookFormPage extends StatefulWidget {
  final int? aid; // null이면 등록, 값이 있으면 수정
  const BookFormPage({Key? key, this.aid}) : super(key: key);

  @override
  State<BookFormPage> createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
  final _formKey = GlobalKey<FormState>();
  final titleCtrl = TextEditingController();
  final writerCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  final newPwdCtrl = TextEditingController(); // 수정 시 새 비밀번호
  File? imageFile;

  bool isEdit = false;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    if (widget.aid != null) {
      isEdit = true;
      fetchBook();
    }
  }

  Future<void> fetchBook() async {
    try {
      final res = await dio.get("http://192.168.40.5:8080/ab/abfindbyid", queryParameters: {
        "aid": widget.aid,
      });

      final data = res.data;
      titleCtrl.text = data['atitle'];
      writerCtrl.text = data['awriter'];
      contentCtrl.text = data['acontent'];
    } catch (e) {
      print("기존 도서 정보 불러오기 실패: $e");
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    final formData = FormData.fromMap({
      "atitle": titleCtrl.text,
      "awriter": writerCtrl.text,
      "acontent": contentCtrl.text,
      "apwd": pwdCtrl.text,
      if (imageFile != null)
        "multipartFile": await MultipartFile.fromFile(imageFile!.path),
    });

    // 수정일 경우 추가 필드
    if (isEdit) {
      formData.fields.add(MapEntry("aid", widget.aid.toString()));
      if (newPwdCtrl.text.isNotEmpty) {
        formData.fields.add(MapEntry("newPwd", newPwdCtrl.text));
      }
    }

    try {
      final response = await dio.request(
        isEdit
            ? "http://192.168.40.5:8080/ab/abupdate"
            : "http://192.168.40.5:8080/ab/abpost",
        data: formData,
        options: Options(
          method: isEdit ? "PUT" : "POST",
          contentType: "multipart/form-data",
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(isEdit ? "수정 완료되었습니다." : "등록 완료되었습니다."),
        ));
        Navigator.pop(context, true); // 리스트 새로고침 신호
      }
    } catch (e) {
      print("전송 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("작업 실패. 비밀번호를 확인하세요."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "도서 수정" : "도서 등록"),
        backgroundColor: Colors.green.shade800,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleCtrl,
                decoration: InputDecoration(labelText: "책 제목"),
                validator: (v) => v!.isEmpty ? "제목 입력" : null,
              ),
              TextFormField(
                controller: writerCtrl,
                decoration: InputDecoration(labelText: "저자"),
                validator: (v) => v!.isEmpty ? "저자 입력" : null,
              ),
              TextFormField(
                controller: contentCtrl,
                decoration: InputDecoration(labelText: "내용"),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? "내용 입력" : null,
              ),
              TextFormField(
                controller: pwdCtrl,
                decoration: InputDecoration(labelText: isEdit ? "기존 비밀번호" : "비밀번호"),
                obscureText: true,
                validator: (v) => v!.isEmpty ? "비밀번호 입력" : null,
              ),
              if (isEdit)
                TextFormField(
                  controller: newPwdCtrl,
                  decoration: InputDecoration(labelText: "새 비밀번호 (선택)"),
                  obscureText: true,
                ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: Icon(Icons.image),
                label: Text("이미지 선택"),
              ),
              if (imageFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.file(imageFile!, height: 100),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submit,
                child: Text(isEdit ? "수정하기" : "등록하기"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              )
            ],
          ),
        ),
      ),
    );
  }
}