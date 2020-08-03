//
//  DepartmentInfoVC.swift
//  Chaper06-HR
//
//  Created by 이재은 on 2020/08/03.
//  Copyright © 2020 Jaeeun. All rights reserved.
//

import UIKit

class DepartmentInfoVC: UITableViewController {
    
    // 부서 정보를 저장할 데이터 타입
    typealias DepartRecord = (departCd: Int, departTitle: String, departAddr: String)
    
    // 부서 목록으로부터 넘겨 받을 부서 코드
    var departCd: Int!
    
    // DAO 객체
    let departDAO = DepartmentDAO()
    let empDAO = EmployeeDAO()
    
    var departInfo: DepartRecord!
    var empList: [EmployeeVO]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        departInfo = departDAO.get(departCd: departCd)
        empList = empDAO.find(departCd: departCd)
        
        navigationItem.title = "\(departInfo.departTitle)"
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        // 1. 헤더에 들어갈 레이블 객체 정의
        let textHeader = UILabel(frame: CGRect(x: 35, y: 5, width: 200, height: 30))
        textHeader.font = .systemFont(ofSize: 15, weight: 2.5)
        textHeader.textColor = UIColor(red: 0.03, green: 0.28, blue: 0.71, alpha: 1)
        
        // 2. 헤더에 들어갈 이미지뷰 객체 정의
        let icon = UIImageView()
        icon.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        
        // 3. 섹션에 따라 타이틀과 이미지 다르게 설정
        if section == 0 {
            textHeader.text = "부서 정보"
            icon.image = UIImage(imageLiteralResourceName: "depart")
        } else {
            textHeader.text = "소속 사원"
            icon.image = UIImage(imageLiteralResourceName: "employee")
        }
        
        // 4. 레이블과 이미지뷰를 담을 컨테이너용 뷰 객체 정의
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        v.backgroundColor = UIColor(red: 0.93, green: 0.96, blue: 0.99, alpha: 1)
        
        // 5. 뷰에 레이블과 이미지뷰 추가
        v.addSubview(textHeader)
        v.addSubview(icon)
        
        return v
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return empList.count
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DEPART_CELL")
            
            cell?.textLabel?.font = .systemFont(ofSize: 13)
            cell?.detailTextLabel?.font = .systemFont(ofSize: 12)
            
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "부서 코드"
                cell?.detailTextLabel.text = "\(departInfo.departCd)"
                
            case 1:
                cell?.textLabel?.text = "부서명"
                cell?.detailTextLabel.text = departInfo.departTitle
                
            case 2:
                cell?.textLabel?.text = "부서 주소"
                cell?.detailTextLabel.text = departInfo.departAddr
            default:
                () // 작성할 구문이 없을 때 넣어주는 더미 코드
            }
            return cell!
        } else {
            let row = empList[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EMP_CELL")
            
            cell?.textLabel?.font = .systemFont(ofSize: 12)
            cell?.textLabel?.text = "\(row.empName) (입사일: \(row.joinDate))"
            
            // 재직 상태를 나타내는 세그먼트 컨트롤
            let state = UISegmentedControl(items: ["재직중", "휴직", "퇴사"])
            state.frame.origin.x = view.frame.width - state.frame.width - 10
            state.frame.origin.y = 10
            state.selectedSegmentIndex = row.stateCd.rawValue // DB에 저장된 상태값으로 설정
            
            state.tag = row.empCd // 액션 메소드에서 참조할 수 있도록 사원 코드를 저장
            state.addTarget(self, action: #selector(changeState(_:)), for: .valueChanged)
            
            cell?.contentView.addSubview(state)
            return cell!
        }
    }
    
    @objc func changeState(_ sender: UISegmentedControl) {
        let empCd = sender.tag // 사원 코드
        let stateCd = EmpStateType(rawValue: sender.selectedSegmentIndex) // 재직 상태
        
        // 재직 상태 업데이트
        if empDAO.editState(empCd: empCd, stateCd: stateCd!) {
            let alert = UIAlertController(title: nil, message: "재직 상태가 변경되었습니다", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: false)
        }
    }
    
}
