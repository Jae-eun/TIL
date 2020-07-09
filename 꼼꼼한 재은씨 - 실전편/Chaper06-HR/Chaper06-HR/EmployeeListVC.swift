//
//  EmployeeListVC.swift
//  Chaper06-HR
//
//  Created by 이재은 on 2020/07/05.
//  Copyright © 2020 Jaeeun. All rights reserved.
//

import UIKit

class EmployeeListVC: UITableViewController {
    var empList: [EmployeeVO]! // 데이터 소스를 저장할 멤버 변수
    var empDAO = EmployeeVO() // SQLite 처리를 담당할 DAO 객체
    
    override func viewDidLoad() {
        self.empList = self.empDAO.find()
        initUI()
    }
    
    func initUI() {
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = .systemFont(ofSize: 14)
        navTitle.text = "사원 목록 \n총 \(self.empList.count) 명"
        
        self.navigationItem.titleView = navTitle
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.empList.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowData = self.empList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EMP_CELL")
        
        cell?.textLabel?.text = "\(rowData.empName) (\(rowData.stateCd.desc()))"
        cell?.textLabel?.font = .systemFont(ofSize: 14)
        
        cell?.detailTextLabel?.text = rowData.departTitle
        cell?.detailTextLabel?.font = .systemFont(ofSize: 12)
        
        return cell!
    }
}
