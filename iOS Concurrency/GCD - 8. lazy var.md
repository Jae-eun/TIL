# (심화) Lazy var와 관련된 이슈들

* 여러 스레드에서 객체 내의 `lazy var`에 동시에 접근하게 될 수 있음.
* 쓰기 작업과 유사하게 메모리에 로딩되는 시간이 좀 걸림.



### 1) Thread-safe하지 않은 Lazy var의 경우

```swift
// 디스패치 커스텀 동시큐의 생성
let queue = DispatchQueue(label: "text", qos: .default, attributes: [.initiallyInactive, .concurrent])
// initiallyInactive: 처음에는 비활성화됨. 큐로 작업을 보내도 즉시 실행되지 않음.

// 디스패치그룹 생성
let group1 = DispatchGroup()

// 1번 케이스: 메모리에 lazy var 변수가 여러 개 생기는 이슈
class SharedInstanceClass1 {
    lazy var testVar = {
        return Int.random(in: 0..<99)
    }()
}

// 객체 생성
let instance1 = SharedInstanceClass1()

// 실제 비동기 작업 실행
for i in 0..<10 {
    group1.enter()
    queue.async(group: group1) {
        print("id\(i), lazy var 이슈: \(instance1.testVar)")
        group1.leave()
    }
}

group1.notify(queue: DispatchQueue.global()) {
    print("lazy var 이슈가 생기는 모든 작업 완료")
}

queue.activate() // 활성화됨. 작업이 실행됨.
group1.wait() // 동기적으로 작업이 끝날 때까지 기다림

// id7, lazy var 이슈: 56
// id2, lazy var 이슈: 40
// id3, lazy var 이슈: 95
// id6, lazy var 이슈: 80
// id1, lazy var 이슈: 93
// id9, lazy var 이슈: 8
// id0, lazy var 이슈: 44
// id5, lazy var 이슈: 54
// id4, lazy var 이슈: 30
// id8, lazy var 이슈: 96
// lazy var 이슈가 생기는 모든 작업 완료
```



### 2) 시리얼큐+Sync로 해결(Thread-safe 처리)

* 작업이 시리얼큐에 들어가서 동기적으로 차례를 기다린 후 작업됨.

```swift
// 객체 내부에서 처리하는 방법
// 2번 케이스: 시리얼큐로 해결(엄격한 Thread-safe)
class SharedInstanceClass2 {
    let serialQueue = DispatchQueue(label: "serial")

    lazy var testVar = {
        return Int.random(in: 0...100)
    }()

    // 객체 내부에서 시리얼큐로 다시 testVar에 접근하도록
    var readVar: Int {
        serialQueue.sync {
            return testVar
        }
    }
}

// 디스패치그룹 생성
let group2 = DispatchGroup()

// 객체 생성
let instance2 = SharedInstanceClass2()

for i in 0..<10 {
    group2.enter()
    queue.async(group: group2) {
        print("id:\(i), lazy var 이슈: \(instance2.readVar)")
        group2.leave()
    }
}

group2.notify(queue: DispatchQueue.global()) {
    print("시리얼큐로 해결한 모든 작업 완료")
}

queue.activate()
group2.wait()

// id:1, lazy var 이슈: 97
// id:8, lazy var 이슈: 97
// id:3, lazy var 이슈: 97
// id:2, lazy var 이슈: 97
// id:4, lazy var 이슈: 97
// id:5, lazy var 이슈: 97
// id:6, lazy var 이슈: 97
// id:7, lazy var 이슈: 97
// id:0, lazy var 이슈: 97
// id:9, lazy var 이슈: 97
// 시리얼큐로 해결한 모든 작업 완료
```



### 3) Dispatch Barrier로 해결 (Thread-safe 처리)

* 한 번에 하나의 스레드에서 한 작업씩만 접근할 수 있도록 함

```swift
// 보내는 작업 자체를 배리어 처리하는 방법
// 3번 케이스: 배리어 작업으로 해결 (Thread-safe)
class SharedInstanceClass3 {
    lazy var testVar = {
        return Int.random(in: 0...100)
    }()
}

// 디스패치그룹 생성
let group3 = DispatchGroup()

// 객체 생성
let instance3 = SharedInstanceClass3()

// 실제 비동기 작업 실행
for i in 0..<10 {
    group3.enter()
    queue.async(flags: .barrier) {
        print("id:\(i), lazy var 이슈: \(instance3.testVar)")
        group3.leave()
    }
}

group3.notify(queue: DispatchQueue.global()) {
    print("디스패치 배리어로 해결한 모든 작업 종료")
}

group3.wait()

// id:0, lazy var 이슈: 54
// id:1, lazy var 이슈: 54
// id:2, lazy var 이슈: 54
// id:3, lazy var 이슈: 54
// id:4, lazy var 이슈: 54
// id:5, lazy var 이슈: 54
// id:6, lazy var 이슈: 54
// id:7, lazy var 이슈: 54
// id:8, lazy var 이슈: 54
// id:9, lazy var 이슈: 54
// 디스패치 배리어로 해결한 모든 작업 종료
```



### 4) DispatchSemaphore로 해결 (Thread-safe)

* 작업 수를 제한하여 큐에서 나머지 작업들이 기다리도록 함

```swift
// 4번 케이스: 디스패치 세마포어로 해결 (Thread-safe)
class SharedInstanceClass4 {
    lazy var testVar = {
        return Int.random(in: 0...100)
    }()
}

// 디스패치그룹 생성
let group4 = DispatchGroup()

// 객체 생성
let instance4 = SharedInstanceClass4()

let semaphore = DispatchSemaphore(value: 1)

// 실제 비동기 작업 실행
for i in 0..<10 {
    group4.enter()
    semaphore.wait()
    queue.async(group: group4) {
        print("id:\(i), lazy var 이슈: \(instance4.testVar)")
        group4.leave()
        semaphore.signal()
    }
}

group4.notify(queue: DispatchQueue.global()) {
    print("디스패치 세마포어로 해결한 모든 작업 완료")
}

// id:0, lazy var 이슈: 64
// id:1, lazy var 이슈: 64
// id:2, lazy var 이슈: 64
// id:3, lazy var 이슈: 64
// id:4, lazy var 이슈: 64
// id:5, lazy var 이슈: 64
// id:6, lazy var 이슈: 64
// id:7, lazy var 이슈: 64
// id:8, lazy var 이슈: 64
// id:9, lazy var 이슈: 64
// 디스패치 세마포어로 해결한 모든 작업 완료
```



### `Lazy var` 의 Thread-safe 처리 방법

> 1. 명확하게 lazy 변수 생성 후 작업
> 2. 시리열큐 + Sync 로 작업
> 3. Dispatch Barrier 로 작업
> 4. 세마포어 이용, 작업의 동시 실행 개수를 제한



[출처](https://www.inflearn.com/course/iOS-Concurrency-GCD-Operation/dashboard)