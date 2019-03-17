# Generic

Ex) 

func swapTwoValues<T>(_ a: inout T, _ b: inout T) {

​	let temporaryA = a

​	a = b

​	b = temporaryA

}



* 유연함과 재사용성이 높아짐.
* T는 타입 파라미터
* T는 함수가 호출될 때마다 결정된다.
* a와 b는 T타입과 일치해야 한다.