import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../review/review_card.dart';
import '../review/review_form.dart';
import '../book/book_form.dart'; // ✅ 도서 수정 화면 import 추가
import '../book/book_delete.dart';
class BookDetailPage extends StatefulWidget { // CS
  final int aid; // 도서 식별자
  const BookDetailPage({super.key, required this.aid});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
} // CE

class _BookDetailPageState extends State<BookDetailPage> { // CS
  Dio dio = Dio();
  Map<String, dynamic>? book; // 도서 상세 정보
  List<Map<String, dynamic>> reviews = []; // 연결된 리뷰 리스트

  // [1] 도서 + 리뷰 불러오기
  Future<void> fetchData() async {
    try {
      final response = await dio.get(
        "http://192.168.40.5:8080/ab/abfindbyid",
        queryParameters: {"aid": widget.aid},
      );

      setState(() {
        book = response.data;
        reviews = List<Map<String, dynamic>>.from(response.data['reviewList'] ?? []);
      });
    } catch (e) {
      print("불러오기 실패: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) { // fs
    return Scaffold(
      appBar: AppBar(
        title: Text(book?['atitle'] ?? '도서 상세'),
        backgroundColor: Colors.green.shade800,
        actions: [
          // ✅ 리뷰 작성 버튼
          IconButton(
            icon: Icon(Icons.rate_review),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewFormPage(aid: widget.aid),
                ),
              ).then((value) {
                if (value == true) fetchData(); // 등록 성공 시 새로고침
              });
            },
          ),

          // ✅ 도서 수정 버튼 추가
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookFormPage(aid: widget.aid),
                ),
              ).then((value) {
                if (value == true) fetchData(); // 수정 후 새로고침
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDeletePage(aid: widget.aid),
                ),
              ).then((value) {
                if (value == true) {
                  Navigator.pop(context, true); // 목록으로 돌아가기 + 새로고침
                }
              });
            },
          ),
        ],
      ),
      body: book == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((book!['aimg'] ?? '').isNotEmpty)
              Image.network(
                "http://192.168.40.5:8080/upload/${book!['aimg']}",
                height: 200,
              ),
            SizedBox(height: 12),
            Text("제목: ${book!['atitle']}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("저자: ${book!['awriter']}"),
            Text("소개: ${book!['acontent']}", maxLines: 5),
            Divider(height: 32),
            Text("📌 리뷰 목록", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (reviews.isEmpty)
              Text("등록된 리뷰가 없습니다."),
            ...reviews.map((r) => ReviewCard(
              rtitle: r['rtitle'] ?? '',
              rwriter: r['rwriter'] ?? '',
              rcontent: r['rcontent'] ?? '',
              rimg: r['rimg'] ?? '',
              rno: r['rno'],
              aid: widget.aid,
              onDeleted: fetchData, // 삭제 후 새로고침
            ))
          ],
        ),
      ),
    );
  } // fe
} // CE