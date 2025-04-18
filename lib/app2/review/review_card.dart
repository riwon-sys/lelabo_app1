/*  review_card.dart | rw 25-04-18 재구성
    - 책 상세 페이지에서 사용하는 리뷰 출력용 위젯입니다.
    - 리뷰 정보(제목, 작성자, 내용, 이미지)를 깔끔하게 카드 형태로 보여줍니다.
*/

import 'package:flutter/material.dart';
import 'review_delete.dart'; // 삭제 화면 import

class ReviewCard extends StatelessWidget { // CS
  final String rtitle;
  final String rwriter;
  final String rcontent;
  final String rimg;
  final int rno;     // ✅ 리뷰 번호
  final int aid;     // ✅ 책 번호
  final VoidCallback? onDeleted; // ✅ 삭제 후 새로고침을 위한 콜백

  const ReviewCard({
    Key? key,
    required this.rtitle,
    required this.rwriter,
    required this.rcontent,
    required this.rimg,
    required this.rno,
    required this.aid,
    this.onDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) { // fs
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목 + 삭제 버튼을 한 줄에 배치
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(rtitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewDeletePage(rno: rno, aid: aid),
                      ),
                    ).then((value) {
                      if (value == true && onDeleted != null) {
                        onDeleted!(); // ✅ 삭제 성공 시 콜백 호출
                      }
                    });
                  },
                ),
              ],
            ),
            Text("작성자: $rwriter", style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text(rcontent),
            if (rimg.isNotEmpty) ...[
              const SizedBox(height: 10),
              Image.network(
                "http://192.168.40.5:8080/upload/$rimg",
                height: 120,
              ),
            ]
          ],
        ),
      ),
    );
  } // fe
} // CE