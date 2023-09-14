---
title: "Mac下抓包工具"
date: 2023-09-14T16:53:34+08:00
lastmod: 2023-09-14T16:53:34+08:00
keywords: ["Mac", "抓包"]
tags: ["Mac", "网络"]
categories: ["Mac", "网络"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Mac下抓包工具有哪些好用的呢？

### 1.charles

* 官网地址：[官网链接](https://www.charlesproxy.com/)
* 适用范围:http/https等协议,Mac/Windows/iOS/Android等设备

### 2.Wireshark

* 官网地址：[官网链接](https://www.wireshark.org/)
* 适用范围:使用WinPCAP作为接口，直接与网卡进行数据报文交换，http/https,tcp，ip，dns，icp等协议，Mac/Windows/iOS/Android等设备
  * 移动设备上https受限，如果有证书，也可。
  * Mac/windows上 https可以使用chrome截包。

### 3.proxyman

* 官网地址：[官网链接](https://proxyman.io/)
* 适用范围:http/https等协议,Mac/Windows/iOS/Android等设备。
* 其它：限制截包域名个数，需要购买升级


### 4.Reqable

* 官网地址：[官网链接](https://reqable.com/zh-CN/)
* 适用范围:http/https等协议,Mac/Windows/iOS/Android等设备。


## Reqable的使用

### 1.安装Reqable/安装证书.

以iOS手机上截包为例,

电脑上在图示位置进入后，分别在电脑和iOS手机上安装证书，在iOS手机上注意代理的设置
![image](/images/post/Mac下抓包工具/overview4.jpg)
![image](/images/post/Mac下抓包工具/overview5.jpg)

### 2.iOS微博截包

#### 1. http请求头/响应头
![image](/images/post/Mac下抓包工具/overview1.jpg)

#### 2. http请求体/响应体
![image](/images/post/Mac下抓包工具/overview2.jpg)

#### 3. http总览
![image](/images/post/Mac下抓包工具/overview3.jpg)