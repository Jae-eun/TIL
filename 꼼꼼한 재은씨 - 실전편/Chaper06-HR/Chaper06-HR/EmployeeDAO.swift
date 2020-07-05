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
