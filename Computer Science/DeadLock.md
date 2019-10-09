# DeadLock 교착상태

* 한정된 자원을 여러 프로세스가 동시에 사용하고자 할 때, 서로 원하는 자원을 얻지 못하고 계속 상대방의 작업이 끝나기만을 기다리게 되는 상황



**<데드락 발생 조건>**

1. 상호 배제(Mutual Exclusion)

   : 자원은 한 번에 한 프로세스만 사용할 수 있어야 한다.

2. 점유 대기(Hold and Wait)

   : 최소한 하나의 자원을 점유하고 있으면서 다른 프로세스에 할당되어 사용하고 있는 자원을 추가로 점유하기 위해 대기하는 프로세스가 있어야 한다. 

3. 비선점(No Preemption)

   : 다른 프로세스에 할당된 자원은 사용이 끝날 때까지 강제로 빼앗을 수 없어야 한다.

4. 순환 대기(Circular Wait)

   : 프로세스의 집합 {P0, P1, …Pn}에서 Pn-1은 Pn이 점유한 자원을 대기하며 Pn은 P0가 점유한 자원을 요구해야 한다.





**<데드락 대처 방법>**

1. 데드락 예방 및 회피 : 발생하지 않도록

   * 예방(Prevention) 

     : 주로 순환 대기 부정을 통해 해결하는 경우가 많음.

     1) 상호 배제 부정 : 여러 개의 프로세스가 공유 자원을 사용할 수 있도록 한다.

     2) 점유 대기 부정 : 프로세스가 실행되기 전 필요한 모든 자원을 할당한다.

     3) 비선점 부정 : 자원을 점유 중인 프로세스가 다른 자원을 요구할 때, 현재 점유 중인 자원을 반납하고 새로 요구하는 자원을 기다리게 한다. 

     4) 순환 대기 부정 : 자원에 고유한 번호를 할당하고, 번호 순서대로 자원을 요구하도록 한다.

   * 회피(Avoidance)

     : 교착상태가 발생할 것 같으면 회피하도록 하는 방법

     : 은행원 알고리즘(Banker's Algorithm)

     자원 요청 -> 안전 여부 체크 -> 안정 상태이면 자원 할당, 아닌 경우 할당 거부

2. 데드락 탐지 및 회복 : 발생 후

   * 탐지(Detection)

     : 자원 할당 그래프 알고리즘을 통해 데드락 탐지 후 해결

     : 자원 요청시마다 탐지 알고리즘을 수행하면 오버헤드 발생

   * 회복(Recovery)

     : 데드락 상태의 프로세스를 종료하거나 할당된 자원을 해제하는 방식

     1) 종료 : 데드락을 일으킨 프로세스를 모두 종료, 또는 데드락이 풀릴 때까지 한 프로세스씩 종료

     2) 선점 : 데드락에 빠진 프로세스가 점유하고 있는 자원을 선점해 다른 프로세스에게 할당하며, 해당 프로세스를 일시정지

3. 데드락 무시 : 자주 발생하지 않으므로

   : 데드락은 자주 발생하지 않는 현상

   : 데드락 예방, 회피, 탐지, 회복 등의 방법은 비용이 많이 든다.

   : UNIX, MINIX에서 사용

















참고 : http://blog.naver.com/PostView.nhn?blogId=itperson&logNo=220933650178&categoryNo=50&parentCategoryNo=0&viewDate=&currentPage=1&postListTopCurrentPage=1&from=postView
