# Any, AnyObject

* Any : 함수 타입을 포함하여 모든 타입의 인스턴스를 나타낼 수 있다.

  : 구조체로 구현된 값타입은 모두 넣을 수 있음.

  var anyArr: [Any] = [1, "hi", true, 1.0]

  

* AnyObject : 모든 클래스 타입의 인스턴스를 나타낼 수 있다.

  : 모든 클래스가 암시적으로 준수하는 프로토콜

  var anyObjectArr: [AnyObject] = [aType(), bType()]