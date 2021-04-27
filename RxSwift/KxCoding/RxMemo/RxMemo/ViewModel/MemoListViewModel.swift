//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by 이재은 on 2021/04/27.
//

import Foundation
import RxSwift
import RxCocoa

// 뷰모델에는 의존성을 주입하는 생성자와 바인딩에 사용되는 속성과 메소드가 추가됨
class MemoListViewModel: CommonViewModel {
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
    
}
