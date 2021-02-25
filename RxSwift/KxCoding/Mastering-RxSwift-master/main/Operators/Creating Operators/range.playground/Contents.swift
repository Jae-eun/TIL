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
 # range
 */
// * range(): 시작 값에서 1씩 증가하는 시퀀스를 정해진 갯수만큼 방출함.

// func range(start: Self.Element, count: Self.Element, scheduler: RxSwift.ImmediateSchedulerType = CurrentThreadScheduler.instance) -> RxSwift.Observable<Self.Element> {
//      return RangeProducer<Element>(start: start, count: count, scheduler: scheduler)
// }

let disposeBag = DisposeBag()

Observable.range(start: 1, count: 10)
   .subscribe { print($0) }
   .disposed(by: disposeBag)
//next(1)
//next(2)
//next(3)
//next(4)
//next(5)
//next(6)
//next(7)
//next(8)
//next(9)
//next(10)
//completed
