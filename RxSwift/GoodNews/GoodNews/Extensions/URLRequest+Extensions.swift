//
//  URLRequest+Extensions.swift
//  GoodNews
//
//  Created by 이재은 on 22/04/2020.
//  Copyright © 2020 Jaeeun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T: Decodable> {
    let url: URL
}

extension URLRequest {
    static func load<T>(resource: Resource<T>) -> Observable<T?> {
        return Observable.from([resource.url])
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
        }.map { data -> T? in
            return try? JSONDecoder().decode(T.self, from: data)
        }//.asObservable()
    }

//    static func load<T>(resource: Resource<T>) -> Observable<T?> {
//        return Single.just(resource.url)
//            .flatMap { url -> Single<Data> in
//                let request = URLRequest(url: url)
//                return URLSession.shared.rx.data(request: request).asSingle()
//        }.map { data -> T? in
//            return try? JSONDecoder().decode(T.self, from: data)
//        }.asObservable()
//    }
}
