# Equatable

* 값이 동일한지 어떤지 비교 할 수 있는 타입
* Equatable 프로토콜을 준수하는 타입은 등호 연산자(==) 또는 같지 않음 연산자(!=)를 사용하여 동등성을 비교할 수 있다.
* Swift 표준 라이브러리의 대부분 기본 데이터 타입은 Equatable을 따른다.



* 클래스의 인스턴스끼리 비교하고 싶을 때

class A: Equatable {

​	var aNum: Int 

​	init(_ aNum: Int) {

​		self.aNum = aNum

​	}

​	public static func ==(lhs: A, rhs: A) -> Bool {

​		return lhs.aNum == rhs.aNum

​	}

}