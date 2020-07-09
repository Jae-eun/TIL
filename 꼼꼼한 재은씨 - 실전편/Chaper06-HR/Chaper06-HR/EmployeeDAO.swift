//
//  EmployeeDAO.swift
//  Chaper06-HR
//
//  Created by 이재은 on 2020/07/05.
//  Copyright © 2020 Jaeeun. All rights reserved.
//

import Foundation

enum EmpStateType: Int {
    case ING = 0, STOP, OUT

    func desc() -> String {
        switch self {
        case .ING:
            return "재직중"
        case .STOP:
            return "휴직"
        case .OUT:
            return "퇴사"
        }
    }
}

struct EmployeeVO {
    var empCd = 0 // 사원 코드
    var empName = 0 // 사원명
    var joinDate = 0 // 입사일
    var stateCd = EmpStateType.ING // 재직 상태(기본값: 재직중)
    var departCd = 0 // 소속 부서 코드
    var departTitle = "" // 소속 부서명
}

class EmployeeDAO {
    // FMDatabase 객체 생성 및 초기화
    lazy var fmdb: FMDatabase! = {
        // 1. 파일 매니저 객체를 생성
        let fileMgr = FileManager.default

        // 2. 샌드박스 내 문서 디렉터리 경로에서 데이터베이스 파일을 읽어옴
        let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbPath = docPath!.appendPathComponent("hr.sqlite").path

        // 3. 샌드박스 경로에 hr.sqlite 파일이 없다면 메인 번들에 만들어 둔 파일을 가져와 복사
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "hr", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }

        // 4. 준비된 데이터베이스 파일을 바탕으로 FMDatabase 객체를 생성
        let db = FMDatabase(path: dbPath)
        return db
    }()

    init() {
        self.fmdb.open()
    }

    deinit {
        self.fmdb.close()
    }

    func find() -> [EmployeeVO] {
        var employeeList = [EmployeeVO]()

        do {
            let sql = """
                SELECT emp_cd, emp_name, join_date, state_cd, department.depart_title
                FROM employee
                JOIN department On department.depart_cd = employee.depart_cd
            """

            let rs = try self.fmdb.executeQuery(sql, values: nil)

            while rs.next() {
                var record = EmployeeVO()

                record.empCd = Int(rs.int(forColumn: "emp_cd"))
                record.empName = rs.string(forColumn: "emp_name")!
                record.joinDate = rs.string(forColumn: "join_date")!
                record.departTitle = rs.string(forColumn: "depart_title")!

                let cd = Int(rs.int(forColumn: "state_cd")) // DB에서 읽어온 state_cd 값
                record.stateCd = EmpStateType(rawValue: cd)!

                employeeList.append(record)
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        return employeeList
    }

    // 단일 사원 레코드를 읽어옴
    func get(empCd: Int) -> EmployeeVO? {
        // 1. 질의 실행
        let sql = """
            SELECT emp_cd, emp_name, join_date, state_cd, department.depart_title
            FROM employee
            JOIN department On department.depart_cd = employee.depart_cd
            WHERE emp_cd = ?
        """

        let rs = self.fmdb.executeQuery(sql, withArgumentsIn: [empCd])

        // 결과 집합 처리
        if let _rs = rs {
            _rs.next()

            var record = EmployeeVO()
            record.empCd = Int(_rs.int(forColumn: "emp_cd"))
            record.empName = _rs.string(forColumn: "emp_name")!
            record.joinDate = _rs.string(forColumn: "join_date")!
            record.departTitle = _rs.string(forColumn: "depart_title")!

            let cd = Int(_rs.int(forColumn: "state_cd"))
            record.stateCd = EmpStateType(rawValue: cd)!

            return record
        } else {
            return nil
        }
    }

    // 신규 사원 정보 추가
    func create(param: EmployeeVO) -> Bool {
        do {
            let sql = """
                INSERT INTO employee (emp_name, join_date, state_cd, depart_cd)
                VALUES ( ? , ? , ? , ? , ? )
            """

            // Prepared Satement를 위한 인자값
            var params = [Any]()
            params.append(param.empName)
            params.append(param.joinDate)
            params.append(param.stateCd.rawValue)
            params.append(param.departCd)

            try self.fmdb.executeUpdate(sql, values: params)

            return true
        } catch let error as NSError {
            print("Insert Error : \(error.localizedDescription)")
            return false
        }
    }

    // 사원 정보 삭제
    func remove(empCd: Int) -> Bool {
        do {
            let sql = "DELETE FROM employee WHERE emp_cd = ? "
            try self.fmdb.executeUpdate(sql, values: [empCd])
            return true
        } catch let error as NSError {
            print("Insert Error : \(error.localizedDescription)")
            return false
        }
    }
}
