# Higher-Order Functions

* 하나 이상의 함수를 인자로 취하는 함수
* 함수를 결과로 반환하는 함수



# Map

: 콜렉션 내부의 기존 데이터를 변형하여 새로운 콜렉션 생성

: container.map(f(x)) 

 	return f(container의 각 요소)



Ex) 

for number in numbers {

​	doubleNumbers.append(number*2)

}



doubleNumbers = numbers.map({ (number: Int) -> Int in

​	return number*2

}

doubleNumbers = numbers.map() { $0*2 }





# Filter



ex)

for number in numbers {

​	if number % 2 != 0 { continue }

}



let evenNumbers = numbers.filter { (number: Int) -> Bool in

​	return number % 2 == 0

}



let oddNumbers = numbers.filter { $0 % 2 != 0 }





# Reduce 

* 컨테이너 내부의 콘텐츠를 하나로 통합



ex)

for number in numbers {

​	sum += number 

}



let sum = numbers.reduce(0, { (first: Int, second: Int) -> Int in 

​	return first + second

}



`let sumFromThree = numbers.reduce(3) {$0 + $1}`









# self

클로저가 클래스의 프로퍼티로 속하게 될 때, 그 안에 self를 쓰면 recursive cycle이 생김.

다른 인스턴스로 전달이 되서 다른 쪽에서 참조가 되면 reference cyle이 되서 써야 함.







** 뷰컨트롤러 인스턴스가 계속 살아있고, 인터랙션해야 하면 딜리게이트

** 인스턴스가 죽거나 없어져도, 계속 실행되어야 하면 클로저로 넘겨주면 좋을 것 같음.