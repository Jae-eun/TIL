//
//  ImageViewController.swift
//  iOSStudy_ch7_delegate_191203
//
//  Created by 이재은 on 03/12/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pick(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true

        picker.delegate = self

        self.present(picker, animated: false)
    }

}

// MARK:- 이미지 피커 컨트롤러 델리게이트 메소드
extension ImageViewController: UIImagePickerControllerDelegate {

    // 이미지 피커에서 이미지를 선택하지 않고 취소했을 때 호출되는 메소드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        picker.dismiss(animated: false) { () in
            let alert = UIAlertController(title: "",
                                          message: "이미지 선택이 취소되었습니다.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            self.present(alert, animated: false) // picker.presentingController
        }
    }

    // 이미지 피커에서 이미지를 선택했을 때 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: false) { () in
            let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.imgView.image = img
        }

    }
}

// MARK:- 네비게이션 컨트롤러 델리게이트 메소드

extension ImageViewController: UINavigationControllerDelegate {

}
