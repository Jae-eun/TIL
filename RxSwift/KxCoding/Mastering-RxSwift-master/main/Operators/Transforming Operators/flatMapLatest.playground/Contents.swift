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
 # flatMapLatest
 */
// * flatMapLatest() : 모든 옵저버블이 방출하는 항목을 하나로 합치지 않음. 가장 최근에 변환된 옵저버블이 방출하는 요소만 구독자에게 전달함.

//func flatMapLatest<Source: ObservableConvertibleType>(_ selector: @escaping (Element) throws -> Source)
//        -> Observable<Source.Element> {
//     return FlatMapLatest(source: self.asObservable(), selector: selector)
//}

let disposeBag = DisposeBag()

let a = BehaviorSubject(value: 1)
let b = BehaviorSubject(value: 2)

let subject = PublishSubject<BehaviorSubject<Int>>()

subject
   .flatMapLatest { $0.asObservable() }
   .subscribe { print($0) }
   .disposed(by: disposeBag)

subject.onNext(a)
//next(1)

a.onNext(11)
//next(1)
//next(11)

subject.onNext(b)
//next(1)
//next(11)
//next(2)

b.onNext(22)
//next(1)
//next(11)
//next(2)
//next(22)

a.onNext(11)
//next(1)
//next(11)
//next(2)
//next(22)

subject.onNext(a)
//next(1)
//next(11)
//next(2)
//next(22)
//next(11)

b.onNext(222)
a.onNext(111)
//next(1)
//next(11)
//next(2)
//next(22)
//next(11)
//next(111)

