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
 # Disposables
 */

let subscription1 = Observable.from([1, 2, 3]) // 3개의 정수를 방출하는 Observable
    .subscribe(onNext: { element in
        print("Next", element)
    }, onError: { error in
        print("Error", error)
    }, onCompleted: {
        print("Completed")
    }, onDisposed: { // Observable이 전달하는 이벤트는 아님
        print("Disposed") // Observable과 관련된 모든 리소스가 제거된 후에 호출됨
    })

subscription1.dispose()
//Next 1
//Next 2
//Next 3
//Completed
//Disposed


var bag = DisposeBag()

Observable.from([1, 2, 3])
    .subscribe { // 하나의 클로저에서 모든 이벤트를 처리
        print($0)
    }
    .disposed(by: bag)

bag = DisposeBag()
//next(1)
//next(2)
//next(3)
//completed

// * 원하는 시점에 DisposeBag을 메모리에서 해제하고 싶다면, DisposeBag을 새로 생성하거나 nil을 할당하면 됨
// * 직접 리소스를 해제하는 것을 권장함

// interval() : 1씩 증가하는 정수를 무한으로 방출함
let subscription2 = Observable<Int>
    .interval(.seconds(1),
              scheduler: MainScheduler.instance)
    .subscribe(onNext: { element in
        print("Next", element)
    }, onError: { error in
        print("Error", error)
    }, onCompleted: {
        print("Completed")
    }, onDisposed: {
        print("Disposed")
    })

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    subscription2.dispose()
}
// * dispose 메소드가 호출되는 즉시 모든 리소스가 해제됨. 더이상 이벤트가 전달되지 않음.
// * Completed 이벤트도 전달되지 않기 때문에 dispose 메소드를 직접 호출하는 것은 권장하지 않음.
