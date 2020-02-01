//
//  ViewController.swift
//  iOSStudy_ch7_delegate_191203
//
//  Created by 이재은 on 03/12/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tf: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        setTextField()
    }

    @IBAction func confirm(_ sender: Any) {
        // 텍스트 필드를 최초 응답자 객체에서 해제
        self.tf.resignFirstResponder()
    }

    @IBAction func input(_ sender: Any) {
        self.tf.becomeFirstResponder()
    }

    func setTextField() {
        self.tf.placeholder = "값을 입력하세요"
        self.tf.keyboardType = UIKeyboardType.alphabet
        self.tf.keyboardAppearance = UIKeyboardAppearance.dark
        self.tf.returnKeyType = UIReturnKeyType.join
        self.tf.enablesReturnKeyAutomatically = true

        self.tf.borderStyle = .line
        self.tf.backgroundColor = UIColor(white: 0.87, alpha: 1.0)
        self.tf.contentVerticalAlignment = .center
        self.tf.contentHorizontalAlignment = .center
        self.tf.layer.borderColor = UIColor.darkGray.cgColor
        self.tf.layer.borderWidth = 2.0
        // 텍스트 필드를 최초 응답자로 지정
        self.tf.becomeFirstResponder()

        self.tf.delegate = self
    }
}

extension ViewController: UITextFieldDelegate {
    // 텍스트 필드의 편집을 시작할 때 호출
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("텍스트 필드의 편집이 시작됩니다.")
        return true // false면 편집되지 않음
    }

    // 텍스트 필드의 편집이 시작된 후 호출
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("텍스트 필드의 편집이 시작되었습니다.")
    }

    // 텍스트 필드의 내용이 삭제될 때 호출
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("텍스트 필드의 내용이 삭제됩니다")
        return true // false면 삭제되지 않음
    }

    // 텍스트 필드의 내용이 변경될 때 호출
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("텍스트 필드의 내용이 \(string)으로 변경됩니다")
        if Int(string) == nil {
            if (textField.text?.count)! + string.count > 10 {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
        return true // false면 내용이 변경되지 않음
    }

    // 텍스트 필드의 리턴키가 눌러졌을 때 호출
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("텍스트 필드의 리턴키가 눌러졌습니다.")
        return true
    }

    // 텍스트 필드 편집이 종료될 때 호출
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("텍스트 필드의 편집이 종료됩니다.")
        return true // false면 편집이 종료되지 않음
    }

    // 텍스트 필드의 편집이 종료되었을 때 호출
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("텍스트 필드의 편집이 종료되었습니다.")
    }
}
