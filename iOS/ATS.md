# App Transport Security

* 애플리케이션과 웹 서비스 사이에 통신 시 보안 향상을 위한 기능
* 모든 인터넷 통신 시 안전한 프로토콜을 사용하도록 보장하는 것으로 사용자의 민감한 정보가 유출되는 것을 방지함.



# 전송 계층 보안 (Transport Layer Security - TLS)

* **암호 프로토콜**
* 서버와 클라이언트 애플리케이션이 네트워크로 통신하는 과정에서 도청, 간섭, 위조를 방지하기 위해서 설계됨.



# HTTPS (Hypertext Transfer Protocol Secure)

* TLS를 사용해 암호화된 연결을 하는 HTTP 프로토콜





# 예외 사항

> ATS 기능을 사용하지 않을 수 있는 예외사항

* AVFoundation 프레임워크를 통한 스트리밍 서비스
* WebKit을 통한 콘텐츠 요청
* 로컬 네트워크 연결
* 서버가 최신 TLS 버전으로 업그레이드할 때까지 일시적으로 가능