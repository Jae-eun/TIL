# 순수 함수(`Pure Function`)

> 특정 input에 대해서 항상 동일한 output을 반환하는 함수

* 함수 외부의 값을 사용하지 않아 side-effect가 없음
* output은 input에 의해서만 결정됨
* 함수 수행 과정에서 외부에 있는 값을 사용하지 않음
* 외부의 값을 변경하지 않음

* 변경 불가능한 값(`immutable data`)만 사용하는 함수도 순수 함수라 할 수 있음



```swift
let day = ["화", "수", "목", "금", "토", "일", "월"]
func whatDayOfTheWeekInJanuary(_ date: Int) -> String {
    return "\(day[date % 7])요일"
}
```

