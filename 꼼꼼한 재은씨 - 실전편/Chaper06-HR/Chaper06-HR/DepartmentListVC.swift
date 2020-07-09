//
//  DepartmentListVC.swift
//  Chaper06-HR
//
//  Created by 이재은 on 2020/07/05.
//  Copyright © 2020 Jaeeun. All rights reserved.
//

import UIKit

class DepartmentListVC: UITableViewController {
    var departList: [(departCd: Int, departTitle: String, departAddr: String)]! // 데이터 소스용 멤버 변수
    let departDAO = DepartmentDAO() // SQLite 처리를 담당할 DAO 객체
    
    override func viewDidLoad() {
        self.departList = self.departDAO.find() // 기존 저장된 부서 정보를 가져옴
        self.initUI()
    }
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "신규 부서 등록",
                                      message: "신규 부서를 등록해 주세요",
                                      preferredStyle: .alert)
        alert.addTextField() { (tf) in tf.placeholder = "부서명" }
        alert.addTextField() { (tf) in tf.placeholder = "주소" }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default) { (_) in
            let title = alert.textFields?[0].text
            let addr = alert.textFields?[1].text
            
            if self.departDAO.create(title: title!, addr: addr!) {
                self.departList = self.departDAO.find()
                self.tableView.reloadData()
                
                let navTitle = self.navigationItem.titleView as? UILabel
                navTitle.text = "부서 목록 \n총 \(self.departList.count) 개"
            }
        })
        self.present(alert, animated: false)
    }
    
    func initUI() {
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = .systemFont(ofSize: 14)
        navTitle.text = "부서 목록 \n총 \(self.departList.count) 개"
        
        self.navigationItem.titleView = navTitle
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        self.tableView.allowsSelectionDuringEditing = true
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.departList.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = self.departList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DEPART_CELL")
        
        cell?.textLabel.text = rowData.departTitle
        cell?.textLabel.font = .systemFont(ofSize: 14)
        
        cell?.detailTextLabel.text = rowData.departAddr
        cell?.detailTextLabel.font = .systemFont(ofSize: 12)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        let departCd = self.departList[indexPath.row].departCd
        
        if departDAO.remove(departCd: departCd) {
            self.departList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
