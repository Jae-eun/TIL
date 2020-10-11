# <iOS Concurrency 프로그래밍, 동기 비동기 처리 그리고 GCD/Operation - 디스패치큐와 오퍼레이션큐의 이해> 강의 정리



## GCD - 3. 디스패치큐(GCD) 사용시 주의해야 할 사항

## 반드시 메인 큐에서 처리해야 하는 작업, sync 메서드에 대한 주의사항, weak, strong 캡처 주의, 컴플리션 핸들러의 존재 이유, 동기적 함수를 비동기함수처럼 만드는 방법



## 1) 반드시 메인 큐에서 처리해야 하는 작업

* **UI 관련된 작업은 "메인 큐"에서 처리해야 한다.** 다른 스레드로부터의 간섭이 없도록 하기 위해.

```swift
DispatchQueue.global().async {
// URLSession.shared.dataTask(with: url) (내부적으로 비동기로 처리되어 있음)  
	// 이미지 다운로드 등 관련 코드 
	DispatchQueue.main.async {
		// 다운로드한 이미지 표시
		self.imageView.image = image
	}
}
```



> 실제 앱에서는 UI 관련 작업들이 `DispatchQueue.main`에서 동작하지만 플레이그라운드에서는 `DispatchQueue.global()`에서 동작합니다. 

```swift
var imageCach = [String: UIImage]() 
class CustomImageView: UIImageView {
	var lastImgUrlUsedToLoadImage: String? 
	
	func loadImage(with urlString: String) {
		self.image = nil 
		// 마지막으로 이미지를 다운로드한 String 경로 
		lastImgUrlUsedToLoadImage = urlString 
		
		// 이미지가 캐시에 들어 있는지 확인
		if let cachedImage = imageCache[urlString] {
			self.image = cachedImage 
			return 
		}
		
		guard let url = URL(string: urlString) else { return }
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in 
			if let error = error {
				print("Failed to load image with error", error.localizedDescription)
			}
			
			if self.lastImgUrlUsedToLoadImage != url.absoluteString {
				return 
			}
			
			guard let imageData = data else { return }
			let photoImage = UIImage(data: imageData)
			imageCache[url.absoluteString] = photoImage 
			
			DispatchQueue.main.async {
				self.image = photoImage
			}
		}.resume() 
	}
}

```



## 2) sync 메서드에 대한 주의사항

* **메인 큐에서 다른 큐로 보낼 때 sync 메서드를 절대 호출하면 안됩니다.**
  * 메인 큐에서는 항상 비동기적으로 보내야 합니다.
  * 동기적으로 처리하면 UI가 멈춰서 버벅거리게 됩니다. 

```swift
// 현재 메인 스레드에서 작업하고 있다면 아래와 같은 코드는 사용하면 안됨
DispatchQueue.global().sync {
}
```

* **현재 큐에서 현재 큐로 동기적으로 보내서는 안된다.**
  * 현재 큐를 블락(`block`)하는 동시에 다시 현재 큐에 접근하기 때문에 교착상태(`deadlock`)가 발생할 수 있다.

```swift
DispatchQueue.global().async { // 어떤 뷰컨트롤러의 다음과 같은 코드에서 사용한 객체 안에
	DispatchQueue.global().sync { // sync 호출이 되고 있다면 교착 상태가 일어날 수 있음
  }
}
```



## 3) weak, strong 캡처 주의

* 다른 큐로 작업을 보내는 것은 클로저를 보내는 것이라 객체에 대한 캡처가 발생한다. 
* 약한 참조(`weak reference`) 를 하면 해당 뷰컨이 사라진다면 클로저 작업도 같이 중단될 수 있다. 
* 강한 참조(`strong reference`) 상태라면 해당 뷰컨이 사라지더라도 큐로 보낸 클로저 작업은 여전히 동작될 수 있다.

```swift
DispatchQueue.global(qos: .utility).async { [weak self] in 
	guard let self = self else { return } 
	
	DispatchQueue.main.async {
		self.
	}
}
```



## 4) (비동기 작업에서) 컴플리션 핸들러(`completionHandler`)의 존재 이유

* 비동기 작업이 명확하게 끝나는 시점을 알아야 할 때가 있음



## 5) 동기적 함수를 비동기함수처럼 만드는 방법

* 여러 번 재활용을 위해. 오래 걸리는 작업을 내부적으로 비동기로 하여, 빠르게 처리할 수 있게. 

```swift
// 시간이 오래 걸리는 동기적으로 처리하는 함수(동기 함수)
public func tiltShift(image: UIImage?) -> UIImage? {
	guard let image = image else { return nil }
  sleep(1)
  let mask = topAndBottomGradient(size: image.size)
  return image.applyBlur(radius: 6, maskImage: mask)
}

let image = UIImage(named: "dark_road_small.jpg")
let _ = tiltShift(image: image)

// 1) 직접 작업을 실행할 큐와 
// 2) 작업을 마치고 난 후 사용할 큐
// 3) 컴플리션 핸들러
// 4) 에러처리에 대한 내용이 필요
func asyncTiltShift(_ inputImage: UIImage?, runQueue: DispatchQueue, completionQueue: DispatchQueue, completion: @escaping (UIImage?, Error?) -> ()) {
  runQueue.async {
    var error: Error?
    error = .none 
    
    let outputImage = tiltShift(image: inputImage) 
    
    completionqueue.async {
      completion(outputImage, error)
    }
  }
}

let workingQueue = DispatchQueue(label: "com.inflearn.serial")
let resultQueue = DispatchQueue.global() 
// 플레이그라운드에서는 메인큐가 아닌 디폴트글로벌큐에서 동작 

print("함수 시작")
asyncTiltShift(image, runQueue: workingQueue, completionQueue: resultQueue) { image, error in 
  image 
	print("비동기 작업 실제 종료")
}
print("함수 종료")
```



* 활용 예제

```swift
let imageNames = ["dark_road_small", "train_day", "train_dusk", "train_night"]
let images = imageNames.compactMap { UIImage(named: "\($0).jpg")}

// 변형한 이미지 저장하기 위한 배열 생성
var tiltShiftedImages = [UIImage]()

// 동시큐 만들기
let workerQueue = DispatchQueue(label: "com.inflearn.concurrent", attributes: .concurrent)
let appendQueue = DispatchQueue(label: "com.inflearn.append.serial")

for image in images {
  asyncTiltShift(image, runQueue: workerQueue, completionQueue: appendQueue) { image, error in. 
    guard let image = image else { return }
		tiltShiftedImages.append(image)
	}
}
```



[출처](https://www.inflearn.com/course/iOS-Concurrency-GCD-Operation/dashboard)