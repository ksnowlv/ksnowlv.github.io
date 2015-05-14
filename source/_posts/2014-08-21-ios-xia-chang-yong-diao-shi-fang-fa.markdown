---
layout: post
title: "iOS下常用调试方法"
date: 2014-08-21 20:10
comments: true
categories: iOS-调试
---


**1.预编译器内置的宏可用于c/c++/Objective-C**

* \__func__ :当前函数名

* \__LINE__ :当前代码行号

* \__FILE__ :文件名

* \__PRETTY_FUNCTION__ :当前函数名



**2.在Objective-C中常用的表达式**

* NSStringFromSelector(_cmd)  :当前selector
* NSStringFromClass           :   class名
* [NSThread callStackSymbols] :   线程调用栈
 

`_cmd`是`objective-c`的方法中内置的变量。


**3.常用日志函数**

* NSLog 
* print

