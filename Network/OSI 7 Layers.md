# OSI(Open System Interconnection) 7 Layers 

> 7계층으로 구분하는 이유 : 통신이 일어나는 과정을 단계별로 알 수 있고, 특정한 곳에 이상이 생기면 그 단계만 수정할 수 있기 때문



## 1. 물리(`Physical`)

> 리피터, 케이블, 허브 등

* 데이터를 전기적인 신호로 변환해서 주고 받는 역할
* 케이블 종류, 무선 주파수 링크, 핀 배치, 전압, 물리 요건 등이 포함됨



## 2. 데이터링크(`Data Link`)

> 브릿지, 스위치 등

* 물리 계층으로 송수신되는 정보를 관리하여 전달되도록 도와주는 역할
* 두 개의 직접 연결된 노드 사이의 노드 간 데이터 전송을 제공함
* 물리 계층의 오류 수정도 처리함
* 2개의 부계층이 존재함(매체 접근 제어 `Mac` 계층 / 논리적 연결 제어 `LLC` 계층)
* Mac 주소를 통해 통신함. 프레임에 Mac 주소를 부여하고 에러검출, 재전송, 흐름제어를 진행함



## 3. 네트워크(`Network`)

> 라우터, IP

* 데이터를 목적지까지 가장 안전하고 빠르게 전달하는 기능 담당
* 라우터를 통해 이동할 경로를 선택하여 IP 주소를 지정하고, 해당 경로에 따라 패킷을 전달해줌
* 라우팅, 흐름 제어, 오류 제어, 세그먼테이션 등을 수행함



## 4. 전송(`Transport`)

> TCP, UDP

* 최종 시스템 및 호스트 간의 데이터 전송 조율을 담당함
* 보낼 데이터의 용량과 속도, 목적지 등을 처리함
* 기기의 IP 주소가 여기서 작동함
* TCP와 UDP 프로토콜을 통해 통신을 활성화함. 포트를 열어두고, 프로그램들이 전송을 할 수 있도록 제공해줌
* TCP : 신뢰성, 연결지향적
* UDP : 비신뢰성, 비연결성, 실시간



## 5. 세션(`Session`)

> API, Socket

* 데이터가 통신하기 위한 논리적 연결을 담당함
* 컴퓨터 또는 서버 간에 통신을 하는 세션을 만듦
* TCP/IP 세션을 만들고 없애는 책임을 지니고 있음
* 설정, 조율(ex. 시스템의 응답 대기 시간), 세션 마지막에 응용프로그램 간의 종료 등의 기능이 필요함



## 6. 표현(`Presentation`)

> JPEG, MPEG 등

* 응용 계층의 데이터 표현에 대한 독립성을 제공하고 암호화하는 역할을 담당
* 파일 인코딩, 명령어를 포장, 압축, 암호화함
* 전송하는 데이터의 포맷을 결정함
* Ex) 데이터를 안전하게 전송하기 위해 암호화, 복호화하는 것



## 7. 응용(`Application`)

> HTTP, FTP, DNS 등

* 최종 목적지(사용자에게 보이는 부분)로, 사용자와 직접적으로 상호작용함
* 사용자 인터페이스, 전자우편, 데이터베이스 관리, 웹 브라우저 등의 서비스를 제공함


















