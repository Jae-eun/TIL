# Object-Oriented Programming (객체지향 프로그래밍)

**1. 추상화 (Abstraction)**

: 대상의 특성 중 불필요한 부분을 무시하고 필요한 공통점만을 다루어, 현실의 복잡성을 극복하고 목적에 집중할 수 있도록 하는 것

* 복잡성을 다루기 위한 추상화의 2가지 차원

  1) 사물들 간의 공통점은 취하고 차이점은 버리는 일반화를 통한 단순화

  2) 중요한 부분의 강조를 위해 불필요한 세부 사항을 제거하는 단순화

* 추상화는 문제 영역과 관점에 의존적이므로 어떤 영역에서는 중요한 속성이 다른 영역에서는 그렇지 않을 수 있다. 원하는 목적이나 기능에 따라 추상화 모델은 서로 다를 수 있다.



**2. 캡슐화 (Encapsulation)**

: 객체 스스로가 자신의 상태를 책임지게 하여, 해당 객체의 역할 수행에 집중할 수 있도록 자율성을 높이는 것

* 캡슐화의 2가지 관점

  1) 상태와 행위의 캡슐화(데이터 캡슐화) : 객체는 상태와 행동을 하나의 단위로 묶는 자율적 실체

  2) 사적인 비밀의 캡슐화(은닉화) : 외부에서 객체의 상태를 마음대로 변경할 수 없도록 보호

* 외부 객체가 메시지를 보냈을 때, 실제 내부에서 상태가 어떻게 바뀌고 어떤 행동을 하는지 스스로만 알 뿐 외부로 노출하지 않으며, 그 자신의 상태는 스스로만 변경할 수 있도록 함. 요청자는 무엇을 요청하는지만 전달하며, 수신자는 어떻게 처리할지를 결정하면 됨.



**3. 상속성 (Inheritance)**

: 부모 클래스의 속성과 기능을 상속 받아 동일하게 사용하는 것

* 새로운 클래스는 상속을 통해 부모 클래스의 속성과 기능을 물려 받음.
* 범용적인 클래스를 작성한 뒤 상속을 활용하면, 여러 클래스에서 중복되는 속성과 기능을 반복적으로 구현하지 않아도 쉽게 적용할 수 있음.



**4. 다형성 (Polymorphism)**

: 동일 요청에 대해 서로 다른 방식으로 응답할 수 있도록 만드는 것

* 동일한 요청이 들어왔을 때, 그것을 구현하는 방법에 차이를 두어 다른 결과를 만들어내는 것을 말함.
* 메서드 오버라이딩과 오버로딩이라는 형태로 지원함.
* 오버라이딩 : 상위 클래스에게 상속 받은 동일한 메서드 재정의
* 오버로딩 : 동일한 메소드가 매개변수의 차이에 따라 다르게 동작





참고 : http://blog.naver.com/PostView.nhn?blogId=itperson&logNo=220817680631&parentCategoryNo=&categoryNo=50&viewDate=&isShowPopularPosts=false&from=postView























