---
title: "Swift代码风格检查利器SwiftLint的使用"
date: 2021-07-30T21:09:40+08:00
lastmod: 2021-07-30T21:09:40+08:00
keywords: ["Swift","SwiftLint"]
tags: ["Swift","SwiftLint"]
categories: ["Swift","SwiftLint"]

comment: true
toc: true
autoCollapseToc: true
reward: true

---



## 代码检查利器SwiftLint

如何使用工具检查swift代码风格？可以使用SwiftLint ,见链接https://github.com/realm/SwiftLint

<!--more-->

### 安装

安装好了后，在targets中添加Run Script，见下图：

![image](/images/post/swift代码风格检查利器SwiftLint的使用/1.jpg)

### 检测情况

![image](/images/post/swift代码风格检查利器SwiftLint的使用/2.jpg)

### 问题 

空格/空行问题，及for循环中变量字符少。如何解决呢？

### 解决方案

在工程目录下，添加**.swiftlint.yml**。
![image](/images/post/swift代码风格检查利器SwiftLint的使用/5.jpg)

### 检测情况

![image](/images/post/swift代码风格检查利器SwiftLint的使用/3.jpg)

![image](/images/post/swift代码风格检查利器SwiftLint的使用/4.jpg)




