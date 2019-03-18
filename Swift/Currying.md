# Currying

* 여러 개의 매개변수를 갖는 함수를 하나의 매개변수를 가지는 함수의 나열로 표현하는 방법

* 함수를 만드는 함수~^0^
* func 함수를 만드는 함수(인자: 인자타입) -> ((인자타입) -> 결과타입)



Ex) 

두 Int 값을 받아서 덧셈을 하고 결과값을 리턴해주는 함수

기존 방법 :

```swift
func add(_ value1: Int, _ value2: Int) -> Int {

	return value1 + value2

}

add(2,3)
```

```swift
func currideAdd(_ value: Int) -> ( (Int) -> Int ) {

	return { value2 in
		return value1 + value2
	}
}
let add2 = curriedAdd(2)

add2(3)

curriedAdd(2)(3)
```



Ex2) 

문자열을 쪼개서 배열을 만들어 보자

기존 방법

`"aaa/bbb/ccc/ddd".components(separatedBy: "/")`

`"aaa*bbb*ccc*ddd".components(separatedBy: "*")`



커링 방법

```swift
func stringDevider(_ seperater: String) -> (String) -> [String] {

	return { (string: String) -> [String] in

		return string.components(separatedBy: separator)

	}

}

let stringDevideBySlash = stringDevider("/")

let stringDevideByAsterisk = stringDevider("*")

stringDevideBySlash("aaa/bbb/ccc/ddd")`

stringDevideByAsterisk("aaa*bbb*ccc*ddd")
```







# 클래스 인스턴스가 함수를 콜하는 방법

```swift
class SomeClass {

	func someFuction() {

	}
}

let someInstance = SomeClass()

someInstance.someFunction()



SomeClass.someFunction(someInstance)()
```



클래스 객체를 인자로 받아 함수를 리턴해줌.(?)

멤버 함수를 리턴해주는 클래스 함수임.



#  

```swift
func regexTest(pattern: String) -> (String) -> Bool {

	let expression: NSRegularExpression? = try? NSRegularExpression(pattern: pattern, 

					options: .caseInsensitive)

	return { (input: String) -> Bool in

	guard let expression = expression else { return false }

	let inputRange = NSMakeRange(0, input.characters.count)

	let matches = expression.matches(in: input,

									options: [],

									range: inputRange)

	return matches.count > 0

	}

}

regesTest(pattern: "main")("int main()")



let hasMainIn = regexTest(pattern: "main")

hasMainIn("int main()")
```





** 클래스 방법**

```swift
class Regex {

	var internalExpression: NSRegularExpression?

	init(_ pattern: String) {

		self.internalExpression = 

			try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)

	}

	func test(_ input: String) -> Bool {

		let inputRange = NSMakeRange(0, input.characters.count)

		guard let matchesCount = self.internalExpression?

			.matches(in: input, options: [], range: inputRange)

			.count else { return false }

		return matchesCount > 0
	}
}

let regex = Regex("main")

regex.test("int main()")

Regex("main").test("int main()")
```





# 액션시트로 친구 초대

**친구 구조체**

struct Friend {

​	var name: String

​	var id: Int

}



**친구 데이터**

let friends = [Friend(name: "키윈도", id: 1)

​			Friend(name: "엉덩숭아", id: 2)]



**초대 API**

func inviteFriend(ID: Int) -> Void



**알럿 컨트롤러 생성**

let actionsheet = UIAlertController(title: "친구", message: "초대받을 친구 선택", preferredStyle: .actionSheet)



**알럿 액션 생성자 타입**

UIAlertAction(title: String?, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)?)



**알럿 액션 핸들러**

func actionHandler(friendID: Int) -> (UIAlertAction) -> () {

​	return { [weak self] action -> Void in

​		self?.inviteFriend(ID: friendID)

​	}

}



**알럿 액션 추가**

friends.forEach { (friend: Friend) in

​	actionsheet.addAction(UIAlertAction(title: friend.name,

​									style: UIAlertActionStyle.default,

handler: actionHandler(friendID: friend.id)))

}

actionsheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))





# 애니메이션 예제

그냥

@IBAction func leftButtonTapped(_ sender: Any) {

​	UIView.animate(withDurtion: 0.5, animations: { 

​		var frame = self.yellowBox.frame

​		frame.origin.x = frame.origin.x - 100

​		self.yellowBox.frame = frame

​	}, completion: nil)

}



커링

enum AnimationDirection {

​	case up

​	case down

​	case left

​	case right

}

extension ViewController {

​	func moveBox(to: AnimationDirection) -> () -> Void {

​		return {

​			var frame = self.yellowBox.frame

​			switch to {

​			case .left: 

​				frame.origin.x = frame.origin.x - 100

​			case .right:

​				frame.origin.x = frame.origin.x + 100

​			case .down: 

​				frame.origin.y = frame.origin.y + 100

​			case .up:

​				frame.origin.y = frame.origin.y - 100

​			}

​			self.yellowBox.frame = frame

​		}

​	}

@IBAction func leftButtonTapped(_ sender: Any) {

​	UIView.animate(withDuration: 0.5,

​					animations: moveBox(to: .left),

​					completion: nil)

}





# 지정된 타입의 API 확장

* 게시판을 보여주는 뷰컨트롤러가 있다.
* 게시판을 불러오는 API 함수는 클로저로 저장한다.
* 여러가지 게시판을 하나의 뷰 컨트롤러로 보여준다.
* Var api: (pageID: Int) -> Observable<[Post]>



**api 함수 세팅**

viewController.api = { (pageID: Int) -> Observable<[Post]> in

​	// alamofire 따위로 api 콜 후 Observable Return

}

**Search API 추가**

func searchAPI(searchText: String) -> (Int) -> Observable<[Post]>

self.api = searchAPI(searchText: "search keywords")





# 함수 합성

g(f(x))



# 바인딩

let result = bind(add2, 3) // result => 5



 















참고 : https://academy.realm.io/kr/posts/currying-on-the-swift-functions/

** 나중에 다시 봐야지



















