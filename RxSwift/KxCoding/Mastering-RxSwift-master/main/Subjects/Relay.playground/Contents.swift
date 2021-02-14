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
import RxCocoa

/*:
 # Relay
 */

let bag = DisposeBag()

// * Relay는 내부에 Subject를 랩핑하고 있음
// * Next이벤트만 전달함
// * 구독자가 dispose 되기 전까지 이벤트를 계속 전달함
// * 주로 UI 이벤트 처리에 활용됨

let prelay = PublishRelay<Int>()
prelay.subscribe { print("1: \($0)") }
    .disposed(by: bag)

prelay.accept(1)
//1: next(1)

let brelay = BehaviorRelay(value: 1) // 하나의 값을 생성자로 전달해야 함
brelay.accept(2)

brelay.subscribe {
    print("2: \($0)")
}
.disposed(by: bag)
//2: next(2)

brelay.accept(3)
//2: next(3)

print(brelay.value) // relay에 저장되어 있는 값 return
//3
