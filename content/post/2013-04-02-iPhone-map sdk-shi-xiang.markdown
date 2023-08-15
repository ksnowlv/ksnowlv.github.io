---
title: "iPhone map sdk需要注意的事项"
date: 2013-04-02
lastmod: 2013-04-02
categories:
  - "iOS"
tags:
  - "iOS"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

### 1.慎用消息通知,避免给某一类对象发送消息通知。
### 2.慎用全局或静态对象
避免多个对象共享一份数据导致 UI 或数据 操作混乱。

### 3.非必要情况,尽量使用OC,不使用 Objective-C++。
### 4.尽量减少分类的使用,可以用全局函数来替代
### 5.尽量减少内存使用

能 release 的,尽量不 要 autorelease,需要注意内存 cache 合适的大小.
### 6.网络请求,代理等,取消操作需要特别注意

 避免出现 CRASH 等 意外情况,多线程下的同步需要注意。
 
 ###  7.在遵循iPhone设计相关原则时,尽量减少文件个数,减少生成库的大小。
### 8.资源包尽量小

像图片包,配置文件等,在满足基本需求的情况下, 尽量不引入不必要的资源文件。
### 9.接口制定尽量考虑扩展性,可维护性

在添加接口前,需要明确目 标和需求。

### 10.尽量可以适配iPhone更多SDK 版本