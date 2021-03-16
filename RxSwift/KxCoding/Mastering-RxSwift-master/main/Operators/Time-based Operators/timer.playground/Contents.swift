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
 # timer
 */
// * timer() : 지연 시간과 반복 주기를 지정해서 정수를 방출함.

//extension ObservableType where Element: RxAbstractInteger {
//    func timer(_ dueTime: RxTimeInterval,
//               period: RxTimeInterval? = nil,
//               scheduler: SchedulerType)
//        -> Observable<Element> {
//        return Timer(
//            dueTime: dueTime,
//            period: period,
//            scheduler: scheduler
//        )
//    }
//}

// 첫번째 파라미터 : 첫번째 요소가 구독자에게 전달되는 시점

let disposebag = DisposeBag()

Observable<Int>.timer(.seconds(1),
                      scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: disposebag)
//next(0)
//completed

Observable<Int>.timer(.seconds(1),
                      period: .milliseconds(500),
                      scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: disposebag)
//next(0)
//next(1)
//next(2)
//next(3)
//... 0.5초마다 반복 방출
