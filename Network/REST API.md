# Rest API 

**REpresentational State Transfer**

: Resource Oriented Architecture, ROA를 따르는 웹 서비스 아키텍처

: HTTP URI + HTTP Method, HTTP URI로 대상 자원을 명시하고 HTTP Method로 해당 자원에 대한 행위를 지정하는 방식으로 동작함



**<REST 구성 요소>**

* 리소스 : 자원을 정의

* 메서드 : 자원에 대한 행위

* 표현 : 자원에 대한 행위의 내용을 정의, 일반적으로 JSON 문서를 이용해 표현되는 데이터

  

**<HTTP 메서드>**

* POST (Create)

  : URI의 리소스 생성

  : 다른 메서드들과는 달리 POST에는 URI에 리소스 ID가 없다는 점을 주의

* GET (Read)

  : URI의 리소스 조회

* PUT (Update)

  : URI의 리소스 수정

  : PATCH 메서드가 사용되기도 함(일부를 변경하는 의미를 지님)

  : 해당 자원의 전체를 교체하는 의미를 지님

* Delete

  : URI의 리소스 삭제



** POST 메서드 외에는 모두 idempotent함. (반복적으로 수행했을 때 결과가 같음) (GET의 경우에도 조회수를 늘려주는 등의 기능을 수행한다면 idempotent하지 않다고 봐야 함)

REST API를 호출하다 실패했을 경우, 트랜잭션 복구를 위해 다시 실행해주어야 할 경우가 있는데 idempotent 하지 않은 메서드들은 기존 값을 저장해두었다가 다시 원복해주어야 하는 문제가 있음



**<REST 특성>**

* 유니폼 인터페이스 (Uniform interface)

  : HTTP 표준에만 따른다면, 어떠한 기술이든 적용 가능하여 모든 플랫폼에 사용할 수 있는 느슨한 결합(Loosely coupling) 형태의 구조

* 무상태성 (Stateless)

  : 클라이언트의 컨텍스트를 서버 쪽에 유지하지 않음 (HTTP Session과 같은 컨텍스트 저장소에 상태 정보를 저장하지 않는 형태)

  : 상태 정보를 저장하지 않으면 각 API 서버는 들어오는 요청만을 들어오는 메시지로만 처리하면 되며, 세션과 같은 컨텍스트 정보를 신경쓸 필요가 없기 때문에 구현이 단순해짐

* 캐싱 가능 (Cacheable)

  : 웹에서 사용하는 기존의 인프라를 그대로 활용 가능.

  : Last-Modified 태그나 E-Tag를 이용해 구현 가능

  : 네트워크 응답시간을 단축시킬 수 있음

  : REST 컴포넌트가 위치한 서버에 트랜잭션을 발생시키지 않으므로 전체 응답시간과 성능, 서버의 자원 사용률을 향상시킬 수 있음

* 자체 표현 구조 (Self-Descriptiveness)

  : API 메시지만 보고도 이해할 수 있음

* 클라이언트 - 서버 구조

  : REST 서버는 API 제공 및 API를 이용해 비즈니스 로직 처리 및 저장을 책임짐

  : 클라이언트는 사용자 인증이나 컨텍스트(세션, 로그인 정보 등)를 직접 관리하고 책임지는 구조

  : 역할이 구분되면서 개발 관점에서 클라이언트와 서버에서 개발해야 할 내용들이 명확해지고 서로 간의 의존성이 줄어들게 됨.

* 계층형 구조 (Layered System)

  : 클라이언트 입장에서는 Rest API 서버만 호출하지만 서버는 다중 계층으로 구성될 수 있음

  : 순수 비즈니스 로직을 수행하는 API 서버와 그 앞단에 사용자 인증, 암호화(SSL), 로드 밸런싱 등을 하는 계층을 추가해서 구조 상의 유연성을 둘 수 있음.

  





참고 : http://blog.naver.com/PostView.nhn?blogId=itperson&logNo=220844559492&parentCategoryNo=&categoryNo=50&viewDate=&isShowPopularPosts=false&from=postView