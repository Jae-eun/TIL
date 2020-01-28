# 비동기 반환(`Async Result`)

* 동기식(`Sync`) 함수의 연산 과정이 오래 걸리면 프로그램의 수행이 멈추게 됨

* 비동기식(`Async`) 함수는 결과는 나중에 전달받기로 하고, 프로그램의 수행을 멈추지 않음

  * Ex) 연산이 오래 걸리거나 / 네트워크를 통해서 결과를 얻거나 / 딜레이가 포함되는 경우

  ```swift
  func f(_ nums: [Int]) -> Int {
  	sleep(1) // 프로그램이 멈춤
  	let sum = nums.reduce(0, +)
  	return sum
  }
  ```

  ```swift
  // 비동기로 변경
  func af(_ nums: [Int], _ result: @escaping (Int) -> Void) {
  	DispatchQueue.main.async {
  		sleep(1)
  		let sum = nums.reduce(0, +)
  		result(sum)
  	}
  }
  ```

  * 연산 결과가 리턴되는 것이 아니라, 전달받은 `reulst `함수를 호출함으로써 리턴값이 전달됨
  * 결과가 발생하는 시점에 수행되게 됨

