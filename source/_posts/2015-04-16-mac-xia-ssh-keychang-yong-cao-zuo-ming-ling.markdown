---
layout: post
title: "mac下ssh-key常用操作命令"
date: 2015-04-16 19:54
comments: true
categories: Mac
---
**Mac**上关于**ssh key**常用的操作命令

<!--more-->

###1.生成公钥/私钥

```objective-c
 ssh-keygen -t rsa -C "邮箱名"

``` 

###2.添加公钥/私钥

```objective-c

ssh-add 密钥名

```

###3.显示公钥

```objective-c

cat 公钥名

```


###截图如下

![image](/images/post/2015-04-16-mac-xia-ssh-keychang-yong-cao-zuo-ming-ling/overview.png)