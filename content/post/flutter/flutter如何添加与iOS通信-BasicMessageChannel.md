---
title: "Flutter如何添加与iOS通信 BasicMessageChannel"
date: 2024-04-26T23:00:09+08:00
lastmod: 2024-04-26T23:00:09+08:00
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


iOS与flutter通信有以下MethodChannel，BasicMessageChannel，EventChannel三种方式，此次介绍下BasicMessageChannel用法

### 1. 基本消息通道（BasicMessageChannel）


主要用于传递字符串或结构化消息（如 JSON，XML等）。

* 优点：适用于需要响应消息的场景，可以进行连续通信。
* 不足：不支持方法调用的模式，主要限于消息传递。

### 2.iOS端的BasicMessageChannel

初始化**com.example.flutter_channel_basic_message_channel**基本消息通道，并在iOS端调用sendMessage，传递了**ksnowlv**,**10**两个参数到flutter端；

```swift

 func setupBasicMessageChannel(_ flutterViewController: FlutterViewController) {
        let flutterMessageChannel = FlutterBasicMessageChannel(name:"com.example.flutter_channel_basic_message_channel",binaryMessenger:flutterViewController as!FlutterBinaryMessenger)
        
        let arguments:[String:Any] = [
            "name":"ksnowlv from iOS",
            "age":10
        ]
        
        //向Flutter端发送消息
        flutterMessageChannel.sendMessage(arguments) { (reply) in
            print("Received reply from Flutter:\(String(describing: reply))")
            
        }
        
        // 监听Flutter发送到iOS端的消息
        flutterMessageChannel.setMessageHandler { [weak self] (message, reply)  in
            
            if let data = message as? Dictionary<String,Any>,
                let msg = data["message"] as? String,
               let count = data["count"] as? Int {
                
                DispatchQueue.main.async { [weak self] in
                    // 在主线程中更新UI
                    self?.flutterInfoLabel.text = "from flutter:message:\(msg),count:\(count)"
                }
                // 返回一个结果给Flutter
                reply("iOS Data received successfully")
                
                print("Received result from Flutter: \(message)")
                
            }
        }
    }
    
```


### 3.flutter端的BasicMessageChannel

#### 3.1。声明和iOS端相同的消息通道

```dart
  static const messageChannel = BasicMessageChannel<dynamic>(
  'com.example.flutter_channel_basic_message_channel',
  StandardMessageCodec(),
);

```

#### 3.2.初始化基本消息通道，并监听消息

初始化基本消息通道的同时，监听iOS端的发送的消息，处理消息，并显示在flutter视图上；


```dart
  void initMessageChannel() {
  messageChannel.setMessageHandler((message) async {
    if (message != null && message is Map) {
      messageChannelName = message['name'];
      messageChannelAge = message['age'];

      setState(() {
        debugPrint("MessageChannel name: $messageChannelName, age: $messageChannelAge");
      });
    }
    // Return an optional reply back to iOS
    return "Data received by Flutter";
  });
}

```

#### 3.3 flutter端向iOS端发送消息

```dart
  void _messageChannelSendMessageToiOS() async {
    try {
      final Map<String, dynamic> arguments = {
        'message': 'BasicMessageChannel I am air from Flutter',
        'count': _counter
      };
      final String result = await messageChannel.send(arguments);

      debugPrint('BasicMessageChannel  send data to iOS: $result');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
```

### 4.效果

![image](/images/flutter/flutter如何添加与iOS通信-BasicMessageChannel/result1.png)

![image](/images/flutter/flutter如何添加与iOS通信-BasicMessageChannel/result2.png)

**iOS端日志**

```shell
flutter: Method call: openFlutterView
flutter: name: ksnowlv, age: 10
flutter: MessageChannel name: ksnowlv from iOS, age: 10
Received reply from Flutter:Optional(Data received by Flutter)
Received result from Flutter: Optional({
    count = 4;
    message = "BasicMessageChannel I am air from Flutter";
})
flutter: BasicMessageChannel  send data to iOS: iOS Data received successfully

```
