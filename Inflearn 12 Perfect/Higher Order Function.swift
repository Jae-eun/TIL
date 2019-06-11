//
//  Higher Order Function.swift
//  Inflearn_12_Perfect
//
//  Created by 이재은 on 12/06/2019.
//  Copyright © 2019 Jaeeun Lee. All rights reserved.
//

import Foundation

// 24 Higher Order Function 고차 함수

// map
// 각 요소에 변화를 줌

var numberArray = [2, 3, 6, 4, 1]
let mapped = numberArray.map{ $0 * 10 }
print(mapped) // [20, 30, 60, 40, 10]

let stringArray = ["lee", "june", "kim"]
let mappedString = stringArray.map{ $0.uppercased() }
print(mappedString) // ["LEE", "JUNE", "KIM"]


// compact map
// optional upwrapping
let someArray: [Any] = [2, 3, 4, "kim", "jin"]
let compactMapped = someArray.compactMap{ $0 as? Int } // Int 타입으로 가져올 수 있는지
print(compactMapped) // [2, 3, 4]

let saMapped = someArray.map{ $0 as? Int }
print(saMapped) // [Optional(2), Optional(3), Optional(4), nil, nil]
// 옵셔널이 유지됨.


// filter
// 특정한 조건이 맞는 경우를 반환함
let over3 = stringArray.filter{ $0.count == 3 }
print(over3) // ["lee", "kim"]


// reduce
// 재귀적으로 모든 요소에 연산을 함
numberArray.reduce(0) { (value1, value2) -> Int in
    return value1 + value2 // 16
}

// 축약
let reduceResult = numberArray.reduce(0) { $0 + $1 }
//let reduceResult = numberArray.reduce(0, { $0 + $1 })
print(reduceResult)

let reduceResultString = stringArray.reduce("aaa ", { $0 + $1 })
print(reduceResultString) // aaa leejunekim


// sort 해당되는 그 값 자체를 변경함
// sorted 새로운 값에 정렬한 것을 저장함. 원래 값에 영향 없음.

numberArray.sort() //  [1, 2, 3, 4, 6]
numberArray.sort(by: >) // 내림차순 [6, 4, 3, 2, 1]
print(numberArray) // [6, 4, 3, 2, 1]

let sorted = numberArray.sorted()
print(sorted) // [1, 2, 3, 4, 6]
print(numberArray) // [2, 3, 6, 4, 1]
