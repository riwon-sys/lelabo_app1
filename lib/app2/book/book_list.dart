/*  book_list.dart | rw 25-04-19 수정
   - 도서 등록 + 리뷰 등록 버튼 통합
   - 리뷰 등록 버튼을 첫 화면에서 제거하고, 상세 페이지에 배치 예정
*/

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lelabo_app1/app2/book/book_detail.dart';
import 'package:lelabo_app1/app2/book/book_form.dart'; // ✅ 도서 등록 페이지

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
    delayedFetch();
  }

  Future<void> delayedFetch() async {
    await Future.delayed(Duration(milliseconds: 300));
    await fetchBooks();
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
      appBar: AppBar(
        title: Text("도서 목록"),
        backgroundColor: Colors.green.shade800,
      ),
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
                        "http://192.168.40.5:8080/upload/${book['aimg']}",
                        height: 160,
                      ),
                    SizedBox(height: 8),
                    Text("제목: ${book['atitle']}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("저자: ${book['awriter']}",
                        style: TextStyle(color: Colors.grey[600])),
                    SizedBox(height: 4),
                    Text("소개: ${book['acontent']}",
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookFormPage()),
          );

          if (result == true) {
            await fetchBooks();
            setState(() {});
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        tooltip: "도서 등록하기",
      ),
    );
  }
}