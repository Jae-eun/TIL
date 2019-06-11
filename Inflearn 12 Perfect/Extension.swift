//
//  Extension.swift
//  Inflearn_12_Perfect
//
//  Created by 이재은 on 12/06/2019.
//  Copyright © 2019 Jaeeun Lee. All rights reserved.
//

import Foundation

// 21 Extension 익스텐션
// 원래 있는 것에 추가적인 기능을 만들 때
// extension 안에는 저장 프로퍼티를 만들 수 없음
// 클래스 바깥에 만들어야 함

var titleColor: UIColor!
var descriptionColor: UIColor!

titleColor = UIColor(red: 240/255, green: 30/255, blue: 30/255, alpha: 1)
descriptionColor = UIColor(red: 30/255, green: 250/255, blue: 30/255, alpha: 1)


extension UIColor {
    var mainRedColor: UIColor {
        return UIColor(red: 240/255, green: 30/255, blue: 30/255, alpha: 1)
    }
    var subGreenColor: UIColor {
      return UIColor(red: 30/255, green: 250/255, blue: 30/255, alpha: 1)
    }
}

titleColor = UIColor().mainRedColor
descriptionColor = UIColor().subGreenColor
