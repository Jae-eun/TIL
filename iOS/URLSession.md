# URLSession

* **HTTP/HTTPS를 통해 콘텐츠(데이터)를 주고 받는 API를 제공하는 클래스** 

  > - 인증 지원을 위한 많은 델리게이트 메서드를 제공함
  >
  > - 애플리케이션이 실행 중이지 않거나 일시 중단된 백그라운드 작업을 통해 콘텐츠를 다운로드하는 것을 수행하기도 함

  * URLSession API를 사용하기 위해 애플리케이션은 세션을 생성함
  * 세션은 관련된 데이터 전송 작업 그룹을 조정함
  * 각 세션 내에서 애플리케이션은 작업을 추가하고, 각 작업은 특정 URL에 대한 요청을 나타냄

  

* **Request** : 서버로 요청을 보낼 때 어떤 HTTP 메서드를 사용할 것인지, 캐싱 정책은 어떻게 할 것인지 등의 설정 가능
* **Response** : URL 요청의 응답을 나타내는 객체



# 세션의 유형

1. **기본 세션(Default Session)** : URL 다운로드를 위한 다른 파운데이션 메서드와 유사하게 동작함. 디스크에 저장하는 방식임.
2. **임시 세션(Ephemeral Session)** : 기본 세션과 유사하지만, 디스크에 어떤 데이터도 저장하지 않고, 메모리에 올려 세션과 연결함. 따라서 애플리케이션이 세션을 만료시키면 세션과 관련한 데이터가 사라짐.
3. **백그라운드 세션(Background Session)** : 별도의 프로세스가 모든 데이터 전송을 처리한다는 점을 제외하고 기본 세션과 유사함.



### 세션 만들기

* `init(configuration)` : 지정된 세션 구성으로 세션을 만듦.

  ```swift
  init(configuration: URLSessionConfiguration)
  ```

* `shared` : 싱글턴 세션 객체를 반환함.

  ```swift
  class var shared: URLSession { get }
  ```



### 세션 구성

* `configuration` : 이 세션에 대한 구성 객체

  ```swift
  @NSCopying var configuration: URLSessionConfiguration { get }
  ```

* `delegate` : 이 세션의 델리게이트

```swift
var delegate: URLSessionDelegate? { get }
```



#  URLSessionTask

* **세션 작업 하나를 나타내는 추상 클래스**

  1. `URLSessionDataTask`

     : HTTP의 각종 메서드를 이용해 서버로부터 응답 데이터를 받아서 Data 객체를 가져오는 작업을 수행함.

  2. `URLSessionUploadTask`

     : 애플리케이션에서 웹 서버로 Data 객체 또는 파일 데이터를 업로드하는 작업을 수행함. 주로 HTTP의 `POST` / `PUT` 메서드를 이용함.

  3. `URLSessionDownloadTask`

     : 서버로부터 데이터를 다운로드 받아서 파일의 형태로 저장하는 작업을 수행함. 백그라운드 상태에서도 다운로드가 가능함.

> * **데이터 작업**은 서버로부터 어떤 응답이라도 **Data 객체의 형태로 전달 받을 때** 사용하며, **업로드 작업 및 다운로드 작업**은 단순한 **바이너리 파일의 전달**에 목적은 둔다고 볼 수 있음.
> * **JSON, XML, HTML 데이터** 등 단순한 데이터의 전송에는 주로 **데이터 작업**을 사용하며, **용량이 큰 파일**의 경우 애플리케이션이 백그라운드 상태인 경우에도 전달할 수 있도록 **업로드/다운로드 작업**을 주로 사용함.



## 세션에 Data Task 추가하기

* `dataTask(with:)` : URL에 데이터를 요청하는 데이터 작업 객체를 만듦.

``` swift
func dataTask(with url: URL) -> URLSessionDataTask
```

* `dataTask(with:)` : URLRequest 객체를 기반으로 URL에 데이터를 요청하는 데이터 작업 객체를 만듦.

```swift
func dataTask(with request: URLRequest) -> URLSessionDataTask
```

* `dataTask(with: completionHandler:)` : URL에 데이터를 요청하고 요청에 대한 응답을 처리할 완료 핸들러를 갖는 데이터 작업 객체를 만듦.

```swift
func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
```

* `dataTask(with: completionHandler: )` : URLRequest 객체를 기반으로 URL에 데이터를 요청하고 요청에 대한 응답을 처리할 완료 핸들러를 갖는 데이터 작업 객체를 만듦.

```swift
func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
```





## 작업(태스트) 상태 제어

* cancel() : 작업을 취소함.

  ```swift
  func cancel()	
  ```

* resume() : 일시중단된 경우 작업을 다시 시작함.

  ```swift
  func resume()
  ```

* suspend() : 작업을 일시적으로 중단함.

  ```swift
  func suspend()
  ```

* state() : 작업의 상태를 나타냄.

  ```swift
  var state: URLSessionTask.State{ get }
  ```

* priority() : 작업처리 우선순위. 0.0부터 1.0 사이

  ```swift
  var priority: Float { get set }
  ```

  













