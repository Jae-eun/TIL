//
//  ListViewController.swift
//  iOSstudy_ch8_CustomCell_191219
//
//  Created by 이재은 on 19/12/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    var dataset = [
        ("다크 나이트", "영웅물에 철학에 음악까지 더해져 예술이 되다", "2008-09-04", 8.95, "darknight.jpg"),
        ("호우시절", "때를 알고 내리는 좋은 비", "2009-10-08", 7.31, "rain.jpg"),
        ("말할 수 없는 비밀", "여기서 너까지 다섯 걸음", "2015-05-07", 9.19, "secret.jpg")
    ]

    // 테이블뷰를 구성할 리스트 데이터
    lazy var list: [MovieVO] = {
        var datalist = [MovieVO]()
        for (title, desc, opendate, rating, thumbnail) in self.dataset {
            let mvo = MovieVO()
            mvo.title = title
            mvo.description = desc
            mvo.opendate = opendate
            mvo.rating = rating
            mvo.thumbnail = thumbnail

            datalist.append(mvo)
        }
        return datalist
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return list.count
    }


    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let row = self.list[indexPath.row]
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
        cell.thumbnailImageView.image = UIImage(named: row.thumbnail!)

        return cell
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {

        NSLog("선택된 행은 \(indexPath.row) 번째 행입니다.")
    }

}
