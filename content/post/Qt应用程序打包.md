---
title: "Qt应用程序打包"
date: 2023-12-23T21:46:30+08:00
lastmod: 2023-12-23T21:46:30+08:00
keywords: ["Qt", "C++"]
tags: ["Qt", "C++"]
categories: ["Qt", "C++"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Mac Qt 应用程序打包

### 1.应用的目录
使用Qt生成Release版本，目录如下
![image](/images/post/Qt应用程序打包/qt_demo_overview.png)


### 2.macdeployqt打包

使用macdeployqt命令生成应用需要的支持类
![image](/images/post/Qt应用程序打包/qt_dir.png)

```shell
lvwei@lvweideMacBook-Pro build-QAnimationTest-Qt_6_6_1_for_macOS-Release % /Users/lvwei/Qt/6.6.1/macos/bin/macdeployqt QAnimationTest.app
File exists, skip copy: "QAnimationTest.app/Contents/PlugIns/platforms/libqcocoa.dylib"
File exists, skip copy: "QAnimationTest.app/Contents/PlugIns/styles/libqmacstyle.dylib"
File exists, skip copy: "QAnimationTest.app/Contents/PlugIns/imageformats/libqgif.dylib"
File exists, skip copy: "QAnimationTest.app/Contents/PlugIns/imageformats/libqico.dylib"
File exists, skip copy: "QAnimationTest.app/Contents/PlugIns/imageformats/libqjpeg.dylib"
File exists, skip copy: "QAnimationTest.app/Contents/PlugIns/iconengines/libqsvgicon.dylib"
WARNING:
WARNING: "QAnimationTest.app/Contents/Resources/qt.conf" already exists, will not overwrite.
WARNING: To make sure the plugins are loaded from the correct location,
WARNING: please make sure qt.conf contains the following lines:
WARNING: [Paths]
WARNING:   Plugins = PlugIns

```


### 3.应用打包
创建QAnimationTest文件夹，把QAnimationTest.app拷贝到QAnimationTest文件夹下。

![image](/images/post/Qt应用程序打包/qt_dmg.jpg)

通过磁盘工具在“基于文件夹新建磁盘映像”选择QAnimationTest文件夹，完成后，即生成QAnimationTest.dmg
![image](/images/post/Qt应用程序打包/qt_app_dmg.png)

