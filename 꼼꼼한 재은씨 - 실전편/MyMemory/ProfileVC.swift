//
//  ProfileVC.swift
//  MyMemory
//
//  Created by 이재은 on 25/05/2020.
//  Copyright © 2020 jaeeun. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    let profileImage = UIImageView()
    let tv = UITableView()

    override func viewDidLoad() {
        self.navigationItem.title = "프로필"
        let backBtn = UIBarButtonItem(title: "닫기",
                                      style: .plain,
                                      target: self,
                                      action: #selector(close(_:)))
        self.navigationItem.leftBarButtonItem = backBtn
    }

    @objc func close(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }


}

extension ProfileVC: UITableViewDelegate {

}
