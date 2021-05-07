# Kingfisher

> A lightweight, pure-Swift library for downloading and caching images from the web.
>
> https://github.com/onevcat/Kingfisher
>
> iOS 관련 이미지 관리 오픈소스 라이브러리

* 비동기 이미지 다운로드 및 캐싱

* `URLSession` 기반 네트워킹

* 기본 이미지 processor 및 filter

* 메모리와 디스크를 위한 다중 계층 캐시

* 성능 향상을 위한 다운로드 작업 취소나 처리 가능

* `UIImage`, `NSImage`, `UIButton` 의 확장으로 URL에서 이미지 설정 가능

* 필요에 따라 `downLoader`, `Cache` 시스템을 별도로 사용

* 이미지 설정 시 내장된 애니메이션 사용 가능

* 확장 가능한 이미지 처리

  * 여러 processor 적용 : `>>` 연산자 활용

  ```
  // 모서리 둥글게
  let processor = RoundCornerImageProcessor(cornerRadius: 20)
  // 사이즈 재설정
  let processor = ResizingImageProcessor(targetSize: CGSize(width: 100, height: 100))
  // 흐림 정도
  let processor = BlurImageProcessor(blurRadius: 5.0)
  // Overlay 색상과 fraction(Overlay가 차지하는 비율) 설정
  let processor = OverlayImageProcessor(overlay: .red, fraction: 0.5)
  // Color Tint 설정
  let processor = TintImageProcessor(tint: .blue)
  // 인접 색상
  let processor = ColorControlProcessor(brightness: 1.0, contrast: 0.5, saturation: 1)
  // 흑백
  let processor = BlackWhiteProcessor()
  ```

* GIF 이미지 형식 지원

  ```swift
  let imageView = AnimatedImageView() 
  ```



### 장점

* High-resolution image 처리

```swift
let processor = DownsamplingImageProcessor(size: imageView.size) 
								>> RoundCornerImageProcessor(cornerRadius: 20)
imageView.kf.indicatorType = .activity 
imageView.kf.setImage(with: url,
                      plceholder: UIImage(named: "플레이스홀더이미지"),
                      options: [.processor(processor),
                                .scaleFactor(UIScreen.main.scale),
                                .transition(.fade(1)),
                                .cacheOriginalImage]) { result in 
                                                       switch result {
                                                         case .sucess(let value):
                                                         // 처리
                                                         case .failure(let error): 
                                                         // 에러 처리
                                                       }}
```

* 이미지 캐싱

```

```







### 사용

1. 이미지의 URL을 통해 바로 ImageView에 적용

>  비동기, 캐싱 처리됨

```swift
guard let url = URL(string: "이미지 URL") else { return }
let processor = RoundCornerImageProcessor(cornerRadius: 8)
imageView.kf.setImage(with: url, options: [.processor(processor)])
```

2. URL을 통해 UIImage를 만들고 재가공 후 적용 

> 사이즈 변경 / 화질 변경 등

```swift
if let thumbnailUrl = URL(string: "이미지 URL") {
	KingfisherManager.shared.retrieveImage(with,
                                         thumbnailUrl,
                                         completionHandler: { result in 
		switch result { 
		case .success(let imageResult): 
			let resized = imageResult.image.resizedImageWithContentMode(.scaleAspectFit,
                                                                    bounds: CGSize(width: 84, height: 84),
                                                                    interpolationQuality: .medium) 
			imageView.isHidden = false 
			imageView.image = resized 
		case .failure(let error):
			imageView.isHidden = true 
    }
	})
}
```

3. 별도의 요청 헤더 추가 

```swift
let imageDowloadRequest = AnyModifier { request in 
	var requestBody = request
	requestBody.setValue(authValue, forHTTPHeaderField: "Authorization")
	return requestBody 
}
// 1
imageView.kf.setImage(with: url, options: [.requestModifier(imageDownloadRequest)])
// 2 
KingfisherManager.shared.retrieveImage(with: thumbnailUrl,
                                       options: [.requestModifier(imageDownloadRequest)],
                                       completionHandler: { request in                                                                                                                                 })
```























### 참고

[https://terry-some.tistory.com/89](https://terry-some.tistory.com/89)

[https://gaki2745.github.io/ios/2019/10/11/iOS-Basic-10/](https://gaki2745.github.io/ios/2019/10/11/iOS-Basic-10/)