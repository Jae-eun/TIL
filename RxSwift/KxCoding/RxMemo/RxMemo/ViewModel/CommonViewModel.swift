//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by 이재은 on 2021/04/27.
//

import Foundation
import RxSwift
import RxCocoa

class CommonViewModel: NSObject {
    let title: Driver<String> // 네비 아이템에 쉽게 바인딩 할 수 있음
    let sceneCoordinator: SceneCoordinatorType
    let storage: MemoStorageType // 프로토콜을 사용하면 의존성을 쉽게 수정할 수 있음

    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}

// 앱을 구성하는 모든 Scene은 네비게이션 컨트롤러에 임베드됨
