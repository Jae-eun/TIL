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
 # map
 */
// * map() : 원본 옵저버블이 방출하는 요소를 대상으로 함수를 실행하고 그 결과를 새로운 옵저버블로 리턴함.

//func map<Result>(_ transform: @escaping (Self.Element) throws -> Result) -> Observable<Result>

let disposeBag = DisposeBag()
let skills = ["Swift", "SwiftUI", "RxSwift"]

Observable.from(skills)
    .map { "Hello, \($0)" }
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(Hello, Swift)
//next(Hello, SwiftUI)
//next(Hello, RxSwift)
//completed

Observable.from(skills)
    .map { $0.count }
    .subscribe { print($0) }
    .disposed(by: disposeBag)
//next(5)
//next(7)
//next(7)
//completed
