//
//  Deinitialization.swift
//  Inflearn_12_Perfect
//
//  Created by 이재은 on 12/06/2019.
//  Copyright © 2019 Jaeeun Lee. All rights reserved.
//

import Foundation

// 20 Deinitialization 초기화 해제
// 인스턴스가 소멸되는 시점에 호출
// 데이터를 없애거나 마지막에 전송하거나

class Score {
    init() {
        print("생성되는 시점에 호출")
    }
    
    deinit {
        print("소멸되는 시점에 호출")
    }
}

var myScore: Score? = Score() // "생성되는 시점에 호출"

myScore = nil // "소멸되는 시점에 호출"

