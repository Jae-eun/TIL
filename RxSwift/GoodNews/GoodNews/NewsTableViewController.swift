//
//  NewsTableViewController.swift
//  GoodNews
//
//  Created by 이재은 on 22/04/2020.
//  Copyright © 2020 Jaeeun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsTableViewController: UITableViewController {

    let disposeBag = DisposeBag()
    private var articles = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true

        populateNews()

        startWith()
        concat()
        merge()
        combineLatest()
        withLatestFrom()
        reduce()
        scan()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableVeiwCell else {
            fatalError("ArticleTableViewCell does not exist")
        }

        cell.titleLabel.text = self.articles[indexPath.row].title
        cell.descriptionLabel.text = self.articles[indexPath.row].description

        return cell
    }

    private func populateNews() {
        //        guard let url = URL(string:  "https://newsapi.org/v2/top-headlines?country=us&apiKey=e246fe3262d448db929998bfca2c1b62") else {
        //            return
        //        }
        // 1
        //        Observable.just(url)
        //            .flatMap { url -> Observable<Data> in
        //                let request = URLRequest(url: url)
        //                return URLSession.shared.rx.data(request: request)
        //        }.map { data -> [Article]? in
        //            return try? JSONDecoder().decode(ArticleList.self, from: data).articles
        //        }.subscribe(onNext: { [weak self] articles in
        //            if let articles = articles {
        //                self?.articles = articles
        //                DispatchQueue.main.async {
        //                    self?.tableView.reloadData()
        //                }
        //            }
        //
        //        }).disposed(by: disposeBag)

        // 2
        //        let resource = Resource<ArticleList>(url: url)

        URLRequest.load(resource: ArticleList.all)
            .subscribe(onNext: { [weak self] result in
                if let result = result {
                    self?.articles = result.articles
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }).disposed(by: disposeBag)
    }



    func startWith() {
        let numbers = Observable.of(2,3,4)

        let observable = numbers.startWith(1)
        observable.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)

        //1
        //2
        //3
        //4
    }

    func concat() {
        let first = Observable.of(1,2,3)
        let second = Observable.of(4,5,6)

        let observable = Observable.concat([first,second])

        // Observabledml 클래스 메소드 사용
        observable.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)

        // Observable의 인스턴스 메소드 사용
        first.concat(second)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)

        //1
        //2
        //3
        //4
        //5
        //6
    }

    func merge() {
        let left = PublishSubject<Int>()
        let right = PublishSubject<Int>()

        let source = Observable.of(left.asObserver(), right.asObservable())

        let observable = source.merge()
        observable.subscribe(onNext: {
            print($0)
            }).disposed(by: disposeBag)

        left.onNext(5)
        left.onNext(3)
        right.onNext(2)
        right.onNext(1)
        left.onNext(99)

//        5
//        3
//        2
//        1
//        99
    }

    func combineLatest() {
        let left = PublishSubject<Int>()
        let right = PublishSubject<Int>()

        let observable = Observable.combineLatest(left, right, resultSelector: {
            lastLeft, lastRight in
            "\(lastLeft) \(lastRight)"
        })

        let disposable = observable
            .subscribe(onNext :{ value in
                print(value)
            })

        left.onNext(45)
        right.onNext(1)
        left.onNext(30)
        right.onNext(1)
        right.onNext(2)

        //45 1
        //30 1
        //30 1
        //30 2
    }


    func withLatestFrom() {
        let button = PublishSubject<Void>()
        let textField = PublishSubject<String>()

        let observable = button.withLatestFrom(textField)
        let disposable = observable.subscribe(onNext: {
            print($0)
        })

        textField.onNext("Sw")
        textField.onNext("Swif")
        textField.onNext("Swift")

        button.onNext(())
        button.onNext(())

//        Swift
//        Swift
    }

    func reduce() {
        let source = Observable.of(1,2,3)

        source.reduce(0, accumulator: +)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)

        //6

        source.reduce(0, accumulator: {
            summary, newValue in
            return summary + newValue
        }).subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)

        //6
    }

    func scan() {
        let source = Observable.of(1,2,3,5,6)

        source.scan(0, accumulator: +)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)

        //1
        //3
        //6
        //11
        //17
    }

}
