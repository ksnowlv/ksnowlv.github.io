---
title: "Flutter添加模块到iOS项目中报错iOS Xcode 15.3Sandbox Rsync Deny File Write Create"
date: 2024-03-22T11:48:26+08:00
lastmod: 2024-03-22T11:48:26+08:00
keywords: ["flutter", "iOS"]
tags: ["flutter", "iOS"]
categories: ["flutter", "iOS"]
comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


### 1. 问题

Flutte作为模块添加到iOS项目中,在XCode 15.3中报错：rsync.samba(41060) deny(1)


```shell
Showing All Messages
Failed to package /Users/ksnowlv/Documents/FlutterProjects/FlutterProjects/flutter_module.

Sandbox: rsync.samba(41060) deny(1) file-write-create /Users/ksnowlv/Library/Developer/Xcode/DerivedData/FlutterModuleTest-gqckgsygljdgpsahyljtkzkjgfmw/Build/Products/Debug-iphonesimulator/Flutter.framework

Sandbox: dart(41033) deny(1) file-write-create /Users/ksnowlv/Library/Developer/Xcode/DerivedData/FlutterModuleTest-gqckgsygljdgpsahyljtkzkjgfmw/Build/Products/Debug-iphonesimulator/.last_build_id

[   +4 ms] Flutter failed to write to a file at "/Users/ksnowlv/Library/Developer/Xcode/DerivedData/FlutterModuleTest-gqckgsygljdgpsahyljtkzkjgfmw/Build/Products/Debug-iphonesimulator/.last_build_id".

```

### 2.解决方案

在Targets中，选择项目中的Build-Settings中，搜索“User Script”，默认开关为YES，修改为NO即可。


![image](/images/flutter/flutter添加模块到iOS项目中报错iOS-Xcode-15.3Sandbox-rsync-deny-file-write-create/result.png)