# 고차 함수(`Higher-Order Function`)

> 함수를 파라미터로 받거나 함수를 리턴하는 함수



```swift
// filter 함수의 정의
func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element]
```

