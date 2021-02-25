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
 # repeatElement
 */
// * repeatElement(): 동일한 요소를 반복적으로 무한 방출함.

// func repeatElement(_ element: Self.Element, scheduler: RxSwift.ImmediateSchedulerTyep = CurrentThreadScheduler.instance) -> RxSwift.Observable<Self.Element> {
//      return RepeatElement(element: element, scheduler: scheduler)
// }

let disposeBag = DisposeBag()
let element = "❤️"

Observable.repeatElement(element)
    .take(3) // 지정한 개수만큼만 방출함
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(❤️)
//next(❤️)
//next(❤️)
//completed
