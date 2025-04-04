// 스스로 학습 p.73~84

void main(){
  // 1. 기본 조건문
  int number =31;
  if(number %2 ==1){
    print("홀수!");
  }else{
    print("짝수!");
  }
  // 2. 더 복잡한 조건문
  String light= "red";
  if(light =="green"){
    print("초록불!");
  } else if (light == "yellow"){
    print("노란불!");
  } else if ( light == "red"){
    print("빨간불!");
  } else {
    print("잘못된 신호입니다.");
  }

  // 3. 2를 살짝 바꾸어 본 조건문
  String light3 = "purple";
  if (light3== "green"){
    print("초록불!");
  } else if(light3== "yellow"){
    print("노란불!");
  } else if(light3== "red"){
    print("빨간불!");
  } // else 없고 , 변수 light3의 값이 모든조건에 해당 하지 않음
    // console 에 아무것도 표시되지 않음.

  // 4. 기본 반복문
  // 횟수를 지정하는 for | 반복의 조건을 지정하는 while
  // 4-(1) 기본 예제
  for (int i=0; i<100; i++){ // (초기화식; | 조건식; | 증감식)
    print(i+1);
  }
  // 4-(2) 기본 예제
  List<String> subjects = ["자료구조","이산수학","알고리즘","플러터"];
  for( String subject in subjects){
    print(subject);
  } // []안에 입력한 내용들이 순서대로나옴
  // 4-(3) 기본 예제
  //int i =0;
  //while (i<100){
   // print(i+1);
    //i=i+1;
  //} // 조건이 맞으면 내부의 코드 블럭 실현
    // 조건이 틀리면 while 문을 빠져나와 다음 줄의 코드가 실행됨

  // 4-(4) 응용예제
  int i =0;
  while(true){
    print(i+1);
    i=i+1;
    if(i==100){
      break;
    }
  }
  // 4-(5) 응용예제
  for(int i=0; i<100; i++){
    if(i%2==0){ // 짝수이면
      continue; // 일단 출력하지말고 패스
    }
    print(i+1); // 홀수에 +1해서 짝수만 출력
  }
  // 5. 기본 함수
  // 5-(1). 기본함수문
  //int add(int a, int b){
  //  return a+b;
  //}
  //int number=add(1,2);
  // print(number);
}