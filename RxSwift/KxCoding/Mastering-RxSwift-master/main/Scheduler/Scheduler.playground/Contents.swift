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
 # Scheduler
 */
// * 스케줄러는 특정 코드가 실행되는 컨텍스트를 추상화한 것. 컨텍스트는 로우 레벨 Thread가 될 수도 있고, Dispatch Queue나 Operation Queue가 될 수도 있음.
// * 스케줄러는 스레드와 일대일로 매칭되는 것은 아님.
// UI 업데이트는 Main Scheduler에서 함.
// 네트워크 요청이나 파일 처리 같은 작업은 Background Scheduler에서 함.

// Serial Scheduler
// : CurrentThreadScheduler - 스케줄러를 별도로 지정하지 않으면 이 스케줄러가 실행됨.
// : MainScheduler - Main Queue처럼 UI 업데이트를 할 때 사용함.
// : SerialDispatchQueueScheduler - 작업을 실행할 DispatchQueue를 직접 지정하고 싶을 때 사용함.

// Concurrent Scheduler
// : ConcurrentDispatchQueueScheduler - 작업을 실행할 DispatchQueue를 직접 지정하고 싶을 때 사용함.
// : OperationQueueScheduler - 실행 순서나 동시에 실행할 작업 수를 제한하고 싶을 때 사용함.

// TestScheduler : Unit test에 사용함.
// CustomScheduler : 스케줄러를 직접 구현할 수 있음.

// Scheduler를 지정할 때는 `observeOn(_:)` `subscribeOn(_:)` 메소드를 사용하면 됨.
// observeOn(_:) : 이어지는 연산자들이 작업을 실행할 스케줄러를 지정함.
// subscribeOn(_:) : 구독을 시작하고 종료할 때 사용할 스케줄러를 지정함. 이벤트를 방출할 스케줄러를 지정하는 것임. 이 메소드를 사용하지 않으면 subscribe 메소드가 호출된 스케줄러에서 새로운 시퀀스가 시작됨.

let disposeBag = DisposeBag()

let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())

Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
    .filter { num -> Bool in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
        return num.isMultiple(of: 2)
    }
    .map { num -> Int in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
        return num * 2
    }
    .subscribe {
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> subscribe")
        print($0)
    }
    .disposed(by: disposeBag)
//Main Thread >> filter
//Main Thread >> filter
//Main Thread >> map
//Main Thread >> subscribe
//next(4)
//Main Thread >> filter
//Main Thread >> filter
//Main Thread >> map
//Main Thread >> subscribe
//next(8)
//Main Thread >> filter
//Main Thread >> filter
//Main Thread >> map
//Main Thread >> subscribe
//next(12)
//Main Thread >> filter
//Main Thread >> filter
//Main Thread >> map
//Main Thread >> subscribe
//next(16)
//Main Thread >> filter
//Main Thread >> subscribe
//completed
// CurrentThreadScheduler와 Main Thread에서 실행됨

Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
    .filter { num -> Bool in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
        return num.isMultiple(of: 2)
    }
    .observeOn(backgroundScheduler)
    .map { num -> Int in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
        return num * 2
    }
    .subscribe {
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> subscribe")
        print($0)
    }
    .disposed(by: disposeBag)
//Main Thread >> filter
//Main Thread >> filter
//Background Thread >> map
//Main Thread >> filter
//Background Thread >> subscribe
//Main Thread >> filter
//next(4)
//Main Thread >> filter
//Background Thread >> map
//Main Thread >> filter
//Background Thread >> subscribe
//Main Thread >> filter
//next(8)
//Main Thread >> filter
//Background Thread >> map
//Main Thread >> filter
//Background Thread >> subscribe
//next(12)
//Background Thread >> map
//Background Thread >> subscribe
//next(16)
//Background Thread >> subscribe
//completed

Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
    .filter { num -> Bool in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
        return num.isMultiple(of: 2)
    }
    .observeOn(backgroundScheduler)
    .map { num -> Int in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
        return num * 2
    }
    .subscribeOn(MainScheduler.instance)
    .subscribe {
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> subscribe")
        print($0)
    }
    .disposed(by: disposeBag)
//Main Thread >> filter
//Main Thread >> filter
//Background Thread >> map
//Main Thread >> filter
//Background Thread >> subscribe
//Main Thread >> filter
//next(4)
//Main Thread >> filter
//Background Thread >> map
//Main Thread >> filter
//Background Thread >> subscribe
//next(8)
//Main Thread >> filter
//Background Thread >> map
//Main Thread >> filter
//Background Thread >> subscribe
//next(12)
//Main Thread >> filter
//Background Thread >> map
//Background Thread >> subscribe
//next(16)
//Background Thread >> subscribe
//completed
// subscribeOn(_:)은 subscribeOn 메소드가 실행될 스케줄러나, 이어지는 연산자가 실행될 스케줄러를 지정하는 것이 아님.
// * 옵저버블이 시작되는 시점에 어떤 스케줄러를 사용할지 지정한 것임.
// * 호출 시점이 중요하지 않음.
