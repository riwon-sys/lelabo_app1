/*  book_detail.dart | rw 25-04-18 재구성
    - 특정 추천 도서의 상세 정보와 리뷰를 출력합니다.
    - Dio로 /ab/abdetail + /rb/rbreviewlist?aid= 호출하여 도서 + 리뷰 출력
    - 관련 리뷰는 별도 컴포넌트(review_card.dart)로 구성
*/

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../review/review_card.dart';
import '../review/review_form.dart';

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
      final bRes = await dio.get("http://192.168.40.5:8080/ab/abdetail", queryParameters: {"aid": widget.aid});
      final rRes = await dio.get("http://192.168.40.5:8080/rb/rbreviewlist", queryParameters: {"aid": widget.aid});

      setState(() {
        book = bRes.data;
        reviews = List<Map<String, dynamic>>.from(rRes.data);
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
          IconButton(
            icon: Icon(Icons.rate_review),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewFormPage(aid: widget.aid),
                ),
              );
            },
          )
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
              Image.network("http://localhost:8080/upload/${book!['aimg']}", height: 200),
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
            ))
          ],
        ),
      ),
    );
  } // fe
} // CE
