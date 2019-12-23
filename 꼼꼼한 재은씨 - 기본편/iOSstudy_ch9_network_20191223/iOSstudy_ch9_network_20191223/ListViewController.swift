//
//  ListViewController.swift
//  iOSstudy_ch9_network_20191223
//
//  Created by 이재은 on 23/12/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    @IBOutlet weak var moreBtn: UIButton!

    var page = 1

    // 테이블뷰를 구성할 리스트 데이터
    lazy var list: [MovieVO] = {
        var datalist = [MovieVO]()
        return datalist
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.callMovieAPI()
    }

    @IBAction func more(_ sender: Any) {
        self.page += 1
        self.callMovieAPI()
        self.tableView.reloadData()
    }

    func callMovieAPI() {
        // 호핀 API 호출을 위한 URI 생성
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=1&count=10&genreId=&order=releasedateasc"
        let apiURI: URL! = URL(string: url)
        // REST API를 호출
        let apidata = try! Data(contentsOf: apiURI)

        // 데이터 전송 결과를 로그로 출력
        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? ""
        NSLog("API Result=\( log )")

        do {
            // JSON 객체를 파싱하여 NSDictionary 객체로 받음
            let apiDictionary = try JSONSerialization
                .jsonObject(with: apidata,
                            options: []) as! NSDictionary
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = apiDictionary["movies"] as! NSDictionary
            let movie = apiDictionary["movie"] as! NSArray

            // Iterator 처리를 하면서 API 데이터를 MovieVO 객체에 저장한다.
            for row in movie {
                // 순회 상수를 NSDictionary 타입으로 캐스팅
                let r = row as! NSDictionary
                // 테이블뷰 리스트를 구성할 데이터 형식
                let mvo = MovieVO()

                // movie 배열의 각 데이터를 mvo 상수의 속성에 대입
                mvo.title = r["title"] as? String
                mvo.description = r["genre"] as? String
                mvo.thumbnail = r["thumbnailImage"] as? String
                mvo.detail = r["linkUrl"] as? String
                mvo.rating = ((r["ratingAverage"] as! NSString).doubleValue)

                // 섬네일 경로를 인자값으로 하는 URL 객체를 생성
                let url: URL! = URL(string: mvo.thumbnail!)
                // 이미지를 읽어와 Data 객체에 저장
                let imageData = try! Data(contentsOf: url)
                mvo.thumbnailImage = UIImage(data: imageData)
                // list 배열에 추가
                self.list.append(mvo)

                let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
                if (self.list.count >= totalCount) {
                    self.moreBtn.isHidden = true
                }
            }
        } catch {
            NSLog("Parse Error!!")
        }
    }

    func getThumbnailImage(_ index: Int) -> UIImage {
        // 인자값으로 받은 인덱스를 기반으로 해당하는 배열 데이터를 읽어옴
        let mvo = self.list[index]

        // 메모이제이션 : 저장된 이미지가 있으면 그것을 반환하고, 없을 경우 내려받아 저장한 후 반환
        if let savedImage = mvo.thumbnailImage {
            return savedImage
        } else {
            let url: URL! = URL(string: mvo.thumbnail!)
            let imageData = try! Data(contentsOf: url)
            mvo.thumbnailImage = UIImage(data: imageData) // UIImage를 MovieVO 객체에 우선 저장

            return mvo.thumbnailImage! // 저장된 이미지를 반환
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }


    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let row = self.list[indexPath.row]
        NSLog("제목: \(row.title!), 호출된 행번호: \(indexPath.row)")
        // 테이블 셀 객체를 직접 생성하는 대신 큐로부터 가져옴
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell

        //        let title = cell.viewWithTag(101) as? UILabel
        //        let desc = cell.viewWithTag(102) as? UILabel
        //        let opendate = cell.viewWithTag(103) as? UILabel
        //        let rating = cell.viewWithTag(104) as? UILabel
        //
        //        title?.text = row.title
        //        desc?.text = row.description
        //        opendate?.text = row.opendate
        //        rating?.text = "\(row.rating!)"

        cell.titleLabel.text = row.title
        cell.descLabel.text = row.description
        cell.opendateLabel.text = row.opendate
        cell.ratingLabel.text = "\(row.rating!)"

        // 비동기 방식으로 섬네일 이미지를 읽어옴옴
        DispatchQueue.main.async(execute: {
            NSLog("비동기 방식으로 실행되는 부분입니다")
            cell.thumbnailImageView.image = self.getThumbnailImage(indexPath.row)
        })
//        cell.thumbnailImageView.image = UIImage(data: try! Data(contentsOf: URL(string: row.thumbnail!)!))
        NSLog("메소드 실행을 종료하고 셀을 리턴합니다")

        return cell
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {

        NSLog("선택된 행은 \(indexPath.row) 번째 행입니다.")
    }

}
