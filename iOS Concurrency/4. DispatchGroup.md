# <iOS Concurrency 프로그래밍, 동기 비동기 처리 그리고 GCD/Operation - 디스패치큐와 오퍼레이션큐의 이해> 강의 정리



## GCD - 4. 디스패치 그룹

## 1) 디스패치 그룹의 개념

*  여러 스레드에서 진행 중인 그룹에 속한 작업들이 언제 끝날지 알기 위하여 필요함
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
// 그룹의 모든 작업이 완료됐을 때 알림 받음
group1.notify(queue: defaultQueue) {
  print("모든 작업 완료")
}
```



* 어떤 이유로 그룹의 완료 알림에 비동기적으로 응답할 수 없는 경우, 디스패치 그룹에서 `wait` 메서드를 사용할 수 있음. **모든 작업이 완료될 때까지 현재 대기열을 차단하는 동기적 방법임.** 작업이 완료될 때까지, 얼마나 오래 기다릴지 기다리는 시간을 지정하는 파라미터(optional)가 필요함.(지정하지 않으면 무한 대기)
* 메인 스레드에서는 앱이 멈추기 때문에 사용하면 안됨.

```swift
let group1 = DispatchQroup() 
DispacthQueue.global().async(group: group1) { } 

// 그룹의 모든 작업이 끝나야 다음 작업을 할 수 있는 상황이라면 사용
// 현재 큐에서 '동기적인 요청'이기 때문에 현재 큐가 블락됨
// 그룹 내에서 현재 큐를 사용하길 원하는 다른 작업이 있다면 데드락이 발생할 가능성이 있음
group1.wait(timeout: DispatchTime.distantFuture)

if group1.wait(timeout: .now() + 60) == .timeOut {
  print("작업이 60초 안에 종료되지 않았습니다.")
}
```



## 2) 디스패치 그룹의 사용 (비동기 디스패치 그룹)

```swift
let group1 = DispatchGroup() 
DispatchQueue.global(qos: ).async(group: group1) {
	print("async group task started")
	asyncMethod(input: url) { result in 
	
	}
	print("async group task finished")
}
```


[출처](https://www.inflearn.com/course/iOS-Concurrency-GCD-Operation/dashboard)
