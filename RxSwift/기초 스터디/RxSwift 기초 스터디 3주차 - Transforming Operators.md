# 옵저버블 변환 (`Transforming Observables`)

> `Observable`에서 내보낸 항목을 변환하는 연산자



## Map

> `Observable`이 방출한 각 요소에 함수를 적용하여 변환 후 그 결과를 새로운 옵저버블로 리턴함

![image](https://user-images.githubusercontent.com/12438429/110915719-59fdcd00-835b-11eb-84f3-54b457c16410.png)

```swift
// 함수 원형
func map<Result>(_ transfrom: @escaping (Self.Element) throws -> Result) -> Observable<Result>

let disposeBag = DisposeBag() 
let animals = ["🐱", "🐰", "🦊"]

Observable.from(animals)
    .map { "Hello, \($0)" }
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(Hello, 🐱)
//next(Hello, 🐰)
//next(Hello, 🦊)
//completed
```



## FlatMap 

> `Observable`에 의해 방출된 요소를 `Observable`로 변환한 다음, 그 결과를 하나의 `Observable`로 평평하게 합쳐서 리턴함
>
> * 원본 `Observable`이 방출하는 항목을 계속 감시하고, 최신 항목을 확인할 수 있음
>
> * 요소가 업데이트 될 때마다 새로운 항목을 방출함
>
> * 네트워크 요청을 구현할 때 자주 활용됨

![image](https://user-images.githubusercontent.com/12438429/110915513-11461400-835b-11eb-9e44-1c97d8f3ec44.png)

```swift
// 함수 원형
func flatMap<Source>(_ selector: @escaping (Self.Element) throws -> Source) -> Observable<Source.Element> where Source: ObservableConvertibleType

let disposeBag = DisposeBag()
let a = BehaviorSubject(value: "🐱")
let b = BehaviorSubject(value: "🐰")

let subject = PublishSubject<BehaviorSubject<String>>()

subject
    .flatMap { $0.asObservable() } // 새로운 옵저버블이 생성됨. Subject를 Observable로 바꿈
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject.onNext(a)
//next(🐱)

subject.onNext(b)
//next(🐱)
//next(🐰)

a.onNext("🦊")
//next(🐱)
//next(🐰)
//next(🦊)

b.onNext("🐹")
//next(🐱)
//next(🐰)
//next(🦊)
//next(🐹)
```



## GroupBy

> `Observable`을 키로, 구성된 원래 `Observable`과 다른 요소 그룹을 각각 방출하는 `Observable` 집합으로 나눔
>
> * 방출되는 요소를 조건에 따라 그룹핑함
> * 파라미터로 클로저를 받음. 클로저는 요소를 파라미터로 받아서 키를 리턴함
> * 클로저에서 동일한 값을 리턴하는 요소끼리 그룹으로 묶임
> * 그룹에 속한 요소들을 개별 옵저버블로 방출됨

![image](https://user-images.githubusercontent.com/12438429/110915554-228f2080-835b-11eb-9442-2079e495ffda.png)

```swift
// 함수 원형
func groupBy<Key: Hashable>(KeySelector: @escaping (Element) throws -> Key) -> Observable<GroupedObservable<Key, Element>> { 
		return GroupBy(source: self.asObservable(), selector: keySelector)
}

let disposeBag = DisposeBag()
let words = ["Apple", "Banana", "Orange", "Book", "City", "Axe"]

Observable.from(words)
    .groupBy { $0.count }
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(GroupedObservable<Int, String>(key: 5, source: RxSwift.(unknown context at $10f441a28).GroupedObservableImpl<Swift.String>))
//next(GroupedObservable<Int, String>(key: 6, source: RxSwift.(unknown context at $10f441a28).GroupedObservableImpl<Swift.String>))
//next(GroupedObservable<Int, String>(key: 4, source: RxSwift.(unknown context at $10f441a28).GroupedObservableImpl<Swift.String>))
//next(GroupedObservable<Int, String>(key: 3, source: RxSwift.(unknown context at $10f441a28).GroupedObservableImpl<Swift.String>))
//completed

Observable.range(start: 1, count: 10)
    .groupBy { $0 % 2 == 0 }
    .flatMap { $0.toArray() }
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next([1, 3, 5, 7, 9])
//next([2, 4, 6, 8, 10])
//completed
```



## Buffer

> 주기적으로 `Observable`에서 요소를 묶음으로 수집하고 한 번에 하나씩 요소를 방출하는 대신 이 묶음(배열)을 방출함
>
> * 첫번째 파라미터 : 요소를 수집할 시간. 시간이 경과하지 않았더라도 요소를 방출할 수 있음
> * 두번째 파라미터 : 수집한 파라미터의 최대 수. 시간이 경과하면 수집된 항목만 방출함 

![image](https://user-images.githubusercontent.com/12438429/110915499-0d19f680-835b-11eb-859c-b8a6ae54ae66.png)

```swift
// 함수 원형
func buffer(timeSpan: RxTimeInterval,
           count: Int, 
           scheduler: SchedulerType) -> Observable<[Element]> {
  		return BufferTimeCount(source: self.asObservable(),
                            timeSpan: timeSpan, 
                            count: count, 
                            scheduler: scheduler)
}

let disposeBag = DisposeBag()

Observable<Int>.interval(.seconds(1),
                         scheduler: MainScheduler.instance)
    .buffer(timeSpan: .seconds(5),
            count: 3,
            scheduler: MainScheduler.instance)
    .take(5) // take 조건을 주지 않으면 무한정 방출
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next([0, 1, 2])
//next([3, 4, 5])
//next([6, 7, 8])
//next([9, 10, 11])
//next([12, 13, 14])
//completed
```



## Scan

> `Observable`이 방출한 각 요소에 순차적으로 함수를 적용하여 각 연속 값을 방출함
>
> * 기본값으로 연산을 시작함
> * 원본 옵저버블이 방출하는 요소의 수와 구독자로 전달하는 요소의 수가 동일함
> * 첫번째 파라미터는 기본값
> * 두번째 파라미터는 옵저버블이 방출하는 요소의 값과 같음
> * 클로저의 리턴형은 첫번째 파라미터와 같음
> * 클로저가 리턴한 값은 이어서 실행되는 클로저의 첫번째 값으로 쓰임

![image](https://user-images.githubusercontent.com/12438429/110915736-5f5b1780-835b-11eb-81a9-6934b7687402.png)

```swift
// 함수 원형
func scan<A>(_ seed: A, 
             accumulator: @escaping (A, Element) throws -> A) -> Observable<A> 
		return Scan(source: self.asObservable(),
               seed: seed) { acc, element in 
				let currentAcc = acc 
				acc = try accumulator(currentAcc, element)
}

let disposeBag = DisposeBag()

Observable.range(start: 1, count: 10)
    .scan(0, accumulator: +)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(1)
//next(3)
//next(6)
//next(10)
//next(15)
//next(21)
//next(28)
//next(36)
//next(45)
//next(55)
//completed

// * 작업 결과를 누적시키면서 중간 결과와 최종 결과가 모두 필요할 때 사용함
// * 최종 결과만 필요하다면 reduce 연산자를 사용하면 됨
```



## Window

> 요소를 `Observable`에서 `Observable` 창으로 주기적으로 세분화하고 한 번에 하나씩 요소를 방출하는 대신 이러한 창을 방출

![image](https://user-images.githubusercontent.com/12438429/110915588-2d49b580-835b-11eb-933b-2194167bc5d4.png)

```swift
// 함수 원형
func window(timeSpan: RxTimeInterval,
            count: Int,
            scheduler: SchedulerType) -> Observable<Observable<Element>> {
  	return WindowTimeCount(source: self.asObservable(), timespan: timeSpan, count: count, scheduler: scheduler)
}

let disposeBag = DisposeBag()

Observable<Int>.interval(.seconds(1),
                         scheduler: MainScheduler.instance)
    .window(timeSpan: .seconds(5),
            count: 3,
            scheduler: MainScheduler.instance)
    .take(5)
    .subscribe {
        print($0)
        if let observable = $0.element {
            observable.subscribe { print("inner: ", $0) }
        }
    }
    .disposed(by: disposeBag)
//next(RxSwift.AddRef<Swift.Int>)
//inner:  next(0)
//inner:  next(1)
//inner:  next(2)
//inner:  completed
//next(RxSwift.AddRef<Swift.Int>)
//inner:  next(3)
//inner:  next(4)
//inner:  next(5)
//inner:  completed
//next(RxSwift.AddRef<Swift.Int>)
//inner:  next(6)
//inner:  next(7)
//inner:  next(8)
//inner:  completed
//next(RxSwift.AddRef<Swift.Int>)
//inner:  next(9)
//inner:  next(10)
//inner:  next(11)
//inner:  completed
//next(RxSwift.AddRef<Swift.Int>)
//completed
//inner:  next(12)
//inner:  next(13)
//inner:  next(14)
//inner:  completed

// * AddRef는 옵저버블이고 구독할 수 있음
```



## ToArray

> `Completed` 이벤트 발생 이후 원본 `Observable` 이 방출하는 모든 요소를 하나의 배열로 방출함

```swift
// 함수 원형
func toArray() -> Single<[Self.Element]> 

let disposeBag = DisposeBag()

let subject = PublishSubject<Int>()
subject
    .toArray()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject.onNext(1)
subject.onNext(2)
subject.onCompleted()
//success([1, 2])
```



## FlatMapFirst

> 처음에 변환된 `Observable`이 방출하는 항목만 방출함.

```swift
// 함수 원형
func flatMapFirst<Source: ObservableConvertibleType>(_ selector: @escaping (Element) throws -> Source)
        -> Observable<Source.Element> {
     return FlatMapFirst(source: self.asObservable(), selector: selector)
}

let disposeBag = DisposeBag()
let a = BehaviorSubject(value: "🐯")
let b = BehaviorSubject(value: "🦊")

let subject = PublishSubject<BehaviorSubject<String>>()

subject
   .flatMapFirst { $0.asObservable() }
   .subscribe { print($0) }
   .disposed(by: disposeBag)

subject.onNext(a)
subject.onNext(b)
// a에 저장된 값만 방출됨
//next(🐯)

a.onNext("🐯🐯")
//next(🐯)
//next(🐯🐯)


b.onNext("🦊🦊")
//next(🐯)
//next(🐯🐯)

b.onNext("🦊🦊🦊")
//next(🐯)
//next(🐯🐯)

a.onNext("🐯🐯🐯")
//next(🐯)
//next(🐯🐯)
//next(🐯🐯🐯)
```



## FlatMapLatest

> 모든 `Observable`이 방출하는 항목을 하나로 합치지 않음. 가장 최근에 변환된 `Observable`이 방출하는 요소만 구독자에게 전달함.
>
> * `map`과 `switchLatest`연산자의 결합

```swift
// 함수 원형
func flatMapLatest<Source: ObservableConvertibleType>(_ selector: @escaping (Element) throws -> Source)
        -> Observable<Source.Element> {
     return FlatMapLatest(source: self.asObservable(), selector: selector)
}

let disposeBag = DisposeBag()

let a = BehaviorSubject(value: "🐯")
let b = BehaviorSubject(value: "🦊")

let subject = PublishSubject<BehaviorSubject<String>>()

subject
   .flatMapLatest { $0.asObservable() }
   .subscribe { print($0) }
   .disposed(by: disposeBag)

subject.onNext(a)
//next(🐯)

a.onNext("🐯🐯")
//next(🐯)
//next(🐯🐯)

subject.onNext(b)
//next(🐯)
//next(🐯🐯)
//next(🦊)

b.onNext("🦊🦊")
//next(🐯)
//next(🐯🐯)
//next(🦊)
//next(🦊🦊)

a.onNext("🐯🐯")
//next(🐯)
//next(🐯🐯)
//next(🦊)
//next(🦊🦊)

subject.onNext(a)
//next(🐯)
//next(🐯🐯)
//next(🦊)
//next(🦊🦊)
//next(🐯🐯)

b.onNext("🦊🦊🦊")
//next(🐯)
//next(🐯🐯)
//next(🦊)
//next(🦊🦊)
//next(🐯🐯)

a.onNext("🐯🐯🐯")
//next(🐯)
//next(🐯🐯)
//next(🦊)
//next(🦊🦊)
//next(🐯🐯)
//next(🐯🐯🐯)
```

