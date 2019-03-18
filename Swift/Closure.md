# Closure

* 코드의 블럭
* 일급 객체
* 전달인자, 변수, 상수 등으로 저장, 전달이 가능
* 매개변수, 반환 타입 생략가능
* return 키워드 생략 가능
* 축약된 전달인자 이름을 사용 가능



{ (매개변수들) -> 반환 타입 in 

​	실행 코드

}



in : 정의부와 실현부를 구분하기 위해 사용



* func sorted(by areInIncreasingOrder: (E, E) -> Bool) -> [E]