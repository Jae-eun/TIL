//
//  SideBarViewController.swift
//  Chapter04-SideBarDIY
//
//  Created by 이재은 on 24/05/2020.
//  Copyright © 2020 Jaeeun. All rights reserved.
//

import UIKit

class SideBarViewController: UITableViewController {

    let titles = [
        "메뉴 01",
        "메뉴 02",
        "메뉴 03",
        "메뉴 04",
        "메뉴 05"]

    let icons = [
        UIImage(named: "icon01.png"),
        UIImage(named: "icon02.png"),
        UIImage(named: "icon03.png"),
        UIImage(named: "icon04.png"),
        UIImage(named: "icon05.png"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        let accoutLabel = UILabel()
        accoutLabel.frame = CGRect(x: 10, y: 30, width: self.view.frame.width, height: 30)

        accoutLabel.text = "je4297@naver.com"
        accoutLabel.textColor = .white
        accoutLabel.font = .boldSystemFont(ofSize: 15)

        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70)
        v.backgroundColor = .brown
        v.addSubview(accoutLabel)

        self.tableView.tableHeaderView = v

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.titles.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 재사용 큐 대신 매번 셀을 새로 생성함
        //        let cell = UITableViewCell()

        // 재사용 큐에서 테이블 셀을 꺼내옴
        let id = "MenuCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id)
            ?? UITableViewCell(style: .default, reuseIdentifier: id)

        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 14)

        return cell
    }

}

