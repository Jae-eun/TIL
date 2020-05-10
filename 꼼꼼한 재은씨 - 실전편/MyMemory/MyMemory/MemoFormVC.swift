//
//  MemoFormVC.swift
//  MyMemory
//
//  Created by 이재은 on 26/03/2020.
//  Copyright © 2020 jaeeun. All rights reserved.
//

import UIKit

class MemoFormVC: UIViewController {
    @IBOutlet private weak var contents: UITextView!
    @IBOutlet private weak var preview: UIImageView!
    
    private var subject: String?
    private let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contents.delegate = self
        picker.delegate = self
    }
    
    @IBAction func save(_ sender: Any) {
        guard self.contents.text?.isEmpty == false else {
            let alert = UIAlertController(title: nil,
                                          message: "내용을 입력해주세요",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        // 객체 생성, 데이터 저장
        let data = MemoData()
        
        data.title = self.subject // 제목
        data.contents = self.contents.text // 내용
        data.image = self.preview.image // 이미지
        data.regdate = Date() // 작성 시각
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.memolist.append(data)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pick(_ sender: Any) {
        showActionSheet()
    }
    
    func showActionSheet() {
        let photoActionSheet = UIAlertController(title: nil,
                                                 message: "이미지를 가져올 곳을 선택해주세요~",
                                                 preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "카메라",
                                         style: .default,
                                         handler: { (alert) -> Void in
                                            self.openCamera()
        })
        let albumAction = UIAlertAction(title: "저장 앨범",
                                        style: .default,
                                        handler: { (alert) -> Void in
                                            self.openLibrary()
        })
        let libraryAction = UIAlertAction(title: "사진 라이브러리",
                                          style: .default,
                                          handler: { (alert) -> Void in
                                            self.openSaveAlbum()
        })
        photoActionSheet.addAction(cameraAction)
        photoActionSheet.addAction(albumAction)
        photoActionSheet.addAction(libraryAction)
        
        self.present(photoActionSheet, animated: true)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {

            picker.sourceType = .camera
            picker.allowsEditing = true
            self.present(picker, animated: true)
        } else {
            let alert = UIAlertController(title: "알림",
                                          message: "현재 카메라를 켤 수 없습니다.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func openSaveAlbum() {
        picker.sourceType = .savedPhotosAlbum
        self.present(picker, animated: true)
    }
    
    func openLibrary() {
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
}

extension MemoFormVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 이미지 선택을 완료했을 때 호출
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 선택된 이미지를 미리보기에 표시
        self.preview.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        picker.dismiss(animated: false)
    }
    
}

extension MemoFormVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let contents = textView.text as NSString
        let length = ((contents.length > 15) ? 15 : contents.length)
        self.subject = contents.substring(with: NSRange(location: 0, length: length))
        self.navigationItem.title = subject
    }
}
