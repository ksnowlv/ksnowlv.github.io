---
layout: post
title: "swift调用objective-c"
date: 2017-11-27 15:06
comments: true
categories: swift
---

swift调用objective-c在混编开发时经常会使用。下面聊下如何使用？
###一.项目设置
#####TARGETS ->Swift Compiler - General ->Objective-c Bridging Header 选项指定桥接文件，通常该文件命名为：工程名+Bridging-Header.h

如图所示
![image](/images/post/2017-11-27-swiftdiao-yong-objective-c/oc-bridging-setting.png) 

###二.objective-c工程文件。
####1.桥接文件
在桥接文件中需要包含需要引用的头文件
![image](/images/post/2017-11-27-swiftdiao-yong-objective-c/oc-bridging.png) 

####2.swift类中调用。

![image](/images/post/2017-11-27-swiftdiao-yong-objective-c/swift-call-oc-demo.png) 


