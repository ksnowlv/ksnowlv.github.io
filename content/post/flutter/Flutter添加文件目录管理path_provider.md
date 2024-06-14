---
title: "Flutter添加文件目录管理path_provider"
date: 2024-04-07T14:22:39+08:00
lastmod: 2024-04-07T14:22:39+08:00
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

### 1.添加path_provider

官方链接见[https://pub-web.flutter-io.cn/packages/path_provider](https://pub-web.flutter-io.cn/packages/path_provider)

支持平台Android/iOS/Linux/macOS/Windows

### 2.pubspec.yaml添加依赖

```yaml
  path_provider: ^2.1.2
```

### 3.示例

```dart
import 'package:path_provider/path_provider.dart';

class FileMgr {
  FileMgr._privateConstructor();

  static final FileMgr instance = FileMgr._privateConstructor();
  //文档目录
  String? _documentsDirectory;
  //临时目录
  String? _temporaryDirectory;
  //
  String? _cacheDirectory;

  //获取文档目录
  Future<String> getDocumentsDirectory() async {
    _documentsDirectory ??= (await getApplicationDocumentsDirectory()).path;

    return _documentsDirectory!;
  }

//获取临时目录
  /// - `NSCachesDirectory` on iOS and macOS.
  /// - `Context.getCacheDir` on Android.
  Future<String> getTemporaryDirectoryPath() async {
    _temporaryDirectory ??= (await getTemporaryDirectory()).path;
    return _temporaryDirectory!;
  }

//获取缓存目录
  Future<String> getApplicationSupportDirectoryPath() async {
    _cacheDirectory ??= (await getApplicationSupportDirectory()).path;
    return _cacheDirectory!;
  }
}

```

调用

```dart

 debugPrint('cacheDirectory:${await FileMgr.instance.getApplicationSupportDirectoryPath()}\n documentsDirectory:${await FileMgr.instance.getDocumentsDirectory()} \n temporaryDirectoryPath:${await FileMgr.instance.getTemporaryDirectoryPath()}');


```

### 4.效果

```shell
flutter: cacheDirectory:/Users/ksnowlv/Library/Developer/CoreSimulator/Devices/F35779E0-8AA1-4124-BECC-E1945A8E4000/data/Containers/Data/Application/DD4D8EF3-1CC4-4B8D-9C8F-DF0726E2C55E/Library/Application Support
flutter:  documentsDirectory:/Users/ksnowlv/Library/Developer/CoreSimulator/Devices/F35779E0-8AA1-4124-BECC-E1945A8E4000/data/Containers/Data/Application/DD4D8EF3-1CC4-4B8D-9C8F-DF0726E2C55E/Documents
flutter:  temporaryDirectoryPath:/Users/ksnowlv/Library/Developer/CoreSimulator/Devices/F35779E0-8AA1-4124-BECC-E1945A8E4000/data/Containers/Data/Application/DD4D8EF3-1CC4-4B8D-9C8F-DF0726E2C55E/Library/Caches

```

### 5.小结

#### 1.目录
文档目录、临时目录，缓存目录为应用中常用目录，上述仅做演示;不同的平台可能会有差异，注意区别。



