//
//  SceneCoordinatortype.swift
//  RxMemo
//
//  Created by 이재은 on 2021/04/27.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable

    @discardableResult
    func close(animated: Bool) -> Completable
    
}

// Completable에 구독자를 추가하고 화면 전환이 완료된 후의 작업을 구현하면 됨.
