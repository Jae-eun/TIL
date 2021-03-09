//
//  Copyright (c) 2019 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import RxSwift

/*:
 # Observables
 */
// Observable / Observable Sequence / Sequence라고 부름

// Observable은 이벤트를 전달함
// Observer는 Observable을 감시(`Subscribe` 구독)하고 있다가 전달되는 이벤트를 처리함
// Observable에서 발생한 새로운 이벤트는 `next`이벤트를 통해 Observer로 전달됨
// `next`이벤트에 값이 포함되어 있으면 같이 전달됨(`Emissions` 방출, 배출)
//
// Observable에서 에러가 발생하면 `Error` 이벤트가 전달됨
// Observable에서 정상적으로 종료되면 `Completed` 이벤트가 전달됨
// 두 이벤트는 Observable의 라이프 사이클에서 가장 마지막에 전달됨
// `Notification`이라고 부름

// next 이벤트는 값을 포함할 수 있음
// vertical bar는 완료(`Completed`이벤트)를 의미하고, 이 때 Observable의 라이프사이클이 종료됨
// X는 에러(`Error`이벤트)를 의미하고, 이 때 Observable의 라이프사이클이 종료됨
// `Marble Diagram`: Observable과 연산자의 동작을 시각적으로 표현해줌

// #1
// create 연산자를 통해 Observerable의 동작을 직접 구현하는 방법
Observable<Int>.create { (observer) -> Disposable in
    observer.on(.next(0)) // observer로 0이 저장되어 있는 next이벤트를 전달함
    observer.onNext(1) // 1이 저장된 next 이벤트가 전달됨
    observer.onCompleted() // Completed이벤트가 전달되고 Observable이 종료됨

    return Disposables.create() // 메모리 정리에 필요한 객체
}

// #2
// 미리 정의된 규칙에 따라서 이벤트를 전달함
// from: 파라미터로 전달된 배열 요소를 순서대로 방출하고, Completed 이벤트를 전달함
Observable.from([0, 1])

// Observable이 생성만 되었을 때, 아무런 이벤트가 전달되지 않음
// 이벤트가 어떤 순서로 전달될지 정의할 뿐
// Observer가 Observable을 구독할 때 next이벤트를 통해 값이 방출되고 이벤트가 발생함



//let ofObservable: Observable<Int> = Observable<Int>.of(1,2,3,4,5)
//ofObservable.subscribe {
//    print($0)
//}

let arrayOfObservable: Observable<[Int]> = Observable<[Int]>.of([1,2,3])
//let justObservable: Observable<Int> = Observable<Int>.just(1)
let fromObservable: Observable<Int> = Observable<Int>.from([1,2,3])
let emptyObservable = Observable<Void>.empty()
//let neverObservable = Observable<Any>.never()
//let rangeObservable = Observable<Int>.range(start: 3, count: 3)
//let repeatElementObservable = Observable<Int>.repeatElement(3)
//let intervalObservable = Observable<Int>.interval(3, scheduler: MainScheduler.instance)
//intervalObservable.subscribe {
//    print($0)
//}
//
//let observable = Observable<Int>.create({ observer -> Disposable in
//    observer.onNext(3) // 3이 저장된 Next 이벤트가 전달됨
//    observer.on(.next(4)) // observer로 4가 저장되어 있는 Next 이벤트를 전달함
//    observer.onCompleted() // Completed 이벤트가 전달되고 Observable이 종료됨
//
//    return Disposables.create() // 메모리 정리
//})
//observable.subscribe {
//  print($0)
//}
let disposeBag = DisposeBag()

Observable.of("A", "B", "C")
.subscribe {
    print($0)
}
.disposed(by: disposeBag)
