# Observable

> 이벤트가 비동기적으로 생성하는 기능, 계속해서 이벤트를 생성하는 과정 `Emit`

* `Next` 이벤트 : 각각의 요소를 방출합니다. 이벤트들이 모두 방출되면 `Completed` 이벤트가 발생하며 종료됩니다.
* `Error` 이벤트 
* `Completed` 이벤트 : 아무 인스턴스를 가지지 않고, 단순히 이벤트를 종료시킵니다.

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



## Observable 생성

### just

: 오직 **하나의 Element**를 포함하는 `Observable Sequence` 를 생성합니다.

```swift
let intObservable: Observable<Int> = Observable<Int>.just(1)
```



### of

: **가변적인 Element**를 포함하는 `Observable Sequence` 를 생성합니다.

````swift
let intObservable2: Observable<Int> = Observable<Int>.of(1,2,3,4,5)

// `인자로 Array` 를 넣으면 `단일 요소`로 가지게 됩니다. 
let observable: Observable<[Int]> = Observable<[Int].of([1,2,3])
// [1,2,3]
````



### from

: **array의 요소들**로 `Observable Sequence` 를 생성합니다. 

```swift
let intArrayObservable: Observable<Int> = Observable<Int>.from([1,2,3])
//1
//2
//3
```







### empty

: **요소를 가지지 않는** Observable이어서 .completed` 이벤트만 방출합니다.

```swift
let emptyObservable = Observable<Void>.empty()
```



### never

: **아무 이벤트를 방출하지 않는** Observable

```swift
let neverObservable = Observable<Any>.never()
```



### range

: `start` 부터 `count` 크기 만큼 값을 갖는 Observable을 생성합니다.

```swift
let rangeObservable = Observable<Int>.range(start: 3, count: 3)
//3
//4
//5
```



### repeatElement

: **지정된 요소를 계속 방출**합니다.

```swift
let repeatElementObservable = Observable<Int>.repeatElement(3)
//3
//3
//.....
```



### interval

: **지정된 시간에 한 번씩 이벤트를 방출**합니다.

```swift
// 3초마다 0부터 숫자가 증가합니다.
Observable<Int>.interval(3, scheduler: MainScheduler.instance)
```



### create

:  **`Observer`에 직접 이벤트를 방출**합니다.

```swift
Observable<Int>.create({ (observer) -> Disposable in 
	observer.onNext(3)
	observer.onNext(4)
	observer.onNext(5)
	observer.onCompleted()
	
	return Disposables.create()
})
//3
//4
//5
//Completed
```











































# Subject

