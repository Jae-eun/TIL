//
//  DepartPickerVC.swift
//  Chaper06-HR
//
//  Created by 이재은 on 2020/07/06.
//  Copyright © 2020 Jaeeun. All rights reserved.
//

import UIKit

class DepartPickerVC: UIViewController, UIPickerViewDataSource, UIDocumentPickerDelegate {
      
    let departDAO = DepartmentDAO()
    var departList: [(departCd: Int, departTitle: String, departAddr: String)]! // 피커뷰의 데이터 소스
    var pickerView: UIPickerView!
    var selectedDepartCd: Int {
        let row = self.pickerView.selectedRow(inComponent: 0)
        return self.departList[row].departCd
    }
    
    override func viewDidLoad() {
        // DB에서 부서 목록을 가져와 튜플 배열을 초기화
        self.departList = self.departDAO.find()
        
        self.pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.view.addSubview(self.pickerView)
        
        let pWidth = self.pickerView.frame.width
        let pHeight = self.pickerView.frame.height
        self.preferredContentSize = CGSize(width: pWidth, height: pHeight)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return self.departList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var titleView = view as? UILabel
        if titleView == nil {
            titleView = UILabel()
            titleView.font = .systemFont(ofSize: 14)
            titleView?.textAlignment = .center
        }
        
        titleView.text = "\(self.departList[row].departTitle) (\(self.departList[row].departAddr))"
        
        return titleView!
    }
}
