# Error Handling

```swift
// `Error` 프로토콜을 준수하면 Swift의 에러 핸들링 시스템에서 에러로 표시할 수 있음 
enum APIError: Error {
    case invalidURL
    case invalidData
  	case invalidResponse
  	// error에 관한 추가 세부사항이 있다면 정보를 포함한 associated value를 사용
    case failedRequest(Int)
    case failedDecoding
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("유효하지 않은 URL입니다.", comment: "invalidURL")
        case .invalidData:
            return NSLocalizedString("유효하지 않은 데이터입니다.", comment: "invalidData")
        case .invalidResponse:
            return NSLocalizedString("유효하지 않은 응답입니다.", comment: "invalidResponse")
        case .failedRequest(let code):
            return NSLocalizedString("네트워크 요청에 실패했습니다. code: \(code)", comment: "failedRequest")
        case .failedDecoding:
            return NSLocalizedString("데이터 디코딩에 실패했습니다.", comment: "failedDecoding")
        }
    }
  	// Ex: invalidURL case만 작성
    var failureReason: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("에러 발생 이유", comment: "My error")
        ...
        }
    }
    var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("에러 해결 방법", comment: "My error")
        ...
        }
    }
   var helpAnchor: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("에러 도움말", comment: "My error")
        ...
        }
    }
}

let error: APIError = APIError.invalidURL
print(error.localizedDescription) // 유효하지 않은 URL입니다.
print(error.errorDescription) // Optional("유효하지 않은 URL입니다.")
print(error.failureReason) // Optional("에러 발생 이유")
print(error.recoverySuggestion) // Optional("에러 해결 방법")

extension APIError: CustomNSError {
    static var errorDomain: String {
        return "APIError"
    }
    var errorCode: Int {
        switch self {
        case .invalidURL:
            return 999
        ...
        }
    }
    var errorUserInfo: [String: Any] { 
    		return [NSLocalizedDescriptionKey: errorDescription ?? "",
            		NSLocalizedFailureErrorKey: failureReason ?? "",
            		NSLocalizedRecoverySuggestionErrorKey: recoverySuggestion ?? ""] 
    } 
}

let nsError: NSError = APIError.invalidURL as NSError

print(nsError.code) // 999
print(error.errorCode) // 999
print(nsError.domain) // APIError
print(nsError.userInfo) // ["NSLocalizedFailure": "에러 발생 이유", "NSLocalizedDescription": "유효하지 않은 URL입니다.", "NSLocalizedRecoverySuggestion": "에러 해결 방법"]
print(error.errorUserInfo) // ["NSLocalizedRecoverySuggestion": "에러 해결 방법", "NSLocalizedFailure": "에러 발생 이유", "NSLocalizedDescription": "유효하지 않은 URL입니다."]
```

### 

### LocalizedError

> A specialized error that provides localized messages describing the error and why it occurred.
>
> : 오류와 발생한 이유를 설명하는 현지화 된 메시지를 제공하는 특수 오류



### try

> * `throws` 함수를 호출할 때 사용
> * `throw` 된 에러를 처리함

\- **try** : 오류를 외부로 전달 (`do ~ catch`)

\- **try!** : 오류 발생시에 프로그램 강제 종료 

\- **try?** : 오류를 던질지 말지 선택 (`optional` 처럼 사용)

```swift
// Ex)
func fetchResult() throws {
    throw APIError.invalidData
}

func test() {
    do {
        try fetchResult()
    }
    catch let error as APIError {
        print(error.errorDescription)
    } catch {
        print("Other error: \(error)")
    }
}
```



### 에러가 발생했을 때, 처리하고 싶은 것이 있다면? => `defer` 활용

```swift
// 참고: https://hongprogrammer.tistory.com/entry/Swift-%EC%98%A4%EB%A5%98-%EC%B2%98%EB%A6%AC-2
// Ex: 예외가 발생했을 때, 기존 Data를 defer block에서 삭제
func writeToFiles(data: [URL: String]) throws {
    var completed = [URL]()
    
    //defer block에서는 defer 밖으로 Error를 던질 수 없다.
    defer {
        if completed.count != data.count {
            print("예외가 발생했습니다. - \(completed)")
            for url in completed {
                do {
                    try FileManager.default.removeItem(at: url)
                } catch {
                    print("복구할 수 없는 오류 발생")
                }
            }
        }
    }
    for (url, contents) in data {
        try contents.write(to: url, atomically: true, encoding: .utf8)
        completed.append(url)
    }
}
```



### 에러에 관련된 공통적인 추가 data가 있다면 struct로 만들 수도 있음

```swift
// 참고: https://velog.io/@wonhee010/Enum%EA%B3%BC-Error%EC%97%90-%EB%8C%80%ED%95%98%EC%97%AC
struct XMLParsingError: Error {
    enum ErrorKind {
        case invalidCharacter
        case mismatchedTag
        case internalError
    }
  
    let line: Int
    let column: Int
    let kind: ErrorKind
}

func parse(_ source: String) throws -> XMLDoc {
    // ...
    throw XMLParsingError(line: 19, column: 5, kind: .mismatchedTag)
    // ...
}

do {
    let xmlDoc = try parse(myXMLData)
} catch let e as XMLParsingError {
    print("Parsing error: \(e.kind) [\(e.line):\(e.column)]")
} catch {
    print("Other error: \(error)")
}
```