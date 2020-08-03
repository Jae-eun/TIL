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
        empList = empDAO.find()
        initUI()
    }
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "사원 등록",
                                      message: "등록할 사원 정보를 입력해 주세요",
                                      preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "사원명"
        }
        
        // contentViewController 영역에 부서 선택 피커 뷰 삽입
        let pickerVc = DepartPickerVC
        alert.setValue(pickerVc, forKey: "contentViewController")
        
        // 등록창 버튼 처리
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default) { (UIAlertAction) in
            
            // 1. 알림창의 입력 필드에서 값을 읽어온다
            var param = EmployeeVO()
            param.departCd = pickerVc.selectedDepartCd
            param.empName = (alert.textFields?[0].text)!
            
            // 2. 가입일은 오늘
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            param.joinDate = df.string(from: Date())
            
            // 3. 재직 상태는 재직중
            param.stateCd = EmpStateType.ING
            
            // 4. DB 처리
            if empDAO.create(param: param) {
                // 결과가 성공이면 데이터를 다시 읽어 테이블뷰를 갱신함
                empList = empDAO.find()
                tableView.reloadData()
            }
            // 네비게이션 타이틀을 갱신함
            if let navTitle = navigationItem.titleView as? UILabel {
                navTitle.text = "사원목록 \n 총 \(empList.count) 명"
            }
        })
        present(alert, animated: false)
    }
    
    @IBAction func editing(_ sender: Any) {
        if isEditing == false {
            setEditing(true, animated: true)
            (sender as? UIBarButtonItem)?.title = "Done"
        } else {
            setEditing(false, animated: true)
            (sender as? UIBarButtonItem)?.title = "Edit"
        }
    }

    func initUI() {
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = .systemFont(ofSize: 14)
        navTitle.text = "사원 목록 \n총 \(self.empList.count) 명"

        navigationItem.titleView = navTitle

        // 당겨서 새로고침 기능
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)

    }

//    @objc func pullToRefresh{_ sender: Any) { // 새로고침 시 갱신되어야 할 내용들
//    self.empL丄st = self.empDAO.find()
//    s e lf.tableView.reloadData()
//    // 당겨서 Ad로고U 가능 종료
//    self. ref reshControl?.endRefresh丄ng()

    @objc func pullToRefresh(_ sender: Any) {
        empList = empDAO.find()
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return empList.count
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
    
    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        // 1. 삭제할 행의 empCd를 구함
        let empCd = empList[indexPath.row].empCd
        
        // 2. DB, 데이터소스, 테이블뷰에서 차례대로 삭제
        if empDAO.remove(empCd: empCd) {
            empList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
