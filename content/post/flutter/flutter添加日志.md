---
title: "Flutter添加日志"
date: 2024-03-04T15:20:32+08:00
lastmod: 2024-03-04T15:20:32+08:00
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

### 1.Flutter添加日志组件logger

根据流行程序选择 [logger](https://pub.dev/packages/logger)

### 2.pubspec.yaml添加依赖

```yaml
dependencies:
  flutter:
    sdk: flutter

  logger: ^2.1.0
```

### 3.添加日志工具类

```Dart
import 'package:logger/logger.dart';

class XLogger {

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: true // Should each log print contain a timestamp
        ),
  );

  static Logger getLogger() {
    return _logger;
  }
}

```

### 4.示例代码


```Dart
import 'package:base_demo/logger.dart';


XLogger.getLogger().t('counter:$_counter');
XLogger.getLogger().i('counter:$_counter');
XLogger.getLogger().w('counter:$_counter');
XLogger.getLogger().e('counter:$_counter');
XLogger.getLogger().f('counter:$_counter');
XLogger.getLogger().d('counter:$_counter');

```

### 5.效果

![image](/images/flutter/flutter添加日志/log_result.png)
