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
 # groupBy
 */
// * groupBy() : 방출되는 요소를 조건에 따라 그룹핑함.
// 파라미터로 클로저를 받음. 클로저는 요소를 파라미터로 받아서 키를 리턴함.
// 클로저에서 동일한 값을 리턴하는 요소끼리 그룹으로 묶임.
// 그룹에 속한 요소들은 개별 옵저버블로 방출됨.

//func groupBy<Key: Hashable>(keySelector: @escaping (Element) throws -> Key)
//    -> Observable<GroupedObservable<Key, Element>> {
//    return GroupBy(source: self.asObservable(), selector: keySelector)
//}

let disposeBag = DisposeBag()
let words = ["Apple", "Banana", "Orange", "Book", "City", "Axe"]

Observable.from(words)
    .groupBy { $0.count }
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(GroupedObservable<Int, String>(key: 5, source: RxSwift.(unknown context at $10f441a28).GroupedObservableImpl<Swift.String>))
//next(GroupedObservable<Int, String>(key: 6, source: RxSwift.(unknown context at $10f441a28).GroupedObservableImpl<Swift.String>))
//next(GroupedObservable<Int, String>(key: 4, source: RxSwift.(unknown context at $10f441a28).GroupedObservableImpl<Swift.String>))
//next(GroupedObservable<Int, String>(key: 3, source: RxSwift.(unknown context at $10f441a28).GroupedObservableImpl<Swift.String>))
//completed

Observable.from(words)
    .groupBy { $0.count }
    .subscribe(onNext: { GroupedObservable in
        print("== \(GroupedObservable.key)") // key에 저장된 값
        GroupedObservable.subscribe { print("  \($0)") }
    })
    .disposed(by: disposeBag)
//== 5
//    next(Apple)
//== 6
//    next(Banana)
//    next(Orange)
//== 4
//    next(Book)
//    next(City)
//== 3
//    next(Axe)
//    completed
//    completed
//    completed
//    completed

Observable.from(words)
    .groupBy { $0.count }
    .flatMap { $0.toArray() }
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(["Banana", "Orange"])
//next(["Axe"])
//next(["Book", "City"])
//next(["Apple"])
//completed

Observable.from(words)
    .groupBy { $0.first ?? Character(" ") }
    .flatMap { $0.toArray() }
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(["Banana", "Book"])
//next(["City"])
//next(["Orange"])
//next(["Apple", "Axe"])
//completed

// 홀수 짝수 그룹 만들기
Observable.range(start: 1, count: 10)
    .groupBy { $0 % 2 == 0 }
    .flatMap { $0.toArray() }
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next([1, 3, 5, 7, 9])
//next([2, 4, 6, 8, 10])
//completed
