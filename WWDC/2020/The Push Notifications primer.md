# The Push Notifications primer

> 푸시 알림: 실시간으로 어플리케이션에 업데이트를 전달하는 기능

![](https://user-images.githubusercontent.com/12438429/103569180-3016cd00-4f0a-11eb-8e2f-c6cd2f2bdc7b.png)

### Advantages: 이점

* `Foreground not required` : 어플리케이션이 항상 Foreground에 있을 필요가 없음. 앱 상태와 상관없이 앱에 전달되며 필요한 경우 앱이 시작됨.
* `Power efficient` : 전력 효율적임.
* `Best engagement` : 고객과 소통할 수 있는 좋은 방법



### Types : 종류

* `Alert notifications(경고 알림)` : 앱에서 사용자가 커스터마이징 할 수 있는 방식으로, 상호 작용하는 가시적 경고를 전달할 수 있음.
* `Background notifications(백그라운드 알림)` : 애플리케이션이 `foreground`에 있지 않아도, 런타임을 수신하여 콘텐츠를 최신 상태로 유지할 수 있음.



## Alert push functionality

* 애플리케이션에 대한 업데이트를 제공하는 가시적 경고(`visible alerts`)를 전달할 수 있음.
* 이 `alert`는 상호 작용할 수 있고(`can be interactive`), 새로운 정보를 알리는 데 사용되어야 함.(`display new information`)
* 애플리케이션이 실행될 필요가 없으며 **앱 상태에 관계없이 표시**됨.
* 완전히 **사용자 정의(`customizable)`** 할 수 있음. Ex) 경고의 모양과 상호 작용 가능성 

```swift
// Registering to Notifications: 경고 알림을 위해 애플리케이션을 설정하는 방법
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  func application(_ application: UIApplication, 
                  	didFinishLaunchingWithOptions launchOptions: 
                  	[UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  	UIApplication.shared.registerForRemoteNotifications() // 1) 가장 먼저해야 할 일: 원격 알림에 등록
  	UNUserNotificationCenter.current().delegate = self // 2) AppDelegate를 알림 센터의 대리인으로 할당
  	return true 
	}
```



1)  **Apple 푸시 알림 시스템 (`APN`)에 기기가 등록**되고 응용 프로그램에 **기기 토큰(`device token`)이 반환**됨. 이 토큰은 **기기를 식별**하는 데 사용되며 **알림 대상으로 지정**할 수 있음.

2) `AppDelegate`를 `UNUserNotificationCenterDelegate`로 선언하고, `AppDelegate`를 **알림 센터의 대리인으로 할당**함.

=> 알림이 열릴 때 애플리케이션에 알림이 전송됨.



```swift
// Registration callbacks
func application(_ application: UIApplication, 
									didFailToRegisterForRemoteNotificationsWithError error: Error) {
	// The token is not currently available.
	print("Remote notification is unavailable: \(error.localizaedDescription)")
}

func application(_ application: UIApplication, 
									didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
	// Forward the token to your provider, using a custom method.
	self.forwardTokenToServer(token: deviceToken)
}
```

* `registerForRemoteNotifications`를 호출하면 이 두 메서드 중 하나에 대한 콜백을 받게 됨.
  * 기기에 대한 토큰을 가져 오지 못한 경우, 등록 **실패** 이유를 설명하는 **오류**와 함께 `didFailToRegisterFor RemoteNotificationsWithError`가 호출됨.
  * 토큰을 가져 오는 데 **성공**한 경우, 이 기기에 알림을 전달할 수 있도록 해당 **토큰을 백엔드 푸시 서버로 보내야 함**.

```swift
// Converting token to string
// 디바이스 토큰은 데이터 객체로 애플리케이션에 전달됨. 서버로 보내려면 문자열로 변환해야 함. 
func forwardTokenToServer(token: Data) {
  // 데이터를 구성 요소로 분리하고 해당 구성 요소를 16진수 문자열로 변환
	let tokenComponents = token.map { data in String(format: "%02.2hhx", data) }
	let deviceTokenString = tokenComponents.joined() // 다시 하나의 문자열로 결합
  // 해당 문자열을 URLQuery에 추가하여 정규화 된 엔드 포인트를 만듦.
	let queryItems = [URLQueryItem(name: "deviceToken", value: deviceTokenString)]
	var urlComps = URLComponents(string: "www.example.com/register")! 
	urlComps.queryItems = queryItems 
	guard let url = urlComps.url else {
		return 
	}
  
  // URLSession을 수행하여 해당 토큰을 서버로 보내 데이터베이스에 등록
	let task = URLSession.shared.dataTask(with: url) { data, response, error in 
		// Handle data
	}
	task.resume() 
}
```



![](https://user-images.githubusercontent.com/12438429/103568975-dca47f00-4f09-11eb-9e9f-95128964e360.png)

```swift
// Requesting Permissions: 응용 프로그램에서 경고를 표시 할 권한을 요청
@IBAction func subscribeToNotifications(_ sender: Any) {
	let userNotificationCenter = UNUserNotificationCenter.current()
	userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in 
	print("Permission granted: \(granted)")}
}
```

* `requestAuthorization`을 호출하면 애플리케이션이 **경고를 표시 할 수 있는지 묻는 메시지가 표시**됨. 
* 결정된 결과는 `completeHandler`에 전달되어 **장치 설정에 상태가 반환**됨. 
* 프롬프트는 표시되지 않음.
* **알림 표시, 사운드 재생 및 애플리케이션 아이콘에 배지 표시 권한을 요청**함.



```swift
// Alert Notificaiton payload
{ 
	"aps" : {
			"alert" : {
						"title" : "Check out our new special!", 
						"body" : "Avocado Bacon Burger on sale"
			}, 
			"sound" : "default", // 기본값
			"badge" : 1,
	},
	"special" : "avocado_bacon_burger", 
	"price" : "9.99"
}
```

* `aps dictionary(aps 사전)` : **알림을 렌더링하는 방법을 장치에 알려줌**.
* `alert dictinoary(경고 사전)` : aps 사전 내부에 있음. **알림에 사용할 텍스트를 시스템에 알려줌**. 그 안에 제목과 본문 필드가 있음. 제목 필드(`title field`)는 알림의 목적을 설명하는 짧고 이해하기 쉬운 문자열임. 본문 필드(`body field`)는 경고 메시지의 전체 설명 텍스트임.

* `sound` : 선택 사항. 경고가 수신 될 때, 장치에서 **사운드**를 재생하도록하려는 경우 포함되어야 함. 응용 프로그램에 사용자 정의 사운드를 제공 할 수도 있음.
* `badge field` :  앱 아이콘의 배지를 수정하는 데 사용되는 선택적 필드. **앱 아이콘에 표시되는 절대값**. 이 값은 프로그래밍 방식으로 수정할 수 있으므로 경고가 열리면 알림을 처리 할 때 이 값을 0으로 설정함. 
* 사용자 지정 데이터 : aps 필드 외부에서 알림과 함께 제공 할 수 있음.



```swift
// Handling user interaction: 알림 수신을 처리하는 방법
// 알림이 열릴 때마다 호출되는 `UNUserNotificationCenterDelegate` 메서드
func userNotificationCenter(_ center: UNUserNotificationCenter, 
														didReceive response: UNNotificationResponse, 
														withCompletionHandler completionHandler: @escaping () -> Void) {
  
  // 애플리케이션에 전달된 페이로드는 알림 콘텐츠의 userInfo 속성에서 추출 할 수 있음.
	let userInfo = response.notification.request.content.userInfo 
  // 페이로드가 있으면 JSON의 dictionary 표현에서 데이터 구문 분석
	guard let specialName = userInfo["special"] as? String, 
				let specialPriceString = userInfo["price"] as? String, 
				let specialPrice = Float(specialPriceString) else {
				// Always call the completion handler when done.: 데이터가 없으면 반환하기 전에 완료 핸들러를 호출
				completionHandler()
				return 
	}
	
	let item = Item(name: specialName, price: specialPrice) 
	addItemToCart(item) // 데이터가 있으면 애플리케이션에 필요한 업데이트를 수행 할 수 있음.
	showCartViewController() // 항목이 카트에 추가되고 카트가 표시됨.
	completionHandler() // 완료 핸들러를 호출하여 시스템에 완료되었음을 알림.
}
```





## Background Pushes

* `fetch data in background` : 애플리케이션이 푸시 알림을 수신 할 때, **백그라운드에서 데이터를 가져올 수 있음**.
* **애플리케이션이 실행되고 있지 않더라도** 애플리케이션을 **최신 상태로 유지**(`stay up to date`)하는 데 사용해야 함.
* `will launch if necessary` : 시스템이 애플리케이션을 시작하고 백그라운드 업데이트를 수행하는 데 **필요한 런타임을 제공**함.
* `system managed` : 몇 가지 제한 사항이 있음. 시스템은 앱이 **하루에 너무 많은 백그라운드 작업을 하면 제한**하며, 장치가 **특정 제약 조건에있는 경우(ex. 배터리 부족 상태) 백그라운드 업데이트가 수행되지 않음**.



```swift
// Registering to Notifications
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, 
                  	didFinishLaunchingWithOptions launchOptions: 
                  	[UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  	UIApplication.shared.registerForRemoteNotifications() // 1) 가장 먼저해야 할 일: 원격 알림에 등록
  	return true 
	}
```

* 알림 푸시와 마찬가지로 애플리케이션에 대한 디바이스 토큰을 얻으려면 **원격 알림에 애플리케이션을 등록**해야 함.
* 그러나 알림 푸시와 달리 애플리케이션을 `UNUserNotificationCenterDelegate`로 만들거나 `UNUserNotificationCenter`에 할당 할 필요가 없음. `UNUserNotificationCenterDelegate`는 경고 알림을 처리 할 때만 사용되기 때문.
* `registerForRemoteNotifications`가 호출 되었기 때문에 **디바이스 토큰 수신을 처리**해야하며 자체 등록을 위해 해당 **디바이스를 푸시 서버로 보내야 함**. 이는 경고 알림을 위해 수행해야하는 작업과 정확히 동일함.



```swift
// Background notification payload: 백그라운드 알림에 대한 페이로드
{
	"aps" : {
			"content-available" : 1 
	}, 
	"myCustomKey" : "myCustomData"
}
```

* 백그라운드 알림에 필요한 유일한 필드는 **aps 사전 내의 콘텐츠 사용 가능 필드**입니다. 이 필드는 이것이 **백그라운드 알림이며 업데이트를 수행하기 위해 애플리케이션을 실행해야 함을 시스템에 알려줌.**
* 경고 알림과 마찬가지로 **aps 사전 외부를 사용자 지정 데이터에 사용할 수 있음**.



###  백그라운드 푸시를 처리하는 방법

* 장치가 원격 알림을 받으면 `didReceiveRemoteNotification`이 호출됨. 이 함수에는 `completeHandler`도 있음. 그러나 경고 알림을 처리 할 때의 `completeHandler`와 달리 이 `completeHandler`에는 하나의 매개 변수가 있음. 이 매개 변수는 **백그라운드 업데이트가 실패했는지 여부를 시스템에 알려주는 열거형**임. 이를 통해 시스템은 미래에 애플리케이션을 실행할 시기를  파악할 수 있음.

```swift
// 레스토랑 애플리케이션 콘텐츠가 최신 상태인지 확인하기 위해 매일 메뉴를 가져 오는 데에 백그라운드 알림이 사용됨.
func application(_ application: UIApplication, 
									didReceiveRemoteNotification userInfo: [AnyHashable: Any], 
									fetchCompletionHandler completionHandler: 
									@escaping (UIBackgroundFetchResult) -> Void) {
  guard let url = URL(string: "www.example.com/todays-menu") else {
    completionHanler(.failed) // 현재 버전의 메뉴에 대한 URL을 만들지 못한 경우, 완료 핸들러를 호출하고 백그라운드 업데이트가 실패했음을 알림.
    return 
  }
  
  // URL이 생성되면 오늘의 메뉴 데이터를 가져 오기 위해 URLSession을 생성해야 함.
  let task = URLSession.shared.dataTask(with: url) { data, response, error in 
		guard let data = data else {
      completionHanler(.noData) // 데이터가 수신되지 않은 경우, 완료 핸들러를 호출. 백그라운드 업데이트가 데이터 없이 성공적으로 완료되었음을 알려줌.
      return 
    }
		
		updateMenu(withData: data) // 업데이트 된 메뉴를 가져 왔으므로 애플리케이션은 해당 데이터를 사용하여 콘텐츠를 업데이트 함.
		completionHandler(.newData) // 완료 핸들러를 호출. 백그라운드 업데이트가 성공, 새 데이터를 검색했음을 시스템에 알림.
	}
}
```



[출처](https://developer.apple.com/videos/play/wwdc2020/10095/)