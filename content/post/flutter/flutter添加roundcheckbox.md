---
title: "Flutter添加roundcheckbox"
date: 2024-04-04T11:06:41+08:00
lastmod: 2024-04-04T11:06:41+08:00
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


## roundcheckbox的使用

### 1.roundcheckbox

官方链接见[https://pub-web.flutter-io.cn/packages/roundcheckbox](https://pub-web.flutter-io.cn/packages/roundcheckbox)

支持iOS/Android/Web/MacOS/Linux/Windows

### 2.pubspec.yaml添加依赖

```yaml
  roundcheckbox: ^2.0.5
```

### 3.示例

* flutter_toast_widget.dart
```dart
import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class RoundCheckboxPage extends StatelessWidget {
  static const double roundBoxSize = 50;

  const RoundCheckboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            RoundCheckBox(
              onTap: (selected) {},
              size: roundBoxSize,
            ),
            const SizedBox(height: 10),
            RoundCheckBox(
              onTap: (selected) {},
              size: roundBoxSize,
              uncheckedColor: Colors.yellow,
            ),
            const SizedBox(height: 10),
            RoundCheckBox(
              onTap: (selected) {},
              border: Border.all(
                width: 4,
                color: Colors.red,
              ),
              uncheckedColor: Colors.red,
              uncheckedWidget: const Icon(Icons.close, color: Colors.white),
              size: roundBoxSize,
            ),
            const SizedBox(height: 10),
            RoundCheckBox(
              onTap: (selected) {},
              uncheckedWidget: const Icon(Icons.close),
              size: roundBoxSize,
            ),
            const SizedBox(height: 10),
            RoundCheckBox(
              onTap: (selected) {},
              uncheckedWidget: const Icon(Icons.close),
              animationDuration: const Duration(
                milliseconds: 50,
              ),
              size: roundBoxSize,
            ),
            const SizedBox(height: 10),
            RoundCheckBox(
              onTap: (selected) {},
              checkedWidget: const Icon(Icons.mood, color: Colors.white),
              uncheckedWidget: const Icon(Icons.mood_bad),
              animationDuration: const Duration(
                seconds: 1,
              ),
              size: roundBoxSize,
            ),
            const SizedBox(height: 10),
            RoundCheckBox(
              onTap: (selected) {},
              uncheckedWidget: const Icon(Icons.close),
              isChecked: true,
              size: roundBoxSize,
            ),
            const SizedBox(height: 12),
            RoundCheckBox(
              onTap: (selected) => debugPrint('RoundCheckBox $selected'),
              uncheckedWidget: const Icon(Icons.close),
              isChecked: true,
              size: roundBoxSize,
            ),
            const SizedBox(height: 12),
            const RoundCheckBox(
              onTap: null,
              uncheckedWidget: Icon(Icons.close),
              isChecked: true,
              size: roundBoxSize,
            ),
            const SizedBox(height: 12),
            RoundCheckBox(
              onTap: null,
              uncheckedWidget: const Icon(Icons.close),
              disabledColor: Colors.purple[300],
              isChecked: true,
              size: roundBoxSize,
            ),
          ],
        ),
      ),
    );
  }
}

```

### 4.效果

![image](/images/flutter/flutter添加roundcheckbox/result.png)

### 5.小结

* 使用roundcheckbox包来创建自定义样式的复选框，通过不同属性设置，展示了多种圆形复选框的样式。
  * 设置大小、选中与非选中状态的颜色、边框样式、选中与非选中状态的图标、动画时长、禁用状态下的颜色等。

