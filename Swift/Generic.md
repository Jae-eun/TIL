# Generic

Ex) 

```swift
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {

	let temporaryA = a
	a = b
	b = temporaryA
}
```



* 유연함과 재사용성이 높아짐.
* T는 타입 파라미터
* T는 함수가 호출될 때마다(런타임) 결정된다.
* a와 b는 T타입과 일치해야 한다. (a와 b의 타입이 다를 경우, 컴파일 오류)





= 모든 타입에서 작업할 수 있는 유연하고 재사용 가능한 함수나 타입을 작성할 수 있다. 