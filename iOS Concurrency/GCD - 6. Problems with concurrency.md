# (심화) 동시성과 관련된 문제

> * **2개 이상의 스레드를 사용하면서 동일한 메모리 접근 등으로 인해 발생할 수 있는 문제**
> * Thread-safe: 여러 스레드가 동시에 쓰여도 안전하다. => 동시적 처리



## 1) Race Condition (경쟁 상황)

* **2개 이상의 스레드에서 공유된 데이터(변수나 객체)에 동시적으로 접근하는 경우**

=> **한 번에 한 개의 스레드만 접근 가능하도록 처리**하여 경쟁 상황이 발생하지 않도록 함.

```swift
var a = 1 

DispatchQueue.global().async {
  sleep(1)
  a += 1
}

DispatchQueue.global().async {
  sleep(1)
  a += 1
}

print(a) // 1
```

```swift

// 하나의 값에 여러 개의 스레드가 접근하는 간단한 예제

var value = 777

func changeValue() {
    sleep(2)
    value = 555
}

func changeValue1() {
    sleep(1)
    value = 888
}

func changeValue2() {
    sleep(1)
    value = 0
}

// (동기적 실행) 앞의 작업이 다 끝나야 다음 코드가 실행됨
changeValue()
changeValue1()
changeValue2()

print("(동기)함수 실행값:", value) //(동기)함수 실행값: 0


// 비동기적인 경쟁적 상황

let queue = DispatchQueue(label: "serial")

value = 777

queue.async {
    changeValue()
}

queue.async {
    changeValue1()
}

queue.async {
    changeValue2()
}

print("(비동기)함수 실행값:", value) //(비동기)함수 실행값: 777
// 함수가 동작하기 전에 print문이 실행되어서 값이 변경되지 않음

sleep(3)


// 간단한 해결 방법
// 동기적으로 보냄(현재 스레드를 block하고 기다림) => 경쟁상황을 제거
// (실제로는 사용하면 안됨. 메인 스레드를 block하고 기다리기 때문에 UI 반응이 느려질 수 있음)

value = 777

queue.sync {
    changeValue()
}

queue.sync {
    changeValue1()
}

queue.sync {
    changeValue2()
}

print("동기적으로 실행한 값:", value) //동기적으로 실행한 값: 0
```

```swift
open class Person {
    private var firstName: String
    private var lastName: String

    public init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }

    open func changeName(firstName: String, lastName: String) {
        sleep(1)
        self.firstName = firstName
        sleep(2)
        self.lastName = lastName
    }

    open var name: String {
        return "\(firstName) \(lastName)"
    }
}

// 비동기적인 실행으로(여러 스레드에서) 하나의 객체에 접근하는 예제
// 여러 스레드가 동일한 데이터에 접근하면 항상 Thread-safe를 고려해야 함

let person = Person(firstName: "길동", lastName: "홍")

person.changeName(firstName: "꺽정", lastName: "임") // "꺽정 임"

let nameList = [("재석", "유"), ("동엽", "신"), ("나래", "박"), ("도연", "장"), ("명수", "박"), ]
let concurrentQueue = DispatchQueue(label: "com.jaeeun.concurrent", attributes: .concurrent)
let nameChangeGroup = DispatchGroup()

// 이름 바꾸는 작업을 비동기적으로 동시큐(여러 스레드)에서 접근하기 때문에 일관되지 않은 처리가 일어남
for (idx, name) in nameList.enumerated() {
    concurrentQueue.async(group: nameChangeGroup) {
        usleep(UInt32(10000 * idx))
        person.changeName(firstName: name.0, lastName: name.1)
        print("현재 이름: \(person.name)")
    }
}

nameChangeGroup.notify(queue: DispatchQueue.global()) {
    print("마지막 이름: \(person.name)")
}

nameChangeGroup.wait()

// 여러 스레드에서 동시다발적으로 쓰기(`changeName()`)와 읽기(`print()`)가 발생하고 있음

//현재 이름: 명수 유
//현재 이름: 명수 신
//현재 이름: 명수 박
//현재 이름: 명수 장
//현재 이름: 명수 박
//마지막 이름: 명수 박
```



## 2) Deadlocks (교착 상태)

* **여러 스레드가 한정된 자원을 사용해야 할 때, 서로 점유하려고 하면서 자원을 얻지 못해 다음 처리를 못하고 있는 상태**
* 작업이 진행되지 않음
  * ex) 동기 작업이 현재 스레드가 필요한 경우
  * ex) 앞선 작업이 현재 스레드가 필요한 경우
  * ex) 여러 개의 세마포어가 존재하는데 자원에 대한 사용 순서를 잘못 설계했을 때 등

=> **시리얼큐(`Serial Queue`)**로 해결 가능

​	: 작업이 순서대로 실행될 것이기 때문. 여러 스레드에서 접근하는 것이 아니라 하나의 스레드가 메모리에 접근함. 

​	: 세마포어나 제한된 리소스 순서 등에 주의해야 함. 



## 3) Priority Inversion (우선 순위 뒤바뀜)

* **낮은 우선 순위의 작업이 작업을 배타적으로 사용하고 있을 때(다른 작업이 자원을 사용하지 못하게 막고 있으므로), 작업의 우선 순위가 바뀔 수 있음.**
* ex) 우선 순위 뒤바뀜이 발생할 수 있는 경우

> * Serial Queue에서 높은 우선 순위 작업이 낮은 우선 순위의 뒤에 보내지는 경우
> * 낮은 우선 순위의 작업이 높은 우선 순위가 필요한 자원을 잠그고 있는 경우 (lock 코드, 세마포어 등)
> * 높은 우선 순위 작업이 낮은 작업에 의존하는(dependency) 경우 (`Operation`)

=> **1차적으로 GCD가 알아서 우선 순위를 조정하면서 해결함. **

> 우선 순위가 높은 작업이 필요한 자원을 잠그고 있는 작업의 우선 순위를 높게 만들어 우선적으로 일을 끝내도록 함.

=> **작업들이 공유된 자원에 접근할 때는 동일한 QoS를 사용하는 것이 안전함.**

```swift
// 세마포어 사용으로 인해 우선순위가 바뀔 수 있는 예제
// Qos는 다르지만, 모두 글로벌 동시큐
let highQueue = DispatchQueue.global(qos: .userInitiated)
let mediumQueue = DispatchQueue.global(qos: .utility)
let lowQueue = DispatchQueue.global(qos: .background)

let semaphore = DispatchSemaphore(value: 1)

highQueue.async {
    sleep(3) // 3초간 잠재워서 low 퀄리티의 작업이 '세마포어'를 우선 배정받게 됨
    semaphore.wait()
    print("우선순위 높은 task 1번")
    semaphore.signal()
}

for i in 2...11 {
    // 증간 우선순위의 작업은 세마포어로 제한하지 않음
    mediumQueue.async {
        print("우선순위 중간 task \(i)번")
        sleep(UInt32(Int.random(in: 1...7)))
    }
}

lowQueue.async {
    semaphore.wait()
    print("우선순위 낮은 task 12번")
    sleep(5)
    semaphore.signal()
}

sleep(10)

// 이 예제에서 low 퀄리티의 작업이 세마포어를 먼저 사용하기 때문에
// high 퀄리티의 작업은 low 퀄리티의 작업이 종료해야만 작업을 실행하게 됨

//우선순위 중간 task 8번
//우선순위 중간 task 3번
//우선순위 중간 task 9번
//우선순위 중간 task 10번
//우선순위 중간 task 5번
//우선순위 중간 task 7번
//우선순위 중간 task 4번
//우선순위 중간 task 11번
//우선순위 중간 task 6번
//우선순위 중간 task 2번
//우선순위 낮은 task 12번
//우선순위 높은 task 1번
```



[출처](https://www.inflearn.com/course/iOS-Concurrency-GCD-Operation/dashboard)