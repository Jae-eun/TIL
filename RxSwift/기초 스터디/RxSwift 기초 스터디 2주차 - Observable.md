# Observable

> **이벤트**를 일정 기간 동안 계속해서 **비동기적으로 생성**하는 기능, 그 과정을 `방출(Emit)` 
>
> `observable` = `observable sequence` = `sequence`

* `Next` 이벤트 : 각각의 요소를 방출함.
* `Error` 이벤트 : 이벤트 방출 중 오류가 발생하면 Error 이벤트를 보내고 종료됨.
* `Completed` 이벤트 : 이벤트 방출이 모두 완료되면 아무 인스턴스를 가지지 않고  `Completed` 이벤트가 발생하며 이벤트를 종료시킴.

```swift
public enum Event<Element> {
    /// Next element is produced.
    case next(Element)

    /// Sequence terminated with an error.
    case error(Swift.Error)

    /// Sequence completed successfully.
    case completed
}
```



## 마블 다이어그램(`Marble Diagram`)

> `Observable` 의 이해를 돕기 위해 **시간의 흐름**에 따라서 값을 표시한 것

![](https://user-images.githubusercontent.com/12438429/110340260-68eb3380-806c-11eb-8cd0-80ef179a62c4.png)



## Observable 생성

### just

: 오직 **하나의 요소**를 포함하는 `Observable Sequence` 를 생성

```swift
let justObservable: Observable<Int> = Observable<Int>.just(1)
justObservable.subscribe {
    print($0)
}
//next(1)
//completed
```



### of

: **가변적인 요소**를 포함하는 `Observable Sequence` 를 생성

````swift
let ofObservable: Observable<Int> = Observable<Int>.of(1,2,3,4,5)
ofObservable.subscribe {
    print($0)
}
//next(1)
//next(2)
//next(3)
//next(4)
//next(5)
//completed

// `인자로 Array` 를 넣으면 `단일 요소`로 가지게 됩니다. 
let arrayOfObservable: Observable<[Int]> = Observable<[Int]>.of([1,2,3])
arrayOfObservable.subscribe {
    print($0)
}
//next([1, 2, 3])
//completed
````



### from

: **array의 요소들**로 `Observable Sequence` 를 생성. 파라미터로 전달된 배열 요소를 순서대로 방출함.

```swift
let fromObservable: Observable<Int> = Observable<Int>.from([1,2,3])
fromObservable.subscribe {
    print($0)
}
//next(1)
//next(2)
//next(3)
//completed
```



### empty

: **요소를 가지지 않는** `Observable`이어서 `.completed` 이벤트만 방출

```swift
let emptyObservable = Observable<Void>.empty()
emptyObservable.subscribe {
    print($0)
}
//completed
```



### never

: **아무 이벤트를 방출하지 않는** `Observable`

```swift
let neverObservable = Observable<Any>.never()
neverObservable.subscribe {
    print($0)
}
```



### range

: `start` 부터 `count` 크기 만큼 값을 갖는 `Observable`을 생성

```swift
let rangeObservable = Observable<Int>.range(start: 3, count: 3)
rangeObservable.subscribe {
    print($0)
}
//next(3)
//next(4)
//next(5)
//completed
```



### repeatElement

: **지정된 요소를 계속 방출**

```swift
let repeatElementObservable = Observable<Int>.repeatElement(3)
repeatElementObservable.subscribe {
    print($0)
}
//next(3)
//next(3)
//.....
```



### interval

: **지정된 시간에 한 번씩 이벤트를 방출**합니다.

```swift
// 3초마다 0부터 숫자가 증가합니다.
let intervalObservable = Observable<Int>.interval(3, scheduler: MainScheduler.instance)
intervalObservable.subscribe {
    print($0)
}
//next(0)
//next(1)
//next(2)
//.....
```



### create

:  가장 기본적인 `Observable` 생성 메서드. **`Observer`에 동작을 직접 구현하여 이벤트를 방출**

![](http://reactivex.io/documentation/operators/images/create.c.png)

```swift
// 함수 원형
func create(_ subscribe: @escaping (AnyObserver<Self.Element>) -> Disposable) -> Observable<Self.Element>
```

* 어떤 이벤트를 발생할지 `Generic Type`을 받음.

  

```swift
// 예제
let observable = Observable<Int>.create({ observer -> Disposable in 
	observer.onNext(3) // 3이 저장된 Next 이벤트가 전달됨
	observer.on(.next(4)) // observer로 4가 저장되어 있는 Next 이벤트를 전달함
	observer.onCompleted() // Completed 이벤트가 전달되고 Observable이 종료됨
	
	return Disposables.create() // 메모리 정리
})
observable.subscribe {
  print($0)
}
//next(3)
//next(4)
//completed
```



## Observable 구독

> `Observable`은 `sequence` 의 정의일 뿐임. 따라서 `Observable`이 구독되기 전에는 아무 이벤트도 보내지 않음. 
>
> `Observable`을 구독(`subscribe`)해야 구독한 대상(`Observer`)이 이벤트를 처리할 수 있음.

### subscribe

```swift
// 함수 원형
func subscribe(onNext: ((Self.Element) -> Void)? = default)
```



```swift
let observable = Observable<Int>.range(start: 3, count: 3)
observable.subscribe(onNext: { (element) in 
	print(element)
})
//3
//4
//5
```



## Disposing & Terminating

### dispose()

: 구독을 취소하여 `Observable`을 수동으로 종료시킵니다.

```swift
let observable = Observable.of(1, 2, 3)
let subscription = observable.subscribe({ num in 
	print(num)
})
subscription.dispose() // disposable을 리턴함. 메모리에서 해제됨.
//next(1)
//next(2)
//next(3)
//completed
```



### DisposeBag()

: **구독들을 모아서 한번에 처리**하는 효율적인 방식

```swift
let disposeBag = DisposeBag()

Observable.of("A", "B", "C")
.subscribe {
	print($0)
}
.disposed(by: disposeBag)
//next(A)
//next(B)
//next(C)
//completed
```

