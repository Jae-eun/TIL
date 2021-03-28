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
 # retryWhen
 */
// * retryWhen() : 에러가 발생했을 때, 재시도 시점을 제어하고 싶을 때 사용함.

// func retryWhen<TriggerObservable: ObservableType, Error: Error>(_ notificationHandler: @escaping (Observable<Error>) -> TriggerObservable)
//    -> Observable<Element> {
//    return RetryWhenSequence(sources: InfiniteSequence(repeatedValue: self.asObservable()), notificationHandler: notificationHandler)
//}
// 파라미터에 발생한 에러를 방출하는 옵저버블이 전달됨. 클로저는 TriggerObservable을 리턴함. 리턴하는 시점에 새로운 옵저버블을 구독함.

let bag = DisposeBag()

enum MyError: Error {
    case error
}

var attempts = 1

let source = Observable<Int>.create { observer in
    let currentAttempts = attempts
    print("START #\(currentAttempts)")

    if attempts < 3 {
        observer.onError(MyError.error)
        attempts += 1
    }

    observer.onNext(1)
    observer.onNext(2)
    observer.onCompleted()

    return Disposables.create {
        print("END #\(currentAttempts)")
    }
}

let trigger = PublishSubject<Void>()

source
    .retryWhen { _ in trigger }
    .subscribe { print($0) }
    .disposed(by: bag)
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
