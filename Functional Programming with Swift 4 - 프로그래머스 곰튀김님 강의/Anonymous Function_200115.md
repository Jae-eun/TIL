# 익명함수(`Anonymous Function`) / 클로저(`Closure`)

> 함수 이름을 선언하지 않고 바로 몸체만 만들어 사용하는 일회용 함수 / Java의 람다와 유사함

```swift
{(매개변수) -> 반환타입 in
	실행 구문
}
```

* `in` 키워드를 사용해서 파라미터, 반환 타입 영역과 실제 클로저의 코드를 분리함



```swift
let day = ["화", "수", "목", "금", "토", "일", "월"]
// 순수 함수
func whatDayOfTheWeekInJanuary(_ date: Int) -> String {
    return "\(day[date % 7])요일"
}

// 익명 함수
let whatDayOfTheWeekInJanuaryClosure = { (date: Int) -> String in
    return "\(day[date % 7])요일입니다~"
}

print(whatDayOfTheWeekInJanuaryClosure(15)) // 수요일입니다~
```



* 파라미터명, 파라미터타입, 반환타입과 클로저 내부 코드가 한 줄이라면 `return` 생략 가능

```swift
let today = { (month: Int, date: Int) -> String in
  return "오늘은 \(month)월 \(date)일입니다!"
}

print(today(1, 15)) // 오늘은 1월 15일입니다!

// 축약
let today2: (Int, Int) -> String = { "\($0)월 \($1)일입니다!" }

print(today2(1, 30)) // 오늘은 1월 30일입니다!
```



* 파라미터로 클로저 받기

```swift
func whatDay(month: Int, date: Int, closure: (Int, Int) -> String) -> String {
    return closure(month, date)
}

print(whatDay(month: 1, date: 20, closure: today)) // 오늘은 1월 20일입니다!
print(whatDay(month: 1, date: 22, closure: { mon, da in
    return "\(mon)월 \(da)일!!"
})) // 1월 22일!!
print(whatDay(month: 1, date: 25) { "\($0)월 \($1)일~" }) // 1월 25일~
```

