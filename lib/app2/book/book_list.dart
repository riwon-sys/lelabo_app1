/*  book_list.dart | rw 25-04-18 재구성
   - 추천 도서 전체 조회 페이지입니다.
   - Dio로 /ab/abfindall 호출하여 데이터 출력합니다.
   - 데이터 없을 시 "등록된 책이 없습니다" 메시지 출력.
*/

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lelabo_app1/app2/book/book_detail.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  final Dio dio = Dio();
  List<Map<String, dynamic>> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final response = await dio.get("http://192.168.40.5:8080/ab/abfindall");
      setState(() {
        books = List<Map<String, dynamic>>.from(response.data);
        isLoading = false;
      });
    } catch (e) {
      print("책 목록 불러오기 실패: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : books.isEmpty
          ? Center(child: Text("등록된 책이 없습니다."))
          : ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailPage(aid: book['aid']),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((book['aimg'] ?? '').isNotEmpty)
                      Image.network(
                        "http://localhost:8080/upload/${book['aimg']}",
                        height: 160,
                      ),
                    SizedBox(height: 8),
                    Text("제목: ${book['atitle']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("저자: ${book['awriter']}", style: TextStyle(color: Colors.grey[600])),
                    SizedBox(height: 4),
                    Text("소개: ${book['acontent']}", maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
