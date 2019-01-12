---
layout: post
title: "iPhone之block_block一些概念及应用"
date: 2013-04-07 21:55
comments: true
categories: iOS-基础
---


##### 1.块直接量
指的是一个表达式，类似^(参数列表)｛body｝,块直接量没有名称，有时候称为匿名函数。
##### 2.块指针
指向一个块的指针，例如：

```objc
void  (^showMessage)(NSString* infomation) ;//showMesage就是一个指向块的指针。
```

#####3.块变量
以`__block`修饰的变量。例如,__block int i = 10;//i就是一块变量。

#####4.关于块的应用
从10.6以后，cocoa框架开始使用块了，比如说，GCD，NSOperation,集合类，UIKIT中的许多类。