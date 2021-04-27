//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by 이재은 on 2021/04/27.
//

import Foundation
import RxSwift
import RxCocoa

class SceneCoordinator: SceneCoordinatorType {
    private let bag = DisposeBag()
    private let window: UIWindow
    private var currentVC: UIViewController

    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }

    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        let subject = PublishSubject<Void>() // 전환 결과 방출할 Subject
        let target = scene.instantiate() // Scene 생성

        switch style {
        case .root:
            currentVC = target
            window.rootViewController = target
            subject.onCompleted()
        case .push:
            guard let navigation = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            navigation.pushViewController(target, animated: animated)
            currentVC = target

            subject.onCompleted()

        case .modal:
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            currentVC = target
        }
        return subject.ignoreElements() // Completable로 변환되어서 리턴됨
    }

    @discardableResult
    func close(animated: Bool) -> Completable {
        // Completable을 직접 생성하는 방식
        return Completable.create { [unowned self] completable in
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC
                    completable(.completed)
                }
            } else if let navigation = self.currentVC.navigationController {
                guard navigation.popViewController(animated: animated) != nil else {
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                self.currentVC = navigation.viewControllers.last!
                completable(.completed)
            } else {
                completable(.error(TransitionError.unknown))
            }

            return Disposables.create()
        }
    }
}
