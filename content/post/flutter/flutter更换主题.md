---
title: "Flutter更换主题"
date: 2024-04-04T18:07:19+08:00
lastmod: 2024-04-04T18:07:19+08:00
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


## Flutter更换主题

### 1.定义主题文件

```dart
import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    hintColor: Colors.blueAccent,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    dividerColor: Colors.grey,
    textTheme: const TextTheme(
      displayMedium: TextStyle(fontSize: 42, color: Colors.blueGrey),
      titleMedium: TextStyle(fontSize: 24, color: Colors.blue),
      bodyMedium:  TextStyle(fontSize: 14, color: Colors.black),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blue,
      disabledColor: Colors.blue[300],
      textTheme: ButtonTextTheme.primary,
    ),
    // 其他主题配置...
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey[900],
    hintColor: Colors.blueGrey[700],
    scaffoldBackgroundColor: Colors.grey[850],
    cardColor: Colors.grey[800],
    dividerColor: Colors.white,
    textTheme: TextTheme(
      displayMedium: TextStyle(fontSize: 42, color: Colors.blueGrey[200]),
      titleMedium: TextStyle(fontSize: 24, color: Colors.blueGrey[100]),
      bodyMedium: const TextStyle(fontSize: 14, color: Colors.white),
    ),

    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blueGrey[700],
      disabledColor: Colors.blueGrey[400],
      textTheme: ButtonTextTheme.primary,
    ),
  
  );
}
```

### 2.主题管理

包括主题切换及序列化，序列化采用轻量的存储SharedPreferences。

```dart
import 'package:base_demo/common/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  static const  String themeMode = 'theme_mode';

  late ThemeData _themeData;

  ThemeData get theme => _themeData;


  ThemeManager() {
    _themeData = AppTheme.lightTheme;
     loadTheme();
  }

  void switchTheme() {
    if (_themeData == AppTheme.lightTheme) {
      _themeData = AppTheme.darkTheme;
    } else if (_themeData == AppTheme.darkTheme) {
      _themeData = AppTheme.lightTheme;
    }
    saveTheme();

    notifyListeners();
  }

  Future<void> saveTheme() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final int mode = _themeData.brightness == Brightness.dark ? 1 : 0;
    sharedPreferences.setInt(themeMode, mode);
    debugPrint('saveTheme mode:$mode');
  }

  Future<void> loadTheme() async {
    final sharedPreferences =  await SharedPreferences.getInstance();
    final int mode = sharedPreferences.getInt(themeMode) ?? 0;
     debugPrint('loadTheme mode:$mode');
    _themeData = mode == 1 ? AppTheme.darkTheme: AppTheme.lightTheme;
     notifyListeners();
  }
}

```

### 3.调用

* main.drat

```dart
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
        ChangeNotifierProvider(create: (context) => ThemeManager()),
      ],
      child: const MyApp(),
    ),
  );
}
```

* 主题切换

```dart
    ElevatedButton(
    onPressed: () {
      Provider.of<ThemeManager>(context, listen: false).switchTheme();
    },
    child: const Text('切换主题'))
```

### 4.效果

![image](/images/flutter/flutter更换主题/result0.png)

![image](/images/flutter/flutter更换主题/result1.png)



