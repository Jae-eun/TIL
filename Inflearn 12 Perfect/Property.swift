//
//  Property.swift
//  Inflearn_12_Perfect
//
//  Created by 이재은 on 12/06/2019.
//  Copyright © 2019 Jaeeun Lee. All rights reserved.
//

import Foundation

// 18 - Properties 프로퍼티

// Stored 저장 : 값이 들어있거나 지정되어 있음
// Computed 계산 : 특정한 로직이 들어 있음

// 참조
class SomeClass {
    var firstScore = 10
    var secondScore = 20
    
    // ** Stored Property
    //    var totalScore = 0
    //
    //    func total() -> Int {
    //        totalScore = firstScore + secondScore
    //        return totalScore
    //    }
    
    // ** Computed Property
    // get은 필수. set은 선택
    var totalScore: Int {
        get {
            return firstScore + secondScore
        }
        set {
            
        }
    }
}

var someClass = SomeClass()
SomeClass.totalScore = 10 // 값을 넣으려면 set이 있어야 함.

// 값
class someStruct {
    var firstScore = 10
    var secondScore = 20
    var totalScore: Int {
        get {
            return firstScore + secondScore
        }
    }
}

var someStruct = someStruct()
someStruct.firstScore = 50
someStruct.secondScore = 100
someStruct.totalScore // 150


// 개별 타입의 상태를 나타낼 때 유용함
enum SomeEnum {
    case iPhone
    case iPad
    
    var price: Int {
        switch self {
        case iPhone:
            return 400
        case iPad:
            return 500
    }
}

var someEnum = SomeEnum.iPad
someEnum.price // 500

someEnum = .iPhone
someEnum.price // 400



