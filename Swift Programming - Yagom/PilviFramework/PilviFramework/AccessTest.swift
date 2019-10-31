//
//  AccessTest.swift
//  PilviFramework
//
//  Created by 이재은 on 30/10/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import Foundation

open class OpenClass {
    public init() {}
    open func openMethod() {}
    public func publicMethod() {}
    internal func internalMethod() {}
    fileprivate func fileprivateMethod() {}
    private func privateMethod() {}
}

public class PublicClass {
    public init() {}
    public func publicMethod() {}
}

internal class InternalClass {
    public init() {}
    internal func internalMethod() {}
}

fileprivate class FileprivateClass {
    public init() {}
    fileprivate func fileprivateMethod() {}
}

// 정의한 같은 소스 파일 내에서 접근 가능
// 하지만! 이 변수의 접근수준을 private이나 fileprivate으로 지정해야함
// Error! : Constant must be declared private or fileprivate because its type 'FileprivateClass' uses a fileprivate type
//let fpClass = FileprivateClass()
fileprivate let fpClass = FileprivateClass()

// 서브클래싱도 마찬가지
// 같은 모듈, 같은 소스 내에서 접근 가능하지만
// fileprivate이나 private을 지정해줘야함
fileprivate class FP: FileprivateClass {
    // 오버라이드는 접근수준을 지정하지 않아도 됨
    override func fileprivateMethod() {
        print("fpfp")
    }
}

private class PrivateClass {
    public init() {}
    private func privateMethod() {}
    private var name = "Pilvi"
}

private let pClass = PrivateClass()

extension PrivateClass {
    // Swift 4부터 같은 소스 파일내의 extension에서 private에 접근 가능
    func printMethod() {
        print(name)
    }
}

// 클래스 접근 수준을 fileprivate이나 private으로 지정하면 상속 가능
private class P: PrivateClass {

}

class Open: OpenClass {
    // 오버라이드는 불가능함
    override func fileprivateMethod() {

    }
}
