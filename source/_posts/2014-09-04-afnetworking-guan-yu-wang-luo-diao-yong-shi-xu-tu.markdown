---
layout: post
title: "AFNetworking关于网络调用时序图"
date: 2014-09-04 20:49
comments: true
categories: iOS-网络
---

AFNetworking2.x中，关于网络请求的并发是通过`NSOperation`&`NSOperationQueue`实现的。

 * 网络调用相关封装在[NSOperation](https://developer.apple.com/library/ios/documentation/cocoa/reference/NSOperation_class/Reference/Reference.html#//apple_ref/doc/uid/TP40004591)的子类`AFURLConnectionOperation`中。
 * 类`AFHTTPRequestOperationManager`通过[NSOperationQueue](https://developer.apple.com/library/ios/documentation/cocoa/reference/NSOperationQueue_class/Reference/Reference.html)完成对`AFURLConnectionOperation`的调度，当`AFURLConnectionOperation`一旦被加入到`NSOperationQueue`中，就开始了对网络并发执行... 
 
![image](/images/post/2014-09-04-afnetworking-guan-yu-wang-luo-diao-yong-shi-xu-tu/AFNNetworking_sequence_diagrams.jpg)