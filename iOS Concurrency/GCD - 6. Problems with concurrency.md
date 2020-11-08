# (심화) 동시성과 관련된 문제

> **2개 이상의 스레드를 사용**하면서 **동일한 메모리 접근** 등으로 인해 발생할 수 있음
>
> * Thread-safe: 여러 스레드가 동시에 쓰여도 안전하다. => 동시적 처리



## 1) Race Condition (경쟁 상황)

* **한 번에 한 개의 스레드만 접근 가능하도록 처리**하여 경쟁 상황이 발생하지 않도록 함.

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



## 2) Deadlocks (교착 상태)

* **2개 이상의 스레드가 2개 이상의 배타적인 자원 사용으로 인해 서로 점유하려고 하면서 자원 사용이 막히는 상태**
* 작업이 진행되지 않음
  * ex) 동기 작업이 현재 스레드가 필요한 경우
  * ex) 앞선 작업이 현재 스레드가 필요한 경우
  * ex) 여러 개의 세마포어가 존재하는데 자원에 대한 사용 순서를 잘못 설계했을 때 등

=> **시리얼큐(`Serial Queue`)**로 해결 가능

​	: 작업이 순서대로 실행될 것이기 때문. 여러 스레드에서 접근하는 것이 아니라 하나의 스레드가 메모리에 접근함. 

​	: 세마포어나 제한된 리소스 순서 등에 주의해야 함. 



## 3) Priority Inversion (우선 순위 뒤바뀜)









[출처](https://www.inflearn.com/course/iOS-Concurrency-GCD-Operation/dashboard)

