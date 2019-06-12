//
//  Initialization.swift
//  Inflearn_12_Perfect
//
//  Created by 이재은 on 12/06/2019.
//  Copyright © 2019 Jaeeun Lee. All rights reserved.
//

import Foundation

// 19 Initialization 초기화

class Score {
    var homeTeamScore: Int
    var awayTeamScore: Int
    
    func totalScore() -> Int {
        return homeTeamScore + awayTeamScore
    }
    
    // 생성할 때 초기값이 설정됨
    init() {
        homeTeamScore = 5
        awayTeamScore = 5
    }
}

// 인스턴스 생성
var ss = Score()
ss.awayTeamScore
ss.homeTeamScore
