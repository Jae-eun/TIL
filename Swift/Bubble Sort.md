# Bubble Sort 버블 정렬

import UIKit 

var array = [3,10,9,7,5]

for i in 0..<array.count {

​	for j in 0..<array.count-1 {

​		if array[j]>array[j+1] {

​			swap(&array[i], &array[j+1])

​		}

​	}

}

for i in 0..<array.count {

​	print(array[i])

}



* 좀 더 빠른 방법

  var flag = false

  for i in 0..<array.count {

  ​	flag = false

  ​	for j in 0..<array.count-1-i {

  ​		if array[j]>array[j+1] {

  ​			swap(&array[j], &array[j+1]) 

  ​			flag = true

  ​		}

  ​	}

  ​	if flag == false {

  ​		break

  ​	}



* 한 회전이 끝나면 배열 안에서 가장 큰 값이 맨 뒤로 가게 된다.