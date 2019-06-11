//
//  Generic.swift
//  Inflearn_12_Perfect
//
//  Created by 이재은 on 12/06/2019.
//  Copyright © 2019 Jaeeun Lee. All rights reserved.
//

import Foundation

// 23 Generic 제네릭
// 사용할 때 타입이 정해짐

var intValue: Int = 5
var doubleValue: Double = 5.6
var floatValue: Float = 3.4

func plus(a: Int, b: Int) -> Int {
    return a + b
}

//plus(a: floatValue, b: floatValue) 불가능

// Numeric 숫자 관련 타입들 => 연산 가능
func plusGeneric<T: Numeric>(a: T, b: T) -> T {
    return a + b
}

var result = plusGeneric(a: doubleValue, b: doubleValue)
result // double 타입. 넣는 타입에 따라서 타입이 결정됨.

// 한 번 정해지면 변경 불가
// 같은 타입을 넣어야 함
