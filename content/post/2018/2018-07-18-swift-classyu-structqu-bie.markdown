---
title: "swift-class与struct区别"
date: 2018-07-18
lastmod: 2018-07-18
categories:
  - "swift"
tags:
  - "swift"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---


|比较项|struct|class|
| ------------ |-----------|------ |
| 类型|值类型|引用类型|
| 属性初始化|可用默认构造直接初始化|需要自己创建构造方法|
|变量赋值|深拷贝|浅拷贝，增加原对象引用
|方法中修改属性|需要添加mutating |不需要
|继承关系|不能继承|可以继承
|内存|栈上，自动内存管理|堆上，手动内存管理
|速度|高效|相比效率低
|线程安全|自动线程安全的|大多是非线程安全的
|与oc混编|不支持，oc无法调struct|支持混编
|序列化|不支持，可用字节转NSData|支持序列化