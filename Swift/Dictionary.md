# Dictionary

* 정의된 순서가 없다.
* 특정 순서로 사전의 키 또는 값을 반복하려면 keys 또는 values 속성에 sorted() 메서드를 사용해야 한다.
* Dictionary<KeyType,ValueType>
* KeyType은 해쉬가능한 타입이어야 함. Hashable



var dic: [Int: String] = [:]

var dic2: [Int: String] ()

var dic3: Dictionary = [Int: String] ()

var dic4: Dictionary<Int, String> = Dictionary<Int, String> ()



var dic: [Int: String] = [1: "jae", 2: "eun", 3: "line"]



dic.updateValue("fun", forKey: 3)

dic[4] = "jaja"



for (key, value) in dic {

​	print(key)

}



for (key, value) in dic {

​	print(value) 

}



dic.removeValue(forKey: 5)

dic.removeAll()



dic.values.joined()

dic.keys.joined()

: String만 할 수 있음. Int 불가



let joinedStr = arr.joined(separator: "  , ")



var dicToStr = dic.values.reduce(" ", {$$0+$1})