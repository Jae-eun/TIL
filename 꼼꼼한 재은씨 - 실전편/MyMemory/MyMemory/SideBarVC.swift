//
//  SideBarVC.swift
//  MyMemory
//
//  Created by 이재은 on 2020/05/25.
//  Copyright © 2020 jaeeun. All rights reserved.
//

import UIKit

class SideBarVC: UITableViewController {

    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let profileImage = UIImageView()

    let titles = ["새글 작성하기", "친구 새글", "달력으로 보기", "공지사항", "통계", "계정 관리"]
    
    let icons = [
        UIImage(named: "icon01.png"),
        UIImage(named: "icon02.png"),
        UIImage(named: "icon03.png"),
        UIImage(named: "icon04.png"),
        UIImage(named: "icon05.png")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: self.view.frame.width,
                                              height: 70))
        headerView.backgroundColor = .brown

        self.nameLabel.frame = CGRect(x: 70, y: 15, width: 100, height: 30)
        self.nameLabel.text = "꼼꼼한 재은씨"
        self.nameLabel.textColor = .white
        self.nameLabel.font = .systemFont(ofSize: 15)
        self.nameLabel.backgroundColor = .clear
        headerView.addSubview(self.nameLabel)

        self.emailLabel.frame = CGRect(x: 70, y: 30, width: 100, height: 30)
        self.emailLabel.text = "je4297@naver.com"
        self.emailLabel.textColor = .white
        self.emailLabel.font = .systemFont(ofSize: 11)
        self.emailLabel.backgroundColor = .clear
        headerView.addSubview(self.emailLabel)

        let defaultImage = UIImage(named: "account.jpg")
        self.profileImage.image = defaultImage
        self.profileImage.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        view.addSubview(self.profileImage)

        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.layer.borderWidth = 0
        self.profileImage.layer.masksToBounds = true
        view.addSubview(self.profileImage)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let id = "MenuCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)

        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 14)
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let uv = self.storyboard?.instantiateViewController(identifier: "MemoForm")
            let target = self.revealViewController()?.frontViewController as! UINavigationController
            target.pushViewController(uv!, animated: true)
            self.revealViewController()?.revealToggle(self)
        } else if indexPath.row == 5 {
            let uv = self.storyboard?.instantiateViewController(identifier: "_Profile")
            self.present(uv!, animated: true) {
                self.revealViewController()?.revealToggle(self)
            }

        }

    }
}
