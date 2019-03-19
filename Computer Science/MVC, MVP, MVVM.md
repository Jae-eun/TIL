# MVC

**Model-View-Controller**

: View는 상태에 따라 출력 형식만 달라짐

: 모든 이벤트에 대한 제어나 가공은 Controller에 의해 처리됨

: Controller는 처리해야 할 이벤트에 대하여 Model을 조작하고 그 변경 사항을 표현할 View를 선택함

: Controller는 View를 선택만 할 뿐, 직접적인 업데이트는 하지 않음

: View는 Controller에서 어떤 동작이 수행되는지 알지 못함

: View의 업데이트 방법

1) View 가 Model을 직접 사용하여 업데이트

2) Model에서 View에게 Notify

3) View가 polling을 통해 Model의 변화를 알아채고 스스로 업데이트 하는 방법

=> Model을 참조해야 해서 View - Model 간 의존성이 생김

** 장점 : 구현이 가장 간단함

** 단점 : View와 Model 간의 의존성을 완전히 없앨 수 없음

​	     : 프로그램이 커질수록 가독성이 떨어지고 유지보수가 힘들어짐



# MVP

**Model-View-Presenter**

: MVC에서 파생됨

: Model과 View 간의 의존성 문제를 해결하기 위해 설계됨.

: Presenter는 모델을 조작한 결과를 다시 돌려받아서 직접 View를 업데이트함

: Model과 View의 연결고리는 Presenter를 통해서만 이루어짐

: Presenter는 View와 1:1 관계를 가지고 있어 의존성이 크고 밀접한 관계를 지니므로 Model보다 View와 닮은 구조로 디자인 됨.

** 장점 : Model과 View의 의존성이 완전히 사라짐

​	     : Model은 Presenter의 요청만 수행하면 됨

** 단점 : Presenter와 View 간의 의존성이 큼

​	     : MVC에 비해 필요한 Class 수가 증가함



# MVVM

**Model-View-ViewModel**

: MVC에서 파생됨

: Model과 View 사이 뿐만 아니라 View와 Controller 간의 의존성도 고려해 각 단위가 독립적으로 작성되고 테스트 될 수 있도록 설계된 패턴

: ViewModel은 View와 1:n 관계를 이루며 독립적이도록 만들어짐

: View를 참조하지 않으므로 Model의 구조와 비슷함

: ViewModel은 View를 나타내주기 위한 Model이자 Presentation Logic을 처리하는 역할

: Model을 베이스로 하여 Presentation Logic에 따라 서로 다르게 구현됨

: View에 어떤 View Model을 연결하느냐에 따라 로직 처리가 달라짐

: Model이 변경되면 관련된 ViewModel을 사용하는 View가 자동으로 업데이트 됨

: 각각의 View는 자신이 사용할 ViewModel을 선택하여 바인딩하고 업데이트 받게 됨

: View 클래스는 단순히 사용자 인터페이스를 표시하기 위한 로직만을 담당함

: 일부 사용자 인터페이스를 제외하면 오로지 메소드를 호출하는 생성자만 존재하게 하는 것이 가장 이상적인 형태

: View와 ViewModel 간에는 Command와 Data Binding을 이용함

: 커맨드를 통해 behavior를 ViewModel에서 정의한 특정 View의 액션과 연결할 수 있음

: 데이터 바인딩을 통해 어떤 View의 속성과 ViewModel의 속성을 연결한 뒤 ViewModel 속성이 변경되면 자동으로 View를 업데이트 함

** 장점 : View가 Model이나 ViewModel과 의존성 없이 독립적

​	     : 반복되는 이벤트 핸들러와 비즈니스 로직을 캡슐화하여 관리할 수 있어서 재사용성이 좋음

** 단점 : ViewModel 설계하는 것이 쉽지 않음

​	     : View에 대한 처리가 복잡해질수록 ViewModel에 거대해지게 되어 오버스펙이 될 수 있음

​	     : 플랫폼 제한적인 요소가 있음



# Clean Architecture

**1. 프레임워크에 독립적**

아키텍처는 라이브러리 / 프레임워크의 존재여부에 의존하면 안된다.



**2. 테스트 용이성**

비즈니스 룰은 UI, DB, WebServer 또는 다른 외부 요소와 상관 없이 테스트 가능해야 한다.



**3. UI에 독립적**

시스템의 다른 부분을 변경하지 않으면서 UI를 쉽게 변경할 수 있어야 한다.



**4. Database에 독립적**

현재 사용하는 DB를 다른 DB 환경으로 바꿔도 영향이 없어야 한다.



**5. 다른 외부 요소들에 독립적**

비즈니스 룰은 외부 세계에 대해 아무 것도 몰라도 된다.











참고 : http://blog.naver.com/PostView.nhn?blogId=itperson&logNo=220840607398&parentCategoryNo=&categoryNo=50&viewDate=&isShowPopularPosts=false&from=postView

