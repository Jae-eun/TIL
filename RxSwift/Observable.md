# Observable

ReactiveX에서 옵저버는 Observable을 구독한다. Observable이 배출하는 하나 또는 연속된 항목에 옵저버는 반응한다. 이러한 패턴은 동시성 연산을 가능하게 한다. 그 이유는 Observable이 객체를 배출할 때까지 기다릴 필요 없이 어떤 객체가 배출되면 그 시점을 감시하는 관찰자를 옵저버 안에 두고 그 관찰자를 통해 배출 알림을 받으면 되기 때문이다. 



![image](http://reactivex.io/assets/operators/legend.png)

마블 다이어그램이 어떻게 Observable과 Observable의 전환을 표현하는지 보여준다.



## 배경

개발자들은 자신의 코드가 점진적으로 하나씩 작성된 순서에 따라 실행되고 완료 되기를 기대한다는 사실을 쉽게 알 수 있다. 하지만 이와 달리 ReactiveX에서는 '옵저버'에 의해 임의의 순서에 따라 병렬로 실행되고 결과는 나중에 연산된다. 즉, 메서드 호출보다는 'Observable' 안에 데이터를 조회하고 변환하는 메커니즘을 정의한 후, Observable이 이벤트를 발생시키면 옵저버의 관찰자가 그 순간을 감지하고 준비된 연산을 실행시켜 결과를 리턴하는 메커니즘 때문에, Observable을 구독한다고 표현하는 것이 올바를 것이다.

이 접근 방법은 의존 관계가 없는 많은 코드들을 실행할 때, 하나의 코드 블럭이 실행 결과를 리턴할 때까지 기다릴 필요 없이 계속해서 다음 코드 블럭을 실행할 수 있기 때문에 한 번에 여러 개의 코드를 실행시킬 수 있다. 결과적으로 보면 전체 코드의 실행 시간은 그 중 실행 시간이 긴 시간만큼 밖에 걸리지 않는 큰 장점을 제공한다. 

비동기 프로그래밍과 설계 모델을 이야기하기 위해서 많은 용어들이 사용되고 있는데, 이 문서에서는 다음의 용어들을 사용할 것이다. 옵저버는 Observable을 구독한다. Observable은 항목들을 배출하거나 Observable의 메서드 호출을 통해 옵저버에게 알림을 보낸다. 

우리가 '옵저버'라고 말하는 것이 다양한 문서나 문맥에서는 '구독자'나 '관찰자' 또는 '리액터'로 불려지고 있지만, 통상적으로 이 모델은 리액터 패턴을 말한다.



## 옵저버 생성

이 페이지에서는 예제 코드로 Groovy 스타일의 의사코드(pseudocode)를 사용하지만, 그 외에도 다양한 언어들이 ReactiveX를 지원한다. 

ReactiveX는 기본적으로 비동기와 병렬로 메소드를 호출하지만, Reactive가 아닌 일반적인 메서드 호출은 대게 다음과 같은 흐름으로 진행된다. 

1. 메서드를 호출한다.
2. 메서드가 리턴한 값을 변수에 저장한다.
3. 결과 값을 가진 변수를 통해 필요한 연산을 처리한다.

혹은, 이렇게 표현하기도 한다.

```groovy
// 메서드를 호출하고, 리턴 값을 'returnVal'에 할당한다.
returnVal = someMethod(itsParameters);
// returnVal을 통해 필요한 작업을 진행한다.
```



하지만 비동기 모델에서는 아래와 같은 흐름대로 코드가 실행된다.

1. 비동기 메소드 호출로 결과를 리턴받고 필요한 동작을 처리하는 메서드를 정의한다. 이 메서드는 옵저버의 일부가 된다.
2. Observable로 비동기 호출을 정의한다.
3. 구독을 통해 옵저버를 Observable 객체에 연결시킨다.(또한, 동시에 Observable의 동작을 초기화한다.)
4. 필요한 코드를 계속 구현한다. 메서드 호출로 결과가 리턴될 때마다, 옵저버의 메서드는 리턴 값 또는 (Observable이 배출하는) 항목들을 사용해서 연산을 시작한다.

이를 코드로 구현하면 아래와 같다.

```groovy
// 옵저버의 onNext 핸들러를 정의한다, 하지만 실행하지는 않는다.
// (이 예제에서는, 단순히 옵저버에 onNext 핸들러만 구현한다.)
def myOnNext = { it -> /* 필요한 연산을 처리한다 */ };
// Observable을 정의하지만, 역시 실행하지는 않는다.
def myObservable = someObservable(itsParameters);
// 옵저버가 Observable을 구독한다. 그리고 Observable을 실행한다.
myObservable.subscribe(myOnNext);
// 필요한 코드를 구현한다.
```



### onNext, onCompleted, 그리고 onError

`Subscribe` 메서드를 통해 옵저버와 Observable을 연결한다. 여러분의 옵저버는 아래의 메서드를 구현하게 될 것이다. 

`onNext` 

: Observable은 새로운 항목들을 배출할 때마다 이 메서드를 호출한다. 이 메서드는 Observable이 배출하는 항목을 파라미터로 전달 받는다. 

`onError`

: Observable은 기대하는 데이터가 생성되지 않았거나 다른 이유로 오류가 발생한 경우 오류를 알리기 위해 이 메서드를 호출한다. 이 메서드가 호출되면 `onNext`나 `onCompleted`는 더 이상 호출되지 않는다. `onError` 메서드는 오류 정보를 저장하고 있는 객체를 파라미터로 전달 받는다.

`onCompleted`

: 오류가 발생하지 않았다면 Observable은 마지막 `onNext`를 호출한 후 이 메서드를 호출한다. 

Observable 계약에 명시된 조건에 따라, `onNext` 는 0번 이상 호출될 수 있으며, 그 후에는 `onCompleted` 또는 `onError` 둘 중 하나를 마지막으로 호출한다. 단, 이 둘 모두를 호출하지는 않는다. 이 문서에서는 관례에 따라, `onNext` 호출을 항목의 '배출'로 부르며, `onCompleted` 혹은 `onError`  호출을 '알림'으로 부를 것이다. 

`subscribe` 호출 예제

```groovy
def myOnNext = { item -> /* 필요한 연산을 처리한다 */ };
def myError = { throwable -> /* 실패한 호출에 대응한다 */ };
def myComplete = { /* 최종 응답 후 정리 작업을 한다 */ };
def myObservable = someMethod(itsParameters);
myObservable.subscribe(myOnNext, myError, myComplete);
// 필요한 코드를 계속 구현한다.
```



## 구독 해지

ReactiveX 구현체 중에는 `Subscriber` 라는 특별한 옵저버 인터페이스가 있는데 이 인터페이스는 `unsubscribe` 라는 메서드를 제공한다. 현재 구독 중인 Observable 중, 옵저버가 더 이상 구독을 원하지 않는 경우에는 이 메서드를 호출해서 구독을 해지할 수 있다. 만약 더 이상 관심 있는 다른 옵저버가 존재하지 않는다면 Observable들은 새로운 항목들을 배출하지 않는다. 

unsubscribe는 연산자 체인을 통해 옵저버가 구독하고 있었던 Observable들이 더 이상 항목들을 배출하지 못하도록 체인 안에 연결된 링크들을 끊어 버린다. 



## 명명 규칙에 관한 참고 내용

ReactiveX를 구현하는 언어들은 자신만의 독특한 특징들을 갖고 있다. 그렇다고 반드시 지켜야 하는 강제성이 있는 규칙들이 존재하는 것은 아니지만, 언어별 구현체 간에 공통적으로 유지해야 하는 많은 명명 규칙들이 존재한다.

뿐만 아니라, 이들 규칙 간에는 각기 다른 문맥에서 서로 다른 함축적인 의미로 사용되는 것들도 있으며 특정 언어의 관용구에서는 상당히 어색한 의미로 해석되기도 한다.

예를 들면 `onEvent` 네이밍 패턴이 존재하는데, 어떤 문맥에서는 이런 이름들이 어떤 핸들러가 등록 되었는지를 가리키는 메서드로 사용되기도 한다. 하지만 ReactiveX에서는 이벤트 핸들러 자체를 의미한다. 



## Hot and Cold Observable

그럼 Observable은 연속된 항목들을 언제 배출할까? 이 질문에 대한 대답은 'Observable에 따라 다르다'이다. '뜨거운' Observable은 생성되자 마자 항목들을 배출하기도 하기 때문에, 이 Observable을 구독하는 옵저버들은 어떤 경우에는 항목들이 배출되는 중간부터 Observable을 구독할 수 있다. 

반대로, '차가운' Observable은 옵저버가 구독할 때까지 항목을 배출하지 않기 때문에 이 Observable을 구독하는 옵저버는 Observable이 배출하는 항목 전체를 구독할 수 있도록 보장 받는다.

ReactiveX의 구현 코드 중에는 '연결 가능한(Connectable)' Observable이라고 불리는 Observable 객체가 존재하는데, 이 Observable은 옵저버의 구독 여부와는 상관 없이 자신의 Connect 메서드가 호출되기 전까지 항목들을 배출하지 않는다. 



## Observable 연산자를 활용한 구성

Observable과 옵저버는 그저 ReactiveX의 시작점일 뿐이다. 우리가 알고 있는 표준 옵저버 패턴을 조금 확장한 것이며, 연속된 이벤트를 처리하는데 있어서는 싱글 콜백보다는 훨씬 더 효과적인 방법을 제공한다.

'리액티브 확장(reactive extensions)'의 진짜 힘은 연산자로부터 나온다. 연산자들은 Observable이 배출하는 연속된 항목들을 변환시키고, 결합하고, 조작하는 기능들을 제공한다. 

이 연산자들은 콜백이 제공하는 효율적인 장점들을 바탕으로 선언적인 방법을 통해 연속된 비동기 호출을 구성할 수 있는 방법을 제공하는데, 중요한 것은 일반적인 비동기 시스템이 가진 중첩된 콜백 핸들러의 단점들을 제거했다는 점이다. 

여기에서 제공하는 문서들은 다양한 연산자에 대한 내용을 그룹으로 나눠 연결된 링크들을 통해 실제 사용에 필요한 예제를 제공한다.

**Observable 생성**

`Create`, `Defer`, `Empty`/`Never`/`Throw`, `From`, `Interval`, `Just`, `Range`, `Repeat`, `Start`, `Timer`

**Observable 항목 변환**
`Buffer`, `FlatMap`, `GroupBy`, `Map`, `Scan`, `Window`

**Observable 필터**

`Debounce`, `Distinct`, `ElementAt`, `Filter`, `First`, `IgnoreElements`, `Last`, `Sample`, `Skip`, `SkipLast`, `Take`, `TakeLast`

**Observable 결합**
`And`/`Then`/`When`, `CombineLatest`, `Join`, `Merge`, `StartWith`, `Switch`, `Zip`

**오류 처리 연산자**

`Catch`, `Retry`

**유틸리티 연산자**

`Delay`, `Do`, `Materialize`/`Dematerialize`, `ObserveOn`, `Serialize`, `Subscribe`, `SubscribeOn`, `TimeInterval`, `Timeout`, `Timestamp`, `Using`

**조건 및 Boolean 연산자**

`All`, `Amb`, `Contains`, `DefaultIfEmpty`, `SequenceEqual`, `SkipUntil`, `SkipWhile`, `TakeUntil`, `TakeWhile`

**수학과 조합 연산자**

`Average`, `Concat`, `Count`, `Max`, `Min`, `Reduce`, `Sum`

**변환 Observable**

`To`

**연결 가능한 Observable 연산자**

`Connect`, `Publish`, `RefCount`, `Replay`

**역압(backpressure) 연산자**

특정 제어흐름 원칙들을 적용하는 다양한 연산자들



링크에 연결된 내용들은 ReactiveX의 비핵심적인 연산자 혹은 선택적 모듈에 대한 정보를 포함하고 있으며 하나 이상의 언어를 통해 구현된다. 

## 연산자 체인

대부분의 연산자들은 Observable 상에서 동작하고 Observable을 리턴한다. 이런 접근 방법은 연산자들을 하나의 Observable에 적용하고 또 다음 연산자에 다시 적용할 수 있는 연산자 체인을 제공한다. 연산자 체인에 걸려있는 각각의 연산자들은 이전 연산자가 리턴한 Observable을 변경한다.

특정 클래스의 다양한 메서드 연산을 통해서 같은 클래스에 있는 항목들을 변경하는 빌더 패턴 같은 것도 존재한다. 이 패턴 역시 비슷한 방법으로 메서드 체인을 제공한다. 하지만 연산자의 호출 순서가 문제가 되지 않는 빌더 패턴과는 달리, Observable 연산자들은 호출 순서에 영향을 받는다.

Observable 연산자 체인은 원본 Observable과는 떨어져서 동작할 수 없고 순서대로 동작하기 때문에 호출 체인 중 바로 이전에 호출된 연산자가 리턴한 Observable을 기반으로 실행된다. 









































[참고](http://reactivex.io/documentation/ko/observable.html)