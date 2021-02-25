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
 # debounce
 */
// * 짧은 시간동안 반복적으로 방출되는 이벤트를 제어함.

//func debounce(_ dueTime: RxTimeInterval, scheduler: SchedulerType) -> Observable<Element> {
//      return Debounce(source: self.asObservable(), dueTime: dueTime, scheduler: scheduler)
//}

// * 첫번째 파라미터는 시간을 전달함. Next이벤트를 방출할지 결정하는 조건으로 사용함.
// * Observer가 Next이벤트를 방출한 후 지정된 시간 동안 다른 Next이벤트를 방출하지 않는다면 해당 시간에서 가장 마지막에 방출한 이벤트를 구독자에게 전달함.
// * 지정된 시간 내에 이벤트를 또 방출했다면 타이머를 초기화함.
// * 타이머를 초기화한 후, 다시 지정된 시간 동안 대기함.

// * 두번째 파라미터에는 타이머를 실행할 스케줄러를 전달함.

// * 검색 기능을 구현할 때 활용.
// 문자가 입력될 때마다 매번 작업을 하는 것은 효율적이지 않음.
// 짧은 시간 동안 연속적으로 문자를 입력할 때는 작업이 실행되지 않음.
// 지정된 시간동안 문자를 입력하지 않으면 작업이 실행됨.
// 불필요한 리소스를 낭비하지 않으면서 실시간 검색 기능 개발 가능함.

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
   return Disposables.create {
   }
}

buttonTap
   .subscribe { print($0) }
   .disposed(by: disposeBag)
//next(Tap 1)
//next(Tap 2)
//next(Tap 3)
//next(Tap 4)
//next(Tap 5)
//next(Tap 6)
//next(Tap 7)
//next(Tap 8)
//next(Tap 9)
//next(Tap 10)
//next(Tap 11)
//next(Tap 12)
//next(Tap 13)
//next(Tap 14)
//next(Tap 15)
//next(Tap 16)
//next(Tap 17)
//next(Tap 18)
//next(Tap 19)
//next(Tap 20)
//completed

buttonTap
    .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(Tap 10)
//next(Tap 20)
//completed
