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
 # throttle
 */
//func throttle(_ dueTime: RxTimeInterval, latest: Bool = true, scheduler: SchedulerType) -> Observable<Element> {
//    return Throttle(source: self.asObservable(), dueTime: dueTime, latest: latest, scheduler: scheduler)
//}

// * 기본값을 갖고 있는 두번째 파라미터를 생략하는 경우가 많음.
// * latest가 true이면 반복 주기를 엄격하게 지킴. 지정된 주기마다 하나씩 이벤트를 전달함.
// * false면 반복 주기가 경과한 다음, 가장 먼저 방출되는 이벤트를 구독자에게 전달함.
// * 짧은 시간 동안 반복되는 탭 이벤트나 델리게이트 메시지를 처리할 때 주로 사용함.

let disposeBag = DisposeBag()

let buttonTap = Observable<String>.create { observer in
    DispatchQueue.global().async {
        for i in 1...10 {
            observer.onNext("Tap \(i)")
            Thread.sleep(forTimeInterval: 0.3)
        }

        Thread.sleep(forTimeInterval: 1)

        for i in 11...20 {
            observer.onNext("Tap \(i)")
            Thread.sleep(forTimeInterval: 0.5)
        }

        observer.onCompleted()
    }
    return Disposables.create()
}


buttonTap
    .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(Tap 1)
//next(Tap 4)
//next(Tap 7)
//next(Tap 10)
//next(Tap 11)
//next(Tap 12)
//next(Tap 14)
//next(Tap 16)
//next(Tap 18)
//next(Tap 20)
//completed

//: [Next](@next)
