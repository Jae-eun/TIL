# <iOS Concurrency 프로그래밍, 동기 비동기 처리 그리고 GCD/Operation - 디스패치큐와 오퍼레이션큐의 이해> 강의 정리



## GCD - 4. 디스패치 그룹

## 1) 디스패치 그룹의 개념

*  여러 스레드에서 진행 중인 작업들이 언제 끝날지 알기 위하여 필요함
* Ex) 여러 애니메이션 효과가 겹쳐있을 때, 애니메이션이 모두 종료된 시점을 알기 위해

```swift
let group1 = DispatchGroup() 
DispatchQueue.global(qos: ).async(group: group1) { } // 큐로 보낼 때, 어떤 그룹에 넣을 것인지 정함
DispatchQueue.global().async(group: group1) { } // 보내는 작업들이 같은 큐에 들어가지 않아도 됨

group1.notify(queue: DispatchQueue.main) { [weak self] in 
	self?.textLabel.text = "모든 작업이 완료되었습니다."
}
```



```swift
public func slowAdd(_ input: (Int, Int)) -> Int {
  sleep(1) 
  return input.0 + input.1 
}

public func slowAddArray(_ input: [(Int, Int)], progress: ((Double) -> (Bool))? = nil) -> [Int] {
  var results = [Int]() 
  for pair in input {
    results.append(slowAdd(pair))
    if let progress = progress {
      if !progress(Double(results.count) / Double(input.count)) { return results }
    }
  }
  return results 
}

private let workerQueue = DispatchQueue(label: "com.raywenderlich.slowsum", attributes: DispatchQueue.Attributes.concurrent)

public func asyncAdd_GCD(_ input: (Int, Int), completionQueue: DispatchQueue, completion: @escaping (Int) -> ()) {
  workerQueue.async {
    let result = slowAdd(input) 
    completionQueue.async {
      completion(result)
    }
  }
}

private let additionQueue = OperationQueue() 
public func asyncAdd_OpQ(lhs: Int, rhs: Int, callback: @escaping (Int) -> ()) {
  additionQueue.addOperation {
    sleep(1)
    callback(lhs + rhs)
  }
}

let workingQueue = DispatchQueue(label: "com.inflearn.concurrent", attributes: .concurrent)
let numberArray = [(0,1), (2,3), (4,5), (6,7), (8,9), (10,11)]

// 디스패치 그룹 생성
let group1 = DispatchGroup() 

for inValue in numberArray {
	workingQueue.async(group: group1) {
  	let result = slowAdd(inValue)
  	print("더한 결과값 출력하기 = \(result)")
  }
}

let defaultQueue = DispatchQueue.global()
// 그룹의 모든 작업이 완료됐을 때 실행
group1.notify(queue: defaultQueue) {
  print("모든 작업 완료")
}

// 더한 결과값 출력하기 = 5
// 더한 결과값 출력하기 = 1
// 더한 결과값 출력하기 = 21
// 더한 결과값 출력하기 = 13
// 더한 결과값 출력하기 = 17
// 더한 결과값 출력하기 = 9
// group1 안의 모든 작업 완료
```



* **동기적으로 기다리는 메서드(`wait()`)** : 어떤 이유로 그룹의 완료 알림에 비동기적으로 응답할 수 없는 경우, 디스패치 그룹에서 `wait` 메서드를 사용할 수 있음. **모든 작업이 완료될 때까지 현재 대기열을 차단하는 동기적 방법임.** 작업이 완료될 때까지, 얼마나 오래 기다릴지 기다리는 시간을 지정하는 파라미터(optional)가 필요함.(지정하지 않으면 무한 대기)
* 메인 스레드에서는 앱이 멈추기 때문에 사용하면 안됨.

```swift
let group1 = DispatchGroup() 
DispacthQueue.global().async(group: group1) { } 

// 그룹의 모든 작업이 끝나야 다음 작업을 할 수 있는 상황이라면 사용
// 현재 큐에서 '동기적인 요청'이기 때문에 현재 큐가 블락됨
// 그룹 내에서 현재 큐를 사용하길 원하는 다른 작업이 있다면 데드락이 발생할 가능성이 있음
group1.wait(timeout: DispatchTime.distantFuture)

// 시간 제한 걸어두고 기다리기
if group1.wait(timeout: .now() + 60) == .timeOut {
  print("작업이 60초 안에 종료되지 않았습니다.")
}
```





## 2) 디스패치 그룹의 사용 (비동기 디스패치 그룹)

* 디스패치 그룹의 클로저 안에서 비동기 함수를 호출할 경우 발생할 수 있는 문제

  > 작업 시작할 때 `enter()` 호출, 비동기 작업이 실질적으로 종료될 때 컴플리션 핸들러에 `leave()` 호출
  >
  > => 비동기 디스패치 그룹 함수를 만들 수 있음. 

```swift
let group1 = DispatchGroup() 

DispatchQueue.global(qos: ).async(group: group1) {
	print("async group task started")
	asyncMethod(input: url) { result in // 다른 스레드에서 작업됨. 완전히 작업이 끝난 시점을 알 수 없음.
	
	}
	print("async group task finished")
}

queue.async(group: group1) {
  group1.enter() 
  someAsyncMethod { 
  	group1.leave() 
  }
}
```

```swift

public func slowAdd(_ input: (Int, Int)) -> Int {
  sleep(1)
  return input.0 + input.1
}

// * 비동기 디스패치 그룹함수 만들기
// 기존의 비동기 API를 래핑해서 비동기 디스패치 그룹함수 만들어 보기

let workingQueue = DispatchQueue(label: "com.inflearn.concurrent", attributes: .concurrent)
let defaultQueue = DispatchQueue.global()

let numbers = [(0, 1), (2, 3), (4, 5), (6, 7), (8, 9), (10, 11)]

// 1. 기존의 동기적인 함수를 비동기 함수로 만들기
func asyncAdd(_ input: (Int, Int),
              runQueue: DispatchQueue,
              completionQueue: DispatchQueue,
              completion: @escaping (Int, Error?) -> ()) {
    runQueue.async {
        var error: Error?
        error = .none

        let result = slowAdd(input)
        completionQueue.async {
            completion(result, error)
        }
    }
}

// 2. 비동기 디스패치 그룹함수 만들기
// 1과 유사, '디스패치 그룹' 아규먼트 추가
func asyncAdd_Group(_ input: (Int, Int),
                    runQueue: DispatchQueue,
                    completionQueue: DispatchQueue,
                    group: DispatchGroup,
                    completion: @escaping (Int, Error?) -> ()) {
    group.enter()
    asyncAdd(input, runQueue: runQueue, completionQueue: completionQueue) { (result, error) in
        completion(result, error)
        group.leave() // 컴플리션 핸들러에서 끝나는 시점 알기 위해
    }
}

// 3. 사용
// 디스패치 그룹 생성
let wrappedGroup = DispatchGroup()

// 반복문으로 비동기 그룹함수 활용
for pair in numbers {
    asyncAdd_Group(pair, runQueue: workingQueue, completionQueue: defaultQueue, group: wrappedGroup) { (result, error) in
        print("결과값 출력 = \(result)")
    }
}

// 모든 비동기 작업이 끝났음을 알림
wrappedGroup.notify(queue: defaultQueue) {
    print("모든 작업이 완료되었습니다.")
}

// 결과값 출력 = 1
// 결과값 출력 = 17
// 결과값 출력 = 5
// 결과값 출력 = 13
// 결과값 출력 = 21
// 결과값 출력 = 9
// 모든 작업이 완료되었습니다.
```



> ```swift
> // 플레이그라운드 현재 페이지를 계속 실행하도록 함
> // 비동기인 작업이 다 끝나지 않았는데 플레이그라운드 실행이 멈출 수 있기 때문
> PlaygroundPage.current.needsIndefiniteExecution = true 
> PlaygroundPage.current.finishExecution() // 멈출 시점에서 실행
> ```



* **UIViewAnimationGroup**

> UIView 애니메이션은 비동기적(`asynchrounous`)임. 따라서 실제 동시에 작업되는 애니메이션들이 언제 완료되는지, 그 시점을 특정하기 어려움.

```swift
// 1. 먼저 UIView의 익스텐션에서 비동기 디스패치 그룹 만들기
// 디스패치그룹 아규먼트 추가
extension UIView {
    static func animate(withDuration duration: TimeInterval,
                        animations: @escaping () -> Void,
                        group: DispatchGroup,
                        completion: ((Bool) -> Void)?) {
        // 비동기 디스패치 그룹: enter(입장), leave(퇴장) 구현
        group.enter()
        animate(withDuration: duration, animations: animations) { (success) in
            completion?(success)
            group.leave()
        }
    }
}

// 2. 뷰 초기 설정

let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
view.backgroundColor = .red

let box = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
box.backgroundColor = .yellow
view.addSubview(box)

// 3. 디스패치 그룹 생성
let animationGroup = DispatchGroup()
PlaygroundPage.current.liveView = view

// 4. 그룹 애니메이션 메서드 실행
// 애니메이션 비동기적으로 실행
UIView.animate(withDuration: 1, animations: {
    box.center = CGPoint(x: 150, y: 150)
}, group: animationGroup, completion: { _ in
    UIView.animate(withDuration: 2, animations: {
        box.transform = CGAffineTransform(rotationAngle: .pi/4)
    }, group: animationGroup, completion: nil)
})

// 애니메이션 비동기적으로 실행
UIView.animate(withDuration: 1, animations: { () -> Void in
    view.backgroundColor = .blue
}, group: animationGroup, completion: nil)

// 애니메이션이 모두 종료하는 시점에 프린트
animationGroup.notify(queue: DispatchQueue.global()) {
    print("Animations Completed!")
}
```



* **URLSession 예제** 

```swift
let group = DispatchGroup()

let base = "https://images.unsplash.com/photo-"
let imageNames = [
    "1579962413362-65c6d6ba55de?ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80","1580394693981-254c3aeded6a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=3326&q=80", "1579202673506-ca3ce28943ef?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=934&q=80", "1535745049887-3cd1c8aef237?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=934&q=80", "1568389494699-9076492b22e7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=937&q=80",  "1566624790190-511a09f6ddbd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=934&q=80"]

let userQueue = DispatchQueue.global(qos: .userInitiated)

var downloadImages: [UIImage] = []

for name in imageNames {
    guard let url = URL(string: "\(base)\(name)") else { continue }

    group.enter()

    // URLSession 자체가 비동기 작업 처리임
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
        // defer로 클로저의 마지막에 사용하도록 등록할 수 있음
        defer { group.leave() }

        if error == nil, let data = data, let image = UIImage(data: data) {
            downloadImages.append(image)
        }
    }
    task.resume()
}

group.notify(queue: userQueue) {
    print("모든 다운로드 완료")
    PlaygroundPage.current.finishExecution()
}
```



## 3) (참고) Dispatch Work Item(디스패치 워크 아이템)

*  작업을 **클래스로 미리 정의**해 놓고 사용하는 **큐에 제출하기 위한 객체**

```swift

// 객체 생성. 클로저 안에 작업 정의
let item1 = DispatchWorkItem(qos: .utility) {
    print("task1: 출력하기")
    print("task2: 출력하기")
}

// default globalQueue로 생성됨
let item2 = DispatchWorkItem {
    print("task3: 출력하기")
    print("task4: 출력하기")
}

let queue = DispatchQueue(label: "com.inflearn.serial")
// DispatchWorkItem을 큐에 전달
queue.async(execute: item1)
queue.async(execute: item2)

// task1: 출력하기
// task2: 출력하기
// task3: 출력하기
// task4: 출력하기
```



* 빈약한 **취소** 기능 내장

  * `cancel()` 메서드 존재

    > 1. 작업이 아직 시작 안된 경우(큐에 있음) - 작업이 제거됨
    > 2. 작업이 실행중인 경우 - `isCancelled` 속성이 `true`로 설정됨 (실행중인 작업이 멈추지는 않음)

```swift
// 객체 생성. 클로저 안에 작업 정의
let item1 = DispatchWorkItem(qos: .utility) {
    print("task1: 출력하기")
    print("task2: 출력하기")
}

item1.cancel() // 작업이 이미 취소됨. item1은 실행되지 않음.

// default globalQueue로 생성됨
let item2 = DispatchWorkItem {
    print("task3: 출력하기")
    print("task4: 출력하기")
}

let queue = DispatchQueue(label: "com.inflearn.serial")
// DispatchWorkItem을 큐에 전달
queue.async(execute: item1)
queue.async(execute: item2)

// task3: 출력하기
// task4: 출력하기
```



* 빈약한 **순서** 기능 내장
  * `notify(queue: 실행할 큐, execute: 디스패치아이템)` 메서드 존재 : 다음에 실행할 작업을 지정함

```swift
// 객체 생성. 클로저 안에 작업 정의
let item1 = DispatchWorkItem(qos: .utility) {
    print("task1: 출력하기")
    print("task2: 출력하기")
}

// default globalQueue로 생성됨
let item2 = DispatchWorkItem {
    print("task3: 출력하기")
    print("task4: 출력하기")
}

item1.notify(queue: DispatchQueue.global(), execute: item2) // item1이 끝나면 알려서 item2 작업을 시작해라

let queue = DispatchQueue(label: "com.inflearn.serial")
// DispatchWorkItem을 큐에 전달
queue.async(execute: item1)

// task1: 출력하기
// task2: 출력하기
// task3: 출력하기
// task4: 출력하기
```

```swift
// * DispatchWorkItem
// 작업을 클로저에 담아 미리 생성한 후(캡슐화), 나중에 사용가능한 방법

let item1 = DispatchWorkItem(qos: .utility) {
    print("task1 시작")
    sleep(2)
    print("task1 완료")
}

let item2 = DispatchWorkItem(qos: .utility) {
    print("task2 시작")
    print("task2 완료")
}

// 시리얼큐이므로 작업이 순서대로 실행됨
let queue = DispatchQueue(label: "com.inflearn.serial")

queue.async(execute: item1)
queue.async(execute: item2)

//task1 시작
//task1 완료
//task2 시작
//task2 완료


// 취소 기능
sleep(3)
print(item2.isCancelled) // false
item2.cancel()
print(item2.isCancelled) // true


// 순서 기능
let queue2 = DispatchQueue(label: "com.inflearn.second", attributes: .concurrent)

let workItem3 = DispatchWorkItem {
    print("task3 시작")
    sleep(2)
    print("task3 완료")
}

let workItem4 = DispatchWorkItem {
    print("task4 시작")
    print("task4 완료")
}

// 다음 실행할 'DispatchWorkItem'을 지정
workItem3.notify(queue: DispatchQueue.global(), execute: workItem4)
queue2.async(execute: workItem3)

//task3 시작
//task3 완료
//task4 시작
//task4 완료
```



## 4) (심화) Dispatch Semaphore에 대한 이해

> `Semaphore`: 수기 신호

* **공유 리소스에 접근 가능한 작업 수를 제한해야 할 경우**
  * Ex) 다운로드 숫자를 제한해야 할 때

```swift
let semaphore = DispatchSemaphore(value: 3) // 작업 가능한 갯수 3

queue.async(group: group1) {
    group1.enter()
    semaphore.wait() // 기다려라 -1 => 작업 가능한 갯수 2
    someAsyncMethod {
        group1.leave()
        semaphore.signal() // 작업이 끝났으니까 다음 작업 시작해도 됨을 표시 +1 => 작업 가능한 갯수 3
    }
}
```

```swift
// * DispatchSemaphore
let group = DispatchGroup()
let queue = DispatchQueue.global(qos: .userInteractive)

let semaphore = DispatchSemaphore(value: 4) // 접근 가능한 작업수 4

for i in 1...10 {
    group.enter()
    semaphore.wait()
    queue.async(group: group) {
        print("시뮬레이팅 \(i) 시작")
        sleep(3)
        print("시뮬레이팅 \(i) 종료")
        semaphore.signal()
        group.leave()
    }
}

group.notify(queue: DispatchQueue.global()) {
    print("모든 일이 종료됨")
}

// 시뮬레이팅 1 시작
// 시뮬레이팅 2 시작
// 시뮬레이팅 3 시작
// 시뮬레이팅 4 시작
// 시뮬레이팅 1 종료
// 시뮬레이팅 3 종료
// 시뮬레이팅 2 종료
// 시뮬레이팅 5 시작
// 시뮬레이팅 6 시작
// 시뮬레이팅 7 시작
// 시뮬레이팅 4 종료
// 시뮬레이팅 8 시작
// 시뮬레이팅 5 종료
// 시뮬레이팅 6 종료
// 시뮬레이팅 9 시작
// 시뮬레이팅 10 시작
// 시뮬레이팅 7 종료
// 시뮬레이팅 8 종료
// 시뮬레이팅 9 종료
// 시뮬레이팅 10 종료
// 모든 일이 종료됨
```

```swift
// 실제 다운로드를 세마포어로 제한하는 예제
let downloadGroup = DispatchGroup()

let base = "https://images.unsplash.com/photo-"
let imageNames = [
    "1579962413362-65c6d6ba55de?ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80","1580394693981-254c3aeded6a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=3326&q=80", "1579202673506-ca3ce28943ef?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=934&q=80", "1535745049887-3cd1c8aef237?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=934&q=80", "1568389494699-9076492b22e7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=937&q=80",  "1566624790190-511a09f6ddbd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=934&q=80"]

let userQueue = DispatchQueue.global(qos: .userInitiated)

let downloadSemaphore = DispatchSemaphore(value: 4)
var downloadImages: [UIImage] = []

for name in imageNames {
    guard let url = URL(string: "\(base)\(name)") else { continue }

    downloadGroup.enter()
    downloadSemaphore.wait()

    let task = URLSession.shared.dataTask(with: url) { data, _, error in
        defer {
            downloadSemaphore.signal()
            downloadGroup.leave()
        }

        if error == nil, let data = data, let image = UIImage(data: data) {
            downloadImages.append(image)
        }
    }
    task.resume()
}

downloadGroup.notify(queue: userQueue) {
    print("모든 다운로드 완료")
    print(downloadImages)
}

// 모든 다운로드 완료
// [<UIImage:0x600003610090 anonymous {934, 1401}>, <UIImage:0x600003600360 anonymous {934, 1399}>, <UIImage:0x600003600900 anonymous {934, 1400}>, <UIImage:0x60000361c6c0 anonymous {937, 1392}>, <UIImage:0x60000360c900 anonymous {934, 1401}>, <UIImage:0x60000361c900 anonymous {3326, 2180}>]
```



[출처](https://www.inflearn.com/course/iOS-Concurrency-GCD-Operation/dashboard)