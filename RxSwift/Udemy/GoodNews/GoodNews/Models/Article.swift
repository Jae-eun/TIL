//
//  Article.swift
//  GoodNews
//
//  Created by 이재은 on 22/04/2020.
//  Copyright © 2020 Jaeeun. All rights reserved.
//

import Foundation

struct ArticleList: Decodable {
    let articles: [Article]
}

extension ArticleList {
    static var all: Resource<ArticleList> = {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=e246fe3262d448db929998bfca2c1b62")!
        return Resource(url: url)
    }()
}

struct Article: Decodable {
    let title: String
    let description: String?
}
