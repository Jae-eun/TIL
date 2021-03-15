# Operator 

* 대부분의 연산자는 **`Observable`에서 작동하고 `Observable`을 반환**함. 
* **연산자 체인**으로 쓸 수 있음. 체인의 각 연산자는 이전 연산자의 작업 결과인 `Observable`을 수정함. (빌더 패턴과 유사)
* 순서에 따라 결과가 바뀔 수 있기 때문에 **연산자의 순서가 매우 중요**!



## 옵저버블 생성 (`Creating Observables`)

> 새로운 `Observable`을 생성하는 연산자

### Create

> 옵저버 메소드를 프로그래밍 방식으로 호출하여 직접 원하는 동작 방식의 `Observable` 을 생성

![image](https://user-images.githubusercontent.com/12438429/110915019-8107cf00-835a-11eb-9abe-a5881038c74b.png)

```swift
// 함수 원형
func create(_ subscribe: @escaping (AnyObserver<Self.Element>) -> Disposable) -> Observable<Self.Element>
// AnyObserver: 해당 Observable을 구독하게 될 Observer. Observer의 on 메소드를 통해 이벤트를 전달함.
// 

// 타입 추론이 불가능하기 때문에 명시적으로 타입을 제네릭으로 작성해야 함.
let source: Observable<Int> = Observable.create { observer in
    for i in 1...3 {
        observer.on(.next(i))
    }
    observer.on(.completed)

    // 이것은 선택사항임. 클린업이 필요하지 않다면 
    // `Disposables.create()`(`NopDisposable` 싱글턴을 반환하는)을 반환하면 됨 
		// Nop = No Operation
		// NopDisposable: dispose할 때 아무것도 하지 않는 disposable
    return Disposables.create {
        print("disposed")
    }
}

source.subscribe {
    print($0)
}
//next(1)
//next(2)
//next(3)
//completed
//disposed
```



### Generate

> 증가하는 크기를 바꾸거나 감소하는 시퀀스를 생성

```swift
// 함수 원형
func generate(initialState: Self.Element,
              condition: @escaping (Self.Element) throws -> Bool,
              scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance,
              iterate: @escaping (Self.Element) throws -> Self.Element) -> RxSwift.Observable<Self.Element> {
        return Generate(initialState: initialState, condition: condition, iterate: iterate, resultSelector: { $0 }, scheduler: scheduler)
}

let disposeBag = DisposeBag()
let red = "🔴"
let blue = "🔵"

Observable.generate(initialState: 0,
                    condition: { $0 <= 10 },
                    iterate: { $0 + 2 })
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(0)
//next(2)
//next(4)
//next(6)
//next(8)
//next(10)
//completed

Observable.generate(initialState: 10,
                    condition: { $0 >= 0 },
                    iterate: { $0 - 2 })
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(10)
//next(8)
//next(6)
//next(4)
//next(2)
//next(0)
//completed

Observable.generate(initialState: red,
                    condition: { $0.count < 10 },
                    iterate: { $0.count.isMultiple(of: 2) ? $0 + red : $0 + blue })
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(🔴)
//next(🔴🔵)
//next(🔴🔵🔴)
//next(🔴🔵🔴🔵)
//next(🔴🔵🔴🔵🔴)
//next(🔴🔵🔴🔵🔴🔵)
//next(🔴🔵🔴🔵🔴🔵🔴)
//next(🔴🔵🔴🔵🔴🔵🔴🔵)
//next(🔴🔵🔴🔵🔴🔵🔴🔵🔴)
//completed
```



### Deferred

> 옵저버가 구독할 때까지 `Observable`을 생성하지 않고, 각 옵저버에 대해 새로운 `Observable`을 생성
>
> 외부의 특정 조건에 따라 다른 `Observable`을 생성할 수 있음
>
> 상태에 따라 다른 데이터를 처리해야 될 때 사용할 수 있음

![image](https://user-images.githubusercontent.com/12438429/110915099-92e97200-835a-11eb-8d7d-8729477d9f84.png)

```swift
// 함수 원형
func deffered(_ observableFactory: @escaping () throws -> Observable<Self.Element>) {
		return Deferred(ObservableFactory: observableFactory)
}
// Observable을 만들어내는 팩토리 클로저를 인자로 받음.
// 실제 구독이 일어나는 시점에서야 실제 Observable을 만들어냄. (defer: 연기하다)

let disposeBag = DisposeBag()
let animals = ["🐶", "🐱", "🐰", "🦊", "🐻"]
let fruits = ["🍎", "🍋", "🍇", "🍓", "🍑"]
var flag = true

// Observable을 리턴하는 클로저를 파라미터로 받음.
let factory: Observable<String> = Observable.deferred {
    flag.toggle()
    if flag {
        return Observable.from(animals)
    } else {
        return Observable.from(fruits)
    }
}

factory
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(🍎)
//next(🍋)
//next(🍇)
//next(🍓)
//next(🍑)
//completed

factory
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(🐶)
//next(🐱)
//next(🐰)
//next(🦊)
//next(🐻)
//completed
```



### Empty

> 요소를 방출하지 않지만 정상적으로 종료되는 `Observable` 을 생성

![image](https://user-images.githubusercontent.com/12438429/110915113-967cf900-835a-11eb-89c3-be0979a82344.png)

```swift
// 함수 원형
func empty() -> Observable<Self.Element>

let disposeBag = DisposeBag()

Observable<Void>.empty()
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//completed
```



### Never

> 요소를 방출하지 않고 종료도 하지 않는 `Observable` 을 생성

![image](https://user-images.githubusercontent.com/12438429/110915165-a268bb00-835a-11eb-9f1d-b581c61a23c0.png)

```swift
// 함수 원형
func never() -> Observable<Element> {
    return NeverProducer() // 무한 지속 시간을 표시하는 비종료 옵저버블 시퀀스를 리턴함. 옵저버가 호출할 수 없음.
} 

Observable<Any>.never()
```



### Error

> 요소를 방출하지 않고 오류 이벤트로 종료되는 `Observable` 을 생성
>
> 에러 처리에 사용

![image](https://user-images.githubusercontent.com/12438429/110915173-a5fc4200-835a-11eb-92da-149ec14586eb.png)

```swift
// 함수 원형
func error(_ error: Error) -> Observable<Self.Element>

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

Observable<Void>.error(MyError.error)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//error(error)
```



### From

> 다른 객체나 데이터 구조를 `Observable`로 변환
>
> 배열의 요소를 하나씩 순서대로 방출함

 ![image](https://user-images.githubusercontent.com/12438429/110915259-bf9d8980-835a-11eb-8dc5-0fbc88b3e1f8.png)

```swift
// 함수 원형
func from(_ array: [Self.Element],
          scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance) -> Observable<Self.Element> { 
	return ObservableSequence(elements: array, scheduler: scheduler)
}

let disposeBag = DisposeBag()
let fruits = ["🍎", "🍋", "🍇"]

// 값을 직접 받기 때문에 타입 추론 가능
Observable.from(fruits)
   .subscribe { print($0) }
   .disposed(by: disposeBag)
//next(🍎)
//next(🍋)
//next(🍇)
//completed
```



### Interval

> 특정 시간 간격을 두고 1씩 증가하는 정수 시퀀스를 방출하는  `Observable` 생성
>
> * 필터링 연산자 조건을 넣지 않으면, 이 옵저버블은 종료되지 않고 무한히 정수를 방출시킴.

![image](https://user-images.githubusercontent.com/12438429/110915265-c3c9a700-835a-11eb-98ec-4daba54c06c9.png)

```swift
// 함수 원형
func interval(_ period: RxTimeInterval,
              scheduler: SchedulerType) -> Observable<Element> {
	  return Timer(
    		dueTime: period,
    		period: period, 
    		scheduler: scheduler
    ) 
}

let disposeBag = DisposeBag()

Observable<Int>.interval(.seconds(1),
                         scheduler: MainScheduler.instance)
		.takeWhile { $0 < 3 }
		.subscribe { print($0) }
		.disposed(by: disposeBag)
//next(0)
//next(1)
//next(2)
//completed
```



### Just

> 객체나 객체 세트를 해당 객체를 방출하는 `Observable`로 변환
>
> 파라미터로 하나의 요소를 받아 Observable로 방출함

![image](https://user-images.githubusercontent.com/12438429/110915327-d47a1d00-835a-11eb-98ba-2eac6ff903ed.png)

```swift
// 함수 원형
func just(_ element: Self.Element) -> Observable<Self.Element>

let disposeBag = DisposeBag()
let element = "😀"

Observable.just(element)
   .subscribe { print($0) }
   .disposed(by: disposeBag)
//next(😀)
//completed

Observable.just([1, 2, 3])
   .subscribe { print($0) }
   .disposed(by: disposeBag)
//next([1, 2, 3]) // 파라미터로 전달한 요소를 그대로 방출함
//completed
```



### Range

> 일련의 정수 범위를 방출하는 `Observable` 생성
>
> 시작값에서 1씩 증가하는 시퀀스를 정해진 갯수만큼 방출함

![image](https://user-images.githubusercontent.com/12438429/110915352-dcd25800-835a-11eb-8e84-ccbc3c04ecaa.png)

```swift
// 함수 원형
func range(start: Self.Element,
           count: Self.Element,
           scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance) -> Observable<Self.Element> {
      return RangeProducer<Element>(start: start, count: count, scheduler: scheduler)
}

let disposeBag = DisposeBag()

Observable.range(start: 1, count: 5)
   .subscribe { print($0) }
   .disposed(by: disposeBag)
//next(1)
//next(2)
//next(3)
//next(4)
//next(5)
//completed
```



### RepeatElement

> 특정 요소나 시퀀스를 반복적으로 무한 방출하는  `Observable` 생성
>
> * 필터링 연산자 조건을 넣지 않으면, 이 옵저버블은 종료되지 않고 무한히 정수를 방출시킴.

![image](https://user-images.githubusercontent.com/12438429/110915385-e6f45680-835a-11eb-813a-b4699cae5185.png)

```swift
// 함수 원형
func repeatElement(_ element: Self.Element,
                   scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance) -> Observable<Self.Element> {
      return RepeatElement(element: element, scheduler: scheduler)
}

let disposeBag = DisposeBag()
let element = "😀"

Observable.repeatElement(element)
		.take(3)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(😀)
//next(😀)
//next(😀)
```



### Timer

> 지정한 시간 이후에 단일 요소를 방출하는 `Observable` 생성

![image](https://user-images.githubusercontent.com/12438429/110915397-ee1b6480-835a-11eb-84f0-346f3fcbf9f4.png)

```swift
// 함수 원형
func timer(_ dueTime: RxTimeInterval,
           period: RxTimeInterval? = nil,
           scheduler: SchedulerType) -> Observable<Element> {
  	return Timer(
    		dueTime: dueTime, 
    		period: period, 
    		scheduler: scheduler
    )
}

let disposeBag = DisposeBag()

Observable<Int>.timer(.seconds(2),
                      scheduler: MainScheduler.instance)
		.subscribe { print($0) }
		.disposed(by: disposeBag)
// 2초 후
//next(0)
//completed
```



### Of

> 두 개 이상의 요소(가변 파라미터를 받음)를 방출할 수 있음

```swift
// 함수 원형
func of(_ elements: Self.Element...,
        scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance) -> Observable<Self.Element> {
     return ObservableSequence(elements: elements, scheduler: scheduler)
}

let disposeBag = DisposeBag()
let apple = "🍎"
let orange = "🍊"
let kiwi = "🥝"

Observable.of(apple, orange, kiwi)
   .subscribe { print($0) }
   .disposed(by: disposeBag)
//next(🍎)
//next(🍊)
//next(🥝)
//completed

Observable.of([1, 2], [3, 4], [5, 6])
   .subscribe { print($0) }
   .disposed(by: disposeBag)
//next([1, 2])
//next([3, 4])
//next([5, 6])
//completed
// * 요소를 그대로 방출함. 배열 -> 배열로
```

