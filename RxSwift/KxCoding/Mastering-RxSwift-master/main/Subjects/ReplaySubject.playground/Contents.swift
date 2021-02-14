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
 # ReplaySubject
 */
// * 두 개 이상의 이벤트를 저장하고 새로운 구독자로 전달하고 싶을 때 사용
// * 버퍼는 메모리에 저장되므로 메모리 사용량을 신경써야 함

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

let rs = ReplaySubject<Int>.create(bufferSize: 3) // 3개의 최신 이벤트를 저장하는 버퍼가 생성됨

(1...10).forEach { rs.onNext($0) }

rs.subscribe { print("Observer1 >>", $0) }
    .disposed(by: disposeBag)
//Observer1 >> next(8)
//Observer1 >> next(9)
//Observer1 >> next(10)

rs.subscribe { print("Observer2 >>", $0) }
    .disposed(by: disposeBag)
//Observer2 >> next(8)
//Observer2 >> next(9)
//Observer2 >> next(10)

rs.onNext(11) // 새로운 이벤트를 구독자에게 즉시 전달함
//Observer1 >> next(11)
//Observer2 >> next(11)

rs.subscribe { print("Observer3 >>", $0) }
    .disposed(by: disposeBag)
//Observer3 >> next(9)
//Observer3 >> next(10)
//Observer3 >> next(11)

rs.onCompleted() //rs.onError(MyError.error)
//Observer1 >> completed
//Observer2 >> completed
//Observer3 >> completed

rs.subscribe { print("Observer4 >>", $0) }
    .disposed(by: disposeBag)
//Observer4 >> next(9)
//Observer4 >> next(10)
//Observer4 >> next(11)
//Observer4 >> completed
// 버퍼에 저장되어 있는 이벤트가 전달된 다음 Completed이벤트가 전달됨
