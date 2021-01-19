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
  * 새로운 스냅샷 데이터 유형 추가를 통해 UI 상태 관리를 크게 단순화했음.
  * 스냅 샷은 고유한 섹션 및 항목 식별자를 사용하여 전체 UI 상태를 캡슐화함.
  * `UICollectionView`를 업데이트 할 때, 먼저 새 스냅 샷을 만들고 현재 UI 상태로 채운 다음 데이터 소스에 적용함.
* `Automatic animations & No more batch updates`
  * 사용자의 추가 작업 없이 차이를 계산하고 자동으로 애니메이션을 생성함.



### Section Snapshots

> iOS 14부터 추가된 새 스냅샷 유형

* **Single section data** : UICollectionView의 단일 섹션에 대한 데이터를 캡슐화함.
* 목적
  1. **Composable data sources** : 데이터 소스를 섹션 크기의 데이터 덩어리로 구성 할 수 있도록 하기 위함.
  2. **Hierarchical data** : 개요 스타일 UI 렌더링을 지원하는 데 필요한 계층적 데이터의 모델링을 허용하기 위함.



### Example

![image](https://user-images.githubusercontent.com/12438429/105059451-a430a380-5aba-11eb-8c7b-f8e0574d574d.png)

1. 가로 스크롤 섹션에서 단일 섹션 스냅샷을 사용하여 콘텐츠를 모두 모델링하고 있음.
2. 확장 / 축소 가능한 아웃라인 스타일을 볼 수 있음. 계층적 데이터를 모델링함.
3. 목록 섹션에서 섹션의 콘텐츠를 다시 모델링함.

* 새로운 재정렬 API도 추가함.



###Compositional Layout

> iOS 13에서 도입됨.

* **Composable** : 더 작고 합리적인 레이아웃을 함께 구성하여 풍부하고 복잡한 레이아웃을 구축할 수 있음.
* **Fast** : 레이아웃이 작동해야 하는 방식 대신 레이아웃의 모양을 설명하기 때문에 빠름.
* **Section specific layout** : 보다 정교한 UI를 구축하는 데 도움이 되는 섹션별 레이아웃 기능도 포함되어 있음.
* 직교 스크롤 섹션(`orthogonal scrolling section`)도 지원함.



#### * iOS14

>  `Lists`라고 하는 새로운 기능을 사용하여 Compositional Layout의 기반을 구축함.

* **UITableView like appearance** : `Lists` 를 사용하면 `UITableView`와 유사한 섹션을 모든 UICollectionView에 바로 포함할 수 있음.

* **Swipe actions & Common cell layouts** : 스와이프 동작 및 많은 일반적인 셀 레이아웃과 같이 `UITableView`에서 기대할 수 있는 기능들이 있음.

* Lists 스타일 레이아웃을 만드는 것은 간단함.
* `Compositional Layout` 위에 구축되기 때문에 섹션별로 Lists를 다른 종류의 레이아웃과 쉽게 혼합하고 일치시킬 수 있음.



![image](https://user-images.githubusercontent.com/12438429/105063137-b9a7cc80-5abe-11eb-8e46-1dce41c9900c.png)

```swift
let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
let layout = UICollectionViewCompositionalLayout.list(using: configuration)
```

> * `CollectionView`의 모든 섹션이 `insetGrouped` 모양의 목록인 `UICollectionView` 레이아웃을 만듦.



* 새롭고 구체적인 `UICollectionViewListCell`, `Header` 및 `Footer` 지원, 그리고 많은 `iPadOS` 시스템 앱에서 볼 수 있는 새로운 `Sidebar` 모양이 있습니다.



## Modern Cells

> iOS 14부터 `Cell registration`이라고 하는 새로운 API를 사용하여 셀을 구성할 수 있음.

### Cell registrations

* **뷰 모델에서 셀을 설정**하는 간단하고 재사용 가능한 방법
* **재사용 식별자(`reuse identifier`)와 연관시키기 위해 셀 클래스 또는 nib을 등록하는 추가 단계를 제거함.**
* 대신 뷰 모델에서 새 셀을 설정하기 위해 **구성 클로저를 통합하는 일반 등록 유형을 사용**함.

```swift
// 먼저 cell registration(이 경우 MyCell)과 ViewModel 클래스에 대한 generic cell registration 을 만듦.

let reg = UIColletionView.CellRegistration<MyCell, ViewModel> { cell, indexPath, model in 
  // configure cell content 
  // 새 셀이 생성 될 때마다 호출되는 클로저가 적용됨.
  // ViewModel에서 셀의 내용을 구성하는 곳
}

// 셀 등록을 사용하면 더 이상 레지스터를 호출하는 추가 단계가 필요하지 않음.

let dataSource = UICollectionViewDiffableDataSource<S, I>(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell in 
	return collectionView.dequeueConfiguredReusableCell(using: reg, for: indexPath, item: item.viewModel)
// 새로운 API dequeueConfiguredReusableCell과 함께 Diffable Data Source 셀 공급자의 셀 등록을 사용
}
```





## Cell content configurations

* **Similar to UITableViewCell types** : `UITableView` 표준 셀 유형에 표시되는 것과 유사한 셀에 대한 표준화 된 레이아웃을 제공함.
* **Use with any cell** : 모든 셀 또는 일반 `UIView`와 함께 사용할 수 있음.
* **Flexible** : 매우 유연함.



###Example

![image](https://user-images.githubusercontent.com/12438429/105066106-f628f780-5ac1-11eb-9d4c-4c3fcb505097.png)

```swift
var contentConfiguration = UIListContentConfiguration.cell() 
contentConfiguration.image = UIImage(systemNamed: "hammer")
contentConfiguration.text = "Ready. Set. Code."
cell.contentConfiguration = contentConfiguration
```



![image](https://user-images.githubusercontent.com/12438429/105066239-0a6cf480-5ac2-11eb-8330-68f47a588b05.png)

```swift
var contentConfiguration = UIListContentConfiguration.valueCell() // second text is on the trailing side of the cell
```



![image](https://user-images.githubusercontent.com/12438429/105066282-1062d580-5ac2-11eb-94bf-e8cc092a91a5.png)

```swift
var contentConfiguration = UIListContentConfiguration.subtitleCell() // secondary text underneath the main text
```

* 프레임 워크는 모든 레이아웃 고려 사항을 처리하고 자동으로 성능을 최적화함.



##Background configurations 

* `Content configurations` 와 매우 유사하지만 **색상, 테두리 스타일 등과 같은 속성을 조정**할 수 있는 기능으로, **모든 셀의 배경에 적용**됨.



[WWDC : Advances in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10097/)