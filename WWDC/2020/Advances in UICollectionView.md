# Advances in UICollectionView

> iOS14 `UICollectionView`의 향상된 기능
>
> 예제에서 가로로 스크롤되는 그리드(`Horizontally scrolling grid`) / 확장 & 축소 가능한 개요(`outline`) / UITableView와 유사한 디자인(`list`)을 다룸



## CollectionView APIs

* UICollectionView를 구성하는 API는 데이터, 레이아웃 및 프레젠테이션의 세 가지 범주로 구분

![image](https://user-images.githubusercontent.com/12438429/104872070-2a9c9680-5990-11eb-8027-2d64ac1d9a47.png)

* 데이터(`Data`) 간의 관심사나 "무엇(`What`)"을 레이아웃(`Layout`)에서 "어디(`Where`)" 콘텐츠가 렌더링되는지 분리하는 것은 UICollectionView가 구축한 새로운 개념 중 하나고, 이것은 UICollectionView를 유연하게 만드는 핵심 요소임.
* iOS 6에서 처음 출시되었을 때 데이터는 `indexPath` 기반 프로토콜인 `UICollectionViewDataSource`를 통해 관리되었음.
* 레이아웃의 경우 추상 클래스인 `UICollectionViewLayout`이 있었고, 구체적인 하위 클래스인 `UICollectionViewFlowLayout`을 제공했음.
* 프레젠테이션 측면에서는 `UICollectionViewCell` 및 `UICollectionReusableView`의 두 가지 뷰 유형을 제공했음.



![image](https://user-images.githubusercontent.com/12438429/104900221-2c318300-59bf-11eb-8297-21ab35863d16.png)

* iOS 13에서는 각각 데이터(`Data`) 및 레이아웃(`Layout`)에  `Diffable Data Source` 및 `Compositional Layout` 이라는 두 가지 새로운 구성 요소를 도입했음.
* iOS 14의 경우, 이 세 가지 API 범주 모두를 개선하여 새로운 기능을 도입했음.



### Diffable Data Source

* `Simplifies UI State` : iOS 13에 도입. 
  * 새로운 스냅 샷 데이터 유형 추가를 통해 UI 상태 관리를 크게 단순화했음.
  * 스냅 샷은 고유한 섹션 및 항목 식별자를 사용하여 전체 UI 상태를 캡슐화함.
  * `UICollectionView`를 업데이트 할 때, 먼저 새 스냅 샷을 만들고 현재 UI 상태로 채운 다음 데이터 소스에 적용함.
* `Automatic animations & No more batch updates`
  * 사용자의 추가 작업 없이 차이를 계산하고 자동으로 애니메이션을 생성함.



### Section Snapshots

















[WWDC](https://developer.apple.com/videos/play/wwdc2020/10097/)