---
title: "NSInvocationOperation的使用"
date: 2013-04-03
lastmod: 2013-04-03
categories:
  - "iOS"
tags:
  - "多线程"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---


`NSInvocationOperation`的一个子类，在对`NSOperation`控制要求不高的情况下，可以使用。

例如：

```objective-c

NSInvocationOperation* op = [[NSInvocationOperation alloc]
                                   initWithTarget:self selector:@selector(doLongTimeTask) object:nil];
    
    
[myQueue addOperation:op];
[op release];

- (void)doLongTimeTask {
    //可以使用performSelectorOnMainThread来将得来的数据返回到主线程
}

```

