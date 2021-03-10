# HTTP란?

<**H**yper**T**ext **T**ransfer **P**rotocol>

- 인터넷에서 사용하는 웹 서버와 사용자의 인터넷 브라우저 사이에 문서를 전송하기 위한 통신 규약
- 텍스트 교환이므로, 누군가 네트워크에서 신호를 가로채면 내용이 노출되는 보안 이슈가 있음



# HTTPS란?

<**H**yper**T**ext **T**ransfer **P**rotocol over **S**ecure Socket Layer>

### <HTTP + SSL = HTTPS>

- 소켓 통신에서 일반 텍스트를 이용하는 대신에 SSL이나 TLS 프로토콜을 통해 세션 데이터를 암호화하는 것입니다. 따라서 데이터의 암호화를 통해 보안성을 강화하여 보호하고 있습니다.
- 공개키 암호화 방식
- 암호화는 Transport 계층에서 이루어지게 됩니다.



# HTTP와 HTTPS의 차이?

HTTP는 네트워크 보안이 되어 있지 않습니다. 그래서 네트워크상에서 정보를 누군가가 마음대로 보고, 수정할 수 있습니다. 

이와 달리 HTTPS는 네트워크 상에서 중간에 제 3자가 정보를 볼 수 없도록 **HTTP를 암호화**합니다. 이를 위해 HTTPS는 추가적인 인증 절차를 요구하며, 복호화 없이 HTTPS의 정보를 중간에서 볼 수 있는 방법은 아직까지 존재하지 않습니다.

###  

# HTTPS를 모두 사용하지 않는 이유?

HTTPS는 HTTP보다 비용이 많이 듭니다. 모든 통신을 암호화하여 주고 받으면 하지 않을 때보다 속도가 느려질 수 밖에 없습니다. 



# HTTPS 통신 흐름

1. 서버(A)를 만드는 기업은 HTTPS를 적용하기 위해 공개키와 개인키를 만든다.
2. 신뢰할 수 있는 CA 기업을 선택하고, 그 기업에게 내 공개키 관리를 부탁하며 계약을 한다.
3. CA 기업은 해당 기업의 이름, A서버 공개키, 공개키 암호화 방법을 담은 인증서를 만들고, 해당 인증서를 CA 기업의 개인키로 암호화해서 A서버에게 제공한다.
4. A서버는 암호화된 인증서를 갖게 되었다. 
5. A서버는 A서버의 공개키로 암호화된 HTTPS 요청이 아닌 요청이 오면, 이 암호화된 인증서를 클라이언트에게 준다.
6. 클라이언트는 CA기업이 A서버의 정보를 CA기업의 개인키로 암호화한 인증서를 받게 된다.
7. CA기업의 공개키는 브라우저가 이미 알고 있다.(신뢰할 수 있는 기업으로 등록되어 있어서 브라우저가 인증서를 탐색하여 해독이 가능함)
8. 브라우저는 해독한 뒤 A서버의 공개키를 얻게 되었다. 
9. A서버와 통신할 때 얻은 A서버의 공개키로 암호화해서 요청을 보낸다.