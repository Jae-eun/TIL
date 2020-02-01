//
//  ListViewController.swift
//  iOSstudy_ch8_TableCellHeight_20191223
//
//  Created by 이재은 on 23/12/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    var list = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableView.automaticDimension
    }

    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "목록 입력", message: "추가될 글을 작성해주세요", preferredStyle: .alert)
        alert.addTextField() { (tf) in
            tf.placeholder = "내용을 입력하세요"
        }

        let ok = UIAlertAction(title: "OK", style: .default) { (_) in
            if let title = alert.textFields?[0].text {
                self.list.append(title)
                self.tableView.reloadData()
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(ok)
        alert.addAction(cancel)

        self.present(alert, animated: false)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = list[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {

        let row = self.list[indexPath.row]
        let height = CGFloat(60 + (row.count / 30) * 20)
        return height
    }
}
