---
layout: post
title: "iOS下常用调试方法"
date: 2014-08-21 20:10
comments: true
categories: iOS
---

预编译器内置的宏可用于c/c++/Objective-C

 宏| 格式化 | 含义
--------|---------|-------
__func__ | %s | 当前函数名
__LINE__ | %d | 当前代码行号
__FILE__ | %s | 文件名
__PRETTY_FUNCTION__ | %s | 当前函数名

在Objective-C中常用的表达式

 表达式        | 格式化 | 含义
--------------|---------|-------
NSStringFromSelector(_cmd) | %@ | 当前selector
NSStringFromClass | %@ | class名
[NSThread callStackSymbols] | %@ | 线程调用栈

常用日志函数

`NSLog`和`print`

