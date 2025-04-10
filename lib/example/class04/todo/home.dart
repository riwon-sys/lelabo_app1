// home.dart : 메인 화면을 갖는 앱의 파일

// 1. 상태 있는 위젯
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() {
    return _HomeState();
  }
}

// dart 에서는 클래스/변수 명 앞에 _(언더바) private 뜻한다.
class _HomeState extends State<Home> {
  Dio dio = Dio(); // 1. dio 객체 생성
  List<dynamic> todolist = []; // 2. 할일 목록을 저장하는 리스트 선언

  // 3. 자바와 통신 하여 할일 목록을 조회하는 함수 선언
  void todoFindAll() async {
    try {
      final response = await dio.get("http://192.168.40.5:8080/class04/todos");
      final data = response.data;
      // 조회 결과 없으면 [] , 조회 결과가 있으면 [ {} , {} ,{} ]
      // setState 이용하여 재 렌더링한다.
      setState(() {
        todolist = data; // 자바로 부터 응답받은 결과를 상태변수에 저장한다.
      });
      print(todolist); // 확인
    } catch (e) {
      print(e);
    }
  }

  // 4. 화면이 최초로 열렸을때 딱 1번 실행 .initState(){ 함수명(); }
  @override
  void initState() {
    super.initState();
    todoFindAll(); // 해당 위젯이 최초로 열렸을때 자바에게 할일 목록 조회 함수 호출
  }

  // 5. 삭제 이벤트 함수
  void todoDelete(int id) async {
    try {
      final response = await dio.delete(
        "http://192.168.40.5:8080/class04/todos?id=$id",
      );
      final data = response.data;
      if (data == true) {
        todoFindAll();
      } // 삭제 성공시 할일목록 다시 호출 하기.
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(" 메인 페이지 : TODO ")),
      body: Center(
        child: Column(
          children: [
            // (1)  등록 화면으로 이동하는 버튼
            TextButton(
              onPressed: () => {Navigator.pushNamed(context, "/write")},

              child: Text("할일 추가"),
            ),

            // (2) 간격
            SizedBox(height: 30),

            // (3) ListView 이용한 할일 목록 출력
            // 자바로부터 가져온 할일목록을 map 함수를 이용하여 반복해서 Card 형식의 위젯 만들기
            Expanded(
              // Column 위젯 안에서 ListView 사용시 Expanded 위젯 안에서 사용한다.
              child: ListView(
                // ( <ol> )ListView 위젯은 높이 100%의 자동 세로 스크롤 지원하는 위젯
                // children: [] // [] 대신에 map 반복문
                children: todolist.map((todo) {
                  // todolist <==> [ { key : value , key : value } , { key : value , key : value }  ]
                  // todo  <==> { key : value , key : value }
                  // todo['key']  <==> value
                  return Card(
                    child: ListTile(
                      title: Text(todo['title']),
                      // 제목
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // dart 언어 에서 문자와 변수를 같이 출력 하는 방법
                          // 방법1 : 변수값만 출력할 경우에는  , " 문자열 $변수명 "
                          // 방법2 : 변수안에 key의 값을 출력할 경우에는 , " 문자열 ${ 변수명['key'] }"
                          // { key : value , key : value , key : value }
                          Text("할일내용 : ${todo['content']}"),
                          Text("할일상태 : ${todo['done']}"),
                          Text("등록일 : ${todo['createAt']}"),
                        ],
                      ),
                      // subtitle 속성 이후 이므로 ,(세미콜론)를 추가하여 이어서 trailing 속성을 아래에 추가한다.
                      // trailing : ListTile 오른쪽 끝에 표시되는 위젯
                      trailing: Row( // 가로 배치 할 경 우
                        mainAxisSize: MainAxisSize.min, // 버튼을 가로로 최소 너비만 차지하게 정렬
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                "/update", // 수정 페이지로 이동
                                arguments: todo, // todo 객체 전달
                              );
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              todoDelete(todo['id']); // 삭제 기능
                            },
                            icon: Icon(Icons.delete),
                          ),
                          IconButton(
                              onPressed: ()=>{Navigator.pushNamed(context, "/detail",arguments: todo['id'])},
                              icon: Icon(Icons.visibility),// 자세히 보기
                          ),
                        ],
                      ),
                    ), // ListTile end
                  ); // Card end
                }).toList(), // map 결과를 toList() 함수로 변환하여 List 타입으로 변환
              ),
            ), // Expanded end
          ],
        ),
      ), // Center end
    );
  }
}