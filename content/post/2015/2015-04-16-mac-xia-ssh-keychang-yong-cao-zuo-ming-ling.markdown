---
title: "mac下ssh-key常用操作命令"
date: 2015-04-16
lastmod: 2015-04-16
categories:
  - "Mac"
tags:
  - "Mac"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---
**Mac**上关于**ssh key**常用的操作命令


### 1.生成公钥/私钥
```terminal
 ssh-keygen -t rsa -C "邮箱名"

``` 

### 2.添加公钥/私钥
```terminal

ssh-add 密钥名

```

### 3.显示公钥

```terminal

cat 公钥名

```


### 4.示例
![image](/images/post/2015-04-16-mac-xia-ssh-keychang-yong-cao-zuo-ming-ling/overview.png)