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
 # PublishSubject
 */
// * Observable은 이벤트를 전달함. Observer는 Observable을 구독하고 전달되는 이벤트를 처리함.
// * Subject는 다른 Observable로 이벤트를 받아서 Observer로 전달할 수 있음.
// * Subject는 Observer인 동시에 Observable이라 할 수 있음.

// * PublishSubject: Subject로 전달되는 새로운 이벤트를 Observer에게 전달함.
// * BehaviorSubject: 생성 시점에 시작 이벤트를 지정함. 가장 마지막으로 전달된 이벤트를 저장해두었다가 새로운 구독자에게 전달함.
// * ReplaySubject: 하나 이상의 최신 이벤트를 버퍼에 저장함. Observer가 구독을 시작하면 버퍼에 있는 모든 이벤트를 전달함.
// * AsyncSubject: Subject로 Completed이벤트가 전달된 시점에 마지막 전달된 Next이벤트를 구독자로 전달함.

// Relay: Subject와 달리 Next이벤트만 받고, Completed와 Error이벤트는 받지 않음.
//      : 주로 종료 없이 계속 전달되는 이벤트 시퀀스를 처리할 때 활용함.
// * PublishRelay: PublishSubject를 Wrapping한 것.
// * BehaviorRelay: BehaviorSubject를 Wrapping한 것

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

let subject = PublishSubject<String>() // 생성되는 시점에 내부에 아무 이벤트가 존재하지 않음

subject.onNext("Hello")

let o1 = subject.subscribe { print(">> 1", $0) }
o1.disposed(by: disposeBag)
// * PublishSubject는 구독 이후에 새로 발생한 이벤트만 구독자로 전달함.

subject.onNext("RxSwift")
//>> 1 next(RxSwift)

let o2 = subject.subscribe { print(">> 2", $0) }
o2.disposed(by: disposeBag)

subject.onNext("Subject")
//>> 1 next(Subject)
//>> 2 next(Subject)

subject.onCompleted() //subject.onError(MyError.error)
//>> 1 completed
//>> 2 completed

let o3 = subject.subscribe { print(">> 3", $0) }
o3.disposed(by: disposeBag)
//>> 3 completed

// * Observable에 Completed이벤트가 전달된 이후에는 Next이벤트가 전달되지 않음
// * 구독 전에 이벤트가 사라지는 것을 피하고 싶다면, ReplaySubject나 Cold Observable을 사용하면 됨


