

# Maybe

> 값이 있거나 없을 수 있는 상태를 표현하는 것. 즉, `Optional`과 유사



```swift
enum Maybe<A> {
	case None
	case Some(A)
}

enum Optional<Wrapped> {
  case none
  case some(Wrapped)
}
```



# Either

> 어떤 값이 두가지 타입을 가질 수 있는 상태. 즉, `Result` 와 유사
>
> * API 통신을 할 때 유용하게 쓰임. <응답 결과를 받거나, 에러가 나거나>

```swift
enum Either<A, B>{
  case Left(A)
  case Right(B)
}		

var either: Either<Int, String>

either = .Left(1)
print(either)
either = .Right("1")
print(either)


// 제네릭으로 에러 인자를 정의하여 상황에 따라 특정한 에러를 설정할 수 있음
enum Result<T, E: Error> {
	case success(T)
	case failure(E)
}
```





[참고1](https://academy.realm.io/kr/posts/tryswift-saul-mora-result-oriented-development/)

