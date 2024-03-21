---
title: "Flutter添加状态管理库provider"
date: 2024-03-21T11:20:47+08:00
lastmod: 2024-03-21T11:20:47+08:00
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


## provider的使用

### 1.provider

官方链接见[https://pub-web.flutter-io.cn/packages/provider](https://pub-web.flutter-io.cn/packages/provider)

支持Android/iOS/linux/MacOS/Web/Windows

### 2.pubspec.yaml添加依赖

```yaml
  provider: ^6.1.2
```

### 3.示例

* provider_widget.dart

```dart
import 'package:base_demo/widgets/getx_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterModel extends ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }

  void decrement() {
    _counter++;
    notifyListeners();
  }
}

class ProviderWidget extends StatefulWidget {
  const ProviderWidget({super.key});

  @override
  ProviderWidgetState createState() => ProviderWidgetState();
}

class ProviderWidgetState extends State<ProviderWidget> {


  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<CounterModel>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('counter value:${counter.counter}'),
        ElevatedButton(onPressed: () => counter.increment(), child: const Text('+')),
        ElevatedButton(onPressed: () => counter.decrement(), child: const Text('-')),
      ],
    );
  }
}

```

* main.dart

```dart
import 'package:provider/provider.dart';

void main() async {
  XLogger.getLogger().d("main init");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();

  await HiveManage.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CounterModel()),
      ],
      child: const MyApp(),
    ),
  );
}
```

### 4.小结

#### 1.创建数据模型类

数据模型类，通常会扩展ChangeNotifier类，并使用notifyListeners方法通知观察者进行更新。


#### 2.应用的顶层创建Provider
通过MultiProvider创建Provider，它创建的数据模型类给整个应用使用。

#### 3.使用Provider访问数据模型
在Widget中使用Provider.of来访问和使用您创建的数据模型。



