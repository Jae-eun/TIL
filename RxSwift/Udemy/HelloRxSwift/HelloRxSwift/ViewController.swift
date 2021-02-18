//
//  ViewController.swift
//  HelloRxSwift
//
//  Created by 이재은 on 29/03/2020.
//  Copyright © 2020 jaeeun. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        _ = Observable.from([1,2,3,4,5])
    }


}

