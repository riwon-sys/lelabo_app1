void main(){
  // p.67 ,  dart3 부터 추가된 타입
  // 튜플  = 값의 묶음 = 집합
  // 1. 레코드 생성하는 방법1
  var record = ( 'first', a:2 , b:true ,'last' );
  print(record);

  // 2. 레코드 생성하는 방법2 : 명시적 타입
  (String , int) record2;
  record2 =('주우재',40); print(record2);

  // 3. 레코드의 값 호출
  print(record.$1); //  KEY 가 존재하지 않는 첫번째 VALUE
  print(record.a); // 'a' 라는 키의 값을 반환
  print(record.b); // 'b' 라는 키의 값을 반환
  print(record.$2); //  KEY 가 존재하지 않는 두번째 VALUE

  // 4. JSON 형식
  var json ={ 'name':'dash' , 'age':10 , 'color':'blue' };
  // dynamic json ={ 'name':'dash' , 'age':10 , 'color':'blue' };
  print( json );

  // 5. 구조분해할당


}