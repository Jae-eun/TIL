# What's New in the Apple Push Notification Service

### HTTP/2 provider API

* `HTTP/2` 영구 푸시를 기반으로 하는 새로운 공급자 프로토콜을 도입함.
* `HTTP/2`는 **단일 연결을 통해 여러 스트림을 지원하는 매우 빠른 바이너리 프로토콜**임.
* 초당 수십만 개의 알림을 제공함.
* 푸시 알림을 매우 쉽게 보낼 수 있음.



### Instant feedback

* **비활성화된 장치 토큰을 나타내는 즉각적인 피드백** 제공을 지원함.



### Larger payload 

* **최대 4KB의 더 큰 페이로드**를 보낼 수도 있음.



### Simplified certificate handling 

* **인증서 처리를 단순화**하므로 이제 APNS에 연결하는 데 사용되는 **클라이언트 인증서를 더 적게 유지해야** 함.



## 푸시 알림 전송 단계 요약

![](https://user-images.githubusercontent.com/12438429/104334798-26a6e980-5536-11eb-9854-202e9cbf012a.png)

> * 오른쪽 하단에는 클라이언트 앱, 오른쪽 상단에는 **APNS에 연결하고 푸시 알림을 보내는 서버 구성요소인 `Provider(공급자)`**가 있음.
> * 먼저, **개발자 계정에서 푸시 알림을 등록**해야 함.
> * **기기는 응용 프로그램을 대신해 APNS에서 토큰을 요청**함. 그리고 **응용 프로그램으로 다시 반환**함.
> * 응용 프로그램은 기기에서 실행되는 운영체제에 등록됨.
> * **기기 토큰은 이 기기에서 실행되는 앱에 대해 고유함**.
> * **앱은 이 토큰을 `Provider(공급자)`에게 전달**해야 함.
> * **공급자는 클라이언트 인증서를 사용하여 APNS에 연결한 다음, 표준 HTTP/2 게시 요청을 사용하여 해당 장치 토큰에 푸시를 보냄**. 
> * HTTP/2 공급자 API는 모든 것이 정상인 경우, **성공을 나타내는 즉각적인 응답을 제공**함. 
> * 오류가 발생한 경우, **장치 토큰이 유효하지 않으면 오류 상태 400 또는, `invalid request(유효하지 않은 요청)` 을 반환**하고, 인접한 JSON 페이로드가 오류 발생 이유를 나타냄. 
> * **장치 토큰이 제거** 된 경우, 즉시 **상태가 410 또는 `removed(제거됨)`인 `HTTP/2` 응답**을 받게 됨. 기기 토큰이 제거되었음을 알게 된 마지막 타임 스탬프가 페이로드에 표시됨.



## Simplified Certificate Handling

> 인증서 처리를 단순화함.
>
> `Application push` / `VoIP push` / `Complication push` / `Development and production environment `

* 이제 **푸시에 대한 단일 인증서를 프로비저닝 할 수 있음**. **개발 및 프로덕션 환경 모두 동일한 인증서를 사용할 수 있음**. 이를 통해 개발자가 여러 인증서를 관리, 갱신 및 취소하는 번거로움을 줄일 수 있음.



## Token Authentication

> 토큰 인증: **알림을 보낼 때 클라이언트 인증서 대신 공급자 토큰을 사용하는 방법**

* 인증 토큰은 **서비스가 APNS에 연결하는 방법을 단순화하기 위함.** 
* 토큰은 프로그래밍 방식으로 생성하기가 쉽기 때문에 **만료되는 인증서를 재발급해야 하는 것에 대해 걱정할 필요가 없음**.
* 인증 자격 증명을 생성하는 메커니즘으로 **JSON 웹 토큰을 사용하여 활성화**됨.
* 토큰을 생성하기 위해 선택한 프로그래밍 언어와 함께 광범위하게 사용할 수 있는 많은 라이브러리가 있음.

 

## 인증서 인증 작동 방식 요약

![](https://user-images.githubusercontent.com/12438429/104344782-f0229c00-5540-11eb-9711-051523c7633a.png)

1) 개발자 계정의 클라이언트 인증서를 Provider에게 제공.

2)  APNS에 연결할 때, 상호 인증을 사용하여 **APNS는 Provider에게 신뢰할 수 있으며 유효성을 검사 할 서버 인증서를 제공**.

![](https://user-images.githubusercontent.com/12438429/104344780-f0229c00-5540-11eb-9964-14878554d507.png)

3) 핸드 셰이크의 일부로 **`Provider`는 클라이언트 인증서에도 서명**하며, **APNS는 이를 확인하고 자격 증명을 설정하는 데 사용**함.



=> 이 시점에서 **APNS와 공급자 간에 신뢰할 수 있는 연결이 설정**됩니다.

=> **이 연결에서 보내는 모든 푸시는 클라이언트 인증서로 식별되는 애플리케이션에 첨부됨.**



![](https://user-images.githubusercontent.com/12438429/104344779-ef8a0580-5540-11eb-90aa-2d78791c56a9.png)

1) 토큰 인증을 사용할 때, **계정에서 Provider로 토큰 로그인 키를 옵트 인(`opt in`)**해야 함.

![](https://user-images.githubusercontent.com/12438429/104344778-ef8a0580-5540-11eb-9b21-62d2503d15c2.png)

2) **공급자가 클라이언트 인증서 없이 PLS 연결을 설정**함.

![](https://user-images.githubusercontent.com/12438429/104345275-80f97780-5541-11eb-9adf-160db9fcd948.png)

3) 이 연결에 대한 알림을 보내기 전에 **공급자는 팀 ID를 포함하는 인증 토큰을 생성함**. 키 옵트 표시기(`key opt indicator)`를 사용하여 서명함.



![](https://user-images.githubusercontent.com/12438429/104344766-edc04200-5540-11eb-9207-6efeaa860369.png)

* **서명된 모든 알림 메시지에는 인증 토큰이 포함되어야 함**. 
* 애플리케이션 주제(`topic`)는 이 요청의 일부여야 함.
* APNS는 **먼저 토큰을 사용하여 공급자를 인증 한 다음 요청을 처리**함.



![](https://user-images.githubusercontent.com/12438429/104344757-ec8f1500-5540-11eb-9abf-fdfe385016a3.png)

* 요청이 성공적으로 처리되면 APNS는 성공을 나타내는 응답을 다시 보냄.
* 요청과 함께 제공된 토큰이 없거나 토큰이 유효하지 않은 경우 오류를 나타내는 응답이 다시 전송됨.
* APNS는 **오류가 나더라도 연결을 닫지 않음**.



## 공급자 토큰을 생성하는 방법

* 개발자 계정의 인증서, ID 및 프로필 섹션(`certificate, identity and profile)`에서 `Provision signing key`부터 시작
* 공용-개인 키패드가 생성됨.
* **`private key(개인 키)`를 사용하여 토큰 데이터에 암호화 방식으로 서명할 수 있음. Apple은 토큰 유효성 검사에 해당 `public key(공개 키)`를 사용함.**



## 토큰 구성 방법

```json
// JSON Web Tokens 
eydosuufaioufoieuioeu.weiofueioewujskfjladfdjl.dsfjkljsdfkljkljeklwj...

Header 
{
	"alg": "ES256", 
	"kid": "ABCDEFGHIJ"
}
Claims 
{
	"iss": "QRSTIUXS"
	"iat": "392308923"
}
Signature
```

>  맨 위 : 요청의 일부인 JSON 웹 토큰이 어떻게 생겼는지 보여주는 예
>
> * JSON 웹 토큰의 구조는 세 부분으로 이루어져 있음.  각 부분은 마침표로 구분된 URL 친화적인 base-64 인코딩 문자열.
>
> 아래 :  웹 토큰의 디코딩 된 표현.
>
> * 첫 번째 부분은 **헤더**. **토큰에 서명하는 데 사용되는 알고리즘을 지정하는 속성을 포함**함. 현재는 ES256입니다. 토큰에 서명하는 데 사용되는 **키에 대한 키 식별자도 포함**됨.
> * **클레임** 섹션에는 계정에서 얻을 수 있는 **개발자 팀 ID 인 assurer tribute가 포함**됨.
> * epoch 이후 초로 표시되는 **초기 타임 스탬프**입니다.
> * 토큰의 마지막 부분은 단순히 **헤더와 클레임에 서명 알고리즘을 적용하여 얻은 base 64의 서명(signature)**임.

* **이렇게 해서 토큰이 생성 된 후 무단 변조되는 것을 방지 할 수 있음.**



## HTTP/2가 토큰 인증을 사용하여 요청 생성

```json
// Request example
HEADERS
- END_STREAM
+ END_HEADERS 
:authority = api.push.apple.com 
:method = POST 
:path = /3/device/ad2bd38djkldf23984... 
authorization = bearer eyJhdfhjdf... 
apns-topic = com.foo.tokenauth 
DATA
+ END_STREAM 
{ "aps" : {"alert" : "Hello Token Authenticaiton"}}

// Response example
HEADERS
- END_STREAM
+ END_HEADERS
:status = 403
content-type = application/json
DATA 
+ END_STREAM
{ "reason": "ExpiredProviderToken"}
```

> * 헤더와 데이터 프레임이 포함되어 있음.
> * **헤더 프레임은 APNS 주제를 포함한 다양한 헤더 필드로 구성됨.**
> * 헤더 프레임에  **`bearer`값과 서명된 공급자 토큰이 있는 권한 부여 헤더가 포함**되어 있음.
> * 인증 토큰이 포함된 요청이 유효한 경우, 응답은 상태 200 또는 "OK."
> * **제공자 토큰이 유효하지 않은 경우,  상태 403 또는 `forbidden(금지됨)` 응답**이 표시됨.

* APNS는 **새로운 토큰을 주기적으로 생성해야 함**.
* APNS는 **토큰 생성 시간이 1시간 이내**여야 함.
* 그러나 **모든 요청에 대해 새 토큰을 생성해서는 안됨**. 실제로 **성능을 위해 토큰이 유효하다면 재사용하는 것이 좋음**.



* **공급자 토큰은 주기적으로 생성되어야 함.**
* **로그인 키는 만료되지 않음.**
* **로그인 키가 손상되었다고 의심되는 경우 계정에서 키를 취소하고 새 키를 프로비저닝 할 수 있음.**
* APNS는 계속해서 인증서 인증을 지원함.



[출처](https://developer.apple.com/videos/play/wwdc2016/724/ )