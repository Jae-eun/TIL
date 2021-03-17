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
 # flatMap
 */
// * flatMap() : 모든 옵저버블이 방출하는 요소들을 모아서 변환 후, 새로운 하나의 옵저버블로 합쳐서 리턴함.
// 원본 옵저버블이 방출하는 항목을 계속 감시하고, 최신 항목을 확인할 수 있음.
// 요소가 업데이트될 때마다 새로운 항목을 방출함.
// 네트워크 요청을 구현할 때 자주 활용됨.

//func flatMap<Source>(_ selector: @escaping (Self.Element) throws -> Source) -> Observable<Source.Element> where Source : ObservableConvertibleType

let disposeBag = DisposeBag()

let a = BehaviorSubject(value: 1)
let b = BehaviorSubject(value: 2)

let subject = PublishSubject<BehaviorSubject<Int>>()

subject
    .flatMap { $0.asObservable() } // 새로운 옵저버블이 생성됨. Subject를 Observable로 바꿈
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject.onNext(a)
//next(1)

subject.onNext(b)
//next(1)
//next(2)

a.onNext(11)
//next(1)
//next(2)
//next(11)

b.onNext(22)
//next(1)
//next(2)
//next(11)
//next(22)
