//
//  FrontViewController.swift
//  Chapter04-SideBar
//
//  Created by 이재은 on 24/05/2020.
//  Copyright © 2020 Jaeeun. All rights reserved.
//

import UIKit

class FrontViewController: UIViewController {

    @IBOutlet var sideBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let revealVC = self.revealViewController() {
            self.sideBarButton.target = revealVC
            self.sideBarButton.action = #selector(revealVC.revealToggle(_:))
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }

    }

}
