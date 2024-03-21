---
title: "Flutter添加Isolate"
date: 2024-03-21T16:26:37+08:00
lastmod: 2024-03-21T16:26:37+08:00
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

## Isolate的使用

### 1.Isolate的简介

Isolate是Dart语言中处理并发的基本单元，每个Isolate都有自己的内存堆和消息通信通道，可以独立地执行任务而不受其他Isolate的影响。

Flutter中，可以使用Isolate来执行耗时的计算、IO操作或其他需要异步处理的任务，以确保不阻塞应用的主线程。


### 2.示例

* isolate_widget.dart

```dart
import 'package:flutter/material.dart';
import 'dart:isolate';

class IsolateWidget extends StatefulWidget {
  const IsolateWidget({super.key});

  @override
  IsolateWidgetState createState() => IsolateWidgetState();
}

class IsolateWidgetState extends State<IsolateWidget> {
  late ReceivePort _receivePort;
  String _message = '';
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    initIsolate();
  }

  @override
  void dispose() {
    super.dispose();
    _receivePort.close();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('message: $_message'),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(onPressed: () {

          setState(() {
            _counter++;
          });

          _receivePort.sendPort.send('Hello from main:$_counter');
        }, child: const Text('Isolate使用')),
      ],
    );
  }

  void initIsolate() async {
    // 创建接收端口
    _receivePort = ReceivePort();
    // 将接收端口的发送端口发送到Isolate
    // 监听来自Isolate的消息
    SendPort sendPort = _receivePort.sendPort;
    Isolate isolate = await Isolate.spawn(entryPoint, sendPort);
    _receivePort.listen((message) {
      debugPrint('Message from isolate: $message');
      if (message is String) {
        setState(() {
          // 更新UI
          _message = message;
        });
      }
    });
  }
}

void entryPoint(SendPort sendPort) {
  // 在这里执行耗时任务
  String result = 'Result of time-consuming task';
  sendPort.send(result);
}


```

### 3.效果

```shell
flutter: Message from isolate: Result of time-consuming task
flutter: Message from isolate: Hello from main:1
flutter: Message from isolate: Hello from main:2
flutter: Message from isolate: Hello from main:3
flutter: Message from isolate: Hello from main:4
flutter: Message from isolate: Hello from main:5
flutter: Message from isolate: Hello from main:6
flutter: Message from isolate: Hello from main:7
```

### 4.小结

* Isolate使用场景
  * 对于复杂的后台任务，可使用Isolate，通常用于需要长时间运行并且不需要与UI交互的任务。

* 计算密集型任务：compute或Isolate可能是更好的选择；
* I/O密集型任务：Future/async/await