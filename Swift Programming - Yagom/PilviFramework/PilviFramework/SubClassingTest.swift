//
//  SubClassingTest.swift
//  PilviFramework
//
//  Created by 이재은 on 30/10/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import Foundation

class A: OpenClass {
    // 모든 모듈 내부에서 오버라이드 가능
    override func openMethod() {
        print("openopen")
    }
    // 정의된 모듈 내부에서는 오버라이드 가능
    // internal, fileprivate, private 마찬가지
    override func publicMethod() {
        print("publicpublic")
    }
}

class B: PublicClass {

    // 정의된 모듈 내부에서 오버라이드 가능
    // internal, fileprivate, private 마찬가지
    override func publicMethod() {
        print("publicpubli")
    }
}

// 같은 모듈이면 다른 소스파일이어도 접근 가능
class C: InternalClass {
    override func internalMethod() {
        print("inin")
    }
}

// 같은 모듈이어도 다른 소스파일이면 접근 불가
//class D: FileprivateClass {
//
//}
//let fpClass = FileprivateClass()


