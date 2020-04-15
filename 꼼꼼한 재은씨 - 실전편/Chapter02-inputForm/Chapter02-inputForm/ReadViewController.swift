//
//  ReadViewController.swift
//  Chapter02-inputForm
//
//  Created by 이재은 on 2020/04/10.
//  Copyright © 2020 이재은. All rights reserved.
//

import UIKit

class ReadViewController: UIViewController {

    var pEmail: String?
    var pUpdate: Bool?
    var pInterval: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        
        let email = UILabel()
        email.frame = CGRect(x: 50, y: 100, width: 300, height: 30)
        email.text = "전달받은 이메일 : \(self.pEmail!)"
        self.view.addSubview(email)
        
        let update = UILabel()
        update.frame = CGRect(x: 50, y: 150, width: 300, height: 30)
        update.text = "업데이트 여부 : \(self.pUpdate == true ? "업데이트 함" : "업데이트 안함")"
        self.view.addSubview(update)
        
        let interval = UILabel()
        interval.frame = CGRect(x: 50, y: 200, width: 300, height: 30)
        interval.text = "업데이트 주기 : \(self.pInterval!)분마다"
        self.view.addSubview(interval)
    }
}
