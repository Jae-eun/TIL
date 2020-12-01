# Key Concepts

## Observables and Observers

> Observable / Observable Sequence / Sequence라고 부름



* `Observable`은 **이벤트를 전달**함
* `Observer`는 **Observable을 감시(`Subscribe` 구독)하고 있다가 전달되는 이벤트를 처리**함
* `Observable`에서 발생한 **새로운 이벤트는 `next`이벤트를 통해 Observer로 전달**됨
*  `next`이벤트에 값이 포함되어 있으면 같이 전달됨(`Emissions` 방출, 배출)



* `Observable`에서 **에러가 발생하면 `Error` 이벤트가 전달**됨
* `Observable`에서 **정상적으로 종료되면 `Completed` 이벤트가 전달**됨
* 두 이벤트는 Observable의 라이프 사이클에서 가장 마지막에 전달됨
*  `Notification`이라고 부름



* `next `이벤트는 값을 포함할 수 있음

* `vertical bar`는 완료(`Completed`이벤트)를 의미하고, 이 때 `Observable`의 라이프사이클이 종료됨

* `X`는 에러(`Error`이벤트)를 의미하고, 이 때 `Observable`의 라이프사이클이 종료됨



### 1. create 연산자를 통해 Observerable의 동작을 직접 구현하는 방법

```swift
Observable<Int>.create { (observer) -> Disposable in
  observer.on(.next(0)) // observer로 0이 저장되어 있는 next이벤트를 전달함
  observer.onNext(1) // 1이 저장된 next 이벤트가 전달됨
  observer.onCompleted() // Completed이벤트가 전달되고 Observable이 종료됨

  return Disposables.create() // 메모리 정리에 필요한 객체
}
```



###2.  미리 정의된 규칙에 따라서 이벤트를 전달함

* `from`: 파라미터로 전달된 **배열 요소를 순서대로 방출**하고, `Completed` 이벤트를 전달함

```swift
Observable.from([0, 1])
```



* `Observable`이 생성만 되었을 때, 아무런 이벤트가 전달되지 않음
* `Observable` 은 이벤트가 어떤 순서로 전달될지 정의할 뿐
* **`Observer`가 `Observable`을 구독할 때 `next`이벤트를 통해 값이 방출되고 이벤트가 발생함**





[출처](https://kxcoding.com/learning/mastering-rxswift)