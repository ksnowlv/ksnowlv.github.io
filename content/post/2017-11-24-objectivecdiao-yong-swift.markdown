---
title: "objectivec调用swift"
date: 2017-11-24
lastmod: 2017-11-24
categories:
  - "swift"
tags:
  - "swift"
comment: true
toc: false
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

objective-c调用swift在混编开发时经常会使用。

### 一.项目设置##### TARGETS ->Build Settings -> Packaging 选项中，* Defines Module设置为YES
* Product Name一般默认工程名。那后面oc调用swift时，引入的头文件为**"工程名+swift.h"**。

如图所示
![image](/images/post/2017-11-24-objectivecdiao-yong-swift/setting.png) 

### 二.swift工程文件。#### 1.桥接文件创建swift类中，Xcode 会提示创建一个桥接文件 点确定创建桥接文件，Xcode会自动创建一个桥接文件，名字格式为：工程名-Bridging-Header.h，所有swift类对应的头文件都会放到桥接文件中。
#### 2.引用头文件引入的头文件为**工程名+swift.h**
![image](/images/post/2017-11-24-objectivecdiao-yong-swift/demo_overview.png) 
#### 3.swift类定义。swift类需要继承NSObject,

![image](/images/post/2017-11-24-objectivecdiao-yong-swift/class_overview.png) 


