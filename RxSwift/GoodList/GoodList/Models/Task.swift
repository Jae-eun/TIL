//
//  Task.swift
//  GoodList
//
//  Created by 이재은 on 15/04/2020.
//  Copyright © 2020 jaeeun. All rights reserved.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
