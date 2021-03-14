# Subjects

* `Observable` 이자 `Observer` 의 성격을 갖고 있음. 이벤트를 방출(`emit`)할 수도 있고, 구독(`subscribe`)할 수도 있음.
  * 이를 이용하여 view의 User interaction을 viewModel의 Subject가 구독하고 구독을 통해 발행된 값을 바탕으로 viewModel에서 비즈니스 로직을 거쳐 가공된 데이터를 View가 구독함으로써 연결다리 역할을 할 수 있음.
* 동적으로 값을 발행할 수 있음. `on()`
* 여러 `Observer` 들에게 값을 발행할 수 있음 (`multicast` 방식)
  * 다른 `Observable`로 이벤트를 받아서 `Observer`로 전달할 수 있음.
* `ObservableType` 프로토콜을 채택하고 있는 `Observable` 을 상속하고 있으며, `ObserverType` 프로토콜을 채택하고 있음.

```swift
// ObserverType protocol 채택. 동적으로 이벤트를 발행할 수 있음.
public protocol ObserverType {
	  associatedtype Element
  
		func on(_ event: Event<Element>)
}

//  Event<Element>
public enum Event<Element> {
    /// Next element is produced.
    case next(Element)

    /// Sequence terminated with an error.
    case error(Swift.Error)

    /// Sequence completed successfully.
    case completed
}

let subject = PublishSubject<Int>()
subject.on(.next(1))
subject.on(.next(2))
subject.on(.next(3))
subject.on(.completed)
```



* 일반적인 `Observable` 은 어떠한 상태도 가지지 않음. 따라서 모든 `Observer` 가 구독하게 되면 그때마다 새로 생성하여 발행함. 하지만 `Subject` 의 경우 `Observer` 들의 정보를 저장하고 발행된 이벤트를 모든 `Observer`에게 제공하게 됨.

```swift
let randomNumGenerator1 = Observable<Int>.create{ observer in
		observer.onNext(Int.random(in: 0..<100))
		return Disposables.create()
}
    
randomNumGenerator1.subscribe(onNext: { (element) in
		print("observer 1 : \(element)")
})
randomNumGenerator1.subscribe(onNext: { (element) in
		print("observer 2 : \(element)")
})                                       
//observer 1 : 54
//observer 2 : 69
// Observer가 해당 Observable 구독을 독자적으로 실행하기 때문에 다른 결과값이 나옴.
// 구독을 할 때마다 create가 호출되는 것이므로 결과값이 그때마다 새로 생성된 값으로 할당됨.

let randomNumGenerator2 = PublishSubject<Int>()
randomNumGenerator2.on(.next(Int.random(in: 0..<100)))
    
randomNumGenerator2.subscribe(onNext: { (element) in
		print("observer subject 1 : \(element)")
})
randomNumGenerator2.subscribe(onNext: { (element) in
		print("observer subject 2 : \(element)")
})
//observer subject 1 : 92
//observer subject 2 : 92
// 구독시에 같은 값이 공유됨. Subject는 observer들에게 발행된 이벤트를 알려줌. 
```



## PublishSubject

* 생성되는 시점 내부에 아무 이벤트가 존재하지 않음.
* **구독 이후에 새로 발생한 이벤트만 구독자로 전달**함.

```swift
let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

let subject = PublishSubject<String>() // 생성되는 시점 내부에 아무 이벤트가 존재하지 않음.
subject.onNext("Hello")

let o1 = subject.subscribe { print(">> 1", $0) }
o1.disposed(by: disposeBag)
// * PublishSubject는 구독 이후에 새로 발생한 이벤트만 구독자로 전달함.

subject.onNext("RxSwift")
//>> 1 next(RxSwift)

let o2 = subject.subscribe { print(">> 2", $0) }
o2.disposed(by: disposeBag)

subject.onNext("Subject")
//>> 1 next(Subject)
//>> 2 next(Subject)

subject.onCompleted() //subject.onError(MyError.error) : 에러 이벤트
//>> 1 completed
//>> 2 completed

let o3 = subject.subscribe { print(">> 3", $0) }
o3.disposed(by: disposeBag)
//>> 3 completed

// * Observable에 Completed이벤트가 전달된 이후에는 Next이벤트가 전달되지 않음.
// * 구독 전에 이벤트가 사라지는 것을 피하고 싶다면, ReplaySubject나 Cold Observable을 사용하면 됨.
```



## BehaviorSubject

* `BehaviorSubject`를 생성하면 내부에 `Next` 이벤트가 하나 만들어짐.
* 새로운 구독자가 추가되면 저장되어 있는 `Next` 이벤트가 바로 전달됨.
* **생성 시점에 시작 이벤트를 지정**함. 가장 마지막으로 전달된 이벤트를 저장해두었다가 새로운 구독자에게 전달함.

```swift
let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

let publishSubject = PublishSubject<Int>()

publishSubject.subscribe { print("PublishSubject1 >>", $0) }
 .disposed(by: disposeBag)

let behaviorSubject = BehaviorSubject<Int>(value: 0) // 생성자로 값을 전달함

behaviorSubject.subscribe { print("BehaviorSubject2 >>", $0) }
 .disposed(by: disposeBag)
//BehaviorSubject1 >> next(0)

behaviorSubject.onNext(1)
//BehaviorSubject1 >> next(1)
//BehaviorSubject2 >> next(1)

behaviorSubject.onCompleted() //behaviorSubject.onError(MyError.error)
//BehaviorSubject1 >> completed
//BehaviorSubject2 >> completed

behaviorSubject.subscribe { print("BehaviorSubject3 >>", $0) }
    .disposed(by: disposeBag)
//BehaviorSubject3 >> completed
// * Subject로 Completed이벤트가 전달되었기 때문에, Next이벤트는 다른 Observer로 더 이상 전달되지 않음.
// * 즉시 Completed이벤트가 전달되고 종료됨.
```



## ReplaySubject

* **두 개 이상의 이벤트를 저장**하고 **새로운 구독자로 전달**하고 싶을 때 사용
* 버퍼는 메모리에 저장되므로 메모리 사용량을 신경써야 함.
* **하나 이상의 최신 이벤트를 버퍼에 저장**함. `Observer`가 **구독을 시작하면 버퍼에 있는 모든 이벤트를 전달**함.

```swift
let disposeBag = DisposeBag()

let relaySubject = ReplaySubject<Int>.create(bufferSize: 3) // 3개의 최신 이벤트를 저장하는 버퍼가 생성됨

(1...10).forEach { relaySubject.onNext($0) }

relaySubject.subscribe { print("Observer1 >>", $0) }
    .disposed(by: disposeBag)
//Observer1 >> next(8)
//Observer1 >> next(9)
//Observer1 >> next(10)

relaySubject.subscribe { print("Observer2 >>", $0) }
    .disposed(by: disposeBag)
//Observer2 >> next(8)
//Observer2 >> next(9)
//Observer2 >> next(10)

relaySubject.onNext(11) // 새로운 이벤트를 구독자에게 즉시 전달함
//Observer1 >> next(11)
//Observer2 >> next(11)

relaySubject.subscribe { print("Observer3 >>", $0) }
    .disposed(by: disposeBag)
//Observer3 >> next(9)
//Observer3 >> next(10)
//Observer3 >> next(11)

relaySubject.onCompleted() //relaySubject.onError(MyError.error) : 에러 발생
//Observer1 >> completed
//Observer2 >> completed
//Observer3 >> completed

relaySubject.subscribe { print("Observer4 >>", $0) }
    .disposed(by: disposeBag)
//Observer4 >> next(9)
//Observer4 >> next(10)
//Observer4 >> next(11)
//Observer4 >> completed
// 버퍼에 저장되어 있는 이벤트가 전달된 다음 Completed이벤트가 전달됨
```



## AsyncSubject

* `Completed` 이벤트가 전달되어야 최신 이벤트 하나를 구독자들에게 전달함.
* `Subject`로 `Completed` 이벤트가 전달된 시점에 마지막 전달된 `Next` 이벤트를 구독자로 전달함.
* 전달된 이벤트가 없으면 `Completed` 이벤트만 전달하고 종료됨.

```swift
let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

let subject = AsyncSubject<Int>()

subject.subscribe { print($0) }
    	 .disposed(by: disposeBag)

subject.onNext(1)
subject.onNext(2)
subject.onNext(3)

subject.onCompleted()
//next(3)
//completed

// * Error 이벤트가 발생하면 Next 이벤트를 전달하지 않고 Error 이벤트만 전달하고 종료됨
subject.onError(MyError.error)
//error(error)
```



## Relay

* **`Relay`는 내부에 `Subject`를 랩핑**하고 있음.
* **`Next` 이벤트만 전달**함.
* 구독자가 dispose 되기 전까지 **이벤트를 계속 전달**함.
* 주로 `UI 이벤트 처리`에 활용됨.

* `PublishRelay`: `PublishSubject`를 Wrapping한 것.
* `BehaviorRelay`: `BehaviorSubject`를 Wrapping한 것

```swift
let disposeBag = DisposeBag()

let prelay = PublishRelay<Int>()
prelay.subscribe { print("1: \($0)") }
    .disposed(by: disposeBag)

prelay.accept(1)
//1: next(1)

let brelay = BehaviorRelay(value: 1) // 하나의 값을 생성자로 전달해야 함
brelay.accept(2)

brelay.subscribe {
    print("2: \($0)")
}
.disposed(by: disposeBag)
//2: next(2)

brelay.accept(3)
//2: next(3)

print(brelay.value) // relay에 저장되어 있는 값 return
//3
```
