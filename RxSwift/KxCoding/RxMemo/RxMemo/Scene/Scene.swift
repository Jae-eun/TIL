//
//  Scene.swift
//  RxMemo
//
//  Created by 이재은 on 2021/04/27.
//

import UIKit

enum Scene {
    case list(MemoListViewModel)
    case detail(MemoDetailViewModel)
    case compose(MemoComposeViewModel)
}

extension Scene {
    // 스토리보드에 있는 Scene을 생성하고, 연관값에 저장된 뷰모델을 바인딩해서 리턴하는 메소드
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: .main)

        switch self {
        case .list(let viewModel):
            guard let navigation = storyboard.instantiateViewController(withIdentifier: "ListNavigation") as? UINavigationController else {
                fatalError()
            }
            guard var listVC = navigation.viewControllers.first as? MemoListViewController else {
                fatalError()
            }

            listVC.bind(viewModel: viewModel)
            return navigation
            
        case .detail(let viewModel):
            guard var detailVC = storyboard.instantiateViewController(withIdentifier: "MemoDetailViewController") as? MemoDetailViewController else {
                fatalError()
            }

            detailVC.bind(viewModel: viewModel)
            return detailVC

        case .compose(let viewModel):
            guard let navigation = storyboard.instantiateViewController(withIdentifier: "ComposeNavigation") as? UINavigationController else {
                fatalError()
            }
            guard var composeVC = navigation.viewControllers.first as? MemoComposeViewController else {
                fatalError()
            }

            composeVC.bind(viewModel: viewModel)
            return navigation
        }
    }
}

// MVVM 패턴에서는 뷰모델을 뷰컨트롤러의 속성으로 추가함
// 뷰모델과 뷰를 바인딩함
