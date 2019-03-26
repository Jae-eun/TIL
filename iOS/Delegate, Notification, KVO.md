# Delegate, Notification, KVO

* **Delegate**

  : 보통 Protocol을 정의하여 사용함

  : 객체는 어떤 이벤트가 일어났을 때 delegate로 지정한 객체에 알려줄 수 있음

  ** 장점

  : 매우 엄격한 Syntax로 인해 프로토콜에 필요한 메소드들이 명확하게 명시됨

  : 컴파일시 경고나 에러가 떠서 프로토콜의 구현되지 않은 메소드를 알려줌

  : 로직의 흐름을 따라가기 쉬움

  : 프로토콜 메소드로 알려주는 것뿐만이 아니라 정보를 받을 수 있음

  : 커뮤니케이션 과정을 유지하고 모니터링하는 제 3의 객체가 필요 없음

  : 프로토콜이 컨트롤러의 범위 안에서 정의됨

  ** 단점

  : 많은 줄의 코드가 필요

  : delegate 설정에 nil이 들어가지 않게 주의해야 함. 크래시를 일으킬 수 있음

  : 많은 객체들에게 이벤트를 알려주는 것이 어렵고 비효율적임



* Notification

  : Notification Center라는 싱글턴 객체를 통해서 이벤트들의 발생 여부를 옵저버를 등록한 객체들에게 post하는 방식으로 사용함.

  : Notification name이라는 key 값을 통해 보내고 받을 수 있음.

  ** 장점

  : 많은 줄의 코드가 필요 없이 쉽게 구현이 가능함

  : 다수의 객체들에게 동시에 이벤트 발생을 알려줄 수 있음

  : Notification과 관련된 정보를 Any? 타입의 object, [AnyHashable:Any]? 타입의 userInfo로 전달할 수 있음

  ** 단점

  : key 값으로 notification의 이름과 userInfo를 서로 맞추기 때문에 컴파일시 구독이 잘되고 있는지 올바르게 value를 받아오는지 체크가 불가능함.

  : 추적이 쉽지 않을 수 있음

  : Notification post 이후 정보를 받을 수 없음



* Key Value Observing

  : A 객체에서 B 객체의 프로퍼티가 변화됨을 감지할 수 있는 패턴

  : 메소드나 다른 액션에서 나타나는 것이 아니라 프로퍼티의 상태에 반응하는 형태

  ** 장점

  : 두 객체 사이의 정보를 맞춰주는 것이 쉬움

  : new / old value를 쉽게 얻을 수 있음

  : key path로 옵저빙하기 때문에 nested objects도 옵저빙이 가능

  ** 단점

  : NSObject를 상속 받는 객체에서만 사용이 가능

  : dealloc될 때 옵저버를 지워줘야 함

  : 많은 value를 감지할 때는 많은 조건문이 필요



** 여러 객체들이 동시에 어떤 이벤트를 받아 모두 반영해야 하는 경우 notification이 적절함































참고 : https://medium.com/@Alpaca_iOSStudy/delegation-notification-%EA%B7%B8%EB%A6%AC%EA%B3%A0-kvo-82de909bd29