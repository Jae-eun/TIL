//
//  CSButton.swift
//  Chapter03-CSButton
//
//  Created by 이재은 on 10/05/2020.
//  Copyright © 2020 Jaeeun. All rights reserved.
//

import Foundation
import UIKit

class CSButton: UIButton {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        self.backgroundColor = .green
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitle("버튼", for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .gray
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitle("코드로 생성된버튼", for: .normal)
    }

    init() {
        super.init(frame: CGRect.zero)
    }
}
