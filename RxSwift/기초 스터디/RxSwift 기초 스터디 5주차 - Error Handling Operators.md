# Error Handling Operators

## 에러 관리 방법

1. **Catch** : 기본값으로 에러 복구하기

> `Observable` => `Catch` => `Subscriptions`

2. **Retry** : 제한 또는 무제한으로 재시도하기

> `Observable` => `Retry` => `Observable` => `Subscriptions`

3. **materialize** / **dematerialize** : 시퀀스를 제어해서 처리하기



### Catch

> * Swift의 **do / try / catch 문과 유사**함.
> * 에러가 발생했을 때 **Error 이벤트로 종료되지 않게** 함. 
> * Error 이벤트 **대신 특정 이벤트를 발생**시키고 `Complete` 시킴. 

![image](https://user-images.githubusercontent.com/12438429/112963070-fa3c5a00-9181-11eb-92a6-4c0910b18621.png)



#### catchError(_ handler: Error) -> Observable<E>) 

> * Error를 다른 타입의 `Observable` 로 반환하는 클로저를 파라미터로 받음. 
> * 에러가 발생했을 때, **에러를 무시하고 클로저의 반환값 `Observable<E>`를 반환**함.
> * 기본값이나 로컬 캐시를 방출하는 옵저버블을 구독자에게 전달하는 방식으로 사용할 수 있음.

```swift
// 정의
func catchError(_ handler: @escaping (Error) throws -> Observable<Element>) -> Observable<Element> {
    return Catch(source: self.asObservable(), handler: handler)
}

let disposeBag = DisposeBag()
enum MyError: Error {
    case error
}

let subject = PublishSubject<Int>()
let recovery = PublishSubject<Int>()

subject
    .catchError { _ in recovery } // 에러가 발생하면 새로운 옵저버블로 교체
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject.onError(MyError.error)
subject.onNext(11) // recovery로 교체되었음

recovery.onNext(22)
//next(22)
recovery.onCompleted()
//completed
// 구독이 에러 없이 정상적으로 종료됨
```



#### catchErrorJustReturn(_ element: E)

> * 에러가 발생했을 때, **에러를 무시하고 파라미터로 전달한  `element`를 반환**함. 
> * 파라미터의 타입은 원본 옵저버블이 방출하는 타입과 같음.
> * 모든 에러에 동일한 값이 반환되기 때문에  `catchError` 에 비해 제한적임. 

```swift
// 원형
func catchErrorJustReturn(_ element: Self.Element) -> Observable<Self.Element>

let subject = PublishSubject<Int>()

subject
    .catchErrorJustReturn(-1)
    .subscribe { print($0) }
    .disposed(by: bag)

subject.onError(MyError.error)
//next(-1)
//completed
// 더이상 다른 이벤트를 전달하지 못함. 
```



### Retry

> * **에러가 발생했을 때 `Observable` 을 다시 시도**하도록 함. (`Observable` 내의 전체 작업을 반복)
> * 에러가 발생하면 구독을 취소하고 새로운 구독을 시작함. 
> * 옵저버블이 계속 에러가 난다면 무한 시퀀스가 됨. 

![image](https://user-images.githubusercontent.com/12438429/112965390-31ac0600-9184-11eb-8bec-58e39f0abe91.png)



### retry() 

> * 일반적인 재시도에 사용하는 연산자
> * 에러가 발생했을 때, **성공할 때까지 `Observable` 을 다시 시도**함. 

```swift 
// 정의
func retry() -> Observable<Self.Element>

var attempts = 1

let source = Observable<Int>.create { observer in
    let currentAttempts = attempts
    print("#\(currentAttempts) START")

    if attempts < 3 {
        observer.onError(MyError.error)
        attempts += 1
    }

    observer.onNext(1)
    observer.onNext(2)
    observer.onCompleted()

    return Disposables.create {
        print("#\(currentAttempts) END")
    }
}

source
    .subscribe { print($0) }
    .disposed(by: bag)
//#1 START
//error(error)
//#1 END

source
    .retry()
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//#1 START
//#1 END
//#2 START
//#2 END
//#3 START
//next(1)
//next(2)
//completed
//#3 END
```



#### retry(_ maxAttemptCount: Int)

> * **몇 번 재시도 할지 지정**할 수 있는 연산자
> * `maxAttempCount` 가 3이라면 3번의 요청을 보냄. (재시도는 2번)
> * 재시도 횟수가 넘어갔는데도 에러가 발생하면 그대로 `Error` 이벤트를 전달함. 

```swift
// 정의
func retry(_ maxAttemptCount: Int) -> Observable<Self.Element>

source
    .retry(1)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//#1 START
//#1 END
//error(error)
// 마지막 결과도 실패면 구독자에게 에러 이벤트가 전달되고 구독이 종료됨.

source
    .retry(5)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//#1 START
//#1 END
//#2 START
//#2 END
//#3 START
//next(1)
//next(2)
//completed
//#3 END
// 재시도 횟수 안에 성공하면 completed 이벤트가 전달되고 구독이 종료됨.
```



#### retryWhen

> * **재시도하는 시점을 지정**할 수 있고, **한 번만 수행**함. 
> * **마지막 `Error` 이벤트를 전달하지 않음**.

```swift
// 정의
func retryWhen<TriggerObservable: ObservableType, Error: Error>(_ notificationHandler: @escaping (Observable<Error>) -> TriggerObservable) -> Observable<Element> {
    return RetryWhenSequence(sources: InfiniteSequence(repeatedValue: self.asObservable()),
                             notificationHandler: notificationHandler)
}

let trigger = PublishSubject<Void>()

source
    .retryWhen { _ in trigger }
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//START #1
//END #1
// 바로 재시도하지 않고, trigger Subject가 Next 이벤트를 방출할 때까지 대기함.

trigger.onNext(())
//START #1
//END #1
//START #2
//END #2

trigger.onNext(())
//START #1
//END #1
//START #2
//END #2
//START #3
//next(1)
//next(2)
//completed
//END #3
```



### Materialize / Dematerialize 

> * 이벤트 시퀀스를 제어할 수 있게 해줌.
> * 보통 `Materialize`와 `Dematerialize`는 함께 사용됨.
> * `Observable` 을 분해할 수 있기 때문에 신중하게 사용해야 함. 



#### Materialize

> * **`Sequence`를 `Event<Element> Sequence` 로 변환**함.

![image](https://user-images.githubusercontent.com/12438429/112970171-e1837280-9188-11eb-94ed-c376068dbcb4.png)



#### Dematerialize

> * **`Event<Element> Sequence`  를 다시 `Sequence`로 변환**함.

![image](https://user-images.githubusercontent.com/12438429/112970721-75edd500-9189-11eb-8e1f-7633cff08e77.png)

```swift
// 정의
func materialize() -> Observable<Event<Element>> {
    return Materialize(source: self.asObservable())
}

func dematerialize() -> Observable<Element.Element> {
    return Dematerialize(source: self.asObservable())
}

let observable = Observable<Int>
    .create { observer -> Disposable in
        observer.onNext(1)
        observer.onNext(2)
        observer.onNext(3)
        observer.onError(NSError(domain: "", code: 100, userInfo: nil))
        observer.onError(NSError(domain: "", code: 200, userInfo: nil))
        return Disposables.create {}
}

observable
    .materialize()
    .map { event -> Event<Int> in
        switch event {
        case .error:
            return .next(999)
        default:
            return event
        }
    }
    .dematerialize()
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)
//next(1)
//next(2)
//next(3)
//next(999)
//completed
// event로 변환 후 error일 경우 next로 교체함.
```



[참고: https://okanghoon.medium.com/rxswift-5-error-handling-example-9f15176d11fc](https://okanghoon.medium.com/rxswift-5-error-handling-example-9f15176d11fc)