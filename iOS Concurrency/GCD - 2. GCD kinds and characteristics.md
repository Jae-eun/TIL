# <iOS Concurrency 프로그래밍, 동기 비동기 처리 그리고 GCD/Operation - 디스패치큐와 오퍼레이션큐의 이해> 강의 정리



## GCD - 2. 디스패치큐(GCD)의 종류와 특성



## 메인큐, 글로벌큐와 Qos(서비스품질)에 대한 이해, 프라이빗(커스텀) 큐

### Main Queue

* 종류 한 개 / Serial / 메인 스레드
* UI 업데이트 관련 처리를 함

```swift
DispatchQueue.main.sync { // 실제로는 에러가 남
	print("print something")
}
```



### Global Queue

* 종류 여러 개 / Concurrent(기본 설정) / Qos(6종류)

```swift
DispatchQueue.global().async {
  
}
```

* **DispatchQueue.global(qos: .userInteractive)**
  * 거의 즉시 처리해야 하는 작업
  * 유저와 직접적인 상호작용 (UI 업데이트, 애니메이션 등)
* **DispatchQueue.global(qos: .userInitiated)**
  * 몇 초가 걸림
  * 유저가 즉시 필요하긴 하지만, 비동기적으로 처리된 작업(ex. 앱 내에서 pdf 파일을 여는 것과 같은 로컬 데이터베이스 읽기)
* **DispatchQueue.global()**
  * 디폴트
  * 일반적인 작업
* **DispatchQueue.global(qos: .utility)**
  * 몇 초에서 몇 분이 걸림
  * 보통 Progress Indicator와 함께 길게 실행되는 작업, 계산, IO, Networking, 지속적인 데이터 feeds
* **DispatchQueue.global(qos: .background)**
  * 속도보다는 에너지 효율성 중시, 몇 분 이상 걸림
  * 유저가 직접적으로 인지하지 않는 시간이 중요하지 않은 작업. 
  * 데이터 미리 가져오기나 데이터베이스 유지, 원격 서버 동기화 및 백업 수행
* **DispatchQueue.global(qos: .unspecified)**
  * 사용하지 않는 것이 좋음
  * legacy API에 사용됨

> * 큐의 종류에 따라, iOS 내에서 우선순위를 판단하여 더 중요한 작업에 스레드를 더 배치함
>
> ```swift
> let queue = DispatchQueue.global(qos: .background)
> queue.async(qos: .utility)
> // 큐가 작업을 보내는 품질의 영향을 받아 큐도 utility 품질이 됨 
> ```
>
> 

### Private Queue

* 커스텀으로 만듦 / Serial(기본 설정) / Qos 설정 가능

```swift
let queue = DispatchQueue(label: "com.jaeeun.serial")
let queue2 = DispatchQueue(label: "com.jaeeun.concurrent", attributes: .concurrent) // 동시 큐로 설정 가능
```

* OS가 알아서 Qos를 추론함



[출처](https://www.inflearn.com/course/iOS-Concurrency-GCD-Operation/dashboard)