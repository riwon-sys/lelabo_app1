// DART 언어
// 1. 주석
// 한줄주석
/* 여러줄 주석*/

// 2. DART 프로그램 진입점 함수 = main
// void main(){} vs pub static main~(자바)

// 3. 출력함수 = print(); // 컨트롤 + 쉬프트 + 10


void main(){
  print("hello,world!");

  // p.64
  // 1. 문자열 타입
  String name = '주우재'; print( name );
  String name2 = "주우재2"; print( name2 );
  String name3 = "이름 : $name"; print(name3);  // 이름 : 주우재
  String name4 = "이름 : $name2"; print(name3); // 이름 : 주우재2

  // 2, 숫자 타입
  int year = 2023; print( year ); // 정수
  double pi = 3.14; print( pi) ; // 실수
  num year2 = 2023; print( year2);
  num pi2 = 3.14; print(pi2);

  // 3.불 타입
  bool darkMode = false; print( darkMode );

  // p.65 컬렉션
  // List<타입> : 중복 허용 | Set<타입> : 중복 불가 | Map<타입,타입> : key-value
  List<String> fruits = ['사과','사과1','사과2','사과3'];
  print( fruits ); print( fruits[3] ); print( fruits.length );


  Set<int> odds = {1,3,5,7,9,9}; print(odds); // 중복값 '9'는 두번 콘솔 출력 불가
  // '9'는 두번 입력해도 한번만 출력된 것으로 나옴
  Map<String , int> regionMap={"서울":0,"인천":1,"대전":2,"부산":3,"대구":4,
    "공주":5,"울산":6,"세종":7,"세종":0};
  // 중복값 "세종":7,"세종":0중에 마지막에 입력된 키-값으로 출력됨.
  print( regionMap);
  print( regionMap['서울'] );

  // p.65 기타
     // 1. Object : 모든 자료들을 Object(최상위타입) 저장 , 타입변환 필요
  Object a = 1;
  Object b = 3.14;
  Object c = "강호동";
     // 2. Dynamic : 동적 타입으로 대입이 되는 순간 타입 결정 . 타입변환 필요 없다.
  dynamic a1 = 1;
  dynamic a2 = 3.14;
  dynamic a3 = "강호동";
  dynamic a4 = ['사과'];
  dynamic a5 = {1,3,4};
  dynamic a6 = {"name" : "주우재" , "age" : 40};

    // 3.
  String ? nickname=null;
  // String nickname = null; // 다트3부터는 타입뒤에 '?' 붙여서 null안정성을 보정한다.
  // var : 처음 할당된 값의 타입이 결정 , dynamic 선언된 변수는 모든 타입들이 들어올 수 있다.
  print(nickname);

  // 4.
  DateTime dt = DateTime(2025,4,2,15,58,59);
  print(dt);

  // 5.
  dynamic memberId = "riwon7317";
  dynamic memberCode = 100000;
  print(memberId);
  print(memberCode);



}

