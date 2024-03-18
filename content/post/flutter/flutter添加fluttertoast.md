---
title: "Flutter添加fluttertoast"
date: 2024-03-18T20:48:08+08:00
lastmod: 2024-03-18T20:48:08+08:00
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


## fluttertoast的使用

### 1.fluttertoast

官方链接见[https://pub-web.flutter-io.cn/packages/fluttertoast](https://pub-web.flutter-io.cn/packages/fluttertoast)

支持iOS/Android/Web

### 2.pubspec.yaml添加依赖

```yaml
  fluttertoast: ^8.2.4
```

### 3.示例1

* flutter_toast_widget.dart
```dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FlutterToastWidget extends StatelessWidget {
  const FlutterToastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ElevatedButton(
              onPressed: () {
                Fluttertoast.showToast(msg: 'toast demo');
              },
              child: const Text("show default toast")
          ),
          ElevatedButton(
              onPressed: () {
                Fluttertoast.cancel();
              },
              child: const Text("cancel toast")
          ),

        ]);
  }
}


```

* 效果

![image](/images/flutter/flutter添加fluttertoast/result_1.png)

### 4.示例2

* regist_request.dart

```dart
   late FToast fToast;

    int _counter = 0;
    
    @override
    void initState() {
    
      super.initState();
    
      fToast = FToast();
      // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
      fToast.init(context);
    }

void _showToast() {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 22.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.greenAccent,
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check),
        SizedBox(
          width: 12.0,
        ),
        Text("This is a Custom Toast"),
      ],
    ),
  );


  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 12),
  );

  // Custom Toast Position
  fToast.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 10),
      positionedToastBuilder: (context, child) {
        return Positioned(
          top: 156.0,
          left: 16.0,
          child: child,
        );
      });
  }
  
```

* 效果

![image](/images/flutter/flutter添加fluttertoast/result_2.png)

![image](/images/flutter/flutter添加fluttertoast/result_3.png)

