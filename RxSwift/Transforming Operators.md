# Transforming Operators



## toArray()

> - `Observable`의 독립적인 요소들을 `array` 로 만듭니다.

![](https://koenig-media.raywenderlich.com/uploads/2017/04/image001-1.png)

```swift
Observable.of(1,2,3,4,5)
	.toArray()
	.subscribe(onSuccess: {
		print($0)
	}).disposed(by: disposeBag)
// [1,2,3,4,5]
```



## map()

> - 이벤트를 바꿉니다.  (E Type 이벤트를 R Type 이벤트로)
>
> ```swift
> public func map<R>(_ transform: @escaping (Self.E) throws -> R) -> RxSwift.Observable<R>
> ```

![](https://github.com/fimuxd/RxSwift/raw/master/Lectures/07_Transforming%20Operators/2.%20map.png?raw=true)

```swift
Observable.of(1,2,3,4,5)
	.map {
		return $0 * 2
	}.subscribe(onNext: {
		print($0)
	}).disposed(by: disposeBag)
// 2
// 4
// 6
// 8
// 10
```



## flatMap()

> - `Observable` 시퀀스의 `element` 당 한 개의 새로운 `Observable` 시퀀스를 생성합니다. 이렇게 생성된 여러 개의 새로운 시퀀스를 하나의 시퀀스로 합쳐줍니다.
> - 즉, 이벤트를 다른 `Observable`로 바꾼다.
>
> - 각 `Observable` 의 변화를 계속 지켜본다.
>
> ```swift
> public func flatMap<O: ObservableConvertibleType>(_ selector: @escaping (E) throws -> O)
>         -> Observable<O.E>
> ```

![](https://miro.medium.com/max/2560/0*Gk3ijqPWa9L_nGCi.png)

```swift
struct Student {
	var score: BehaviorRelay<Int>
}

let john = Student(score: BehaviorRelay(value: 75))
let mary = Student(score: BehaviorRelay(value: 95))

let student = PublishSubject<Student>()

student.asObservable()
	.flatMap {  $0.score.asObservable() }
	.subscribe(onNext: {
		print($0)
	}).disposed(by: disposeBag)

student.onNext(john)
//        john.score.value = 100 // Error: Cannot assign value of type 'Int' to type 'BehaviorRelay<Int>'
john.score.accept(100)

student.onNext(mary)
mary.score.accept(80)

john.score.accept(40)
//    75
//    100
//    95
//    80
//    40
```



## flatMapLatest()

> - 새로운 `Observable` 을 만들고, 새로운 `Observable` 이 동작할 때, 새로 발행된 아이템이 전달되면 만들어진 `Observable` 은 `dispose` 하고 새로운 `Observable` 을 만듭니다.
>
> - 즉, 가장 마지막으로 추가된 시퀀스의 이벤트만 `subscribe` 하게 됩니다.

![](https://miro.medium.com/max/5320/1*hAkHyhTT6FLlEu7Z-fGeIA.png)

```swift
struct Student {
	var score: BehaviorRelay<Int>
}

let john = Student(score: BehaviorRelay(value: 75))
let mary = Student(score: BehaviorRelay(value: 95))

let student = PublishSubject<Student>()

student.asObservable()
	.flatMapLatest {  $0.score.asObservable() }
	.subscribe(onNext: {
		print($0)
	}).disposed(by: disposeBag)

student.onNext(john)
john.score.accept(100)

student.onNext(mary)
john.score.accept(45)
// 75
// 100
// 95
```

