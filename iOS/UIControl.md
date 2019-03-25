# UIControl

* 특정 액션이나 사용자의 의도를 전달하는 시각적인 요소들의 기반이 되는 클래스입니다. UIButton이 상속받습니다.
* Target-Action이라는 매커니즘을 이용해 사용자의 액션들을 앱에 전달합니다.
  - addTarget(_:action:for:) 메소드를 이용하여 구현
  - 파라미터로 액션을 담당할 객체, 액션에 대한 행위를 정의해준 메소드, 어느 액션(.touchUpInsider, .valueChanged 등)에 대해 해당 메소드를 호출할 것인지를 넘겨줌
* UIControl 클래스의 속성에는 **상태**라는 속성이 존재하는데 이 상태는 해당 뷰의 모습과 사용자의 액션에 대한 기능을 결정하는 역할을 한다. 









참고 : https://baked-corn.tistory.com/125

