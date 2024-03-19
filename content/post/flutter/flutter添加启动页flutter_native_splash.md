---
title: "Flutter添加启动页flutter_native_splash"
date: 2024-03-19T23:20:01+08:00
lastmod: 2024-03-19T23:20:01+08:00
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




## flutter_native_splash的使用

### 1.flutter_native_splash

官方链接见[https://pub-web.flutter-io.cn/packages/flutter_native_splash](https://pub-web.flutter-io.cn/packages/flutter_native_splash)

支持Android/iOS/Web

### 2.pubspec.yaml添加依赖

```yaml
  flutter_native_splash: ^2.4.0

  flutter_native_splash:
      color: "#42a5f5"
      image: "images/splash.png"
      # image_dark: "assets/images/splash_dark.png"
      android: true
      ios: true
```

### 3.生成启动画面

    flutter pub run flutter_native_splash:create

```shell
ksnowlv@MacBook-Pro-3 base_demo % flutter pub run flutter_native_splash:create
Deprecated. Use `dart run` instead.
Building package executable... (9.4s)
Built flutter_native_splash:create.
[Android] Creating default splash images
[Android] Updating launch background(s) with splash image path...
[Android]  - android/app/src/main/res/drawable/launch_background.xml
[Android]  - android/app/src/main/res/drawable-v21/launch_background.xml
[Android] Updating styles...
[Android]  - android/app/src/main/res/values-v31/styles.xml
[Android]  - android/app/src/main/res/values-night-v31/styles.xml
[Android]  - android/app/src/main/res/values/styles.xml
[Android]  - android/app/src/main/res/values-night/styles.xml
[iOS] Creating  images
[iOS] Updating ios/Runner/Info.plist for status bar hidden/visible
[Web] Creating images
[Web] Creating images
[Web] Creating background images
[Web] Creating CSS
[Web] Updating index.html

✅ Native splash complete.
Now go finish building something awesome! 💪 You rock! 🤘🤩
Like the package? Please give it a 👍 here: https://pub.dev/packages/flutter_native_splash

ksnowlv@MacBook-Pro-3 base_demo % 
```

### 4.代码示例

* main.dart

```dart
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  XLogger.getLogger().d("main init");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());

}

```

### 5.XCode中设置启动屏

在flutter工程中的iOS目录下，打开Runner.xcworkspace，设置启动屏，如图所示

![image](/images/flutter/flutter添加启动页flutter_native_splash/xcode_setting.jpg)


### 6.效果

![image](/images/flutter/flutter添加启动页flutter_native_splash/result.png)
