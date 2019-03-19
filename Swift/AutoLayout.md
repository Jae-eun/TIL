# AutoLayout

* **intrinsicContentSize** : 컨텐츠 고유 사이즈

  : 표시되는 내용이 변경될 때 이 값도 함께 변경된다.

  : 컨테이너 역할을 하는 일부 뷰들은 intrinsic size가 없다.

  

* **Constraint** : 제약 



* **Priority** : 우선순위
  - Required = 1000
  - DefaultHigh = 750
  - DefaultLow = 250



* **Constraint.isActive**

  - @IBOutlet var constraint: NSLayoutConstaint!

    : Strong으로 연결해야 비활성에서 활성화 가능

    

* **LayoutRelation**

  ```swift
  public enum NSLayoutRelation: Int {
      case lessThanOrEqual
      case equal
      case greaterThanOrEqual
  }
  ```

  

* **Content Hugging** : 최대 크기에 제한을 두는 것

  

* **Compression Resistance**

  





참고 : https://academy.realm.io/kr/posts/ios-autolayout/