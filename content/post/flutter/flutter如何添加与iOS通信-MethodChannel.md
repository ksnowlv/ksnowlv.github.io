---
title: "Flutter如何添加与iOS通信-MethodChannel"
date: 2024-04-26T18:43:50+08:00
lastmod: 2024-04-26T18:43:50+08:00
keywords: ["flutter"]
tags: ["flutter"]
categories: ["flutter"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


iOS与flutter通信有以下MethodChannel，BasicMessageChannel，EventChannel三种方式，我们先介绍下MethodChannel

### 1 方法通道（Method Channels）
允许iOS和Flutter之间互相进行方法调用,传递复杂数据。

优点：支持双向通信，可以传递复杂的数据结构，如 JSON 对象，并且可以进行异步调用。
不足：通信是一次性的，每次调用都需要重新建立连接；在主线程中调用，如果方法执行时间过长，可能会阻塞Flutter或IOS的UI主线程。


### 2.iOS端的Method Channels

初始化com.example.flutter_channel方法通道，并在iOS端调用了openFlutterView方法，传递了**ksnowlv**,**10**两个参数；


```swift

//
//  ViewController.swift
//  FlutterModuleTest
//
//  Created by ksnowlv on 2024/3/22.
//

import UIKit

import Flutter

class ViewController: UIViewController {
    @IBOutlet weak var flutterInfoLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showFlutterView()  {
        let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        
        
        let methodChannel = FlutterMethodChannel(name:"com.example.flutter_channel",binaryMessenger:flutterViewController as!FlutterBinaryMessenger)
        //向flutterView发送消息
        methodChannel.invokeMethod("openFlutterView",arguments:["ksnowlv",10])
        
        // 处理Flutter的返回消息
        methodChannel.setMethodCallHandler { (call,result) in
            if call.method == "dataFromFlutter" {
                print("data from flutter \(String(describing: result))")
                if let arguments = call.arguments as?Dictionary<String,Any>,
                   let message = arguments["message"] as?String,
                   let count = arguments["count"] as?Int {
                    
                    //确保执行在主线程中，目前返回的消息是回调到主线程中的；
                    DispatchQueue.main.async { [self] in
                        flutterInfoLabel.text = "from flutter:message:\(message),count:\(count)"
                    }
                    // 返回一个结果给Flutter
                    result("Data received successfully")
                }
            }
        }
        
        let navigationController = UINavigationController(rootViewController: flutterViewController)
        navigationController.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissFlutterViewController))
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func dismissFlutterViewController() {
        dismiss(animated: true, completion: nil)
        
    }
}


```


### 3.flutter端的Method Channels

初始化**com.example.flutter_channel** 方法通道,并接收openFlutterView方法调用，处理来自iOS端的两个参数，name，age，并显示在flutter视图上；

当点击**send data to iOS**按钮时，调用**dataFromFlutter**方法，并传递含有message，count字段的Map；

当然，也可以传递json结构的数据。

```dart
class _MyHomePageState extends State<MyHomePage> {
  static const methodChannel = MethodChannel('com.example.flutter_channel');
  String name = '';
  int age = 0;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    //处理来自iOS端方法调用
    methodChannel.setMethodCallHandler((call) async {
      debugPrint("Method call: ${call.method}");
      if (call.method == "openFlutterView") {
        if (call.arguments.length == 2) {
          name = call.arguments[0];
          age = call.arguments[1];
          setState(() {
            debugPrint("name: $name, age: $age");
          });
        }

        // Do something with the arguments if needed
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
      
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(' data {name:$name, age:$age} from iOS'),

            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  try {
                    final Map<String, dynamic> arguments = {
                      'message': 'I am air from Flutter',
                      'count':_counter 
                    };
                    final String result = await methodChannel.invokeMethod(
                        'dataFromFlutter', arguments);

                    debugPrint('send data to iOS: $result');
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                child: const Text('send data to iOS'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
```

### 4.效果

![image](/images/flutter/flutter如何添加与iOS通信-MethodChannel/result1.png)

![image](/images/flutter/flutter如何添加与iOS通信-MethodChannel/result2.png)

**iOS端日志**

```shell
flutter: Method call: openFlutterView
flutter: name: ksnowlv, age: 10
data from flutter (Function)
flutter: send data to iOS: Data received successfully

```