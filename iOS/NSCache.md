# NSCache

> Cocoa에서 사용할 수 있는 캐싱을 위한 클래스

* `NSDictionary` 처럼 **Key-Value** 형태로 되어 있음.
* 가용 메모리가 적을 때는 다른 앱을 위해 캐싱된 데이터를 자동으로 버림.

```swift
class NSCache<KeyType, ObjectType> : NSObject where KeyType : AnyObject, ObjectType : AnyObject
```



```swift
class NSCache<KeyType, ObjectType> : NSObject where KeyType : AnyObject, ObjectType : AnyObject
```



### 장점

* 앱의 메모리가 부족할 때 직접 처리하지 않아도 됨.
* 스레드로부터 안전함. 멀티스레드 상태에서 신경쓰지 않아도 됨.
* 캐시의 최대 크기와 캐시에 넣을 개체 수를 지정할 수 있음.

```swift
cache.countLimit = 75 (75 images)
cache.totalCostLimit = 50 * 1024 * 1024 (50MB)
```



## NSCache 프로퍼티

* `countLimit` : NSCache는 캐싱하는 데이터의 개수를 제한할 수 있음. countLimit으로 설정한 수를 초과하는 데이터를 넣게되면 나머지는 자동으로 버림.
* `totalCostLimit` : 