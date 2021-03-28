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
 # timeout
 */
// * timeout() : 모든 요소에 타임아웃 정책을 적용함. 지정한 시간 동안 Next 이벤트를 방출하지 않으면 에러 이벤트가 방출되고 종료됨.

//func timeout(_ dueTime: RxTimeInterval,
//              scheduler: SchedulerType) -> Observable<Self.Element>

//func timeout<Source>(_ dueTime: RxTimeInterval,
//                     other: Source,
//                     scheduler: SchedulerType) -> Observable<Self.Element> where Source : ObservableConvertibleType, Self.Element == Source.Element
// 타임아웃이 되면 에러 이벤트를 전달하는 것이 아니라 구독 대상을 두번째 파라미터로 전달한 옵저버블로 교체함.

let disposeBag = DisposeBag()

let subject = PublishSubject<Int>()

//subject
//    .timeout(.seconds(3),
//             scheduler: MainScheduler.instance)
//    .subscribe { print($0) }
//    .disposed(by: disposeBag)

//Observable<Int>.timer(.seconds(1),
//                      period: .seconds(1),
//                      scheduler: MainScheduler.instance)
//    .subscribe(onNext: { subject.onNext($0) })
//    .disposed(by: disposeBag)
//next(0)
//next(1)
//next(2)
//...

//Observable<Int>.timer(.seconds(5),
//                      period: .seconds(1),
//                      scheduler: MainScheduler.instance)
//    .subscribe(onNext: { subject.onNext($0) })
//    .disposed(by: disposeBag)
//error(Sequence timeout.)


subject
    .timeout(.seconds(3),
             other: Observable.just(0),
             scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

Observable<Int>.timer(.seconds(2),
                      period: .seconds(5),
                      scheduler: MainScheduler.instance)
    .subscribe(onNext: { subject.onNext($0) })
    .disposed(by: disposeBag)
//next(0)
//next(0)
//completed
