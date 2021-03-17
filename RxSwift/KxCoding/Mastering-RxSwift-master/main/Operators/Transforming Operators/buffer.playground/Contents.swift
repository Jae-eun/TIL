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
 # buffer
 */
// * buffer() : 특정 주기동안 옵저버블이 방출하는 요소를 수집하여 하나의 배열로 리턴함
// Controlled Buffering 구현에 사용됨

//func buffer(timeSpan: RxTimeInterval,
//            count: Int,
//            scheduler: SchedulerType) -> Observable<[Element]> {
//    return BufferTimeCount(source: self.asObservable(),
//                           timeSpan: timeSpan,
//                           count: count,
//                           scheduler: scheduler)
//}

// 첫번째 파라미터 : 요소를 수집할 시간. 시간이 경과하지 않았더라도 요소를 방출할 수 있음
// 두번째 파라미터 : 수집한 파라미터의 최대 수. 시간이 경과하면 수집된 항목만 방출함

let disposeBag = DisposeBag()

Observable<Int>.interval(.seconds(1),
                         scheduler: MainScheduler.instance)
    .buffer(timeSpan: .seconds(2),
            count: 3,
            scheduler: MainScheduler.instance)
    .take(5) // take 조건을 주지 않으면 무한정 방출
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next([0])
//next([1, 2, 3])
//next([4, 5])
//next([6, 7])
//next([8, 9])
//completed

Observable<Int>.interval(.seconds(1),
                         scheduler: MainScheduler.instance)
    .buffer(timeSpan: .seconds(5),
            count: 3,
            scheduler: MainScheduler.instance)
    .take(5) // take 조건을 주지 않으면 무한정 방출
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next([0, 1, 2])
//next([3, 4, 5])
//next([6, 7, 8])
//next([9, 10, 11])
//next([12, 13, 14])
//completed
