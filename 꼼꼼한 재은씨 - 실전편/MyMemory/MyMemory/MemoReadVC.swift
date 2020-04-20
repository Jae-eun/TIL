//
//  MemoReadVC.swift
//  MyMemory
//
//  Created by 이재은 on 2020/03/27.
//  Copyright © 2020 jaeeun. All rights reserved.
//

import UIKit

class MemoReadVC: UIViewController {
    @IBOutlet private weak var subjectLabel: UILabel!
    @IBOutlet private weak var contentsLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    var param: MemoData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setData()
    }

    private func setData() {
        self.subjectLabel.text = param?.title
        self.contentsLabel.text = param?.contents
        self.imageView.image = param?.image

        let formatter = DateFormatter()
        formatter.dateFormat = "dd일 HH:mm분에 작성됨"
        let dateString = formatter.string(from: (param?.regdate)!)
        
        self.navigationItem.title = dateString
    }
}
