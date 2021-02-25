//: [Previous](@previous)

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
 ## latest parameter
 */

let disposeBag = DisposeBag()

func currentTimeString() -> String {
    let f = DateFormatter()
    f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    return f.string(from: Date())
}


Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .debug()
    .take(10)
    .throttle(.milliseconds(2500), latest: true, scheduler: MainScheduler.instance)
    .subscribe { print(currentTimeString(), $0) }
    .disposed(by: disposeBag)
//2021-02-26 01:01:40.977: 2.xcplaygroundpage:43 (__lldb_expr_214) -> subscribed
//2021-02-26 01:01:42.084: 2.xcplaygroundpage:43 (__lldb_expr_214) -> Event next(0)
//2021-02-26 01:01:42.084 next(0)
//2021-02-26 01:01:43.084: 2.xcplaygroundpage:43 (__lldb_expr_214) -> Event next(1)
//2021-02-26 01:01:44.083: 2.xcplaygroundpage:43 (__lldb_expr_214) -> Event next(2)
//2021-02-26 01:01:44.586 next(2)
//2021-02-26 01:01:45.084: 2.xcplaygroundpage:43 (__lldb_expr_214) -> Event next(3)
//2021-02-26 01:01:46.084: 2.xcplaygroundpage:43 (__lldb_expr_214) -> Event next(4)
//2021-02-26 01:01:47.084: 2.xcplaygroundpage:43 (__lldb_expr_214) -> Event next(5)
//2021-02-26 01:01:47.087 next(5)
//2021-02-26 01:01:48.083: 2.xcplaygroundpage:43 (__lldb_expr_214) -> Event next(6)
//2021-02-26 01:01:49.083: 2.xcplaygroundpage:43 (__lldb_expr_214) -> Event next(7)
//2021-02-26 01:01:49.588 next(7)
//2021-02-26 01:01:50.083: 2.xcplaygroundpage:43 (__lldb_expr_214) -> Event next(8)
//2021-02-26 01:01:51.084: 2.xcplaygroundpage:43 (__lldb_expr_214) -> Event next(9)
//2021-02-26 01:01:51.084: 2.xcplaygroundpage:43 (__lldb_expr_214) -> isDisposed
//2021-02-26 01:01:52.090 next(9)
//2021-02-26 01:01:52.090 completed

// 2.5초마다 가장 최근 발생한 이벤트를 구독자에게 전달함.


Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .debug()
    .take(10)
    .throttle(.milliseconds(2500), latest: false, scheduler: MainScheduler.instance)
    .subscribe { print(currentTimeString(), $0) }
    .disposed(by: disposeBag)
//2021-02-26 01:05:49.258: 2.xcplaygroundpage:70 (__lldb_expr_216) -> subscribed
//2021-02-26 01:05:50.260: 2.xcplaygroundpage:70 (__lldb_expr_216) -> Event next(0)
//2021-02-26 01:05:50.261 next(0)
//2021-02-26 01:05:51.260: 2.xcplaygroundpage:70 (__lldb_expr_216) -> Event next(1)
//2021-02-26 01:05:52.260: 2.xcplaygroundpage:70 (__lldb_expr_216) -> Event next(2)
//2021-02-26 01:05:53.260: 2.xcplaygroundpage:70 (__lldb_expr_216) -> Event next(3)
//2021-02-26 01:05:53.260 next(3)
//2021-02-26 01:05:54.259: 2.xcplaygroundpage:70 (__lldb_expr_216) -> Event next(4)
//2021-02-26 01:05:55.259: 2.xcplaygroundpage:70 (__lldb_expr_216) -> Event next(5)
//2021-02-26 01:05:56.259: 2.xcplaygroundpage:70 (__lldb_expr_216) -> Event next(6)
//2021-02-26 01:05:56.260 next(6)
//2021-02-26 01:05:57.259: 2.xcplaygroundpage:70 (__lldb_expr_216) -> Event next(7)
//2021-02-26 01:05:58.259: 2.xcplaygroundpage:70 (__lldb_expr_216) -> Event next(8)
//2021-02-26 01:05:59.259: 2.xcplaygroundpage:70 (__lldb_expr_216) -> Event next(9)
//2021-02-26 01:05:59.259 next(9)
//2021-02-26 01:05:59.260 completed
//2021-02-26 01:05:59.260: 2.xcplaygroundpage:70 (__lldb_expr_216) -> isDisposed

// 2.5초가 지난 후 첫번째로 방출된 Next이벤트를 구독자에게 전달함.
