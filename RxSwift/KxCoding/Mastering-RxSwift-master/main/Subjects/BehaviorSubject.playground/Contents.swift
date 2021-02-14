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
 # BehaviorSubject
 */


let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

let p = PublishSubject<Int>()

p.subscribe { print("PublishSubject >>", $0) }
    .disposed(by: disposeBag)

let b = BehaviorSubject<Int>(value: 0) // 생성자로 값을 전달함

b.subscribe { print("BehaviorSubject >>", $0) }
    .disposed(by: disposeBag)
//BehaviorSubject >> next(0)

// * BehaviorSubject를 생성하면 내부에 Next이벤트가 하나 만들어짐.
// * 새로운 구독자가 추가되면 저장되어 있는 Next이벤트가 바로 전달됨


b.onNext(1)
//BehaviorSubject >> next(1)
//BehaviorSubject2 >> next(1)

b.onCompleted() //b.onError(MyError.error)
//BehaviorSubject >> completed
//BehaviorSubject2 >> completed


b.subscribe { print("BehaviorSubject3 >>", $0) }
    .disposed(by: disposeBag)
//BehaviorSubject3 >> completed
// Subject로 Completed이벤트가 전달되었기 때문에, Next이벤트는 다른 Observer로 더 이상 전달되지 않음.
// 즉시 Completed이벤트가 전달되고 종료됨.
