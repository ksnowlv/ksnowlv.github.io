---
title: "iPhone之block_全局block"
date: 2013-04-07
lastmod: 2013-04-07
categories:
  - "iOS"
tags:
  - "iOS"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

可以将一个块变量作为全局块指针变量使用。
如下声明：

```objective-c
void (^showInfomationBlock)(NSString* infomaion) = ^(NSString* infomaion){
    NSLog(@"infomation:%@", infomaion);
};
```

可以如下调用：

```objective-c
showInfomationBlock(@"我是全局块");
```
输出为

	2013-04-07 13:59:28.037 test[8201:c303] infomation:我是全局块

和全局变量，静态变量类似，全局block不会超过作用域，不用担心CRASH。

