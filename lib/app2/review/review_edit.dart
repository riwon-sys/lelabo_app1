/*  review_edit.dart | rw 25-04-19 생성
    - 리뷰 수정 화면 구성 파일입니다.
    - 기존 리뷰 데이터를 받아와서 수정 후 제출합니다.
    - 수정은 Multipart/form-data 방식으로 처리하며 이미지 선택은 optional입니다.
*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class ReviewEditPage extends StatefulWidget {
  final Map<String, dynamic> review; // 기존 리뷰 정보

  const ReviewEditPage({Key? key, required this.review}) : super(key: key);

  @override
  State<ReviewEditPage> createState() => _ReviewEditPageState();
}

class _ReviewEditPageState extends State<ReviewEditPage> {
  final Dio dio = Dio();
  final formKey = GlobalKey<FormState>();

  late TextEditingController titleCtrl;
  late TextEditingController writerCtrl;
  late TextEditingController contentCtrl;
  late TextEditingController pwdCtrl;

  XFile? selectedImage;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.review['rtitle']);
    writerCtrl = TextEditingController(text: widget.review['rwriter']);
    contentCtrl = TextEditingController(text: widget.review['rcontent']);
    pwdCtrl = TextEditingController();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = image;
    });
  }

  Future<void> submitReview() async {
    if (!formKey.currentState!.validate()) return;

    final formData = FormData.fromMap({
      "rno": widget.review['rno'],
      "aid": widget.review['aid'],
      "rtitle": titleCtrl.text,
      "rwriter": writerCtrl.text,
      "rcontent": contentCtrl.text,
      "rpwd": pwdCtrl.text,
      if (selectedImage != null)
        "rimgfile": await MultipartFile.fromFile(selectedImage!.path),
    });

    try {
      final response = await dio.put(
        "http://192.168.40.5:8080/rb/rbupdate",
        data: formData,
      );

      if (response.data == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("리뷰가 수정되었습니다.")));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("비밀번호가 틀렸습니다.")));
      }
    } catch (e) {
      print("리뷰 수정 실패: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("리뷰 수정 중 오류 발생")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("리뷰 수정"),
        backgroundColor: Colors.green.shade800,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleCtrl,
                decoration: InputDecoration(labelText: "제목"),
                validator: (v) => v!.isEmpty ? "제목을 입력하세요" : null,
              ),
              TextFormField(
                controller: writerCtrl,
                decoration: InputDecoration(labelText: "작성자"),
                validator: (v) => v!.isEmpty ? "작성자를 입력하세요" : null,
              ),
              TextFormField(
                controller: contentCtrl,
                decoration: InputDecoration(labelText: "내용"),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? "내용을 입력하세요" : null,
              ),
              TextFormField(
                controller: pwdCtrl,
                decoration: InputDecoration(labelText: "비밀번호"),
                obscureText: true,
                validator: (v) => v!.isEmpty ? "비밀번호를 입력하세요" : null,
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: Icon(Icons.image),
                label: Text("이미지 선택"),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: submitReview,
                child: Text("리뷰 수정"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}