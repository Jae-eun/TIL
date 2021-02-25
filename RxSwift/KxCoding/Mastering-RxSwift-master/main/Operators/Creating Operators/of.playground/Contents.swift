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
 # of
 */
// * of(): 두 개 이상의 요소를 방출할 수 있음

// func of(_ elements: Self.Element..., scheduler: RxSwift.ImmediateSchedulerType = CurrentThreadScheduler.instance) -> RxSwift.Observable<Self.Element> {
//        return ObservableSequence(elements: elements, scheduler: scheduler)
// }

// * 가변 파라미터로 선언되어 있어서 방출할 요소를 여러 값을 동시에 전달할 수 있음
// * 요소를 그대로 방출함. 배열 -> 배열로

let disposeBag = DisposeBag()
let apple = "🍏"
let orange = "🍊"
let kiwi = "🥝"

Observable.of(apple, orange, kiwi)
   .subscribe { element in print(element) }
   .disposed(by: disposeBag)
//next(🍏)
//next(🍊)
//next(🥝)
//completed

Observable.of([1, 2], [3, 4], [5, 6])
   .subscribe { element in print(element) }
   .disposed(by: disposeBag)
//next([1, 2])
//next([3, 4])
//next([5, 6])
//completed
