# Observable Utility Operators 

## doOn

![image](https://user-images.githubusercontent.com/12438429/112802600-541f2000-90ad-11eb-899a-b02b96186624.png)

## delay

> 지정한 시간만큼 방출을 미룸. kxcoding 

![image](https://user-images.githubusercontent.com/12438429/112802567-48cbf480-90ad-11eb-9c91-3873c5156d11.png)



## observeOn





## subscribe 

> `Observable` 의 방출 및 알림에 따라 작동함.

* `subscribe` 연산자는 옵저버블에 옵저버를 연결하는 접착제이다. 



### `onNext`



### `onError`

: `Observable` 은 예상 데이터를 생성하지 못했거나 어떤 오류가 발생했음을 나타내기 위해 이 메서드를 호출한다. `onError` 

### `onCompleted` 

: `Observable` 은 아무 오류도 발생하지 않은  `onNext` 마지막 호출에 `onCompleted` 메서드를 호출한다. 

The Subscribe operator is the glue that connects an observer to an Observable. In order for an observer to see the items being emitted by an Observable, or to receive error or completed notifications from the Observable, it must first subscribe to that Observable with this operator.

A typical implementation of the Subscribe operator may accept one to three methods (which then constitute the observer), or it may accept an object (sometimes called an `Observer` or `Subscriber`) that implements the interface which includes those three methods:

- `onNext`

  An Observable calls this method whenever the Observable emits an item. This method takes as a parameter the item emitted by the Observable.

- `onError`

  An Observable calls this method to indicate that it has failed to generate the expected data or has encountered some other error. This stops the Observable and it will not make further calls to `onNext` or `onCompleted`. The `onError` method takes as its parameter an indication of what caused the error (sometimes an object like an Exception or Throwable, other times a simple string, depending on the implementation).

- An Observable is called a “cold” Observable if it does not begin to emit items until an observer has subscribed to it; an Observable is called a “hot” Observable if it may begin emitting items at any time, and a subscriber may begin observing the sequence of emitted items at some point after its commencement, missing out on any items emitted previously to the time of the subscription.

## subscribeOn





## materialize

??



## dematerialize

??



## timeOut

![image](https://user-images.githubusercontent.com/12438429/112802733-82046480-90ad-11eb-85d0-31150277f83d.png)



## using

![image](https://user-images.githubusercontent.com/12438429/112802760-87fa4580-90ad-11eb-8c25-11acd7799b7d.png)

