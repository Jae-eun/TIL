# NSCache

> Cocoa에서 사용할 수 있는 캐싱을 위한 클래스

* `NSDictionary` 처럼 **Key-Value** 형태로 되어 있음.
* 가용 메모리가 적을 때는 다른 앱을 위해 캐싱된 데이터를 자동으로 버림.

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
* `totalCostLimit` : 총 cost의 최댓값. NSCache에 추가된 데이터들의 cost가 totalCostLimit에 도달하거나 넘으면 데이터를 버림. 
* `evictsObjectsWithDiscardedContent` : NSCache는 시스템에서 메모리를 너무 많이 사용하지 않도록 되어 있음. 그래서 캐싱된 데이터를 자동으로 지우는 다양한 정책을 사용하고 있고, 캐싱된 데이터가 너무 많은 메모리를 사용하면 시스템은 캐싱된 데이터를 삭제함. 

