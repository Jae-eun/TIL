# Big-O Notation

컴퓨터에서 데이터를 처리할 때 걸리는 시간 또는 차지하는 메모리 공간은 일반적으로 데이터 양에 비례하게 됩니다. 

Big-O 표기법은 이 때 필요한 시간, 공간을 점근적으로 표현하는 방법

시간복잡도(time complexity), 공간복잡도(space complexity)



- O(1) : 제일 이상적. 처리하는 데이터의 양에 관계없이 상수 시간만큼 소요됨.

- O(log n) : 데이터 구조에 있는 아이템이 늘어나면 천천히 연산의 횟수가 늘어나게 됨.
- O(n) : 중간 단계의 퍼포먼스. 데이터 구조와 연산횟수가 일차함수를 그리며 증가함.
- O(nlog n) : (데이터가 10M~100M 넘어갈 경우) 낮은 단계의 퍼포먼스를 보여주는 그래프. 비교 기반 정렬(comparison based sort)의 시간복잡도 하한(lower bound)이기도 함.
- O(n^2) : 데이터 구조에 있는 아이템 수의 제곱에 비례하여 늘어남. 여기서부터는 성능이 매우 떨어짐.







** [참고](https://github.com/younatics/Collection-Data-Structures-Swift-KR)