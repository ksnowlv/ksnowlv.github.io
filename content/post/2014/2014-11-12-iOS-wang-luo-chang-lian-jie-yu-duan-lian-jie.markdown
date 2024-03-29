---
title: "网络长连接与短连接"
date: 2014-11-12
lastmod: 2014-11-12
categories:
  - "iOS"
tags:
  - "网络"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---
 网络长连接与短连接有什么区别呢？
 <!--more-->
 
## 一.长连接    

client与server先建立连接，连接建立后不断开，操持连接，然后进行数据的发送和接收。
    由于这种形式的网络通讯方式，网络连接一直存在。
    常用于P2P(点对点)通信。像IM类的产品
     
## 二.短连接    

client与server每进行一次报文收发交易时才进行通讯连接，交易完毕后立即断开连接。
    此方式常用于一点对多点通讯。C/S通信。 


## 三.长连接有两种：

### 1. 基于socket的网络通讯

 a.要对通讯协议格式，包括消息头，数据包头等特别清楚，可以实现同步异步机制，可以向客户端推送消息。

 b.更少的建立和关闭tcp连接，可以减少网络延时和开销。 在使用https连接时更显著。可以减少多次建立高消耗的SSL/TLS握手

 c.实现socket对各种不同类型的网络的穿透，才是真正的麻烦，在某些省份或地区是无法实现网络穿透的。

### 2.基于http的网络通讯

 a.例如spdy协议，iOS8中，系统网络接口提供了对spdy的支持。

 b.即使是长连接，http也需要client先发起请求(**除了spdy协议，spdy协议支持服务端推送**)。在实际应用中有一些限制。

### 长连接

#### 优点
   1.通过开启、关闭更少的TCP连接，节约CPU时间和内存. 
   
   2.通过减少TCP开启引起的包的数目，降低网络阻塞.
    
#### 缺点    
   消耗服务器和客户端资源，像电量，网络流量等    

在保持长连时，需要发送一些心跳包.在iOS/android移动终端中，

* 1.心跳信息是单方向的，只有终端发到应用服务器；
* 2.心跳信息的周期比较长，比如旧版QQ的心跳周期为30s，新版QQ为180s，微信为300s，Google原生应用为1680s左右。

## 短连接    

多用于操作频繁、点对点的通讯，且连接数不是太多的情况，应用较为普遍。

参考资料：
[试试把APP心跳的前因后果解释更简单明白？](http://labs.chinamobile.com/mblog/31189_199441)
[透视互联网APP的心跳机制](http://labs.chinamobile.com/mblog/104209_199343)
[Android/iOS Notification feature](http://blog.csdn.net/totogogo/article/details/7329542)

