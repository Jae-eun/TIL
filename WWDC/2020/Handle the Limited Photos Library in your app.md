# Handle the Limited Photos Library in your app

> iOS14에서 새로 나온 제한된 사진 라이브러리 

* 기존의 앱은 PhotoKit API를 통해 사용자 사진 라이브러리의 거의 모든 에셋에 접근할 수 있었고, 데이터베이스에서 쓰거나 읽을 사진을 요청할 수 있었다. `Limited Photos Library` 에서는 **사용자가 접근할 수 있도록 선택한 에셋만 가져올 수 있게** 되었다.

이 모드로 전환되었는지 확인하기 위해 사용할 수있는 새로운 API

 앱에서 변경해야 할 몇 가지 UI 변경 사항.

 무엇을 의미하는지 

* 사용자가 선택한 접근 가능 에셋을 수정하면 UI를 업데이트 할 수 있도록 앱에 자동으로 알림이 전송됨.

* 사진 라이브러리에 대한 앱 접근 권한 팝업에서 `Select Photos` 라는 추가 옵션이 생김.

![image-20201221233813718](/Users/ijaeeun/Library/Application Support/typora-user-images/image-20201221233813718.png)



## 사용자가 선택한 접근 가능 사진을 수정할 수 있는 방법

1. 앱의 전체 액세스 수준을 변경하는 옵션과 함께 사용자가 선택 항목을 관리 할 수 있는 **설정**으로 이동하는 것
2. PhotoKit을 통해 에셋을 처음 가져올 때 **앱 생명주기마다 한 번씩 사용자에게 현재 선택을 유지하거나 수정하라는 메시지가 표시**



## 도입한 이유

* 사용자에게 데이터에 대한 더 많은 제어 권한을 부여하기 위함.
* 개인의 사진과 비디오가 매우 증가하고 있음. 사용자는 제 3자가 모든 에셋에 접근할 수 있는 것을 원하지 않을 것임.



## PHPicker

* 사용자에게 접근 권한을 요청하지 않고 쉽게 구축할 수 있음.

  * Ex) 프로필 사진 업로드, 사진 메시지 보내기, 게시글에 사진 첨부 등

  * `UIImagePickerController`의 대체

  * 다중 선택 및 내장 검색 기능이 있음.

    

  사용자가 애플리케이션에 제한된 사진 액세스 권한을 부여했는지 확인하는 데 사용할 수있는 API

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



```swift
// Present the limited library management UI : 제한된 라이브러리 표시
import PhotosUI

let library = PHPhotoLibrary.shared()
let viewController = self

library.presentLimitedLibraryPicker(from: viewController)
```



[출처](https://developer.apple.com/videos/play/wwdc2020/10641/)