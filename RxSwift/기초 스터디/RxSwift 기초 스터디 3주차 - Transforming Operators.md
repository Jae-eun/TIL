

## 옵저버블 변환 (`Transforming Observables`)

> `Observable`에서 내보낸 항목을 변환하는 연산자

### Buffer

> 주기적으로 `Observable`에서 요소를 묶음으로 수집하고 한 번에 하나씩 요소를 방출하는 대신 이 묶음을 방출

![image](https://user-images.githubusercontent.com/12438429/110915499-0d19f680-835b-11eb-859c-b8a6ae54ae66.png)

```swift

```



### FlatMap 

> Observable에 의해 방출된 요소를 `Observable`로 변환한 다음, 그 방출을 단일 `Observable`로 평평하게 함

![image](https://user-images.githubusercontent.com/12438429/110915513-11461400-835b-11eb-9e44-1c97d8f3ec44.png)

```swift

```



### GroupBy

> `Observable`을 키로 구성된 원래 `Observable`과 다른 요소 그룹을 각각 방출하는 `Observable` 집합으로 나눔

![image](https://user-images.githubusercontent.com/12438429/110915554-228f2080-835b-11eb-9442-2079e495ffda.png)

```swift

```



### Map

> `Observable`이 방출한 각 요소 함수를 적용하여 변환

![image](https://user-images.githubusercontent.com/12438429/110915719-59fdcd00-835b-11eb-84f3-54b457c16410.png)

```swift

```



### Scan

> `Observable`이 방출한 각 요소에 순차적으로 함수를 적용하여 각 연속 값을 방출

![image](https://user-images.githubusercontent.com/12438429/110915736-5f5b1780-835b-11eb-81a9-6934b7687402.png)

```swift

```



### Window

> 요소를 `Observable`에서 `Observable` 창으로 주기적으로 세분화하고 한 번에 하나씩 요소를 방출하는 대신 이러한 창을 방출

![image](https://user-images.githubusercontent.com/12438429/110915588-2d49b580-835b-11eb-933b-2194167bc5d4.png)

```swift

```
