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


## hive的使用

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