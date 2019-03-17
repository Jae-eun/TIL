# Array

var empty: [Int] = []

var empty2 = [Int] ()

var empty3 = Array<Int> = []



var a: Array<Int> = [1,2,3,4]

var b: [Int] = [1,2,3,4]

var d  = Array<Int>(1..4)



Var anyArr: [Any] = [1,2,"3","4"]



var threeDoubles = [Int] (repeating: 0, count: 3)



a.appen{5}

a += [6,7,8]

a.append(contentsOf: stride(from: 5, through; 10, by: 1))



Range 설정해서 값 변경

Arr[1…2] = [5,6]



arr.insert(5, at: 4)



arr.remove(at: 0)



arr.removeAll()



arr.removeFirst()



arr.popLast()

: nil이어도 오류 안남



arr.removeLast()

: nil이면 오류 남



arr.dropFirst()

arr.dropLast()



arr.startIndex

arr.endIndex



arr.first

arr.last



arr.min()

arr.max()



arr.sort() : 원본 정렬

arr.reverse()



arr.sorted()

arr.sorted(by: >)



arr.count

arr.capacity



* reserveCapacity() : 배열의 용량을 미리 설정하여 재할당 및 복사연산을 수행할 필요 없도록 할 수 있음.
* capacity 는 array Doubling 전략을 사용함.
* 배열에 요소를 추가할 때, 해당 배열이 예약된 용량을 초과하기 시작하면 배열은 더 큰 메모리 영역을 할당하고 요소를 방금 할당한 새 메모리에 복사합니다. 이 때, 새로운 저장소는 이전 저장소 크기의 2배다.



* 크기가 정해진 2차원 배열 만들기

  : var arr: [[Int]] = Array(repeating: Array(repeating: 1, count: 5), count: 3)

  : var arr2 = [[Int]] (repeating: Array(repeating: 1, count: 5) , count: 3)















