/*  review_card.dart | rw 25-04-18 재구성
    - 책 상세 페이지에서 사용하는 리뷰 출력용 위젯입니다.
    - 리뷰 정보(제목, 작성자, 내용, 이미지)를 깔끔하게 카드 형태로 보여줍니다.
*/

import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget { // CS
  final String rtitle;     // 리뷰 제목
  final String rwriter;    // 리뷰 작성자
  final String rcontent;   // 리뷰 내용
  final String rimg;       // 리뷰 이미지 파일명

  const ReviewCard({
    Key? key,
    required this.rtitle,
    required this.rwriter,
    required this.rcontent,
    required this.rimg,
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
            Text(rtitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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