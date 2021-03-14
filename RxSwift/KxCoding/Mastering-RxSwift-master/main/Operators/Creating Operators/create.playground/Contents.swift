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
 # create
 */
// * create(): Observable이 동작하는 방식을 직접 구현할 수 있음

//func create(_ subscribe: @escaping (RxSwift.AnyObserver<Self.Element>) -> RxSwift.Disposable) -> RxSwift.Observable<Self.Element>

let disposeBag = DisposeBag()

enum MyError: Error {
    case error
}

Observable<String>.create { (observer) -> Disposable in
    guard let url = URL(string: "https://www.apple.com") else {
        observer.onError(MyError.error)
        return Disposables.create()
    }

    guard let html = try? String(contentsOf: url, encoding: .utf8) else {
        observer.onError(MyError.error)
        return Disposables.create()
    }

    observer.onNext(html)
    observer.onCompleted()

    observer.onNext("After completed")

    return Disposables.create()
}
//.subscribe { print($0) }
//.disposed(by: disposeBag)
//html결과
//completed

let source: Observable<Int> = Observable.create { observer in
    for i in 1...3 {
        observer.on(.next(i))
    }
    observer.on(.completed)

    // Note that this is optional. If you require no cleanup you can return
    // `Disposables.create()` (which returns the `NopDisposable` singleton)
    // 이것은 선택사항임. 클린업이 필요하지 않다면
    // `Disposables.create()`(`NopDisposable` 싱글턴을 반환하는)을 반환하면 됨
    // Nop = No Operation
    // NopDisposable: dispose할 때 아무것도 하지 않는 disposable
    return Disposables.create {
        print("disposed")
    }
}

source.subscribe {
    print($0)
}

