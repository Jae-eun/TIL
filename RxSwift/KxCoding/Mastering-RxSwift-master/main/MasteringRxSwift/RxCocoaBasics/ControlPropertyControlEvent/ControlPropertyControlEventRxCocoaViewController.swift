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

class ControlPropertyControlEventRxCocoaViewController: UIViewController {

    let disposeBag = DisposeBag()

    @IBOutlet weak var colorView: UIView!

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!

    @IBOutlet weak var redComponentLabel: UILabel!
    @IBOutlet weak var greenComponentLabel: UILabel!
    @IBOutlet weak var blueComponentLabel: UILabel!

    @IBOutlet weak var resetButton: UIButton!

    private func updateComponentLabel() {
        redComponentLabel.text = "\(Int(redSlider.value))"
        greenComponentLabel.text = "\(Int(greenSlider.value))"
        blueComponentLabel.text = "\(Int(blueSlider.value))"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        redSlider.rx.value
            .map { "\(Int($0))" }
            .bind(to: redComponentLabel.rx.text) // 메인 스레드에서 실행됨. 따라서, 스레드 처리를 신경쓰기 않아도 됨.
            .disposed(by: disposeBag)

        greenSlider.rx.value
            .map { "\(Int($0))" }
            .bind(to: greenComponentLabel.rx.text)
            .disposed(by: disposeBag)

        blueSlider.rx.value
            .map { "\(Int($0))" }
            .bind(to: blueComponentLabel.rx.text)
            .disposed(by: disposeBag)

        // slider를 드래그 할 때마다 모든 slider의 value가 하나의 배열로 방출됨.
        Observable.combineLatest([redSlider.rx.value,
                                  greenSlider.rx.value,
                                  blueSlider.rx.value])
            .map { UIColor(red: CGFloat($0[0]) / 255,
                           green: CGFloat($0[1]) / 255,
                           blue: CGFloat($0[0]) / 255,
                           alpha: 1.0) }
            .bind(to: colorView.rx.backgroundColor)
            .disposed(by: disposeBag)

        resetButton.rx.tap // subscribe 전에 observeOn 메소드로 스케줄러를 변경하면 메인 스레드에서 실행되지 않을 수 있음.
            .subscribe(onNext: { [weak self] in
                self?.colorView.backgroundColor = .black

                self?.redSlider.value = .zero
                self?.greenSlider.value = .zero
                self?.blueSlider.value = .zero

                self?.updateComponentLabel()
            })
            .disposed(by: disposeBag)
    }
}
