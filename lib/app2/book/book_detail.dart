/*  book_detail.dart | rw 25-04-19 수정
    - 선택한 도서 상세 정보 출력
    - 리뷰 목록 표시 및 리뷰 등록, 책 수정/삭제 버튼 포함
*/

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lelabo_app1/app2/review/review_card.dart';
import 'package:lelabo_app1/app2/review/review_form.dart';
import 'package:lelabo_app1/app2/book/book_form.dart';
import 'package:lelabo_app1/app2/book/book_delete.dart';

class BookDetailPage extends StatefulWidget {
  final int aid;
  const BookDetailPage({Key? key, required this.aid}) : super(key: key);

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final Dio dio = Dio();
  Map<String, dynamic>? book;
  List<Map<String, dynamic>> reviews = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      final response = await dio.get(
        "http://192.168.40.5:8080/ab/abfindbyid",
        queryParameters: {"aid": widget.aid},
      );
      final reviewRes = await dio.get(
        "http://192.168.40.5:8080/rb/rbfindbyaid",
        queryParameters: {"aid": widget.aid},
      );
      setState(() {
        book = response.data;
        reviews = List<Map<String, dynamic>>.from(reviewRes.data);
        isLoading = false;
      });
    } catch (e) {
      print("도서 상세 정보 불러오기 실패: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("도서 상세"),
        backgroundColor: Colors.green.shade800,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookFormPage(aid: widget.aid),
                ),
              );
              if (result == true) await fetchDetail();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDeletePage(aid: widget.aid),
                ),
              );
              if (result == true) Navigator.pop(context, true);
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : book == null
          ? Center(child: Text("도서 정보를 불러오지 못했습니다."))
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((book!["aimg"] ?? '').isNotEmpty)
              Image.network(
                "http://192.168.40.5:8080/upload/${book!["aimg"]}",
                height: 180,
              ),
            SizedBox(height: 16),
            Text("제목: ${book!["atitle"]}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("저자: ${book!["awriter"]}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("소개: ${book!["acontent"]}", style: TextStyle(fontSize: 14)),
            SizedBox(height: 24),
            Divider(),
            Text("리뷰", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            ...reviews.map((r) => ReviewCard(
              rtitle: r['rtitle'],
              rwriter: r['rwriter'],
              rcontent: r['rcontent'],
              rimg: r['rimg'] ?? '',
              rno: r['rno'],
              aid: widget.aid,
              onDeleted: () => fetchDetail(),
            )).toList(),
            SizedBox(height: 60),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewFormPage(aid: widget.aid),
            ),
          );
          if (result == true) await fetchDetail();
        },
        label: Text("리뷰 등록"),
        icon: Icon(Icons.comment),
        backgroundColor: Colors.green,
      ),
    );
  }
}