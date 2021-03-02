# 두 개의 스택으로 큐 구현하기

* 배열의 마지막 요소를 제거하는 연산은 재정렬이 필요하지 않으므로 수행 속도가 O(1)임을 활용한 방법



```swift
// 구현
public struct QueueDoubleStack<T>: Queue {
	private var leftStack = Array<T>() 
  private var rightStack = Array<T>()
  
  public init() {}
  
  public mutating func enQueue(_ element: T) -> Bool {
    leftStack.append(element)
    return true
  }
  
  public mutating func deQueue() -> T? {
    if rightStack.isEmpty {
      rightStack = leftStack.reversed()
      leftStack.removeAll()
    }
    return rightStack.popLast()
  }
  
  public var isEmpty: Bool {
    return leftStack.isEmpty && rightStack.isEmpty
  }
  
  public var peek: T? {
    return !rightStack.isEmpty ? rightStack.last : leftStack.first
  }
}

extension QueueDoubleStack: CustomStringConvertible {
  public var description: String {
    let printList = rightStack.reversed() + leftStack
    return String(describing: printList)
  }
}

// 실행
var queueStack = QueueDoubleStack<String>()
queueStack.enQueue("A")
queueStack.enQueue("B")
queueStack.enQueue("C")
print(queueStack) // ["A", "B", "C"]
queueStack.deQueue() 
print(queueStack) // ["B", "C"]
```



* 성능
  * enqueue(_:)  : B/W => O(1)
  * dequeue(_:)  : B/W => O(1)
  * Space Complexity : B/W => O(n)



* 배열로 구현한 큐보다 deQueue()의 수행속도가 빠름 : O(1) > O(n)

* 더블 링크드 리스트로 구현한 큐보다 공간 복잡성 측면에서 더 나음

  : 참조 정보로 구성되어 메모리에 접근하는 시간이 더블 스택에 비해 오래 걸림



[참고](https://the-brain-of-sic2.tistory.com/21)











