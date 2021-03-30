# Scheduler란?

> * `Scheduler`는 **특정 코드가 실행되는 컨텍스트를 추상화**한 것. 컨텍스트는 로우 레벨 `Thread`가 될 수도 있고, `Dispatch Queue`나 `Operation Queue`가 될 수도 있음.
> * **`Scheduler`는 스레드와 일대일로 매칭되는 것은 아님**.
> * UI 업데이트는 `Main Scheduler`에서 함.
> * 네트워크 요청이나 파일 처리 같은 작업은 `Background Scheduler`에서 함.



## Serial Scheduler

### CurrentThreadScheduler

> * 스케줄러를 별도로 지정하지 않으면 이 스케줄러가 실행됨. (기본)
> * 현재 스레드에 있는 작업 단위들을 스케줄해줌.
> * 어떤 스레드에서 처음으로 `CurrentThreadScheduler.instance.schedule(state)`  을 호출했다면, 그 예정된 행동은 즉시 실행될 것이고 예정된 모든 재귀적 액션들이 임시로 저장되는 숨겨진 큐가 생성될 것임. 
> * 만약 콜 스택의 몇몇 부모 프레임이 `CurrentThreadScheduler.instance.schedule(state)` 를 실행중이라면, 예정된 액션은 저장되고 현재 실행중인 액션과 모든 이전에 저장되었던 액션 실행이 종료되고 나서 실행될 것임.



### MainScheduler

> * `Main Thread` 에서 실행되어야 하는 추상적인 작업에서 사용함. 
> * `Main Queue`처럼 UI 업데이트를 할 때 사용함.
> * `schedule` 메소드가 메인 스레드에서 호출된 경우, `MainScheduler` 는 스케줄링 없이 액션을 실행할 것임.



### SerialDispatchQueueScheduler

> * 작업을 실행할 `DispatchQueue`를 직접 지정하고 싶을 때 사용함. 
> * 특정 `dispatch_queue_t`에서 실행되어야 하는 추상적인 작업에서 사용함.
> * `observeOn` 을 위한 특정 최적화를 가능하게 해줌.
> * 메인 스케줄러는 `SerialDispatchQueueScheduler` 의 인스턴스 중 하나임.



## Concurrent Scheduler

### ConcurrentDispatchQueueScheduler

> * 작업을 실행할 `DispatchQueue`를 직접 지정하고 싶을 때 사용함.
> * 특정 `dispatch_queue_t` 에서 실행되어야 하는 추상적인 작업에서 사용함.
> * 시리얼 디스패치 큐에도 보낼 수 있으며 아무 문제도 일어나지 않을 것임.
> * 어떤 작업이 백그라운드에서 실행되어야 할 때 사용하기 적합함.



### OperationQueueScheduler

> * 실행 순서나 동시에 실행할 작업 수를 제한하고 싶을 때 사용함. 
> * `NSOperationQueue` 에서 실행되어야 하는 추상적인 작업에서 사용함.
> * 어떤 큰 덩어리의 작업이 백그라운드에서 실행되어야 하는데, `maxConcurrentOperationCount`를 이용해서 처리 과정을 미세하게 조정하고 싶을 때 사용하기 적합함.



## Test Scheduler

> * Unit test에 사용함.



## Custom Scheduler 

> * 스케줄러를 직접 구현할 수 있음.





## Scheduler 지정

### observeOn 

> * 이어지는 연산자들이 작업을 실행할 스케줄러를 지정함.



### subscribeOn(_:)

> * `subscrbeOn` 메소드가 실행될 스케줄러나 이어지는 연산자가 실행될 스케줄러를 지정하는 것이 아님.
> * **옵저버블이 시작되는 시점에 어떤 스케줄러를 사용할지 지정하는 것**임.
> * **호출 시점이 중요하지 않음**.
> * `subscribeOn` 메소드를 사용하지 않으면 `subscribe` 메소드가 호출된 스케줄러에서 새로운 시퀀스가 시작됨.



```swift
let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())

Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
    .filter { num -> Bool in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
        return num.isMultiple(of: 2)
    }
    .map { num -> Int in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
        return num * 2
    }
    .subscribe {
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> subscribe")
        print($0)
    }
    .disposed(by: disposeBag)
//Main Thread >> filter
//Main Thread >> filter
//Main Thread >> map
//Main Thread >> subscribe
//next(4)
//Main Thread >> filter
//Main Thread >> filter
//Main Thread >> map
//Main Thread >> subscribe
//next(8)
//Main Thread >> filter
//Main Thread >> filter
//Main Thread >> map
//Main Thread >> subscribe
//next(12)
//Main Thread >> filter
//Main Thread >> filter
//Main Thread >> map
//Main Thread >> subscribe
//next(16)
//Main Thread >> filter
//Main Thread >> subscribe
//completed
// CurrentThreadScheduler와 Main Thread에서 실행됨

Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
    .filter { num -> Bool in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
        return num.isMultiple(of: 2)
    }
    .observeOn(backgroundScheduler)
    .map { num -> Int in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
        return num * 2
    }
    .subscribe {
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> subscribe")
        print($0)
    }
    .disposed(by: disposeBag)
//Main Thread >> filter
//Main Thread >> filter
//Main Thread >> filter
//Background Thread >> map
//Main Thread >> filter
//Main Thread >> filter
//Main Thread >> filter
//Main Thread >> filter
//Background Thread >> subscribe
//Main Thread >> filter
//next(4)
//Main Thread >> filter
//Background Thread >> map
//Background Thread >> subscribe
//next(8)
//Background Thread >> map
//Background Thread >> subscribe
//next(12)
//Background Thread >> map
//Background Thread >> subscribe
//next(16)
//Background Thread >> subscribe
//completed

Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
    .filter { num -> Bool in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
        return num.isMultiple(of: 2)
    }
    .observeOn(backgroundScheduler)
    .map { num -> Int in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
        return num * 2
    }
    .subscribeOn(MainScheduler.instance)
    .subscribe {
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> subscribe")
        print($0)
    }
    .disposed(by: disposeBag)
//Main Thread >> filter
//Main Thread >> filter
//Main Thread >> filter
//Background Thread >> map
//Main Thread >> filter
//Main Thread >> filter
//Main Thread >> filter
//Background Thread >> subscribe
//next(4)
//Main Thread >> filter
//Main Thread >> filter
//Background Thread >> map
//Background Thread >> subscribe
//Main Thread >> filter
//next(8)
//Background Thread >> map
//Background Thread >> subscribe
//next(12)
//Background Thread >> map
//Background Thread >> subscribe
//next(16)
//Background Thread >> subscribe
//completed
```