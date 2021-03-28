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
 # catchError
 */
// 옵저버블에서 에러 이벤트를 구독자에게 전달하면, 구독이 종료됨. 더 이상 이벤트를 처리하지 못함.
// * 해결 방법
// 1. 에러 이벤트가 전달되면 새로운 옵저버블을 구독자에게 전달함. catchError 연산자를 사용함. Next, Completed 이벤트는 그대로 구독자에게 전달됨. 따라서, 기본값이나 로컬 캐시를 방출하는 옵저버블을 구독자에게 전달할 수 있음.
// 2. 에러가 발생하면 옵저버블을 다시 구독함. retry 연산자를 사용함. 에러가 발생하지 않을 때까지 무한정 재시도하거나 횟수를 제한할 수 있음.

//func catchError(_ handler: @escaping (Error) throws -> Observable<Element>) -> Observable<Element> {
//    return Catch(source: self.asObservable(), handler: handler)
//}

let bag = DisposeBag()

enum MyError: Error {
    case error
}

let subject = PublishSubject<Int>()
let recovery = PublishSubject<Int>()

subject
    .subscribe { print($0) }
    .disposed(by: bag)
//error(error)

subject
    .catchError { _ in recovery } // 에러가 발생하면 새로운 옵저버블로 교체
    .subscribe { print($0) }
    .disposed(by: bag)

subject.onError(MyError.error)

subject.onNext(11)

recovery.onNext(22)
//next(22)
recovery.onCompleted()
//completed
// 구독이 에러 없이 정상적으로 종료됨

