# 동기 vs 비동기

> 2021.05.11 개굴님과 함께하는 iOS 관련 이야기 시간

* 동기(`Synchronize`) : 주어진 태스크를 차례대로 처리하고 하나의 태스크가 완료되기 전까지는 다음 태스크로 넘어가지 않는 방식. 이전 태스크가 완료되기까지 대기하는 시간 때문에 효율은 떨어지지만 태스크의 처리 순서가 보장되고 태스크가 병렬로 처리되지 않으므로 구성이 단순함.
* 비동기(`Asynchronize`) : 주어진 태스크를 차례대로 처리하지만 이전 태스크의 완료를 기다리지 않고 다음 태스크를 병렬적으로 진행하는 방식. 이전 업무가 완료되기 전까지 대기하는 시간이 없어 효율이 중가하지만 순서가 보장되지 않아 동기 방식보다 구성이 복잡할 수 있음.
* iOS에서는 GCD(`Global Central Dispatch`)라는 시스템에서 제공하는 메인 큐를 인자값으로 이용하여 병렬 처리와 스레드풀에 기반을 둔 방식의 비동기 실행 흐름을 구현하여 멀티코어 프로세서에 최적화시켜주고 그 흐름 위에서 원하는 코드가 비동기로 실행되도록 만들어줌. 



# 메모리 캐시 vs 디스크 캐시

### 하드웨어 측면

* 디스크 캐시 : 하드 디스크에 접근하는 시간을 개선하기 위해 RAM에 저장하는 기법. 하드 디스크에 접근하는 것보다 RAM에 접근하는 것이 더 빠르기 때문
* 캐시 메모리 : RAM에 접근하지 않고 더 빠른 시간으로 접근할 수 있는 CPU 칩 안에 있는 작지만 빠른 메모리. 

![image](https://user-images.githubusercontent.com/12438429/117800584-3dfca600-b28e-11eb-836b-2810f1337bd5.png)



### iOS 측면

* 디스크 캐시 : 기기 안에 저장됨. 기기를 종료해도 남아 있음. 경로에 따라 앱을 삭제할 때 사라지게 할 수도, 남아있게 할 수도 있음. `UserDefault` 를 이용하여 간단하게 저장하면 앱을 삭제할 때 함께 사라짐. 파일 경로에 이미지를 저장하면 앱이 삭제되어도 남아 있음. (보통 파일 경로에 이미지를 저장함.)
* 메모리 캐시 : 기기를 종료하면 사라짐. `NSCache` 를 통해 구현 할 수 있음.

### 이미지 가져오는 처리 순서 

1. 메모리 캐시(`NSCache`)에 있는지 확인하고 원하는 이미지가 없다면
2. 디스크 캐시(`UserDefault` 나 기기 디렉토리에 있는 파일 형태)에서 확인 후 있으면 메모리 캐시에 추가, 없으면 
3. 서버 통신을 통해 URL로 이미지를 가져온 후 캐시 처리



### Memory Cache 

```swift
// 키 값으로 쓸 타입과 캐시에 넣을 타입을 정해야 함
let imageCache = NSCache<NSString, UIImage>()
imageCache.setObject(image, forKey: url.lastPathComponent as NSString)

// 저장된 이미지를 불러올 때
guard let image = imageCache.object(forKey: url.lastPathComponent as NSString) else {
  return 
}
```



### Disk Cache

```swift
guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return }

var filePath = URL(fileURLWithPath: path)
filePath.appendPathComponent(url.lastPathComponent)

if !fileManageer.fileExists(atPahth: filePath.path) {
  fileManager.createFile(atPath: filePath.path, 
                        contents: image.jpegData(compressionQuality: 0.4), 
                        attributes: nil)
}

// 저장된 이미지를 불러올 때
if fileManager.fileExists(atPath: filePath.path) {
  guard let imageData = try? Data(contentsOf: filePath) else {
    completion?(.failure(NSError(domain: "disk cache image data nil", 
                                code: 0, 
                                userInfo: nil)))
    return 
  }
  
  guard let image = UIImage(data: imageData) else {
    completion?(.failure(NSError(domain: "image convert error", 
                                code: 0, 
                                userInfo: nil)))
  }
}
```



### 이미지 캐시의 경우 한가지 문제가 발생할 수 있음!

=> 위처럼 이미지명으로 캐시를 했는데, 서버에서 이미지명이 동일한 채 이미지 파일이 변경되었다면 클라이언트에서는 알 수 없음. 

* 해결 방법 : HTTP 통신에 `ETag` 라는 개념을 사용해서 해결할 수 있음. ETag HTTP 응답 헤더는 특정 버전의 리소스를 식별하는 식별자임. 서버에서 구현이 되어 있어야 하고, Etag 값을 UserDefaults에 저장하는 식으로 활용하면 됨. 

```swift
// eTag header 추가한 request 생성
func createRequest(_ url: URL, eTag: String?) -> NetworkRequest {
	var request = URLRequest(url: url)
  request.addValue(eTag ?? "", forHTTPHeaderField: "If-None-Match")
  return request
}

func handleResult(_ result: Session.GetDataResult, completion: ((DownloadResult) -> Void)?) {
  switch result {
  case .success((let data, let response)): 
  	if response.statusCode == 304 {
      completion?(.notModified)
      return 
    }
    let etag = response.allHeaderFields["Etag"] as? String 
    guard let data = data, let image = UIImage(data: data) else {
      completion?(.failure(NSError(domain: "image data convert error", code: 0, userInfo: nil)))
      return 
    }
    completion?(.success((image, etag)))
   case .failure(let error):
    completion?(.failure(error))
  }
}
```







1. 