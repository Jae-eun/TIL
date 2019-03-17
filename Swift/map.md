# map

제공된 클로저를 각 행렬 항목마다 적용한 후, 새롭게 매핑된 값들이 원래 행렬의 해당 값들의 순서와 같도록 배치된 새 행렬을 반환한다.



Array.map(transform: T -> U)



var arr = read.components(separatedBy: " ").map({ (value: String) return in Int(value)! })



var arr = read.components(separatedBy: " ").map { Int($0)! }

