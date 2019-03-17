# Set 집합

* 순서를 보장하지 않음.

* 중복값이 없음.
* 해쉬가능한(Hashable) 타입만 사용 가능함.



var emptySet = Set<String> ()

var emptySet2: Set<String> = []



var emptySet3: Set = ["hello", "world", "jaeeun"]

: Set이라고 명시하지 않으면 배열로 인식됨.



emptySet1.insert("iOS")

: 지정된 요소가 없으면 Set에 넣는다. 

: 지정된 요소가 이미 Set에 있으면 아무 소용이 없다.



emptySet2.update(with: "swift")

: 지정된 요소를 무조건 삽입한다.

: 지정된 요소가 이미 Set에 있으면 새로 넣는 값이 기존의 값을 대체한다.

: 지정된 요소가 없으면 nil 반환

: 지정된 요소가 있으면 Optional(지정한 값) 반환



emptySet1.remove("swift")

emptySet1.remove(at: emptySet.index(of: "iOS")!)

emptySet1.removeAll()



for index in emptySet1 {

​	print(index)

}



a.intersection(b)

a.symmetricDifference(b)

a.union(b)

a.subtracting(b)



set.joined()



var setToStr = set.reduce(" ", {$$0+$1})



var setToStr = set.reduce("") { (s1: String, s2: String) -> String in 	return s1+s2 

}

















