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
 # retry
 */
// * retry() : 옵저버블에서 에러가 발생하면 구독을 취소하고 새로운 구독을 시작함. 옵저버블 시퀀스는 처음부터 다시 시작되는 것임.
// 옵저버블이 계속 에러가 난다면 무한 시퀀스가 됨.

// func retry() -> Observable<Self.Element>
// func retry(_ maxAttemptCount: Int) -> Observable<Self.Element>
// 최대 재시도 횟수를 파라미터로 넣음.

let disposeBag = DisposeBag()

enum MyError: Error {
    case error
}

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
    .disposed(by: disposeBag)
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
