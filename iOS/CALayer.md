# CALayer

* UIView에서 렌더링, 레이아웃, 애니메이션 등을 관리하는 코어 애니메이션 클래스이다. 화면에 대한 특성만 갖고 있다.
* UIView는 CALayer 객체인 layer 프로퍼티를 가지고 있다.
  * layer는 뒷단 레이어, view hierarchy의 개념과 유사하게 layer tree라는 구조가 있다.
* shadow, rounded corner, colored border나 3D transform, masking contents, animation을 할 수 있는 기능들을 제공해줍니다.
  * QuartzCore.framework를 추가해주어야 함.
  * CALayer의 backgroundColor 속성은 CGColorRef 타입이며, Core Graphic 메소드를 사용하여 CGColor를 만들어 적용시킬 수 있음.
  * Content 프로퍼티 속성이 있음. 이 속성에 CGImage나 NSImage를 할당하여 이미지를 보이도록 할 수 있음
  * 뷰의 contentMode 속성을 통해서 이미지의 크기나 위치를 변경할 수 있음. CALayer에는 contentsGravity가 있음
  * 원하는 뷰의 크기를 벗어나지 않게 하려면 UIView에서는 clipsToBounds라는 속성을 사용함. CALayer에서는 masksToBounds라는 속성을 사용함. 이 값을 true로 하면 위에 이미지에서 외각 부분이 보이지 않음.