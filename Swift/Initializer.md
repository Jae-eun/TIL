# initializer

1. class 초기화

   class SurveyQuestion {

   ​	var text: String

   ​	init() {

   ​		self.text = "jaeeun"

   ​	}

   }

   var question = SurveyQuestion()

   * init에 파라미터를 주지 않고 직접 프로퍼티에 값을 줄 수 있다.

     => 모든 클래스 인스턴스가 같은 프로퍼티 값을 가질 때 유용

2. class 초기화 2

   class SurveyQuestion {

   ​	var text: String

   ​	init(text: String) {

   ​		self.text = text

   ​	}

   }

   var question = SurveyQuestion(text: "hello")

   * init에 파라미터를 넣어 초기화 해도 됨. 넘겨주는 String에 따라서 text 프로퍼티의 값이 다른 클래스 인스턴스가 생김.

3. class 초기화 - 이름이 같은데 파라미터는 다른 경우

   class SurveyQuestion {

   ​	var text: String

   ​	init(text: String) {

   ​		self.text = text

   ​	}

   ​	init(questionText: String) {

   ​		self.text = questionText 

   ​	}

   ​	init(_ questionList: String) {

   ​		self.text = questionList

   ​	}

   }

var question = SurveyQuestion(text: "hello")

var cheeseQuestion = SurveyQuestion(questionText: "Do you?")

var questionList = SurveyQuestion("Health")



* _ 를 넣으면 메소드 호출시 파라미터 이름을 생략해도 됨.
* 타입이 다르면 파라미터 이름을 넘겨주지 않는 init이 여러개여도 됨.

4. 옵셔널 타입은 init에 없어도 된다.

   class SurveyQuestion {

   ​	var text: String

   ​	var response: String?

   ​	init(text: String) {

   ​		self.text = text 

   ​	}

   }

   * 옵셔널 타입인 프로퍼티는 클래스 인스턴스가 만들어질 때 nil로 초기화된다.



class SurveyQuestion {

​	var text: String

​	var response: String?

​	init(text: String, response: String) {

​		self.text = text

​		self.response = response

​	}

}

var a = SurveyQuestion(text: "jaeeun", response: "fun")

a.response = nil

var a = SurveyQuestion(text: "jae", response: nil) // error!



class SurveyQuestion {

​	var text: String

​	var response: String?

​	init(text: String, response: String?) {

​		self.text = text

​		self.response = response

​	}

}

var a = SurveyQuestion(text: "jae", response: nil) // 가능

a.response = nil // 가능















