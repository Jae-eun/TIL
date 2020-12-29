# Unsafe Swift

> Swift의 안전하지 않은 API

* 표준 라이브러리는 타입, 프로토콜, 함수, 프로퍼티 등 다양한 구성을 제공합니다. 이들 중 몇몇은 **"안전하지 않음(`Unsafe`)"으로 명시적으로 표시**됩니다.  **안전한 구조와 안전하지 않은 구조의 차이**는 그들이 제공하는 인터페이스에서 분명하게 나타난 것이 아니라  **잘못된 입력을 구현하는 방식에서 발생**합니다. 표준 라이브러리의 대부분은 **작업을 실행하기 전에 입력을 완전히 검증**하므로 **심각한 코딩 오류가 확실하게 포착되고 보고 될 것이라고 안전하게 가정** 할 수 있습니다. 



```swift
// Ex) Swift Optional 유형의 `force-unwrapping` 연산자
let value: Int? = nil 
print(value!) // Fatal error: Unexpectedly found nil while unwrapping an Optional value
```

* **값이 `nil`이면 치명적인 런타임 오류가 보장**됩니다. Optional에게 할 수 없는 일을 요청했으므로 실행을 중지합니다. `nil` 값을 강제 풀려고하는 것은 **심각한 프로그래밍 오류이지만 그 결과는 잘 정의**되어 있습니다. **`force unwrap` 연산자**는 요구 사항을 충족하지 않는 입력을 포함하여 **모든 입력에 대한 동작을 완전히 설명 할 수 있기 때문에 "안전"**하다고 할 수 있습니다.

따라서 안전하지 않은 작업은 문서화 된 기대치를 위반하는 최소한 일부 입력에 대해 정의되지 않은 동작을 나타내야합니다. 

예를 들어, Optional은 "unsafelyUnwrapped"속성을 통해 "안전하지 않은"강제 풀기 작업도 제공합니다.



























































































[출처](https://developer.apple.com/videos/play/wwdc2020/10648/)