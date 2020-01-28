# Currying

> 여러개의 파라미터를 받는 함수를 하나의 파라미터를 받는 여러 개의 함수로 쪼개는 것

```swift
func f(_ a: Int, _ b: Int) -> Int
// 위와 같은 함수를 아래와 같이 쪼갬
func f1(_ a: Int) -> Int
func f2(_ b: Int) -> Int
```



* 커링을 하는 이유?

  : 함수의 `Output`이 다른 함수의 `Input`으로 연결되면서 합성되는데, 함수들이 서로 연속적으로 연결되려면, `Output`과 `Input` 타입의 개수가 같아야 함. 함수의 `Output`은 하나이므로, `Input`도 하나씩 갖게 한다면 쉬워질 것임. 즉, **함수의 합성을 쉽게 하기 위해 커링을 사용하는 것**임.



```swift
func curriedAdd(_ value1: Int) -> ((Int) -> Int) {
	return { value2 in
     return value1 + value2
  }
}
let add2 = curriedAdd(2)
add2(3)
curriedAdd(2)(3)
```



## Ex) 문자열을 쪼개서 배열 만들기

* 기존 방법

  * "/"로 쪼갠다면

  ```swift
  "aaa/bbb/ccc/ddd".components(separatedBy: "/")
  ```

  * "*"로 쪼갠다면

  ```swift
  "aaa/bbb/ccc/ddd".components(separatedBy: "*")
  ```

* 커링 방법

```swift
func stringDevider( _ separater: String) -> (String) -> [String] {
	return { (string: String) -> [String] in
		return string.components(separatedBy: separater)
	}
}
let stringDevideBySlash = stringDevider("/")
let stringDevideByAsterisk = stringDevider("*")
stirngDevideBySlash("aaa/bbb/ccc/ddd")
stringDevideByAsterisk("aaa/bbb/ccc/ddd")
```



## 감춰진 커링

* 클래스 인스턴스가 함수를 콜하는 방법

```swift
class SomeClass {
  // 멤버 함수
	func someFunction() {
	}
}
let someInstance = SomeClass()
someInstance.someFunction()
SomeClass.someFunction(someInstance)()
// 멤버함수를 리턴하는 someFunction 클래스 함수
```

![image-20200119211218037](/Users/ijaeeun/Library/Application Support/typora-user-images/image-20200119211218037.png)

* 클래스 객체를 인자로 받고, 리턴 타입이 () -> Void 함수임

 

## EX) 

> * 어떤 문자열 안에 어떤 문자열이 포함되어 있는지 체크
> * 정규식을 활용
> * `Bool` 리턴

```swift
// 커링 방법
func regexTest(pattern: String) -> (String) -> Bool {
    let expression: NSRegularExpression? = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    return { (input: String) -> Bool in
        guard let expression = expression else { return false }
        let inputRange = NSMakeRange(0, input.count)
        let matches = expression.matches(in: input,
                                         options: [],
                                         range: inputRange)
        return matches.count > 0
    }
}

regexTest(pattern: "main")("int main()") // true

let hasMainIn = regexTest(pattern: "main")
hasMainIn("int main()")
```

```swift
// 클래스 방법
class Regex {
    var internalExpression: NSRegularExpression?

    init(_ pattern: String) {
        self.internalExpression = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }

    func test(_ input: String) -> Bool {
        let inputRange = NSMakeRange(0, input.count)
        guard let matchesCount = self.internalExpression?
            .matches(in: input, options: [], range: inputRange)
            .count else { return false }
        return matchesCount > 0
    }
}

let regex = Regex("main")
regex.test("int main()")

Regex("main").test("int main()")

let hasMainIn2 = Regex("main").test
hasMainIn2("int main()")
```















[참고]()









