//
//  CSTabBarController.swift
//  Chapter03-CSTabBar
//
//  Created by 이재은 on 11/05/2020.
//  Copyright © 2020 Jaeeun. All rights reserved.
//

import Foundation
import UIKit

class CSTabBarController: UITabBarController {

    let csView = UIView()
    let tabItem01 = UIButton(type: .system)
    let tabItem02 = UIButton(type: .system)
    let tabItem03 = UIButton(type: .system)

    override func viewDidLoad() {
        self.tabBar.isHidden = true

        let width = self.view.frame.width
        let height: CGFloat = 50
        let x: CGFloat = 0
        let y = self.view.frame.height - height

        self.csView.frame = CGRect(x: x, y: y, width: width, height: height)
        self.csView.backgroundColor = .brown

        self.view.addSubview(csView)

        let tabBtnWidth = self.csView.frame.size.width / 3
        let tabBtnHeight = self.csView.frame.height

        self.tabItem01.frame = CGRect(x: 0, y: 0, width: tabBtnWidth, height: tabBtnHeight)
        self.tabItem02.frame = CGRect(x: tabBtnWidth, y: 0, width: tabBtnWidth, height: tabBtnHeight)
        self.tabItem03.frame = CGRect(x: tabBtnWidth * 2, y: 0, width: tabBtnWidth, height: tabBtnHeight)

        self.addTabBarBtn(btn: self.tabItem01, title: "첫 번째 버튼", tag: 0)
        self.addTabBarBtn(btn: self.tabItem02, title: "두 번째 버튼", tag: 1)
        self.addTabBarBtn(btn: self.tabItem03, title: "세 번째 버튼", tag: 2)

        self.onTabBarItemClick(self.tabItem01)
    }

    func addTabBarBtn(btn: UIButton, title: String, tag: Int) {
        btn.setTitle(title, for: .normal)
        btn.tag = tag

        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.yellow, for: .selected)

        btn.addTarget(self, action: #selector(onTabBarItemClick(_:)), for: .touchUpInside)

        self.csView.addSubview(btn)
    }

    @objc func onTabBarItemClick(_ sender: UIButton) {
        self.tabItem01.isSelected = false
        self.tabItem02.isSelected = false
        self.tabItem03.isSelected = false

        sender.isSelected = true

        self.selectedIndex = sender.tag
    }

}
