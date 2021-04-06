# RxCocoa

* 애플 환경의 애플리케이션을 제작하기 위한 도구들을 모아놓은 **Cocoa Framework**를 **Reative Library**와 합친 기능을 제공하는 라이브러리
* UI Control 과 다른 SDK 클래스를 `wrapping` 한 커스텀 `extension set` 



## ObserverType과 ObservableType

* `ObserverType` : 값을 주입시킬 수 있는 타입
* `ObservableType` : 값을 관찰할 수 있는 타입 



## Binding 

* 데이터를 UI로 표시
* 



## Binder 

* UI 바인딩에 사용되는 특별한 옵저버
* 데이터 소비자 역할을 수행함. 
* 옵저버블이 아니기 때문에 구독자를 추가하는 것은 불가능함.
* `ObserverType`을 준수함. 따라서 값을 생성하고 주입할 수는 있으나 값을 관찰할 수는 없음.
* `Error` 이벤트를 방출할 수 없음.
* `RxCocoa`에서 `binding`은 `Publisher`에서 `Subscriber`로 향하는 단방향 `binding`임. 
* `bind(to: )` 메소드는 `subscribe()`의 별칭
  * `bind(to: oberver)` 를 호출하게 되면 `subscribe(observer)` 가 실행됨. 
* 메인 스레드에서 실행되는 것을 보장함.
  * `bind(to: )` 메소드는 메인 스레드 실행을 보장함. 

## Traits 

* UI 처리에 특화된 `Observable`  

> * UI 바인딩에서 데이터 생산자 역할을 수행함.
> * **메인 스케줄러, 메인 스레드에서 실행**됨. (스케줄러를 지정하지 않아도 됨.)
> * `Error` 이벤트를 전달하지 않음. 
> * 구독할 때, 새로운 시퀀스가 시작되는 것은 아님. 
> * `Traits`를 구독하는 모든 구독자는 동일한 시퀀스를 공유함. (일반 `Observable` 에서 `share` 연산자를 사용하는 것과 동일한 방식으로 동작함.)



> #### RxCocoa가 제공하는 Traits
>
> * `ControlProperty` : 컨트롤에 data를 바인딩하기 위해 사용함.
> * `ControlEvent` : 컨트롤의 이벤트를 수신하기 위해 사용함.
> * `Driver` : `error`를 방출하지 않고 메인 스레드에서 처리됨.
> * `Signal` : `Driver` 와 거의 동일하나 자원을 공유하지 않음.

> #### 특징 
>
> * `Signal` 을 제외한 나머지 Traits들을 자원을 공유함. 





## ControlProperty 

> * RxCocoa는 Extension으로 View를 확장하고, 동일한 이름을 가진 속성을 추가함. 이 속성들은 대부분 `ControlProperty` 형식으로 선언되어 있음. 
> * 제네릭 구조체로 선언되어 있으며, `ControlPropertyType` 프로토콜을 준수함.
>   *  `ControlPropertyType` 프로토콜은 `ObservableType` 과 `ObserverType` 프로토콜을 상속하고 있음. 
> * `ControlProperty` 가 읽기 전용 속성을 확장했다면 `Observable` 역할만 수행하고, 읽기/쓰기가 모두 가능하다면 `Observer` 의 역할도 함께 수행함.

* UI 바인딩에 사용되므로, 에러를 전달하거나 전달 받지 않음. 
* `Completed` 이벤트는 컨트롤이 제거되지 직전에 전달됨.
* 모든 이벤트는 메인 스케줄러에서 전달됨.
* 

* `Subject`와 같이 프로퍼티에 새 값을 주입시킬 수 있고, 값의 변화도 관찰할 수 있는 타입으로 

  







```swift

```

```swift

```





# Reactive

* 형식을 리액티브 방식으로 확장할 때 사용함. 

```swift
/**
 Use `Reactive` proxy as customization point for constrained protocol extensions.

 General pattern would be:
 // 1. Extend Reactive protocol with constrain on Base
 // Read as: Reactive Extension where Base is a SomeType
 extension Reactive where Base: SomeType {
 // 2. Put any specific reactive extension for SomeType here
 }

 With this approach we can have more specialized methods and properties using
 `Base` and not just specialized on common base type.
 */
public struct Reactive<Base> { // 제네릭 구조체로 선언되어 있음.
    /// Base object to extend.
    public let base: Base // 확장할 형식의 인스턴스를 저장

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

// 기존 형식에 rx라는 속성을 추가하는 역할. namespace를 추가하는 것과 같음.
/// A type that has reactive extensions.
public protocol ReactiveCompatible { 
    /// Extended type
    associatedtype ReactiveBase

    @available(*, deprecated, message: "Use `ReactiveBase` instead.")
    typealias CompatibleType = ReactiveBase

    /// Reactive extensions.
    static var rx: Reactive<ReactiveBase>.Type { get set }

    /// Reactive extensions.
    var rx: Reactive<ReactiveBase> { get set }
}

// 기본 구현을 추가하는 프로토콜 익스텐션
extension ReactiveCompatible {
    /// Reactive extensions. 타입 프로퍼티
    public static var rx: Reactive<Self>.Type {
        get {
            return Reactive<Self>.self
        }
        set {
            // this enables using Reactive to "mutate" base type
        }
    }

    /// Reactive extensions. 인스턴스 프로퍼티
    public var rx: Reactive<Self> {
        get {
            return Reactive(self)
        }
        set {
            // this enables using Reactive to "mutate" base object
        }
    }
}

import class Foundation.NSObject

// NSObject가 ReactiveCompatible 프로토콜을 채택하도록 선언
// NSObject는 Cocoa Framework의 모든 클래스가 상속하는 루트 클래스이므로, 모든 클래스에 rx라는 속성이 자동으로 추가됨. 
/// Extend NSObject with `rx` proxy.
extension NSObject: ReactiveCompatible { }
```



## UIButton + Rx

```swift
#if os(iOS)

import RxSwift
import UIKit

extension Reactive where Base: UIButton {
   // 구독할 수 있음. 버튼에서 touchUpInside 이벤트가 발생할 때마다 구독자에게 Next 이벤트가 전달됨.
    /// Reactive wrapper for `TouchUpInside` control event.
    public var tap: ControlEvent<Void> { // RxCocoa가 제공하는 Trait. UI 처리에 특화된 옵저버블.
        return controlEvent(.touchUpInside)
    }
}

#endif

#if os(iOS) || os(tvOS)

import RxSwift
import UIKit

extension Reactive where Base: UIButton {
    
    /// Reactive wrapper for `setTitle(_:for:)`
    public func title(for controlState: UIControl.State = []) -> Binder<String?> {
        return Binder(self.base) { button, title -> Void in
            button.setTitle(title, for: controlState)
        }
    }

    /// Reactive wrapper for `setImage(_:for:)`
    public func image(for controlState: UIControl.State = []) -> Binder<UIImage?> {
        return Binder(self.base) { button, image -> Void in
            button.setImage(image, for: controlState)
        }
    }

    /// Reactive wrapper for `setBackgroundImage(_:for:)`
    public func backgroundImage(for controlState: UIControl.State = []) -> Binder<UIImage?> {
        return Binder(self.base) { button, image -> Void in
            button.setBackgroundImage(image, for: controlState)
        }
    }
}
#endif

#if os(iOS) || os(tvOS)

    import RxSwift
    import UIKit
    
    extension Reactive where Base: UIButton {
        
        /// Reactive wrapper for `setAttributedTitle(_:controlState:)`
        public func attributedTitle(for controlState: UIControl.State = []) -> Binder<NSAttributedString?> {
            return Binder(self.base) { button, attributedTitle -> Void in
                button.setAttributedTitle(attributedTitle, for: controlState)
            }
        }
    }
#endif
```



## UILabel + Rx

```swift
#if os(iOS) || os(tvOS)

import RxSwift
import UIKit
// 속성들은 rx namespace에 추가됨
extension Reactive where Base: UILabel {
    /// Bindable sink for `text` property.
    public var text: Binder<String?> { // 인터페이스 바인딩에 사용하는 특별한 옵저버
        return Binder(self.base) { label, text in
            label.text = text
        }
    }

    /// Bindable sink for `attributedText` property.
    public var attributedText: Binder<NSAttributedString?> {
        return Binder(self.base) { label, text in
            label.attributedText = text
        }
    }    
}
#endif

//let label = UILabel() 
//label.rx.text 로 접근
```





## UITextField + Rx

```swift
#if os(iOS) || os(tvOS)

import RxSwift
import UIKit

extension Reactive where Base: UITextField {
    // text 속성이 변경될 때마다 Next 이벤트를 전달함.
    /// Reactive wrapper for `text` property.
    public var text: ControlProperty<String?> { // 데이터를 특정 UI에 바인딩할 때 사용하는 특별한 옵저버블
        return value
    }
    
    /// Reactive wrapper for `text` property.
    public var value: ControlProperty<String?> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { textField in
                textField.text
            },
            setter: { textField, value in
                // This check is important because setting text value always clears control state
                // including marked text selection which is imporant for proper input 
                // when IME input method is used.
                if textField.text != value {
                    textField.text = value
                }
            }
        )
    }
    
    /// Bindable sink for `attributedText` property.
    public var attributedText: ControlProperty<NSAttributedString?> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { textField in
                textField.attributedText
            },
            setter: { textField, value in
                // This check is important because setting text value always clears control state
                // including marked text selection which is imporant for proper input
                // when IME input method is used.
                if textField.attributedText != value {
                    textField.attributedText = value
                }
            }
        )
    }

    /// Bindable sink for `isSecureTextEntry` property.
    public var isSecureTextEntry: Binder<Bool> {
        return Binder(self.base) { textField, isSecureTextEntry in
            textField.isSecureTextEntry = isSecureTextEntry
        }
    }
}
#endif
```