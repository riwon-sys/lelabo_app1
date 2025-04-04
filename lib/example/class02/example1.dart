
void main() {
  int a = 2;
  int b = 1;
  print(a + b);

  String firstName = 'Jeongjoo';
  String lastName = 'Lee';
  String fullName = lastName + '' + firstName;

  int a1 = 2;
  int b1 = 1;
  print(a1 - b1);

  int a2 = 2;
  print(-a2);

  int a3 = 6;
  int b3 = 3;
  print(a3 * b3);
  print('*' * 5);

  int a4 = 10;
  int b4 = 4;
  print(a4 / b4); // 소수점 있이 2.5

  int a5 = 10;
  int b5 = 4;
  print(a5 ~/ b5); // 소수점 없이 2

  int a6=10;
  int b6=4;
  print(a6 % b6); // 나머지2

  int a7 = 0;
  print(++a); // 1
  print(a); // 1 // 선반영

  int a8 = 0;
  print(a++); // 0
  print(a); // 1 // 후반영

  int b9 =1;
  print(--b9); // 0
  print(b9); // 0 // 선반영

  int b10 =1;
  print(b10--); // 1
  print(b10); // 0 // 후반영

  int a11 =2;
  int b11 =1;
  print(a==b); // f 같은가?

  int a12=2;
  int b12=1;
  print(a!=b); // t 다른가?

  int a13 =2;
  int b13 =1;
  print(a13>b13); // t 큰가?

  int a14 =2;
  int b14 =1;
  print(a14<b14);// f 작은가?

  int a15 =2;
  int b15 =1;
  print(a>=b); // 크거나 같다 t

  int a16=2;
  int b16=2;
  print(a16<=b16); // 작거나 같다 t

  int a17 =1; // 할당
  print(a17); // 1
  a17 =2; // 재할당
  print(a17); //2

  a *= 3; // a = a * 3
  print(a);

  int a19=2;
  int b19=1;
  bool result = a19>b19;//t
  print(!result); //f 결과 를 뒤바꿈 결과 부정

  int a20 = 3;
  int b20 = 2;
  int c20 = 1;
  print(a20>b20); // t
  print(b20<c20); // f
  print(a20>b20||b20<c20);// t // 또는 // 둘중에 하나만 맞아도 t

  int a21=3;
  int b21=2;
  int c21=1;
  print(a21>b21);//t
  print(b21<c21);//f
  print(a21>b21&&b21<c21); // f

}

