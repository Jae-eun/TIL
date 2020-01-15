# 고차 함수(`Higher-Order Function`)

> 함수를 파라미터로 받거나 함수를 리턴하는 함수



## Map : 변형

> 데이터를 변형하고자 할 때 사용함. 기존 컨테이너의 값들은 변경되지 않고 새로운 컨테이너를 생성하여 반환함

* for-in 구문과 사용하는 것에서 큰 차이가 없음
* 장점
  * 코드 재사용이 편함
  * 컴파일러 최적화 측면에서 성능이 좋음
  * 다중 스레드 환경에서 하나의 컨테이너에 여러 스레드들이 동시에 변경을 하려고 할 때, 예측하지 못한 결과 발생을 방지할 수 있음
  * 빈 배열을 초기에 생성할 필요 없음
  * `append()` 연산을 수행하기 위한 시간도 필요 없음

```swift
// map 함수의 정의
func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]
```

```swift
let numbers = [0, 1, 2, 3, 4]

var doubledNumbers = [Int]()
var strings = [String]()

// for-in
for number in numbers {
    doubledNumbers.append(number * 2)
    strings.append("\(number)")
}

// map
doubledNumbers = numbers.map{ $0 * 2 }
strings = numbers.map{ "\($0)" }
```



* 매개변수로 전달할 함수를 클로저 상수로 만들어 코드 재사용이 편함

```swift
let evens = [0, 2, 4, 6, 8]
let odds = [1, 3, 5, 7, 9]
let multiplyTwo: (Int) -> Int = { $0 * 2 }

let doubledEvens = evens.map(multiplyTwo)
let doubledOdds = odds.map(multiplyTwo)
```



## Filter : 추출

> 컨테이너 내부의 값들을 걸러서 추출하고자 할 때 사용함

* filter의 매개변수로 전달되는 함수의 반환 타입은 `Bool`
* `true`인 값만으로 새로운 컨테이너를 생성하여 반환함

```swift
// filter 함수의 정의
func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element]
```

```swift
let numbers = [0, 1, 2, 3, 4, 5]

let evens = numbers.filter{ $0 % 2 == 0 } // [0, 2, 4]
// map과 filter를 연결하여 사용할 수도 있음
let odds = numbers.map{ $0 + 3 }.filter{ $0 % 2 != 0 } // [3, 5, 7]
```



## Reduce : 결합

> 컨테이너 내부를 하나로 합쳐줌

* 정수 배열이면 전달 받은 함수의 연산 결과로 합치고, 문자열 배열이면 문자열을 하나로 합침
* 첫 번째 매개변수를 통해 초깃값을 지정할 수 있음. 최초의 `$0`으로 사용됨

```swift
// reduce 함수의 정의
func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result

func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, Element) throws -> ()) rethrows -> Result
```

```swift
let numbers = [1, 2, 3]
var sum = numbers.reduce(10) { $0 + $1 } // 16
```



[참고](https://oaksong.github.io/2018/01/20/higher-order-functions/)