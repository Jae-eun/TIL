//
//  Protocol.swift
//  Inflearn_12_Perfect
//
//  Created by 이재은 on 12/06/2019.
//  Copyright © 2019 Jaeeun Lee. All rights reserved.
//

import Foundation

// 22 Protocols 프로토콜
// 특정한 조건을 강제하고 싶을 때

protocol DeskMaterial {
    var top: String { get set }
    var middle: String { get set }
}

protocol DeskSize {
    var width: Int { get set }
    var height: Int { get set }
    func area() -> Int // 구현 말고 정의만
}

protocol DeskInfo: DeskSize, DeskMaterial {
    
}

//class Test: DeskInfo {
//    var width: Int
//
//    var height: Int
//
//    func area() -> Int {
//        <#code#>
//    }
//
//    var top: String
//
//    var middle: String
//}

class MyClass: DeskMaterial, DeskSize {
    var top: String = ""
    
    var middle: String = ""
    
    var width: Int = 0
    
    var height: Int = 0
    
    func area() -> Int {
        return width * height
    }
}

var myClass = MyClass()
myClass.width = 20
myClass.height = 30
myClass.area() // 600
