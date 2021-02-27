## Reactive eXtension 이란?

> \* An API for asynchronous programming with observable streams
> \* ReactiveX is a combination of the best ideas from the Observer pattern, the Iterator pattern, and functional programming



### 장점?

1. 일관성 있는 비동기 처리 코드
2. 가독성이 좋은 깔끔한 코드
3. 쉬운 멀티 스레드 처리



## RxSwift 란?

![img](https://blog.kakaocdn.net/dn/byM0p1/btqYN17iwBq/JF3RDPo2DqLmZKk9t6aEi0/img.png)

\* **RxSwift** : ReactiveX에서 정의한 Rx 표준을 제공함. 종속성은 없음.

\* **RxCocoa** : 공유 시퀀스, 특성 등과 같은 일반적인 iOS / macOS / watchOS 및 tvOS 앱 개발을 위한 Cocoa 관련 기능을 제공함. RxSwift와 RxRelay에 종속됨.

\* **RxRelay** : Subjects를 랩핑하는 PublishRelay, BehaviorRelay, ReplayRelay를 제공함. RxSwift에 종속됨.

\* **RxTest & RxBlocking** : Rx 기반 시스템에 대한 테스트 기능을 제공함. RxSwift에 종속됨.



## 비동기 프로그래밍이란?

: 여러 작업을 순차적으로 수행하는 것이 아니라 동시에 수행할 수 있도록 함.



## 가변 / 불변 상태 (mutable / immutable state)
: 객체 지향 언어에서 객체는 참조 형태로 전달(함수의 파라미터, 리턴 등)됩니다. 객체를 복제하는 게 아니라 참조하여 메모리 관리에 도움이 됨. 하지만 가변 객체에서 참조는 다루기 어려움. 가변 객체를 참조하고 있는 어떤 곳에서 객체의 상태를 변경하면 참조하고 있는 다른 곳에서도 동일하게 상태가 변경되기 때문임. 객체의 상태를 불변으로 만들고 만약 값을 변경해야 하는 경우가 생기면 deep copy를 통해서 새로운 객체를 만들어야 됨.



##일급 객체(first-citizen class)

변수로 선언, 파라미터 전달, 반환값 전달의 조건을 충족하는 것임. closure



## 명령형 프로그래밍



##선언형 프로그래밍



## 주요 구성 요소

## Observable

- 관찰자인 `Observer`가 있고 이벤트를 전달하는 `Observable`이 있음. `Observer`가 `Observable`을 구독하는 형태로 이루어짐. 
`Next`, `Error`, `Completed` 이벤트를 전달할 수 있음. `Next`이벤트는 여러번 발생할 수 있지만 `Error`나 `Completed`는 한번만 발생하며, `Error`나 `Completed` 이벤트가 발생하면 더 이상 이벤트를 전달하지 않음.



## Operator

##  

## Scheduler

- `Observable Operator Chain`에 멀티스레드를 쉽게 적용할 수 있음. 용도에 따라 다양한 `Scheduler`를 선택할 수 있음. 



## Subject

- `Observer`와 `Observable`의 성격을 모두 가지고 있어서, 이벤트를 전달 할 수도 있고 이벤트를 받아서 처리할 수도 있음.



# 