//
//  ViewController.swift
//  AccessControl
//
//  Created by 이재은 on 30/10/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit
import PilviFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // open과 public은 어떤 모듈이든 클래스와 클래스 멤버에 접근할 수 있음
        let openClass = OpenClass()
        let publicClass = PublicClass()

//        Error! 정의한 모듈 밖에서 접근 못함
//        let internalClass = InternalClass()
//        let fileprivateClass = FilePrivateClass()
//        let privateClass = PrivateClass()

        openClass.openMethod()
        openClass.publicMethod()
//        openClass.internalMethod() 접근 불가
//        openClass.fileprivateMethod() 접근 불가
//        openClass.privateMethod() 접근 불가
    }
}




// open은 모든 모듈에서 상속이 가능함
class SubClass: OpenClass {
    override func openMethod() {
        print("Yeah~~")
    }

    // public은 다른 모듈에서 오버라이드가 불가능함, 정의한 모듈 내에서만 가능함
// Error! : Overriding non-open instance method outside of its defining module
//    override func publicMethod() {
//        print("Yes~~")
//    }
}

// public은 다른 모듈에서 상속이 불가능함, 정의한 모듈 내에서만 가능함
// 나머지 internal, fileprivate, private도 마찬가지
// Error! : Cannot inherit from non-open class 'PublicClass' outside of its defining module
//class SubClass2: PublicClass {
//
//}
