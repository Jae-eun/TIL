//
//  RevealViewController.swift
//  Chapter04-SideBarDIY
//
//  Created by 이재은 on 24/05/2020.
//  Copyright © 2020 Jaeeun. All rights reserved.
//

import UIKit

class RevealViewController: UIViewController {

    var contentVC: UIViewController?
    var sideVC: UIViewController?
    var isSideBarShowing = false

    let SLIDE_TIME = 0.3
    let SIDEBAR_WIDTH: CGFloat = 260

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }

    func setupView() {
        // _프론트 컨트롤러 객체를 읽어옴
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "sw_front") as? UIViewController {
            // 읽어온 컨트롤러를 클래스 전체에서 참조할 수 있도록 contentVC 속성에 저장함
            self.contentVC = vc
            // _프론트 컨트롤러 객체를 메인 컨트롤러의 자식으로 등록함
            self.addChild(vc)
            self.view.addSubview(vc.view) // _프론트 컨트롤러의 뷰를 메인 컨트롤러의 서브 뷰로 등록함
            // _프론트 컨트롤러에 부모 뷰 컨트롤러가 바뀌었음을 알려줌
            vc.didMove(toParent: self)
        }
    }

    func getSideView() {
        if self.sideVC == nil {
            if let vc = self.storyboard?.instantiateViewController(identifier: "sw_rear") {
                self.sideVC = vc
                self.addChild(vc)
                self.view.addSubview(vc.view)
                vc.didMove(toParent: self)
                // _프론트 컨트롤러의 뷰를 제일 위로 올림
                self.view.bringSubviewToFront(self.contentVC!.view)
            }
        }
    }

    func setShadowEffect(shadow: Bool, offset: CGFloat) {
        if shadow {
            self.contentVC?.view.layer.cornerRadius = 10
            self.contentVC?.view.layer.shadowOpacity = 0.8
            self.contentVC?.view.layer.shadowColor = UIColor.black.cgColor
            self.contentVC?.view.layer.shadowOffset = CGSize(width: offset, height: offset)
        } else {
            self.contentVC?.view.layer.cornerRadius = 0
            self.contentVC?.view.layer.shadowOffset = CGSize(width: 0, height: 0) // 그림자 크기
        }
    }

    func openSideBar(_ complete: ( () -> Void)? ) {
        
    }

    func closeSideBar(_ complete: ( () -> Void)? ) {

    }

}
