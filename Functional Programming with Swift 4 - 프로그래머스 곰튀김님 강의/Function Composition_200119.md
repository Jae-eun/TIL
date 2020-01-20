# 함수의 합성(`Function Composition`)

> 함수의 반환값이 다른 함수의 입력값으로 사용되는 것

* 함수의 반환값과 이것을 입력으로 받아들이는 값은 타입이 서로 같아야 함

```swift
func f1(_ i: Int) -> Int {
	return i * 2
}

func f2(_ i: Int) -> String {
	return "\(i)"
}

let result = f2(f1(100))
print(result) // 200
```

* 함수도 1급개체로서 사용되기 때문에 함수를 합성할 수도 있음

```swift
func ff(_ pf1: @escaping (Int) -> Int,
        _ pf2: @escaping (Int) -> String) -> (Int) -> String {
	return { i in
		return pf2(pf1(i))
		}
}

let f3 = ff(f1, f2)
let result2 = f3(100)
print(result2) // 200
```

* 제네릭을 사용하여 범용적인 함성합수 생성 함수를 만들 수 있음

```swift
func comp<A, B, C>(_ pf1: @escaping (A) -> B,
                   _ pf2: @escaping (B) -> C) -> (A) -> C {
    return { i in
        return pf2(pf1(i))
    }
}

let f4 = comp(f1, f2)
```































