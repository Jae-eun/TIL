# Method Swizzling

* 이미 정의된 메소드를 교체 실행하게 하는 방식
* methodA가 정의되어 있는데 A를 호출했을 때 서로 교체하며 B가 대신 호출되어 실행됨.
* Objective-C가 runtime언어이기 때문에 가능함



** 이미 정의된 iPhone SDK의 특정 메소드의 다른 실행을 원할 때

** 특정 기능이 추가적으로 실행되기를 원할 때

** 특정 기능을 해당 클래스의 자식 클래스를 포함해 모두 한번에 적용시킬 때



* +load 또는 +initialize에서 실행되어야 함.

  : 각각 클래스가 실행될 때 자동으로 호출됨.

  : +load는 클래스가 처음 로드될 때 실행

  : +initialize는 클래스나 클래스의 instance가 첫번째로 호출될 때 실행

* dispatch_once를 사용하여 단 한번만 실행되도록 해야함

  : +initialize는 여러번 호출됨