# Alamofire

> **Swift 기반 HTTP 네트워킹 라이브러리** [Github](https://github.com/Alamofire/Alamofire)

* 네트워킹 작업을 단순화하고 네트워킹을 위한 다양한 메소드와 JSON 파싱 등을 제공함.



## HTTP

> 서버에서 클라이언트로 데이터를 전송하기 위해 사용하는 어플리케이션 프로토콜

* **GET** : 데이터를 가져옴.
* **HEAD** : GET과 동일하지만 실제 데이터가 아닌 `header`만 요청함.
* **POST** : 서버에 데이터를 보냄. 
* **PUT** : 특정 위치에 데이터를 보냄.
* **DELETE** : 특정 위치의 데이터를 삭제함.



## JSON(`JavaScript Object Notaion`)

> 경량의 데이터 교환 형식

* 시스템 간에 데이터 전송을 위한 단순하고 가독성이 좋은 메커니즘을 제공함. 
* `JSON`에서 사용할 수 있는 데이터 타입은 제한적임.(string, boolean, array, object, dictionary, number, null)

* `Swift`에서는 `Codable`을 사용해서 쉽게 인코딩/디코딩을 할 수 있음.



## REST

> 일관성 있는 웹 API를 설계하기 위한 규약

* `REST`는 요청 간 상태를 유지하지 않고, 요청을 `cacheable`하게 만들고, 균일한 인터페이스를 제공하는 것과 같은 표준을 위한 설계 규약을 가짐. 



## 주요 함수

* AF.upload : 스트림, 파일 메소드 등을 통해 파일을 업로드함.
* AF.download : 파일을 다운로드 하고나, 이미 진행중인 다운로드를 재개함.
* AF.request : 파일 전송과 관련 없는 기타 HTTP 요청



```swift
func fetch() {
	let request = AF.request("http://")
	request.responseJSON { (data) in 
		print(data) 
	}
}

struct Film: Decodable {
  let id: Int 
  let title: String
  let openingCrawl: String 
  
  enum CodingKeys: String, CodingKey {
    case id = "episode_id"
    case title
    case openingCrawl = "opening_crawl"
  }
}

AF.request("https://")
	.validate()
	.responseDecodable(of: Film.self) { (response) in 
		guard let films = response.value else { return } 
}
// endpoint에 요청하고, 응답이 HTTP 상태 코드를 반환하는지 유효성 검사를 한 뒤 데이터 모델로 decode 하는 과정

private func fetch<T: Decodable & Displayable>(_ list: [String], of: T.Type) {
  var items: [T] = []
  let fetchGroup = DispatchGroup() // 비동기적으로 이루어지는 작업, 순서도 지켜지지 않음. 모든 작업들이 끝나면 알 수 있음.
  
  list.forEach { (url) in 
		fetchGroup.enter() // DispatchGroup에 작업을 알림
		AF.request(url).validate().responseDecodable(of: T.self) { (response) in 
		if let value = response.value {
    	items.append(value)
  	} 
    fetchGroup.leave() // 작업의 완료를 알림                                                        	
                                                             	}                                                             }
                
	fetchGroup.notify(queue: .main) {
    self.listData = items 
    self.listTableView.reloadData() 
  }
}
```















































