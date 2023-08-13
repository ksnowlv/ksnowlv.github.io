---
title: "swift-objective-c混编的framework"
date: 2018-07-02
lastmod: 2018-07-02
categories:
  - "swift"
tags:
  - "swift"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

swift-objective-c混编的framework如何制作呢？

## 1.创建cocoaTouchframework,
## 2.需要导出的头文件添加到Headers中

![image](/images/post/2018-07-02-swift-objective-chun-bian-de-framework/overview.png) 

## 3.头文件添加到导出头文件

```objective-c


//! Project version number for YKBaseFramework.
FOUNDATION_EXPORT double YKBaseFrameworkVersionNumber;

//! Project version string for YKBaseFramework.
FOUNDATION_EXPORT const unsigned char YKBaseFrameworkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <YKBaseFramework/PublicHeader.h>

//#import <YKBaseFramework/YKFile.h>

#import <YKBaseFramework/YKString.h>
```