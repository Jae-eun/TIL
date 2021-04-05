//
//  HelloRxCocoaViewController.swift
//  MasteringRxSwift
//
//  Created by Keun young Kim on 26/08/2019.
//  Copyright © 2019 Keun young Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HelloRxCocoaViewController: UIViewController {
   
   let disposeBag = DisposeBag()
   
   @IBOutlet weak var valueLabel: UILabel!
   @IBOutlet weak var tapButton: UIButton!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
    tapButton.rx.tap
        .map { "Hello, RxCocoa" } // 탭 이벤트를 문자열로 바꿈
        .bind(to: valueLabel.rx.text) // 전달된 문자열이 label.text와 바인딩됨
        .disposed(by: disposeBag)
   }
}
