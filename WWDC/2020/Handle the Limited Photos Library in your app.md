# Handle the Limited Photos Library in your app

> iOS14에서 새로 나온 제한된 사진 라이브러리 

* 기존의 앱은 PhotoKit API를 통해 사용자 사진 라이브러리의 거의 모든 에셋에 접근할 수 있었고, 데이터베이스에서 쓰거나 읽을 사진을 요청할 수 있었다. `Limited Photos Library` 에서는 **사용자가 접근할 수 있도록 선택한 에셋만 가져올 수 있게** 되었다.



* 사용자가 선택한 접근 가능 에셋을 수정하면 UI를 업데이트 할 수 있도록 앱에 자동으로 알림이 전송됨.

* 사진 라이브러리에 대한 앱 접근 권한 팝업에서 `Select Photos` 라는 추가 옵션이 생김.

![Handle the Limited Photos Library in your app_1](/Users/ijaeeun/Documents/TIL/WWDC/images/Handle the Limited Photos Library in your app_1.png)



## 사용자가 선택한 접근 가능 사진을 수정할 수 있는 방법

1. 앱의 전체 액세스 수준을 변경하는 옵션과 함께 사용자가 선택 항목을 관리 할 수 있는 **설정**으로 이동하는 것
2. PhotoKit을 통해 에셋을 처음 가져올 때 **앱 생명주기마다 한 번씩 사용자에게 현재 선택을 유지하거나 수정하라는 메시지가 표시**



## 도입한 이유

* **사용자에게 데이터에 대한 더 많은 제어 권한을 부여**하기 위함.
* 개인의 사진과 비디오가 매우 증가하고 있음. 사용자는 제 3자가 모든 에셋에 접근할 수 있는 것을 원하지 않을 것임.



![Handle the Limited Photos Library in your app_2](/Users/ijaeeun/Documents/TIL/WWDC/images/Handle the Limited Photos Library in your app_2.png)

## PHPicker

* 사용자에게 접근 권한을 요청하지 않고 쉽게 구축할 수 있음.

  * Ex) 프로필 사진 업로드, 사진 메시지 보내기, 게시글에 사진 첨부 등

  * `UIImagePickerController`의 대체

  * **다중 선택 및 내장 검색 기능**이 있음.

    

### Limited access API

> 접근 상태 쿼리

```swift
// Request read/write authorization : 권한 요청
import Photos

let accessLevel: PHAccessLevel = .readWrite
let authorizationStatus = PHPhotoLibrary.authorizationStatus(for: accessLevel)

switch authorizationStatus {
case .limited:
    print("limited authorization granted")
default:
    //FIXME: Implement handling for all authorizationStatus values
    print("Not implemented")
}
```

* 기존 `PHAuthorizationStatus` Enumeration에 새 값 `.limited`을 추가

*  `PHAccessLevel`이라는 새로운 열거형을 도입
  * `.addonly` / `.readWrite`

* 앱이 읽기/쓰기 권한이 있는지 확인하거나 액세스 권한만 추가 할 수 있음.

* `Limited library`는 `addOnly` 액세스에 영향을 미치지 않으므로 사용자가 제한된 액세스 권한을 부여했는지 확인하려면 `readWrite` 액세스 수준을 전달하고 제한된 권한 상태 반환 값을 확인해야 함.



### New authorization request API

> 접근 권한 요청

```swift
let requiredAccessLevel: PHAccessLevel = .readWrite 

PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { authorizationStatus in 
	// Handle all possible PHAuthorizationStatus values 
	switch authorizationStatus {
		case .limited: 
	}
}
```

* 이전의 API는 호환성을 위해 `limited` 대신에  `authorizaed` 를 리턴함.



* 앱 내에서 새로운 에셋을 만들면 자동으로 사용자가 선택한 에셋으로 포함됨.

* `User album`은 가져오거나 만들 수 없음.

* 클라우드 공유 에셋 또는 앨범에 액세스 할 수 없음.



### Control photo library management UI

1. 선택 라이브러리 UI를 표시하는 방법

```swift
// Present the limited library management UI : 제한된 라이브러리 표시
import PhotosUI

let library = PHPhotoLibrary.shared()
let viewController = self

library.presentLimitedLibraryPicker(from: viewController)
```

* 기존 `PHPhotoLibraryChangeObserver` API를 통해 사용자의 선택에 따라 발생하는 모든 변경 사항을 모니터링해야 함.



2. 앱 시작 후 PhotoKit API 호출을 처음 수행 할 때 자동 시스템 프롬프트가 발생하지 않도록하는 방법

* `info.plist` 에서 `PHPhotoLibraryPreventAutomaticLimitedAccessAlert` : `YES` 로 추가



[출처](https://developer.apple.com/videos/play/wwdc2020/10641/)