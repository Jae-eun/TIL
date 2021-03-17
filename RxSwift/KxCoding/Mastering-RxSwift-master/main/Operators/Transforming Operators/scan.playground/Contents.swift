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
 # scan
 */
// * scan() : accumulator function을 활용함

// 기본값으로 연산을 시작함
// 원본 옵저버블이 방출하는 요소를 대상으로 변환하여 결과를 하나의 옵저버블을 방출함
// 원본이 방출하는 요소의 수와 구독자로 전달되는 요소의 수가 동일함

//func scan<A>(_ seed: A,
//             accumulator: @escaping (A, Element) throws -> A)
//    -> Observable<A> {
//    return Scan(source: self.asObservable(),
//                seed: seed) { acc, element in
//        let currentAcc = acc
//        acc = try accumulator(currentAcc, element)
//    }
//}

// 첫번째 파라미터는 기본값
// 두번째 파라미터는 옵저버블이 방출하는 요소의 값과 같음
// 클로저의 리턴형은 첫번째 파라미터와 같음
// Accumulator Function / Accumulator Closure : scan 연산자로 전달하는 클로저.
// 클로저가 리턴한 값은 이어서 실행되는 클로저의 첫번째 값으로 쓰임

let disposeBag = DisposeBag()

Observable.range(start: 1, count: 10)
    .scan(0, accumulator: +)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(1)
//next(3)
//next(6)
//next(10)
//next(15)
//next(21)
//next(28)
//next(36)
//next(45)
//next(55)
//completed

// * 작업 결과를 누적시키면서 중간 결과와 최종 결과가 모두 필요할 때 사용함
// * 최종 결과만 필요하다면 reduce 연산자를 사용하면 됨
Observable.of(1, 2, 3, 4, 5)
    .flatMap {
        Observable.just($0 * 2)
    }
    .subscribe(onNext: {
        print("\($0)")
    })

Observable.of("1","2","dk")
    .compactMap { Int($0) }
    .subscribe { print($0) }
    .disposed(by: disposeBag)
