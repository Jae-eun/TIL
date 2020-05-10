//
//  ViewController.swift
//  Chapter03-Tabbar
//
//  Created by 이재은 on 2020/04/09.
//  Copyright © 2020 이재은. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    private func setUI() {
        let title = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 30))

        title.text = "첫번째 탭"
        title.textColor = .red
        title.textAlignment = .center
        title.font = .boldSystemFont(ofSize: 14)
        title.sizeToFit() // 콘텐츠 내용에 맞게 레이블 크기 변경
        title.center.x = self.view.frame.width / 2
        self.view.addSubview(title)
    }

}


