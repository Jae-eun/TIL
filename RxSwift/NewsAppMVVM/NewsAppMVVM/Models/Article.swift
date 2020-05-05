//
//  Article.swift
//  NewsAppMVVM
//
//  Created by 이재은 on 05/05/2020.
//  Copyright © 2020 Jaeeun. All rights reserved.
//

import Foundation

struct ArticleResponse: Decodable {
    let articles: [Article]
}
struct Article: Decodable {
    let title: String
    let description: String?
}
