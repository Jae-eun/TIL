//
//  MemoStorageType.swift
//  RxMemo
//
//  Created by 이재은 on 2021/04/27.
//

import Foundation
import RxSwift

protocol MemoStorageType {
    @discardableResult
    func createMemo(content: String) -> Observable<Memo>

    @discardableResult
    func memoList() -> Observable<[Memo]>

    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo>

    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> 
}
