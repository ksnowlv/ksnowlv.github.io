---
title: "http1.1与2.0主要区别"
date: 2018-04-13
lastmod: 2018-04-13
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


http2.0与1.1相比较，有哪些区别呢？

## 1.数据格式不同
数据格式http2.0采用的是二进制格式，http1.1采用的是文本格式。
二进制协议解析起来更高效，更紧凑，错误更少。

## 2.多路复用：非有序并阻塞，需要一个连接即可实现并发。
### HTTP/1.x 的问题
 
    线端阻塞(head-of-line blocking), 指一个连接(connection)一次只提交一个请求的效率比较高, 多了就会变慢。 HTTP/1.1 试过用流水线(pipelining)来解决这个问题, 但是效果并不理想(数据量较大或者速度较慢的响应, 会阻碍排在他后面的请求). 
     此外, 由于网络媒介(intermediary )和服务器不能很好的支持流水线, 导致部署起来困难重重。
     
###  HTTP2.0使用了多路复用优势，
  
   同一个连接可以并发处理多个请求，同时处理多个消息的请求和响应，而且并发请求的数量比HTTP1.1大了好几个数量级。HTTP1.1也可以多建立几个TCP连接，来支持处理更多并发的请求，创建TCP连接本身也是有开销的。

 TCP连接有一个预热和保护的过程，先检查数据是否传送成功，一旦成功过，则慢慢加大传输速度。因此对应瞬时并发的连接，服务器的响应就会变慢。所以最好能使用一个建立好的连接，并且这个连接可以支持瞬时并发的请求。


## 3.消息头压缩
HTTP1.1不支持header数据的压缩，HTTP2.0使用HPACK算法对header的数据进行压缩，这样数据量小，网络传输时间相对短一些。

## 4.服务器推送
  当浏览器请求一个网页时，服务器将会发回HTML，在服务器开始发送JavaScript、图片和CSS前，服务器需要等待浏览器解析HTML和发送所有内嵌资源的请求。服务器推送服务通过“推送”那些它认为客户端将会需要的内容到客户端的缓存中，以此来避免数据往返的延迟。

  当我们对支持HTTP2.0的web server请求数据的时候，服务器会顺便把一些客户端需要的资源一起推送到客户端，免得客户端再次创建连接发送请求到服务器端获取。这种方式非常合适加载静态资源。

服务器端推送的这些静态资源下发到本地客户端，客户端直接从本地加载这些资源，页面加载速度会大大提高。


