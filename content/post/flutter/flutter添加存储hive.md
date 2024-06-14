---
title: "Flutter添加存储hive"
date: 2024-03-21T09:10:54+08:00
lastmod: 2024-03-21T09:10:54+08:00
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

## 一.hive简介

Hive是一个强大的 Flutter存储解决方案，特别适合需要存储复杂数据类型和跨平台共享数据的应用。轻量级的简单存储，建议不要使用。

### Hive的用途和使用场景：

* 持久化存储：Hive 可以用来持久化存储应用的状态，例如用户的偏好设置、用户数据，应用配置等。
* 跨平台数据共享：Hive 支持将数据存储在本地，因此它可以在不同的平台间共享数据，例如 iOS 和 Android。
* 复杂数据类型存储：Hive 支持存储复杂的数据类型，如列表、映射、对象等。
* 本地缓存：Hive 也可以用来作为本地缓存，存储从服务器获取的数据，以提高应用性能和用户体验。

### Hive优势

* 简单易用：Hive提供了简洁的 API，使得数据存储变得简单直观。
* 类型安全：Hive使用代码生成来提供类型安全的数据访问，减少了运行时错误的可能性。
* 高性能：Hive的数据存储和检索速度很快，适合需要高性能本地存储的应用。
* 支持复杂数据类型：Hive可以存储和检索复杂的数据结构，如列表和映射，而不仅仅是简单的键值对。
* 跨平台兼容：Hive可以在Flutter支持的多个平台上工作，包括移动、Web 和桌面。

### Hive缺点：

* 本地存储限制：Hive依赖于设备的本地存储空间，如果应用需要存储大量数据，可能会受到限制。
* 额外的复杂性：虽然Hive简化了很多存储任务，但在某些情况下，它可能会给项目带来额外的复杂性，特别是对于只需要简单存储功能的应用。
* 数据迁移问题：当应用的数据模型发生变化时，可能需要进行数据迁移，这可能会导致额外的工作量。

 
## 二.hive的使用

### 1.hive

官方链接见[https://pub-web.flutter-io.cn/packages/hive](https://pub-web.flutter-io.cn/packages/hive)

支持Android/iOS/linux/MacOS/Web/Windows

### 2.pubspec.yaml添加依赖

```yaml
  hive: ^2.2.3
  path_provider: ^2.1.2
```

### 3.示例

* hive_manage.dart

```dart
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class HiveManage {
  static HiveManage? _instance;
  // Avoid self instance
  HiveManage._();
  static HiveManage get instance => _instance ??= HiveManage._();

  static const String boxName = "base_demo";

  static init() async {
    final appDocumentDirectory =
    await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path); // 初始化Hive，指定存储路径
    await Hive.openBox(boxName); // 打开名为'myBox'的数据盒子
  }


  static Box<dynamic> getBox() {
    return Hive.box(boxName);
  }
}

```

* HiveWidget.dart

```dart
import 'package:base_demo/common/hive_manage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HiveWidget extends StatefulWidget {
  const HiveWidget({super.key});

  @override
  HiveWidgetState createState() => HiveWidgetState();
}

class HiveWidgetState extends State<HiveWidget> {
  String _name = '';
  int _age = 0;


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("name:$_name, age: $_age"),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {

                  setState(() {
                    _name = 'ksnowlv';
                    _age = 10;
                  });

                  var box = HiveManage.getBox();
                  box.put('name', _name);
                  box.put('age', _age);
                  debugPrint('hive write name: $_name, age: $_age');
                },
                child: const Text('save')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  var box = HiveManage.getBox();

                  setState(() {
                    _name = box.get('name');
                    _age = box.get('age');

                    debugPrint('hive read: name: $_name, age: $_age');
                  });
                },
                child: const Text('read')),
            const SizedBox(
              height: 20,
            ),
            const Text('网络json文件播放Lottie动画示例'),
            SizedBox(
              width: 300, // 替换为适当的宽度
              height: 200, // 替换为适当的高度
              child: Lottie.network(
                  'https://lottie.host/818be078-1686-4e92-b663-251c4d97e4c0/qNnbLZil3p.json'),
            ),
            const Text('本地json文件播放Lottie动画示例'),
            SizedBox(
              width: 300, // 替换为适当的宽度
              height: 200, // 替换为适当的高度
              child: Lottie.asset('lottiefile/animation - 1710978871330.json',
                  onLoaded: (composition) {
                    debugPrint('composition:${composition.duration}');
                  }),
            )
          ],
        ));
  }
}

```

* main.dart

```dart
void main() async {
  XLogger.getLogger().d("main init");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();
  //hive init
  await HiveManage.init();
  runApp(const MyApp());

}
```

### 4.效果

```shell
flutter: composition:0:00:01.000000
flutter: hive write name: ksnowlv, age: 10
flutter: hive read: name: ksnowlv, age: 10
```