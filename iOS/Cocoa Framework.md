# Cocoa framework

* 애플 환경에서 앱을 제작하기 위한 도구들의 모음
* UI, 하드웨어, 자료구조 등을 다루는데 필요한 많은 기능과 표준을 제공함.
* Cocoa는 여러 framework의 집합이며 Cocoa에 속하는 framework는 보통 가장 상위 레벨임.



1) Assets Library : 사용자의 사진과 비디오를 쿼리 기반 인터페이스로 접근함

2) AVFoundation : 오디오 / 비디오 컨텐츠에 대한 처리

3) Core Audio : C 언어 기반의 스테레오 오디오 관리 지원

4) Core Graphics : 쿼츠 2D 드로잉 API 포함. C 기반이지만 객체지향 추상화로 설계

5) Core Text : 텍스트 레이아웃과 폰트 처리를 위한 C 기반 인터페이스 제공

6) Core Video : 코어 비디오를 위한 버퍼와 버퍼풀 지원. 

7) Image I/O : 이미지 및 메타데이터 접근 인터페이스 제공

8) Media Player : 앱 내 포함된 오디오/비디오 재생의 고수준 인터페이스 지원. 아이튠즈 접근하여 미디어 관리 가능.

9) OpenAL - Open Audio Library. 오디오 재생을 위한 크로스 플랫폼 표준 인터페이스

10) OpenGL ES - 2D/3D를 그리는 도구 제공. C 기반으로 높은 프레임의 풀스크린 게임 스타일앱 제작에 사용됨. 하드웨어 성능에 영향을 많이 받음. EAGL 인터레이스와 결합하여 OpenGL 프레임워크를 사용.

11) Quartz Core : 코어 애니메이션 인터페이스 제공. 애니메이션 조합 및 비주얼 효과

12) MobileCoreService : 저수준 데이터 타입에 대한 고유 타입 식별자(UTI) 상수 제공. 앱이나 디바이스 사이에 데이터를 전송할 때 필요함.

13) SystmeConfiguration : 접근 및 사용 가능성을 판단하는 인터페이스 제공. (네트워크 구성을 결정하고 통신망, Wi-Fi 사용 여부 등을 판단)

14) Addressbook : 사용자 장치에 저장된 연락처 정보를 접근

15) QuickLook : 각종 문서 미리보기 기능 제공

16) StoreKit : 앱 내에서 추가 컨텐츠나 서비스를 구매할 수 있는 인터페이스 제공

17) EventKit : 캘린더 및 미리 알림에 접근할 수 있는 인터페이스

18) CFNetwork : C 기반의 네트워크 프로토콜을 사용하기 위한 객체 지향 추상화 제공

 * BSD 소켓 사용
 * SSL / TLS를 사용한 암호화된 연결 생성
 * DNS 호스트 리졸브
 * HTTP / FTP / 봉쥬르 서비스 통신

19) Foundation : 코어 파운데이션 프레임워크의 기능을 Objective-C로 래핑하여 제공함

* 데이터 컬렉션 / 번들 / 날짜 및 시간 연산 / 원시 데이터 블록 처리 / 환경 설정 관리 / URL 및 스트림 처리 / 스레드와 런루프 / 봉쥬르 / 통신 포트 관리 / 국제화 / 정규 표현식 매칭 / 캐쉬 지원 등

20) CoreTelephony : 사용 중인 전화망 서비스의 각종 정보를 얻는 인터페이스 제공

21) CoreMedia : AVFoundation이 사용하는 저수준 미디어 타입 제공

22) CoreMotion : 하드웨어로부터 움직임 데이터를 받고 처리할 수 있는 인터페이스 제공

23) CoreLocation : 장치의 현재 위도와 경도를 제공

24) CoreFoundation : C 기반으로 앱의 기본 데이터 관리와 서비스 기능을 제공

* 데이터 컬렉션 / 번들 / 문자열 연산 / 날짜 및 시간 연산 / 환경 설정 관리 / URL 및 스트림 처리 / 스레드 및 런루프 / 포트와 소켓 통신
* 파운데이션과 코어파운데이션을 혼합해서 써야 할 경우, 톨프리브릿징 기술을 사용하면 됨. 상호 데이터를 메서드/함수에 교환 가능하게 해주는 기술임.

25) CoreData : 모듈-뷰-컨트롤러 앱에서 데이터 모델을 관리하는 인터페이스 제공



참고 : http://blog.naver.com/PostView.nhn?blogId=sokm83&logNo=220970335220&parentCategoryNo=&categoryNo=12&viewDate=&isShowPopularPosts=false&from=section

