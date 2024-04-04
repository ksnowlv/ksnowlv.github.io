---
title: "Flutter性能分析工具"
date: 2024-03-31T11:21:04+08:00
lastmod: 2024-03-31T11:21:04+08:00
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

## flutter代码分析工具

例如Flutter分析器和Lint，对减少错误和漏洞的风险，提高代码质量有帮助。

这些工具可以识别潜在问题，并提供改进代码结构和可读性的建议。

使用**flutter analyze**命令，例如flutter analyze lib/

```shell
ksnowlv@MacBook-Pro-3 base_demo % flutter analyze lib/
Analyzing lib...                                                        

   info • The declaration '_onButtonPressed' isn't referenced • lib/pages/home/home_page.dart:39:8 • unused_element
warning • Dead code • lib/pages/mine/mine_page.dart:44:5 • dead_code
   info • The declaration '_compressImageToWidget' isn't referenced • lib/pages/plugins/image_compress_page.dart:97:18 • unused_element
warning • The value of the local variable 'isolate' isn't used • lib/widgets/isolate_widget.dart:55:13 • unused_local_variable

4 issues found. (ran in 3.6s)
ksnowlv@MacBook-Pro-3 base_demo % 
```

##  Flutter DevTools

Flutter DevTools有很多性能测试工具,可以通过**flutter run --debug**类似命令启用。

```shell
ksnowlv@MacBook-Pro-3 base_demo % flutter run --debug
Launching lib/main.dart on iPhone 15 Pro in debug mode...
Running Xcode build...                                                  
 └─Compiling, linking and signing...                         7.3s
Xcode build done.                                           24.8s
flutter: ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: │ #0   main (package:base_demo/main.dart:12:23)
flutter: │ #1   _runMain.<anonymous closure> (dart:ui/hooks.dart:301:23)
flutter: ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
flutter: │ 11:58:56.720 (+0:00:00.010506)
flutter: ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
flutter: │ 🐛 main init
flutter: └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Syncing files to device iPhone 15 Pro...                           117ms

Flutter run key commands.
r Hot reload. 🔥🔥🔥
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

A Dart VM Service on iPhone 15 Pro is available at: http://127.0.0.1:57288/c8xXUGKah3g=/
The Flutter DevTools debugger and profiler on iPhone 15 Pro is available at: http://127.0.0.1:9101?uri=http://127.0.0.1:57288/c8xXUGKah3g=/
```

在浏览器打开http://127.0.0.1:9101?uri=http://127.0.0.1:57288/c8xXUGKah3g=/即可

效果如下

### Flutter Inspector

![image](/images/flutter/flutter性能分析工具/Flutter%20Inspector1.png)

![image](/images/flutter/flutter性能分析工具/Flutter%20Inspector2.png)

![image](/images/flutter/flutter性能分析工具/Flutter%20Inspector3.png)

### Performance

![image](/images/flutter/flutter性能分析工具/performanc.png)


### CPUProfile

![image](/images/flutter/flutter性能分析工具/CPUProfiler.png)

### Memory

![image](/images/flutter/flutter性能分析工具/memory.png)

### Debugger

![image](/images/flutter/flutter性能分析工具/debugger.png)

### Network

![image](/images/flutter/flutter性能分析工具/network.png)

### Logging

![image](/images/flutter/flutter性能分析工具/Logging.png)

### App Size

![image](/images/flutter/flutter性能分析工具/appsize.png)

### provide

![image](/images/flutter/flutter性能分析工具/provide.png)




