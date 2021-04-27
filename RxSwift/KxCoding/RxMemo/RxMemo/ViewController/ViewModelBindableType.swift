//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by 이재은 on 2021/04/27.
//

import UIKit

protocol ViewModelBindableType {
    associatedtype ViewModelType

    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

// 뷰컨트롤러에 추가된 뷰모델 속성에 실제 뷰모델을 저장
// bindViewModel()를 자동으로 호출
extension ViewModelBindableType where Self: UIViewController {
    /// 개별 뷰컨트롤러에서 bindViewModel()을 호출하지 않아도 되서 코드가 단순해짐. 
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()

        bindViewModel()
    }
}
