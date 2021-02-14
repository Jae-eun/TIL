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
 # Observers
 */

let o1 = Observable<Int>.create { (observer) -> Disposable in
   observer.on(.next(0))
   observer.onNext(1)
   
   observer.onCompleted()
   
   return Disposables.create()
}

// #1: 하나의 클로저를 통해 모든 이벤트를 처리할 때
o1.subscribe {
    print($0)

    // 이벤트에 저장되어 있는 값은 element 속성을 통해 얻을 수 있음
    if let element = $0.element { // 옵셔널 타입임
        print(element)
    }
}

//next(0)
//0
//next(1)
//1
//completed

print("----------------------------------------------")

// #2: 이벤트별로 별도의 클로저로 처리
o1.subscribe(onNext: { element in // 클로저 파라미터로 Next이벤트에 저장된 요소가 바로 전달됨
    print(element)
})

//0
//1


// * Observable은 이벤트가 전달되는 순서를 정의함
// * 실제 이벤트가 전달되는 시점은 Observer가 구독을 시작한 시점
// * Observer는 동시에 여러 이벤트를 처리하지 않음
// * Observable은 Observer가 하나의 이벤트를 처리한 후에 이어지는 이벤트를 전달함

o1.subscribe {
    print("== Start ==")
    print($0)

    // 이벤트에 저장되어 있는 값은 element 속성을 통해 얻을 수 있음
    if let element = $0.element { // 옵셔널 타입임
        print(element)
    }
    print("== End ==")
}

//== Start ==
//next(0)
//0
//== End ==
//== Start ==
//next(1)
//1
//== End ==
//== Start ==
//completed
//== End ==
