---
title: "Flutter使用Future和async/Await异步操作"
date: 2024-03-21T18:28:06+08:00
lastmod: 2024-03-21T18:28:06+08:00
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

## Flutter中Future和async/Await异步操作

### 1.Flutter异步操作简介

* Future 表示一个尚未完成但最终会完成的操作；
  * Future 是一个表示将来某个时间点会完成的操作的对象。它通常用于处理如网络请求、文件读写、数据库操作等异步I/O操作。Future 可以完成（完成时携带一个值）或者失败（失败时携带一个错误）。

* async/await 是Dart语言提供的语法糖，使得异步代码的编写更加简洁和直观。
  * async 是一个修饰符，用于标记一个函数体内可能包含异步操作。它通常与 await 一起使用。
  * await 关键字用于等待一个 Future 完成，并获取它的结果。当 await 一个 Future 时，代码会暂停执行直到 Future 完成，然后将控制权交回给异步操作

所以Flutter中，我们可以使用`Future`和`async/await`来处理网络请求、文件读写、数据库操作等异步操作，保持应用的流畅性。

### 2. 使用Future
`Future`表示可能在未来完成的操作，并提供了一种处理异步操作的方式。

通过创建`Future`来执行异步任务，然后使用`then`方法处理任务完成后的结果。


```dart

Future<int> _fetchLocalData() {
  return Future.delayed(const Duration(seconds: 1), () {
    // 耗时操作
    return 100;
  });
}

```
调用如下
```dart
  _fetchLocalData().then((value) {
    debugPrint('获取到的数据：$value');
  }).catchError((error) {
    debugPrint('发生错误：$error');
  });
```

### 3. 使用async/await
`async`关键字定义函数是异步，`await`关键字用于等待异步操作完成；通过`async/await`组合，实现异步调用。

```dart
  Future<int> _fetchNetData() async {
    await Future.delayed(const Duration(seconds: 2));
    // 耗时操作
    return 101;
  }
```

调用如下
```dart
   try {
      var f = await _fetchNetData();
      debugPrint('获取到的数据：$f');
    } catch (e) {
      debugPrint(e as String?);
    }
```

使用`async/await`可以让异步操作更简洁易懂，不必依赖于多个嵌套的`then`回调。

### 4.容错处理
异步操作中，异常容错非常重要。可以使用`catchError`捕获`Future`中发生的错误，也可以使用`try/catch`在`async`函数中捕获错误。

```dart
Future<int> _fetchData() async {
  try {
    // 耗时操作
    await Future.delayed(const Duration(seconds: 1));
    return 102;
  } catch (error) {
    debugPrint('发生错误：$error');
    return -1;
  }
}
```

调用如下
```dart
  var f = await _fetchData();
  debugPrint('获取到的数据：$f');
  
```

### 5.完整示例代码

```dart
import 'package:flutter/material.dart';

class FutureWidget extends StatefulWidget {
  const FutureWidget({super.key});

  @override
  FutureWidgetState createState() => FutureWidgetState();
}

class FutureWidgetState extends State<FutureWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              _fetchLocalData().then((value) {
                debugPrint('获取到的数据：$value');
              }).catchError((error) {
                debugPrint('发生错误：$error');
              });
            },
            child: const Text('Future处理')),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () async {
              try {
                var f = await _fetchNetData();
                debugPrint('获取到的数据：$f');
              } catch (e) {
                debugPrint(e as String?);
              }
            },
            child: const Text('async/await处理')),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () async {
              var f = await _fetchData();
              debugPrint('获取到的数据：$f');
            },
            child: const Text('异常处理')),
      ],
    );
  }

  Future<int> _fetchLocalData() {
    return Future.delayed(const Duration(seconds: 1), () {
      // 耗时操作
      return 100;
    });
  }

  Future<int> _fetchNetData() async {
    await Future.delayed(const Duration(seconds: 2));
    // 耗时操作
    return 101;
  }

  Future<int> _fetchData() async {
    try {
      // 耗时操作
      await Future.delayed(const Duration(seconds: 1));
      return 102;
    } catch (error) {
      debugPrint('发生错误：$error');
      return -1;
    }
  }
}

```

### 6.效果

```shell
Reloaded 3 of 2602 libraries in 909ms (compile: 69 ms, reload: 226 ms, reassemble: 486 ms).
flutter: 获取到的数据：100
flutter: 获取到的数据：101
flutter: 获取到的数据：102
flutter: 获取到的数据：100
flutter: 获取到的数据：101
flutter: 获取到的数据：102
```

### 7.小结

* Future和async/Await异步操作，可以处理计算或IO类型的数据处理任务，避免在主UI线程中执行这些耗时任务。
* 与多线程相比，异步操作，轻量简洁，高效，易懂；


