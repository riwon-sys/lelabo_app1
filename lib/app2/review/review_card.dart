/*  review_card.dart | rw 25-04-19 수정
    - 리뷰 카드 UI에 수정 버튼 연결
    - 리뷰 삭제 및 수정 완료 시 콜백으로 목록 갱신
*/

import 'package:flutter/material.dart';
import 'review_delete.dart';
import 'review_edit.dart';

class ReviewCard extends StatelessWidget {
  final String rtitle;
  final String rwriter;
  final String rcontent;
  final String rimg;
  final int rno;
  final int aid;
  final VoidCallback? onDeleted;

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
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(rtitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewEditPage(
                              review: {
                                'rno': rno,
                                'aid': aid,
                                'rtitle': rtitle,
                                'rwriter': rwriter,
                                'rcontent': rcontent,
                                'rimg': rimg,
                              },
                            ),
                          ),
                        );
                        if (result == true && onDeleted != null) {
                          onDeleted!();
                        }
                      },
                    ),
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
                            onDeleted!();
                          }
                        });
                      },
                    ),
                  ],
                )
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
  }
}