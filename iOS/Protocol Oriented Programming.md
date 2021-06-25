# Protocol Oriented Programming

> * 애플은 Swift2.0와 함께 스위프트는 프로토콜 지향 언어라고 발표함. 

* 객체지향 프로그래밍 패러다임에 기반을 둔 언어는 대부분 클래스 상속을 사용에 타입에 공통된 기능을 구현함. 반면에 스위프트는 대부분 구조체로 기본 타입이 구현되어 있음. 그래서 스위프트는 프로토콜과 익스텐션을 활용하고 있음. 



## 프로토콜 초기구현

> Protocol : 특정 역할을 수행하기 위한 메서드, 프로퍼티, 기타 요구사항 등의 청사진
>
> * 프로토콜을 채택한 타입은 프로토콜이 요구하는 기능을 구현하여 프로토콜을 준수해야 함. 

* 프로토콜의 익스텐션에 미리 구현해놓으면 프로토콜을 채택한 타입의 정의부에 프로토콜의 요구사항을 구현하지 않아도 됨.
* 초기 구현과 다른 동작을 원할 때만 그 타입에서 재정의하면 됨.  

```swift
protocol Talkable {
    var topic: String { get set }
    func talk(to: Self)
}

// 익스텐션을 사용한 프로토콜 초기 구현
extension Talkable {
    func talk(to: Self) {
        print("\(to)! \(topic)")
    }
}

struct Person: Talkable {
    var topic: String
    var name: String
    // Talkable의 요구사항인 talk(to:) 메서드를 구현하지 않아도 오류가 나지 않음 
}

struct Dog: Talkable {
    var topic: String
    // Talkable의 요구사항인 talk(to:) 메서드를 구현하지 않아도 오류가 나지 않음
}

let jaeeun = Person(topic: "Swift", name: "jaeeun")
let pilvi = Person(topic: "iOS", name: "pilvi")

jaeeun.talk(to: pilvi)
pilvi.talk(to: jaeeun) 
//Person(topic: "iOS", name: "pilvi")! Swift
//Person(topic: "Swift", name: "jaeeun")! iOS
```



## 프로토콜 지향 프로그래밍을 추구하는 이유

* 클래스는 참조 타입이므로 참조 추적에 비용이 많이 발생함.  `POP` 을 통해 비교적 비용이 적은 값 타입에 상속 기능을 활용할 수 있음.
* 다중 상속을 지원하지 않아 하나의 상속 체계에서 다른 상속 체계에 속해 있는 기능을 쓸 수 없는데, `POP`에서는 프로토콜 단위로 기능을 묶어 표현하고 초기 구현을 해놓을 수 있어 상속의 한계를 벗어날 수 있음. 즉, 기능의 모듈화가 더 명확함. 
* 











































### 참고

[https://blog.yagom.net/531/](https://blog.yagom.net/531/)