# Designated init / convenience init

* Designated init(지정 이니셜라이저)

  : init으로 씀

  : 클래스의 모든 프로퍼티가 초기화 될 수 있도록 해야 함.



* Convenience init(보조 이니셜라이저)

  : 클래스의 원래 이니셜라이저인 init을 도와주는 역할

  : Designated init의 파라미터 중 일부를 기본값으로 설정해서, 이 convenience init 안에서 Designated init을 호출하여 초기화를 진행할 수 있음.

  : convenience init을 사용하려면 Designated init이 꼭 선언되어야 함.

  : convenience init은 같은 클래스에서 다른 이니셜라이저를 호출해야한다.

  : 일부를 기본값으로 지정해놓는 것

class Person {

​	var name: String

​	var age: Int

​	var gender: String

​	init(name: String, age: Int, gender: String) {

​		self.name = name

​		self.age = age

​		self.gender = gender

​	}

​	convenience init(age: Int, gender: String) {

​		self.init(name: "jaeeun", age: age, gender: gender) 

​	}

}



Ex)

convenience init(gender: String) {

​	self.init(name: "jaeeun", age: 20, gender: gender) 

}

let jaeeun = Person(gender: "Woman")