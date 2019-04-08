# NSCountedSet

* Set에 어떤 값이 몇번 들어갔는지 알 수 있다.

* Any 타입



let countedSet = NSCountedSet()



Ex) 

```swift
import Foundation

// magazine에 있는 단어로 note를 모두 쓸 수 있는지 확인하기
// Practice > Interview Preparation Kit > Dictionaries and Hashmaps > Hash Tables: Ransom Note
// https://www.hackerrank.com/challenges/ctci-ransom-note/problem?h_l=interview&playlist_slugs%5B%5D=interview-preparation-kit&playlist_slugs%5B%5D=dictionaries-hashmaps

let magazine = ["two", "times", "three", "is", "not", "four"]
let note = ["two", "times", "two", "is", "four"]

func checkMagazine(magazine: [String], note: [String]) -> Void {
  let countedMagazine = NSCountedSet(array: magazine)
  let countedNote = NSCountedSet(array: note)
  var result = "No"
  for noteWord in countedNote {
    if countedMagazine.count(for: noteWord) < countedNote.count(for: noteWord) {
      result = "No"
      break
    } else {
      result = "Yes"
    }
  }
  print(result)
}
checkMagazine(magazine: magazine, note: note)
```

