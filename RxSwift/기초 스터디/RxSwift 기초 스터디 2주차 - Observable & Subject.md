# Observable

> 이벤트를 일정 기간 동안 계속해서 비동기적으로 생성하는 기능, 그 과정을 `방출(Emit)` 이라고 합니다.
>
> `observable` = `observable sequence` = `sequence`

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



## 마블 다이어그램 

> 시간의 흐름에 따라서 값을 표시하는 방식



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

![](http://reactivex.io/documentation/operators/images/create.c.png)

```swift
let source = Observable<Int>.create({ observer -> Disposable in 
	observer.onNext(3)
	observer.onNext(4)
	observer.onCompleted()
	
	return Disposables.create()
})
source.subscribe {
  print($0)
}
//3
//4
//Completed
```



## Observable 구독

> `Observable`은 `sequence` 의 정의일 뿐입니다. 따라서 `Observable`이 구독되기 전에는 아무 이벤트도 보내지 않습니다. 

### subscribe

```swift
let observable = Observable<Int>.range(start: 3, count: 3)
observable.subscribe(onNext: { (element) in 
	print(element)
})
//3
//4
//5
//Completed
```



## Disposing & Terminating

### dispose()

: 구독을 취소하여 `Observable`을 수동으로 종료시킵니다.

```swift
let observable = Observable.of(1, 2, 3)
let subscription = observable.subscribe({ num in 
	print(num)
})
subscription.dispose() // disposable을 리턴하도록 함
```



### DisposeBag()

: 각각의 구독을 일일히 관리하기 보다 **구독을 모아서 한번에 처리**하는 효율적인 방식입니다.

```swift
let disposeBag = DisposeBag()

Observable.of("A", "B", "C")
.subscribe {
	print($0)
}
.disposed(by: disposeBag)
```

https://jinshine.github.io/2019/01/02/RxSwift/2.Observable%EC%9D%B4%EB%9E%80/







## Trait

Trait은 일반적인 Observable보다 좁은 범위의 Observable

사실 Observable만 사용해도 됩니다. 즉, Trait은 `옵션`으로 사용할 수 있습니다.
하지만 Trait의 사용 목적은 코드의 가독성을 높일 수 있습니다.

종류 : `Single`, `May`, `Completable`

#### Single

> Single은 Obvservable의 한 형태이지만, Observable처럼 존재하지 않는 곳에서부터 무한대까지의 임이의 연속된 값들을 배출하는 것과는 달리, 항상 한 가지 값 또는 오류 알림 둘 중 하나만 배출한다.

Single은 `.success(value)`나 `.error` 이벤트를 방출 합니다.
.success(value)는 .next + .completed 이벤트의 결합이라고 볼 수 있습니다.

예를들어 한가지 프로세스인 데이터 다운로드의 로직에서 사용할 수 있겠죠

#### Completable

Completable은 `.completed`나 `.error`를 방출 하고, **어떠한 값을 방출 하진 않습니다!**

연산이 성공적으로 완료되었는지 확인하고 싶을 때 사용합니다.

#### Maybe

Maybe는 Single 과 Completable을 섞어 놓은 형태이고,
`.success(value)` , `.completed` , `.error` 를 방출합니다.
프로세스가 성공, 실패 여부와 더불어 출력된 값도 방출 할 수 있습니다.

```
let disposeBag = DisposeBag()
    
enum FileReadError: Error {
  case fileNotFound
}
    
func findFilePath(from name: String) -> Single<String> {
  return Single.create(subscribe: { (single) -> Disposable in
      
      guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
          single(.error(FileReadError.fileNotFound))
          return Disposables.create()
      }
      
      single(.success(path))
      return Disposables.create()
  })
}

findFilePath(from: "김승진")
  .subscribe(onSuccess: { (result) in
      print(result)
  }, onError: { (error) in
      print(error)
  })
```



































# Subject

