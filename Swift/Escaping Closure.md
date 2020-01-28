# escaping closure

> 클로저를 인자로 받는 함수에서, 해당 클로저가 함수가 반환된 이후에 수행되는 경우

```swift
class ClosureSample {
	func nonescapeSample(closure: () -> Void) {
		closure()
	}
	func escapeSample(closure: @escaping () -> Void) {
		DispatchQueue.main.async {
			closure()
		}
	}
}
```



* 옵셔널 타입의 클로저 매개변수는 제네릭 타입이다. 클로저 매개변수 타입이 아니다.