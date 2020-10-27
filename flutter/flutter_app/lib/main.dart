import 'package:flutter/material.dart';
import 'dart:collection';

void main() {
  print("Hello, Flutter!");

  // 정수
  int integerNumber = 1;

  // 부동 소수점 숫자
  double floatingPointNumber = 1.0;

  // 문자열
  String greeting = "Hello, Flutter!";

  // 불리언: 참 또는 거짓
  bool isHidden = false;

  // 리스트: 중복을 허용하며, 순서가 있는 컬렉션 자료 구조
  List<int> numbers = [1, 2, 3, 4];

  // 셋: 중복을 허용하지 않으며, 순서가 없는 컬렉션 자료 구조
  Set<int> numberSet = [1, 2, 3, 2];

  // 맵: 키-값 쌍으로 구성된 자료 구조
  Map<String, int> students = {
    'jaeeun': 3,
    'pilvi': 22
  };

  // 변수 선언, 타입 추론: 자료형을 명시하지 않아도 됨
  var greet = "Hello, Flutter!";

  // 자료형 명시
  String nickname = "jaeeun";

  // 변경하지 않을 변수
  final weight = 20;
  final double height = 165.0;

  final number = [1, 2];
  number.add(3); // 가능: 설정된 값을 조작할 수 있음

  // 컴파일 타임 상수: 값을 변경할 수 없음
  // 암시적으로 `final`의 특성을 갖게 됨
  const numberOfItems = 12;
  const String identifier = 'basic';

  // 반복문
  // for ([초기식]; [조건식]; [변화식]) { }
  // for ([타입] [변수명] in [리스트]) { }
  for (int i = 0; i < 2; ++i) {
    print(i);
  }

  // 조건문
  // while ([조건식]) { }
  List<int> n = [1, 2, 3];
  while (n.isNotEmpty) {
    int lastNumber = n.removeLast();
    print(lastNumber);
  }

  // 함수
  // [반환형] [함수 이름]([매개변수 타입] [매개변수 이름], ...) {
  //     [함수의 구현]
  //     return [반환할 값]
  // }
  int add(int a, int b) {
    return a + b;
  }
  add(3, 4);

  // 함수 구현이 한 줄일 때, 화살표 구문 축약 가능
  int add2(int a, int b) => a + b;

  // 객체로서의 함수
  // 함수는 일급 객체(first-class citizen)로서 함수의 인자로 전달할 수 있음
  void printNumber(int number) {
    print(number);
  }

  void processNumbers(List<int> numbers, Function process) {
    for (int number in numbers) {
      process(number);
    }
  }

  final nn = [1, 2, 3];
  processNumbers(nn, printNumber);

  // 'dart:io'
  // : File, socket, HTTP 등 서버 어플리케이션을 위한 I/O 지원을 제공함
  // : Web 어플리케이션에서는 지원하지 않음
  // : 많은 I/O 작업들은 [Future](https://api.dartlang.org/stable/2.5.0/dart-async/Future-class.html)나
  // [Stream](https://api.dartlang.org/stable/2.5.0/dart-async/Stream-class.html) 클래스를 사용하여 비동기적으로 처리되고
  // ['dart:async'](https://api.dartlang.org/stable/2.5.0/dart-async/dart-async-library.html) 라이브러리에서 확인할 수 있음

  // 'dart:core'
  // Dart의 Built-in data types, collections 등 모든 Dart 프로그램의 핵심 기능을 제공함
  // 프로그램에 자동으로 import 되어 있음

  // 'dart:math'
  // 수학적 연산에 필요한 상수나 함수, 랜덤 숫자 생성기를 제공함

  // 'dart:convert'
  // 서로 다른 데이터 표현(ex. JSON, UTF-8) 간의 변환을 위한 Encoders, Decoders를 제공함

  // import 'dart:collection';
  // FIFO 방식의 리스트 Queue를 사용함

  Queue numQ = Queue();
  numQ.addAll([100, 200, 300]);
  Iterator i = numQ.iterator;

  while (i.moveNext()) {
    print(i.current);
  }

  // 클래스
  // var coffee = Coffee(2);
  // coffee.describe(); // Price is 2000.

  // 상속
  // coffee = Latte(2, 3);
  // coffee.describe(); // Price is 3500.

  // 추상 클래스
  var americano = Americano(2);
  americano.describe();
  americano.description();

  var latte = Latte(2, 4);
  latte.describe();
  latte.description();

  // 인터페이스
  americano.addIce();
  americano.describe();

  americano.addBlackSugar();
  americano.describe();

  runApp(MyApp());
}

// * 모든 자료형이 클래스로 구현되어 있음
// * 타입이 결정된 변수는 이후에 타입을 변경할 수 없음

// 클래스
// Dart는 클래스 및 믹스인 기반 상속을 지원하는 객체 지향 언어
// 클래스는 속성과 행위를 갖는 객체를 추상화시킨 것

// class Coffee {
//   int price;
//   int shot;
//
//   void describe() {
//     print("Price is $price.");
//   }
//
//   // 생성자
//   Coffee(int shot) {
//     this.shot = shot;
//     price = shot * 1000;
//   }
// }

// 상속
// 부모 클래스가 가지고 있는 모든 것을(생성자 제외) 자식 클래스가 물려받아 같이 공유하며 나아가 확장하는 개념
// 부모 클래스 super class, 자식 클래스 sub class라고 표현하기도 함
// * super: 부모 클래스를 참조하는 데에 사용함. 부모 클래스의 생성자가 호출됨. `super.메소드명`을 통해 부모 클래스에 있는 메소드를 호출할 수도 있음.
// * 단일 상속: 다중 상속을 지원하지 않음. extends 키워드를 통해 여러 개의 부모 클래스를 가질 수 없음.
// * 오버라이딩(override): 부모 클래스의 메소드를 자식 클래스에서 재정의하여 사용할 수 있음.
// `extends` 키워드 사용
// 상위 클래스에 정의된 멤버 변수와 메소드를 상속 받아 새로운 클래스를 만들 수 있음.

// class Latte extends Coffee {
//   int milk;
//
//   Latte(int shot, this.milk): super(shot) {
//     price = shot * 1000 + milk * 500;
//   }
// }

// 추상 클래스
// Dart는 `abstract class` 형식의 추상 클래스를 제공함.
// 밑그림처럼 동작을 구현하지 않은 기능을 정의하고, 상속을 받아 실제 동작에 대한 내용을 구현(재정의)함.
// Coffee 객체는 생성할 수 없음.
// 완전한 메소드 `describe()`, 불완전한 메소드 `description()`을 모두 선언할 수 있음.
// 추상 클래스를 상속 받은 하위 클래스는 추상 클래스에 명시된 불완전한 함수를 구현해야 함.
// 완전한 메소드는 부모 클래스의 구현을 그대로 사용할 수 있음.

abstract class Coffee {
  int price;
  int shot;

  Coffee(this.shot) {
    price = shot * 1000;
  }

  void describe() {
    print("Price is $price.");
  }

  void description();
}

// class Americano extends Coffee {
//   Americano(int shot): super(shot);
//
//   @override
//   void description() {
//     print("Americano는 에스프레소에 물을 타서 희석시킨 커피입니다.");
//   }
// }

class Latte extends Coffee {
  int milk;

  Latte(int shot, this.milk): super(shot) {
    super.price += milk * 500;
  }

  @override
  void description() {
    print("Latte는 오스트리아식 커피우유인 카푸치노를 미국식으로 변형한 커피입니다.");
  }
}

// 인터페이스 `Implicit interfaces`
// 추상 클래스에 선언된 모든 함수를 재정의하도록 규제하거나 상속에서 불가능했던 다중 상속을 가능하게 만들 수 있음.
// Dart는 위와 같은 다른 언어의 `interface` 개념이 구분되지 않고, 모든 클래스가 그 역할을 할 수 있도록 만들었음.
// implements한 클래스에서 구현한 내용은 사용할 수 없고, 사용하려면 상속이나 추상 클래스를 활용해야 함.
// 특정한 기능을 구현하도록 강제만 함.
abstract class Ice {
  void addIce();
}

// 일반 클래스도 `Implicit interface`로 만들 수 있음.
// 완전한 메소드도 재정의해야 함.
class BlackSugar {
  void addBlackSugar() {}
}

class Americano extends Coffee implements Ice, BlackSugar {
  Americano(int shot): super(shot);

  @override
  void description() {
    print("Americano는 에스프레소에 물을 타서 희석시킨 커피입니다.");
  }

  @override
  void addIce() {
    this.price += 500;
  }

  @override
  void addBlackSugar() {
    this.price += 300;
  }
}





class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
