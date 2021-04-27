//
//  TransitionModel.swift
//  RxMemo
//
//  Created by 이재은 on 2021/04/27.
//

import Foundation

enum TransitionStyle {
    case root
    case push
    case modal
}

enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
