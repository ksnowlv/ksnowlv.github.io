---
title: "Flutter如何添加对华为鸿蒙系统的支持"
date: 2024-05-10T09:38:20+08:00
lastmod: 2024-05-10T09:38:20+08:00
keywords: ["flutter","HMOS"]
tags: ["flutter","HMOS"]
categories: ["flutter","HMOS"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 1.flutter鸿蒙项目

官方flutter项目，默认是不支持华为鸿蒙系统的；但是，有个[https://gitee.com/openharmony-sig/flutter_flutter/tree/dev/](https://gitee.com/openharmony-sig/flutter_flutter/tree/dev/)开源SDK，提供了对
`OpenHarmony`平台的兼容拓展，支持IDE，也支持终端使用Flutter Tools指令编译和构建OpenHarmony应用程序。按照标准flutter SDK下载配置即可。

如果原来配置的有`flutter SDK`,可以注释掉，我也不例外，属于这种这种情况。


### 2.DevEco Studio 4.0 Release版鸿蒙环境安装

鸿蒙官网[https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/quick-start/start-with-ets-stage.md](https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/quick-start/start-with-ets-stage.md)下载`DevEco`，我选择`Mac x86`的安装包；

打开IDE，按照引导，安装环境即可，注意，`nodejs`选择 `v16.20`。

Mac下，在`.bash_profile`配置如下环境变量

```shell
export PATH=/Users/用户名/Documents/DevEcoProjects/dev/bin:$PATH
export NODE_HOME=/Users/用户名/nodejs             
export PATH=$NODE_HOME/bin:$PATH

export OHPM_HOME=/Users/用户名/Library/Huawei/ohpm
export PATH=${PATH}:${OHPM_HOME}/bin
export HOS_SDK_HOME=/Users/用户名/Library/Huawei/Sdk
export OHOS_SDK_HOME=/Users/用户名/Library/OpenHarmony/Sdk
export HDC_HOME=/Users/用户名/Library/Huawei/Sdk/openharmony/9/toolchains
export PATH=$PATH:$HDC_HOME
export FLUTTER_GIT_URL=https://gitee.com/openharmony-sig/flutter_flutter.git
```

### 3.创建flutter鸿蒙项目

使用命令行`flutter create --platforms ohos hellohoos_flutter`创建hellohoos_flutter项目

```shell
ksnowlv@MacBook-Pro-3 DevEcoProjects % flutter create --platforms ios,android,linux,macos,windows,web,ohos hello_flutter
Signing iOS app for device deployment using developer identity: "Apple Development: ksnowlv@163.com (GQNQ24T735)"
Creating project hello_flutter...
Running "flutter pub get" in hello_flutter...
Resolving dependencies in hello_flutter... (1.0s)
+ async 2.10.0 (2.11.0 available)
+ boolean_selector 2.1.1
+ characters 1.2.1 (1.3.0 available)
+ clock 1.1.1
+ collection 1.17.0 (1.18.0 available)
+ cupertino_icons 1.0.6
+ fake_async 1.3.1
+ flutter 0.0.0 from sdk flutter
+ flutter_lints 2.0.3 (3.0.2 available)
+ flutter_test 0.0.0 from sdk flutter
+ js 0.6.5 (0.7.1 available)
+ lints 2.0.1 (3.0.0 available)
+ matcher 0.12.13 (0.12.16+1 available)
+ material_color_utilities 0.2.0 (0.11.1 available)
+ meta 1.8.0 (1.15.0 available)
+ path 1.8.2 (1.9.0 available)
+ sky_engine 0.0.99 from sdk flutter
+ source_span 1.9.1 (1.10.0 available)
+ stack_trace 1.11.0 (1.11.1 available)
+ stream_channel 2.1.1 (2.1.2 available)
+ string_scanner 1.2.0
+ term_glyph 1.2.1
+ test_api 0.4.16 (0.7.1 available)
+ vector_math 2.1.4
Changed 24 dependencies in hello_flutter!
OhosDependenciesManager: it no need to add plugins dependencies.
Wrote 163 files.

All done!
You can find general documentation for Flutter at: https://docs.flutter.dev/
Detailed API documentation is available at: https://api.flutter.dev/
If you prefer video documentation, consider: https://www.youtube.com/c/flutterdev

In order to run your application, type:

  $ cd hello_flutter
  $ flutter run

Your application code is in hello_flutter/lib/main.dart.

```

### 4.flutter项目示例

在默认代码中，添加

```dart
    const Text(
      'flutter hoos demo',
      style: TextStyle(fontSize: 30, color: Colors.red),
    ),
    const SizedBox(height: 20,),
```

`main.dart`

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text(widget.title),
      ),
      body: Center(
        child: Column(
    
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'flutter hoos demo',
              style: TextStyle(fontSize: 30, color: Colors.red),
            ),
            const SizedBox(height: 20,),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

```

### 5.鸿蒙系统手机运行

切换到`hello_flutter`目录，执行`flutter run`

我的是华为P30，选择[1]: ELE AL00 (GBG5T19710007532)即可

```shell
ksnowlv@MacBook-Pro-3 DevEcoProjects % cd hello_flutter 
ksnowlv@MacBook-Pro-3 hello_flutter % flutter run                                                                      
OhosDependenciesManager: it no need to add plugins dependencies.
Using hardware rendering with device sdk gphone x86. If you notice graphics artifacts, consider enabling software rendering with "--enable-software-rendering".
Launching lib/main.dart on sdk gphone x86 in debug mode...
Running Gradle task 'assembleDebug'...                          
Checking the license for package Android SDK Platform 33 in /Users/ksnowlv/Library/Android/sdk/licenses
License for package Android SDK Platform 33 accepted.
Preparing "Install Android SDK Platform 33 (revision: 3)".
"Install Android SDK Platform 33 (revision: 3)" ready.
Installing Android SDK Platform 33 in /Users/ksnowlv/Library/Android/sdk/platforms/android-33
"Install Android SDK Platform 33 (revision: 3)" complete.
"Install Android SDK Platform 33 (revision: 3)" finished.



Multiple devices found:
ELE AL00 (mobile) • GBG5T19710007532 • android-arm64  • Android 10 (API 29)
Phone (mobile)    • emulator-5554    • android-x64    • Android 12 (API 31) (emulator)
macOS (desktop)   • macos            • darwin-x64     • macOS 14.4.1 23E224 darwin-x64
Chrome (web)      • chrome           • web-javascript • Google Chrome 124.0.6367.119
[1]: ELE AL00 (GBG5T19710007532)
[2]: Phone (emulator-5554)
[3]: macOS (macos)
[4]: Chrome (chrome)
Please choose one (To quit, press "q/Q"): 1
OhosDependenciesManager: it no need to add plugins dependencies.
Launching lib/main.dart on ELE AL00 in debug mode...
Running Gradle task 'assembleDebug'...                             10.4s
✓  Built build/app/outputs/flutter-apk/app-debug.apk.
Syncing files to device ELE AL00...                             
W/Gralloc3(28193): mapper 3.x is not supported
I/HwViewRootImpl(28193): removeInvalidNode jank list is null
Syncing files to device ELE AL00...                                282ms

Flutter run key commands.
r Hot reload. 🔥🔥🔥
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

💪 Running with sound null safety 💪

An Observatory debugger and profiler on ELE AL00 is available at: http://127.0.0.1:58735/_Jhp9MA3IWE=/
The Flutter DevTools debugger and profiler on ELE AL00 is available at: http://127.0.0.1:9101?uri=http://127.0.0.1:58735/_Jhp9MA3IWE=/
I/AwareBitmapCacher(28193): init lrucache size: 2097152 pid=28193
I/Hwaps   (28193): APS: EventAnalyzed: initAPS: version is 11.0.0.4
D/Hwaps   (28193): Fpsrequest create,type:EXACTLY_IDENTIFY
D/Hwaps   (28193): Fpsrequest create,type:EXACTLY_IDENTIFY
D/Hwaps   (28193): Fpsrequest create,type:OPENGL_SETTING
D/Hwaps   (28193): FpsController create
D/Hwaps   (28193): APS: EventAnalyzed: reInitFpsPara :mBaseFps = 60; mMaxFps = 60
W/Settings(28193): Setting device_provisioned has moved from android.provider.Settings.Secure to android.provider.Settings.Global.
V/HiTouch_HiTouchSensor(28193): User setup is finished.
W/HwApsManager(28193): HwApsManagerService, registerCallback, start !
D/Hwaps   (28193): APS: EventAnalyzed: registerCallbackInApsManagerService, mPkgName:com.example.hello_flutter; result = true
V/AudioManager(28193): querySoundEffectsEnabled...
V/AudioManager(28193): querySoundEffectsEnabled...
V/AudioManager(28193): querySoundEffectsEnabled..

```

### 6.效果


![image](/images/flutter/flutter如何添加对鸿蒙系统的支持/result.png)

### 7.其它

如果原来配置过flutter相关环境，整体上一路畅通，很顺利。小伙伴们，是不是很想试试？！那就试试看