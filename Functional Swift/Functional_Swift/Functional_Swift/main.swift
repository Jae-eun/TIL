//
//  main.swift
//  Functional_Swift
//
//  Created by 이재은 on 13/01/2020.
//  Copyright © 2020 jaeeun. All rights reserved.
//

import Foundation

typealias Distance = Double

struct Position {
    var x: Double
    var y: Double
}

struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}

extension Position {
    /// 회색 영역에 점이 있는지 확인
    func inRange(range: Distance) -> Bool {
        return sqrt(x * x + y * y) <= range
    }
}

extension Ship {
    /// 다른 함선이 포격 범위에 드는지 확인
    func canEngageShip(target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange
    }

    func canSafelyEngageShip(target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange && targetDistance > unsafeRange
    }
}

let day = ["화", "수", "목", "금", "토", "일", "월"]
func whatDayOfTheWeekInJanuary(_ date: Int) -> String {
    return "\(day[date % 7])요일"
}

print(whatDayOfTheWeekInJanuary(30))

let whatDayOfTheWeekInJanuaryClosure = { (date: Int) -> String in
    return "\(day[date % 7])요일입니다~"
}

print(whatDayOfTheWeekInJanuaryClosure(15))

let today = { (month: Int, date: Int) -> String in
  return "오늘은 \(month)월 \(date)일입니다!"
}

print(today(1, 15))

let today2: (Int, Int) -> String = { "오늘은 \($0)월 \($1)일입니다!" }
print(today2(1, 30))

func whatDay(month: Int, date: Int, closure: (Int, Int) -> String) -> String {
    return closure(month, date)
}

print(whatDay(month: 1, date: 20, closure: today))
print(whatDay(month: 1, date: 22, closure: { mon, da in
    return "\(mon)월 \(da)일!!"
}))
print(whatDay(month: 1, date: 25){ "\($0)월 \($1)일~" })
