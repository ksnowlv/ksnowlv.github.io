---
title: "单例的内存泄漏"
date: 2014-08-11
lastmod: 2014-08-11
categories:
  - "iOS"
tags:
  - "性能"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

今天发现iOS上的单例，在苹果自带memory leak工具中,

   * 使用iOS6显示有内容泄漏。
   * 使用iOS7或以上无内存泄漏。
    
推测应该是iOS系统对内存回收策略可能不太一样。


单例创建对象一次，会在App被退出时被系统回收,不用担心内存泄漏的。

    在iOS7或以上有内存泄漏时，检查下单例中创建某些对象时， 是不是忘记对原有对象回收?!
