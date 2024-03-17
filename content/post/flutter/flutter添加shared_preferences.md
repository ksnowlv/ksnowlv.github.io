---
title: "Flutter添加shared_preferences"
date: 2024-03-17T08:47:00+08:00
lastmod: 2024-03-17T08:47:00+08:00
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

## shared_preferences的使用

### 1.shared_preferences

官方链接见[https://pub.dev/packages/shared_preferences](https://pub.dev/packages/shared_preferences)

轻量级数据存储，在各平台存储位置如下

| 平台 | 位置 |
|----|----|
| Android   |  SharedPreferences  |
|  iOS  | NSUserDefaults   |
|  Linux  |  In the XDG_DATA_HOME directory  |
|   macOS |  NSUserDefaults  |
|  Web  |  LocalStorage  |
|  Windows  |  In the roaming AppData directory  |


### 2.pubspec.yaml添加依赖

```yaml
  shared_preferences: ^2.2.2
```

### 3.示例

```dart
 // 加载姓名
_loadName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    _name = prefs.getString('name') ?? '';
  });
}

// 保存姓名
_saveName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('name', _nameController.text);
  _loadName(); // 保存完成后重新加载已保存的文本
}
```
