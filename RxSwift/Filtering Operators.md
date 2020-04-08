# Filtering Operators



## ignoreElements()

> * 모든 `.next` 이벤트를 무시한다.
> * 종료 이벤트(`.error` / `.complete`)는 전달한다.
> * 시퀀스가 종료되는 시점만 알 수 있게 되는 것이다.

![](https://rxjs.dev/assets/images/marble-diagrams/ignoreElements.png)

* `subscribe`하고 있는 라인에서는 아무 이벤트도 받지 못한다.
* 시퀀스가 종료되는 이벤트는 전달된다.

```swift
let strikes = PublishSubject<String>()
strikes.ignoreElements()
	.subscribe { _ in
		print("[Subscription is called]")
   }.disposed(by: disposeBag)
        
strikes.onNext("A") 
strikes.onNext("B")
strikes.onNext("C") // 아무런 이벤트도 호출되지 않음
        
strikes.onCompleted() // 완료 이벤트가 완료되었을 때만 호출됨

// [Subscription is called]
```



## elementAt()

> * `Observable`에서 발생하는 이벤트 중 **n번째 이벤트만** 받는다.

![](https://rxjs.dev/assets/images/marble-diagrams/elementAt.png)

* 2번째에 발생하는 이벤트만 `subscribe`한다.

```swift
let strikes = PublishSubject<String>()
strikes.elementAt(2)
	.subscribe(onNext: { _ in
		print("You are out!")
}).disposed(by: disposeBag)
        
strikes.onNext("X") // 0
strikes.onNext("X") // 1
strikes.onNext("X") // 2 2번째 이벤트가 발생하여 호출됨

// You are out!
```



## filter()

> * `Bool`을 리턴하는 클로저를 받아서 모든 `Observable Event`를 검사한다.
> * 클로저를 `true`로 만족시키는 이벤트만 통과하게 된다.

![](https://rxjs.dev/assets/images/marble-diagrams/filter.png)

* `filter`된 이벤트들을 `subscribe`한다.

```swift
Observable.of(1,2,3,4,5,6,7)
	.filter { $0 % 2 == 0 }
	.subscribe(onNext: {
		print($0)
}).disposed(by: disposeBag)

// 2
// 4
// 6 짝수인 수들이 출력됨
```



## skip()

> * 지정한 갯수만큼 이벤트 발생을 받지 않는다.

![](https://rxjs.dev/assets/images/marble-diagrams/skip.png)

```swift
Observable.of("A", "B", "C", "D", "E", "F")
            .skip(3)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)

// D
// E
// F 3개의 이벤트를 무시한 후 나머지가 출력됨
```



## skipWhile()

> * 클로저 조건에 맞는 이벤트는 무시한다.
> * 클로저 조건에 맞지 않는 이벤트가 나타나면 그 이후부터 전달한다.

![](https://rxjs.dev/assets/images/marble-diagrams/skipWhile.png)

```swift
Observable.of(2,2,3,4,4)
	.skipWhile { $0 % 2 == 0 }
	.subscribe(onNext: {
		print($0)
	}).disposed(by: disposeBag)

// 3 주어진 짝수 조건에 맞지 않음
// 4 짝수더라도 조건에 맞지 않은 이후로는 모두 출력됨
// 4 
```



## skipUntil()

> * 다른 시퀀스(`Trigger`)가 이벤트를 발생할 때까지 구독한 시퀀스의 모든 이벤트는 무시한다. 

![](https://rxjs.dev/assets/images/marble-diagrams/skipUntil.png)

```swift
let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()

subject.skipUntil(trigger)
	.subscribe(onNext: {
		print($0)
	}).disposed(by: disposeBag)

subject.onNext("A")
subject.onNext("B")

trigger.onNext("X")

subject.onNext("C")

// C trigger의 이벤트가 발생한 시점 이후부터 출력됨
```



## take()

> * 처음 발생하는 n개의 이벤트까지 받고 나머지는 무시한다.

![](https://rxjs.dev/assets/images/marble-diagrams/take.png)

```swift
Observable.of(1,2,3,4,5,6)
	.take(3)
	.subscribe(onNext: {
		print($0)
	}).disposed(by: disposeBag)

// 1
// 2
// 3 3개의 이벤트가 출력되고 이후로는 무시됨
```



## takeWhile()

> * 클로저 조건을 만족한 이벤트만 전달된다.
> * 클로저 조건을 만족하지 않는 이벤트가 발생하면 그 이후의 모든 이벤트가 무시된다.

![](https://rxjs.dev/assets/images/marble-diagrams/takeWhile.png)

```swift
Observable.of(2,4,6,7,8,10)
	.takeWhile {
		$0 % 2 == 0
	}.subscribe(onNext: {
			print($0)
	}).disposed(by: disposeBag)

// 2
// 4
// 6 다음의 7은 홀수여서 이후의 이벤트들은 무시됨
```



## takeUntil()

> * `Trigger` 역할을 하는 시퀀스의 이벤트가 발생할 때까지 구독하는 시퀀스의 이벤트가 전달된다.
> * `Trigger` 역할을 하는 시퀀스의 이벤트가 발생하면 그 이후로 구독하는 시퀀스의 이벤트는 무시된다.

![](https://rxjs.dev/assets/images/marble-diagrams/takeUntil.png)

```swift
let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()

subject.takeUntil(trigger)
	.subscribe(onNext: {
		print($0)
	}).disposed(by: disposeBag)

subject.onNext("a")
subject.onNext("b")

trigger.onNext("X")

subject.onNext("c")

// a
// b trigger에 이벤트가 발생하여 그 이후 subject의 이벤트는 무시됨
```



[참고](https://rhammer.tistory.com/296?category=649741)