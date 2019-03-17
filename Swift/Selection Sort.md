# Selection Sort 선택 정렬

import UIKit

var array = [9,8,7,6,5,4,3,2,1]

For i in 0..<array.count {

​	var minn = array[i]

​	var location = i

​	for j in i+1..<array.count {

​		if(minn>array[j]) {

​			minn = array[j]

​			location = j

​		}

​	}

​	if i != location {

​		swap(&array[i], &array[location])

​	}

}

for i in 0..<8 {

​	print(array[i])

}