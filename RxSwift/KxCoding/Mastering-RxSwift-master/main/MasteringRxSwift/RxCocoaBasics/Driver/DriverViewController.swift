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

enum ValidationError: Error {
    case notANumber
}

class DriverViewController: UIViewController {

    let bag = DisposeBag()

    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. 기존
        //        let result = inputField.rx.text
        //           .flatMapLatest { validateText($0) }

        // 2. 개선
        //        let result = inputField.rx.text
        //            .flatMapLatest {
        //                validateText($0)
        //                    .observeOn(MainScheduler.instance) // Observable이 백그라운드 스케줄러에서 결과를 리턴한다면 UI 바인딩이 잘못된 스레드에서 실행될 가능성이 있음.
        //                    .catchErrorJustReturn(false) // 에러 이벤트를 false 반환으로 바꿈
        //            }
        //            .share() // 모든 구독자가 하나의 시퀀스를 공유함. Driver는 시퀀스를 공유하기 때문에 `share()` 연산자가 필요 없음.

        //        result
        //            .map { $0 ? "Ok" : "Error" }
        //            .bind(to: resultLabel.rx.text) // 에러 이벤트를 받지 않음 = 에러 이벤트는 바인딩하지 못함. Debug 환경: Crash / Runtime 환경 : 에러메시지 출력
        //            .disposed(by: bag)
        //
        //        result
        //            .map { $0 ? UIColor.blue : UIColor.red }
        //            .bind(to: resultLabel.rx.backgroundColor)
        //            .disposed(by: bag)
        //
        //        result
        //            .bind(to: sendButton.rx.isEnabled)
        //            .disposed(by: bag)

        // 3. Driver로 변환
        let result = inputField.rx.text.asDriver() // Driver는 직접 생성하는 것이 아니라, 일반 Observable을 Driver로 변환함.
            .flatMapLatest {
                validateText($0)
                    .asDriver(onErrorJustReturn: false)
            }

        result
            .map { $0 ? "Ok" : "Error" }
            .drive(resultLabel.rx.text) // 에러 이벤트를 받지 않음 = 에러 이벤트는 바인딩하지 못함. Debug 환경: Crash / Runtime 환경 : 에러메시지 출력
            .disposed(by: bag)

        result
            .map { $0 ? UIColor.blue : UIColor.red }
            .drive(resultLabel.rx.backgroundColor)
            .disposed(by: bag)

        result
            .drive(sendButton.rx.isEnabled)
            .disposed(by: bag)
    }
}

func validateText(_ value: String?) -> Observable<Bool> {
    return Observable<Bool>.create { observer in
        print("== \(value ?? "") Sequence Start ==")

        defer {
            print("== \(value ?? "") Sequence End ==")
        }

        guard let str = value, let _ = Double(str) else {
            observer.onError(ValidationError.notANumber)
            return Disposables.create()
        }

        observer.onNext(true)
        observer.onCompleted()

        return Disposables.create()
    }
}
