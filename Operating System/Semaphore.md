# Semaphore (세마포어)

: 커널 모드 동기화 객체

: 동시에 여러 개의 공유 자원 공간을 가진 여러 개의 카운트 값을 가지는 뮤텍스

: 접근할 수 있는 스레드 개수를 정하고 그 개수만큼의 스레드를 관리하는데 카운트 수가 1인 세마포어는 바이너리 세마포어, 여러 개라면 카운팅 세마포어라고 함.

: 주로 운영체제의 리소스를 경쟁적으로 사용하는 다중 프로세스에서 행동을 조정하거나 동기화 시키기 위해 사용하는 기술, 비교적 긴 시간을 확보하는 리소스에 대해 활용함.



**<세마포어와 뮤텍스의 차이>**

: 뮤텍스는 카운트가 1인 바이너리 세마포어라고 볼 수 있음.

: 뮤텍스는 락을 소유한 스레드가 직접 해제해야 하지만, 세마포어는 외부에서 조정될 수 있음.

: 세마포어는 일반적으로 공유 자원을 프로세스 단위에서 접근하는 것을 관리하기 위해 사용하고, 뮤텍스는 스레드 단위에서 접근하는 것을 관리하기 위해 사용함.







참고 : http://blog.naver.com/PostView.nhn?blogId=itperson&logNo=220933533752&parentCategoryNo=&categoryNo=50&viewDate=&isShowPopularPosts=false&from=postView

