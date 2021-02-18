import UIKit
import RxSwift

// Section 2: Observables

// Observable은 이벤트 시퀀스를 비동기적으로 생성하는 기능을 가지고 있다.
// Observable이 지속적으로 이벤트를 발생시키는 것을 emit(방출)이라고 한다.

// next: 다음 값을 전송하는 이벤트
// error: 값을 방출하다가 에러가 발생하면 error를 방출하고 시퀀스를 종료시키는 이벤트
// complete: 성공적으로 이벤트 시퀀스를 종료시키는 이벤트. 더 이상 값을 방출하지 않는다.

_ = Observable.from([1,2,3,4,5])

// just: 오직 하나의 요소를 포함하는 Observable Sequence를 생성
let observable = Observable.just(1)

// of: 주어진 값에서 Observable Sequence를 생성
// array를 단일 요소로 가진다.
let observable2 = Observable.of(1,2,3)
let observable3 = Observable.of([1,2,3]) // Observable<[Int]>

// array의 요소들로 Observable Sequence를 생성
let observable4 = Observable.from([1,2,3,4,5]) // Observable<Int>


// Subscribe: subcscribe가 되기 전에는 Observable이 아무 이벤트를 보내지 않는다.
// escaping 클로저로 Event<Int>를 가짐.
// escaping에 대한 리턴값은 없으며 Disposable을 리턴함.
// observable은 각 요소들에 대해서 .next 이벤트를 방출함.
// 마지막에 .completed를 방출

observable4.subscribe { event in
    print(element)
}
//next(1)
//next(2)
//next(3)
//next(4)
//next(5)
//completed

observable4.subscribe { event in
    if let element = event.element {
        print(element)
    }
}
//1
//2
//3
//4
//5

observable3.subscribe { event in
    print(element)
}
//next([1, 2, 3])
//completed

observable3.subscribe { event in
    if let element = event.element {
        print(element)
    }
}
//[1, 2, 3]

observable4.subscribe(onNext: { element in
    print(element)
})
//1
//2
//3
//4
//5

let subscription4 = observable4.subscribe(onNext: { element in
    print(element)
})

subscription4.dispose()

// dispose: subscribe를 취소하여 Observable을 수동적으로 종료시킨다.
// DisposeBag(): 각각의 구독을 하나하나 관리하는 것은 비효율적이기 때문에 한 번에 관리하기 위해 사용한다.
// Disposable은 DisposeBag instance의 deinit()이 실행될 때 dispose()를 호출한다.
let disposeBag = DisposeBag()

Observable.of("A", "B", "C")
    .subscribe {
        print($0)
}.disposed(by: disposeBag)

// create: escaping 클로저로 AnyObserver<T>를 인자로 받아 Disposable을 반환한다.
// .next(“A”), .completed, .next(“?”)의 이벤트를 가진 Observable을 생성하고 Disposable을 반환한다.
// .next(“2”) 의 경우 onComplete 이후여서 방출되지 않는다.
Observable<String>.create { observer in
    observer.onNext("A")
    observer.onCompleted()
    observer.onNext("?")
    return Disposables.create()
}.subscribe(onNext: { print($0) }, onError: { print($0) }, onCompleted: { print("Completed")}, onDisposed: { print("Disposed")})
    .disposed(by: disposeBag)
// onNext 클로저는 .next 이벤트만 핸들링하고, onCompleted 클로저는 .completed만 핸들링 한다.


// Section 3: Subjects

// 13. Behavior Subject
let subject = PublishSubject<String>()

subject.onNext("Issue 1")

subject.subscribe { event in
    print(event)
}
// 프린트 안됨
subject.onNext("Issue 2")
//next(Issue 2)
subject.onNext("Issue 3")
//next(Issue 3)

//subject.dispose()
//subject.onNext("Issue 4")
// dispose 했기 때문에 그 이후로는 무시됨

//subject.onCompleted()
//subject.onNext("Issue 4")
//completed
// 그 이후로는 무시됨


// 14. Behavior Subjects

let subject = BehaviorSubject(value: "Initial Value")

subject.subscribe { event in
    print(event)
}
//next(Initial Value)

subject.onNext("Issue 1")
//next(Issue 1)

let subject2 = BehaviorSubject(value: "Initial Value")

subject2.onNext("Last Issue")

subject.subscribe { event in
    print(event)
}

subject.onNext("Issue 1")
//next(Last Issue)
//next(Issue 1)


// 15. Replay Subjects

let subject3 = ReplaySubject<String>.create(bufferSize: 2)

subject3.onNext("Issue 1")
subject3.onNext("Issue 2")
subject3.onNext("Issue 3")

subject3.subscribe {
    print($0)
}
//next(Issue 2)
//next(Issue 3)


// 16. Variables

let variable = Variable("Initial Value")

variable.value = "Hello World"

variable.asObservable()
    .subscribe {
        print($0)
}
//next(Hello World)

let variable = Variable([String]())

variable.value.append("Item 1")

variable.asObservable()
    .subscribe {
        print($0)
}

variable.value.append("Item 2")
//next(["Item 1"])
//next(["Item 1", "Item 2"])
