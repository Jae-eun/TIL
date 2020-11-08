# <iOS Concurrency 프로그래밍, 동기 비동기 처리 그리고 GCD/Operation - 디스패치큐와 오퍼레이션큐의 이해> 강의 정리



## GCD - 1. GCD/Operation에 앞서 



## 1) 왜 동시성 프로그래밍이 필요할까?

> 스레드가 여러 개이므로 작업을 한 곳이 아니라 여러 곳에 적절히 분배해주면 더 효율적인 작업이 가능하기 때문에.



- 작업(`Task`)을 어떻게 분산시킬지. 어떻게 다른 쓰레드에서 동시에 일하게 할 수 있을지. => **동시성 프로그래밍**
- iOS 환경에서는 작업을 **대기행렬**(`Queue`) 에 보내기만 하면 자동으로 처리가 됨.
- 큐에 들어있는 작업은 항상 선입선출(`FIFO`)로 동작함. 작업이 먼저 시작했다고 해서 먼저 끝나는 것은 아님. 



## 2) 간단한 GCD/Operation 소개 

- 개발자가 직접 스레드를 관리하지 않고, **'큐(Queue)'(대기열/대기행렬)** 라는 개념을 이용해 작업을 분산 처리
- GCD / Operation 을 사용해 **시스템에서 알아서 쓰레드 숫자를 관리**함 
  - (직접 스레드를 생성하는 것은 하드웨어나 일의 부하(load)와 같은 시스템에 대한 지식없이 사용하면 오히려 앱이 느려질 수 있음)
- 스레드보다 더 높은 레벨에서 일을 한다고 보면 됨
- 다른 스레드에서 **(오래 걸리는) 작업들이 비동기적으로 동작** 하도록 쉽게 만들어 줌
  - (어떤 API들은 내부적으로 다른 스레드에서 비동기적으로 실행되도록 설계되어 있음)



### 코드 예시

```swift
// 큐에 보낼거야. 글로벌큐에. 비동기적으로
DispatchQueue.global().async {
	// 이 안에 들어 있는 작업을
}

let queue = DispatchQueue.global() // 보낼 큐의 종류를 선언
queue.async { // 그 큐에 비동기적으로 보낼거야
  // 클로저를
}

// 하나의 클로저 안에 들어간 작업들이 하나로 묶임
```

```swift
func secondTask0() -> String {
	return "작업1, "
}

func secondTask1(inString: String) -> String {
	return inString + "작업2, "
}

func secondTask2(inString: String) -> String {
	return inString + "작업3"
}

DispatchQueue.global().async {
  let out0 = secondTask0() 
  let out1 = secondTask1(inString: out0) 
  let out2 = secondTask2(inString: out1)
  print(out2)
}
```



### GCD(`Grand Central Dispatch`) 디스패치큐

* 간단한 일(커뮤니케이션의 양)
* 함수를 사용하는 작업(메서드 위주)

### Operation 오퍼레이션큐

* 복잡한 일(커뮤니케이션의 양)
* 데이터와 기능을 캡슐화한 객체
* GCD를 기반으로 만들어짐. 취소/순서지정/일시중지(상태추척)을 할 수 있음
* 클래스로 만들어진 객체임. 재사용이 편리함. 



## 3) Synchronous(동기) vs Asynchonous(비동기)

```swift 
DispatchQueue.global().async {

}
// 원래의 작업이 진행되고 있던 곳(메인 스레드)에서 디스패치 글로벌 큐로 보낸 작업이 끝나기를 기다리지 않음.
// 기다리지 않아도 다음 작업을 생성할 수 있다.

DispatchQueue.global().sync {

}
// 원래 작업이 진행되고 있던 곳(메인 스레드)에서 디스패치 글로벌 큐로 보낸 작업이 끝날 때까지 동기적으로 기다림
// 실질적으로 메인 스레드에서 동작하게 됨
// 작업이 끝나기를 기다린 후 다음 작업을 생성할 수 있다.
```

```swift
let queue = DispatchQueue.global() 

func task1() {
	print("Task 1 시작")
	sleep(1)
	print("Task 1 완료")
}

func task2() {
	print("Task 2 시작")
	print("Task 2 완료")
}

func task3() {
	print("Task 3 시작")
	sleep(3)
	print("Task 3 완료")
}

func task4() {
	print("Task 4 시작")
	sleep(4)
	print("Task 4 완료")
}

queue.async {
  task1() 
}

queue.async {
  task2() 
}

queue.async {
  task3() 
}

// Task 1 시작
// Task 2 시작
// Task 3 시작
// Task 2 완료
// Task 1 완료
// Task 3 완료


task1() 
task2() 
task3() 
task4() 

// Task 1 시작
// Task 1 완료
// Task 2 시작
// Task 2 완료
// Task 3 시작
// Task 3 완료
// Task 4 시작
// Task 4 완료
```



## 4) Serial(직렬) vs Concurrency(동시)

### Serial 큐

* (보통 메인에서) 분산처리 시킨 작업을 **다른 한개의 스레드에서** 처리하는 큐
* 순서가 중요한 작업을 처리할 때 사용함

### Concurrent 큐

* (보통 메인에서) 분산처리 시킨 작업을 **다른 여러 개의 스레드에서** 처리하는 큐
* 각자 독립적이지만 유사한 여러 개의 작업을 처리할 때 사용함



[출처](https://www.inflearn.com/course/iOS-Concurrency-GCD-Operation/dashboard)