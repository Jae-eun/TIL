# displayIfNeeded()

CALayer 클래스

**현재 업데이트가 필요한 것으로 표시된 경우, 레이어의 업데이트 프로세스를 시작합니다.**

필요에 따라 이 메소드를 호출하여 레이어의 내용을 표준 업데이트 주기 외로 강제 업데이트할 수 있습니다. 하지만 일반적으로 필요하지 않습니다.

가장 좋은 방법은 setNeedsDisplay()를 호출하고 다음 주기 동안 시스템이 레이어를 업데이트 하도록 하는 것입니다.



# Core Animation

**시각적 요소를 렌더링, 합성하고 애니메이션화합니다.**

CPU에 부담을 주지 않고, 앱 속도를 저하시키지 않으면서 높은 프레임 속도와 부드러운 애니메이션을 제공합니다. 

애니메이션의 각 프레임을 그리는데 필요한 대부분의 작업이 수행됩니다. 

시작 및 종료 지점과 같은 몇가지 애니메이션 매개변수를 구성하고 Core Animation이 시작하도록 지시합니다. 

Core Animation은 나머지 작업을 수행하여 렌더링 작업을 가속화하기 위해 대부분의 작업을 전용 그래픽 하드웨어에 넘깁니다. 



# CALayer

**이미지 기반 컨텐츠를 관리하고 해당 컨텐츠에 대한 애니메이션을 수행할 수 있게 해주는 객체입니다.**


