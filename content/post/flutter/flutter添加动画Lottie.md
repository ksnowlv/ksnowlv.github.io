---
title: "Flutter添加动画Lottie"
date: 2024-03-21T10:27:00+08:00
lastmod: 2024-03-21T10:27:00+08:00
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

## Lottie的使用

### 1.Lottie

官方链接见[https://pub-web.flutter-io.cn/packages/hive](https://pub-web.flutter-io.cn/packages/hive)

支持Android/iOS/linux/MacOS/Windows

### 2.pubspec.yaml添加依赖

```yaml
  lottie: ^3.1.0

  assets:
    - images/
    - lottiefile/
```

注意把示例animation - 1710978871330.json文件添加到lottiefile目录下

### 3.示例

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

### 4.效果

![image](/images/flutter/flutter添加动画Lottie/result_1.png)