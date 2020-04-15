//
//  ViewController.swift
//  Chapter02-inputForm
//
//  Created by 이재은 on 2020/04/10.
//  Copyright © 2020 이재은. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var paramEmail: UITextField!
    var paramUpdate: UISwitch!
    var paramInterval: UIStepper!
    var txtUpdate: UILabel!
    var txtInterval: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        printFontsName()
    }
    
    private func setUI() {
        self.navigationItem.title = "설정"
        let lblEmail = UILabel()
        lblEmail.frame = CGRect(x: 30, y: 100, width: 100, height: 30)
        lblEmail.text = "이메일"
        lblEmail.font = UIFont(name: "SDMiSaeng", size: 21) //.boldSystemFont(ofSize: 14)
        self.view.addSubview(lblEmail)
        
        let lblUpdate = UILabel()
        lblUpdate.frame = CGRect(x: lblEmail.frame.origin.x, y: 150, width: 100, height: 30)
        lblUpdate.text = "자동갱신"
        lblUpdate.font = .systemFont(ofSize: 14)
        self.view.addSubview(lblUpdate)
        
        let lblInterval = UILabel()
        lblInterval.frame = CGRect(x: lblEmail.frame.origin.x, y: 200, width: 100, height: 30)
        lblInterval.text = "갱신주기"
        lblInterval.font = .systemFont(ofSize: 14)
        self.view.addSubview(lblInterval)
        
        self.paramEmail = UITextField()
        self.paramEmail.frame = CGRect(x: 120, y: 100, width: 220, height: 30)
        self.paramEmail.font = .systemFont(ofSize: 13)
        self.paramEmail.borderStyle = .roundedRect
        paramEmail.adjustsFontSizeToFitWidth = true
        paramEmail.placeholder = "이메일 ex) abc@gmail.com"
        self.view.addSubview(self.paramEmail)
        self.paramEmail.autocapitalizationType = .none
        
        self.paramUpdate = UISwitch()
        self.paramUpdate.frame = CGRect(x: 120, y: 150, width: 50, height: 30)
        self.paramUpdate.setOn(true, animated: true)
        self.view.addSubview(self.paramUpdate)
        self.paramUpdate.addTarget(self, action: #selector(presentUpdateValue(_:)), for: .valueChanged)
        
        self.paramInterval = UIStepper()
        self.paramInterval.frame = CGRect(x: 120, y: 200, width: 50, height: 30)
        self.paramInterval.minimumValue = 0
        self.paramInterval.maximumValue = 100
        self.paramInterval.stepValue = 1
        self.paramInterval.value = 0
        self.view.addSubview(self.paramInterval)
        self.paramInterval.addTarget(self, action: #selector(presentIntervalValue(_:)), for: .valueChanged)
        
        self.txtUpdate = UILabel()
        self.txtUpdate.frame = CGRect(x: 250, y: 150, width: 100, height: 30)
        self.txtUpdate.font = .systemFont(ofSize: 12)
        self.txtUpdate.textColor = .red
        self.txtUpdate.text = "갱신함"
        self.view.addSubview(self.txtUpdate)
        
        self.txtInterval = UILabel()
        self.txtInterval.frame = CGRect(x: 250, y: 200, width: 100, height: 30)
        self.txtInterval.font = .systemFont(ofSize: 12)
        self.txtInterval.textColor = .red
        self.txtInterval.text = "0분마다"
        self.view.addSubview(self.txtInterval)
        
        let submibBtn = UIBarButtonItem(barButtonSystemItem: .compose,
                                        target: self,
                                        action: #selector(submit(_:)))
        self.navigationItem.rightBarButtonItem = submibBtn
    }
    
    @objc func presentUpdateValue(_ sender: UISwitch) {
        self.txtUpdate.text = sender.isOn ? "갱신함" : "갱신하지 않음"
    }
    
    @objc func presentIntervalValue(_ sender: UIStepper) {
        self.txtInterval.text = ("\(Int(sender.value))분마다")
    }
    
    @objc func submit(_ sender: Any) {
        let rvc = ReadViewController()
        rvc.pEmail = self.paramEmail.text
        rvc.pUpdate = self.paramUpdate.isOn
        rvc.pInterval = self.paramInterval.value
        
        self.navigationController?.pushViewController(rvc, animated: true)
    }
    
    private func printFontsName() {
        for family in UIFont.familyNames {
            print("\(family)")
            
            for names in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)") // Post Script Name
            }
        }
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16),
                       green: CGFloat(rgbValue & 0x00FF00),
                       blue: CGFloat(rgbValue & 0x0000FF),
                       alpha: CGFloat(1.0))
    }
    // 사용 : let color = UIColorFromRGB(rgbValue: 0xDFDFDF)
}

