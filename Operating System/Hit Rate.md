# 캐시메모리 적중률 (Hit Rate)

* Cache Memory : CPU의 처리 속도와 주기억장치의 접근 속도 차이를 줄이기 위해 사용하는 고속 Buffer Memory

* 이용 효과

  : 프로그램의 실행과정을 분석해 보면, 주어진 시간 동안에 참조하는 메모리 영역은 국한된다는 사실을 알 수 있다. (메모리 참조의 국부성) 따라서, 자주 참조되는 프로그램의 일부를 속도가 빠른 기억장치에 저장해 놓고 실행시키면 프로그램의 총 실행시간을 단축시킬 수 있다. 

* 특징

  1) 캐시는 주기억장치와 CPU 사이에 위치하며, 자주 사용하는 프로그램과 데이터를 기억한다.

  2) 캐시 메모리는 메모리 계층 구조에서 가장 빠른 소자이며, 처리 속도가 거의 CPU 속도와 비슷할 정도이다.

  3) 캐시를 사용하면 주기억장치를 접근하는 횟수가 줄어듦으로써 컴퓨터의 처리속도가 향상된다.

  4) 캐시 주소표는 검색시간을 단출시키기 위해 주로 연관기억장치(CAM, Associative Memory)를 사용한다. (CPU가 찾으려는 주기억장치의 데이터가 캐시 메모리의 몇 번째 페이지에 위치하는지를 나타내는 표)

  5) 캐시의 크기는 보통 수십 킬로바이트에서 수백 킬로바이트이다.

* 캐시 설계시 고려할 사항

  1) 캐시의 크기(Cache Size)

  2) 전송 Block Size

  3) 교체 알고리즘 (Replacement Algorithm)

* 매핑 프로세스(Mapping Process) : 주기억장치로부터 캐시 메모리로 데이터를 전송하는 방법

  1) 직접 매핑 (Direct Mapping)

  2) 어소시에이티브 매핑 (Associative Mapping)

  3) 세트-어소시에이티브 매핑 (Set-Associative Mapping)



: 명령이나 자료를 찾기 위해서 캐시 메모리에 접근했을 때, 원하는 정보가 있을 수도 있고 없을 수도 있음. 

: 원하는 정보가 캐시 메모리에 기억되어 있을 때 적중(Hit)되었다고 함. 기억되어 있지 않으면 실패했다고 함.

: 적중률은 캐시 기억자이가 있는 컴퓨터의 성능을 나타내는 척도로 이용되며, 적중률이 0.95~0.99일 때 우수하다고 함.

* 적중률 = 적중 횟수 / 총 접근 횟수





참고 : https://ndlessrain.tistory.com/entry/%EC%BA%90%EC%8B%9C%EB%A9%94%EB%AA%A8%EB%A6%AC-%EC%A0%81%EC%A4%91%EB%A5%A0Hit-Rate