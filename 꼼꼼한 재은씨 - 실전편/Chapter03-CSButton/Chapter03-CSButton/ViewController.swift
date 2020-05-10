//
//  ViewController.swift
//  Chapter03-CSButton
//
//  Created by 이재은 on 10/05/2020.
//  Copyright © 2020 Jaeeun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = CGRect(x: 30, y: 50, width: 150, height: 30)
        let csBtn = CSButton(frame: frame)
        self.view.addSubview(csBtn)
    }


}

