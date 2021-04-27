//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by 이재은 on 2021/04/27.
//

import Foundation
import RxSwift

class MemoryStorage: MemoStorageType {
    private var list = [
        Memo(content: "Hello", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "RxSwift", insertDate: Date().addingTimeInterval(-20))
    ]
    // 클래스 외부에서 배열에 직접 접근할 일이 없음
    // 배열은 Observable을 통해 외부로 공개됨
    // Observable은 배열의 상태가 변경되면 새로운 Next이벤트를 방출함
    // 초기에 더미데이터를 표시해야 하므로 BehaviorSubject
    private lazy var store = BehaviorSubject<[Memo]>(value: list)

    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        let memo = Memo(content: content)
        list.insert(memo, at: 0)

        store.onNext(list)

        return Observable.just(memo)
    }

    @discardableResult
    func memoList() -> Observable<[Memo]> {
        return store
    }

    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        let updated = Memo(original: memo, updatedContent: content)

        if let index = list.firstIndex(where: { $0 == memo }) {
            list.remove(at: index)
            list.insert(updated, at: index)
        }

        store.onNext(list)

        return Observable.just(updated)
    }

    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        if let index = list.firstIndex(where: { $0 == memo }) {
            list.remove(at: index)
        }

        store.onNext(list)

        return Observable.just(memo)
    }


}
