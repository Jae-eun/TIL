# Combining Operators

## startWith()

>`Observable` 시퀀스 맨 앞에 다른 하나의 요소를 추가함

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/startwith.png)

```swift
let numbers = Observable.of(2,3,4)

let observable = numbers.startWith(1)
observable.subscribe(onNext: {
	print($0)
}).disposed(by: disposedBag)

//1
//2
//3
//4
```





## concat()

>여러 개의 `Observable` 시퀀스를 차례대로 합성함.

![](https://t2.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/1YN0/image/Tu6-vfDmGTlHtmestu_1frvvpWs.png)

```swift
let first = Observable.of(1,2,3)
let second = Observable.of(4,5,6)

let observable = Observable.concat([first,second])

// Observabledml 클래스 메소드 사용
observable.subscribe(onNext: {
	print($0)
}).disposed(by: disposeBag)

// Observable의 인스턴스 메소드 사용
first.concat(second)
	.subscribe(onNext: { 
    print($0)
}).disposed(by: disposeBag) 

//1
//2
//3
//4
//5
//6
```



## merge()

> 같은 타입의 이벤트를 발생하는 `Observable`을 합성함. 각각의 이벤트를 모두 받을 수 있음.

![](https://jcsoohwancho.github.io/img/merge.png)

```swift
let left = PublishSubject<Int>()
let right = PublishSubject<Int>()

let source = Observable.of(left.asObserver(), right.asObservable())

let observable = source.merge()
observable.subscribe(onNext: {
	print($0)
}).disposed(by: disposeBag)

left.onNext(5)
left.onNext(3)
right.onNext(2)
right.onNext(1)
left.onNext(99)

//        5
//        3
//        2
//        1
//        99
```



## combineLatest()

>두 `Observable`에서 각각의 이벤트가 발생할 때, 그 중 가장 최근 것끼리 합쳐서 방출함.

![](https://t1.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/1YN0/image/4Ro_h1bLnVKeeF-jGdO0jBlxmjg.png)

```swift
let left = PublishSubject<Int>()
let right = PublishSubject<Int>()

let observable = Observable.combineLatest(left, right, resultSelector: {
	lastLeft, lastRight in
	"\(lastLeft) \(lastRight)"
})

let disposable = observable
	.subscribe(onNext :{ value in
		print(value)
})

left.onNext(45)
right.onNext(1)
left.onNext(30)
right.onNext(1)
right.onNext(2)

//45 1
//30 1
//30 1
//30 2
```



## withLatestFrom()

>한 쪽 `Observable`의 이벤트가 발생할 때에 다른 한 쪽의 마지막 이벤트로 두 개의 `Observable` 을 합성함
>
>* 합성할 다른 쪽 이벤트가 없다면 이벤트는 넘어감

![](https://jusung.github.io/images/2019/RxSwift%20-%20withLatestFrom.png)

```swift
let button = PublishSubject<Void>()
let textField = PublishSubject<String>()

let observable = button.withLatestFrom(textField)
let disposable = observable.subscribe(onNext: {
	print($0)
})

textField.onNext("Sw")
textField.onNext("Swif")
textField.onNext("Swift")

button.onNext(())
button.onNext(())

//        Swift
//        Swift
```





## reduce()

>모든 이벤트들을 다 더한 총합을 방출함

![](https://t4.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/1YN0/image/hKzf9irZ3Fx0n-HNijwgPNevlNo.png)

```swift
let source = Observable.of(1,2,3)

source.reduce(0, accumulator: +)
	.subscribe(onNext: {
    print($0)
  }).disposed(by: disposeBag)

//6

source.reduce(0, accumulator: {
  summary, newValue in 
  return summary + newValue
}).subscribe(onNext: {
  print($0)
}).disposed(by: disposeBag)

//6
```



## scan()

>발행된 `Observable`을 순차적으로 변환하여 하나씩 값을 방출함

![](https://t2.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/1YN0/image/gtPjGJvh7a8tLY6vH0kqpe7WkBI.png)

```swift
let source = Observable.of(1,2,3,5,6)

source.scan(0, accumulator: +) 
	.subscribe(onNext: {
    print($0)
  }).disposed(by: disposeBag)

//1
//3
//6
//11
//17
```



