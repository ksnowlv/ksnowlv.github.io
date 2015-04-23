---
layout: post
title: "initialize实现单例"
date: 2014-05-09 17:34
comments: true
categories: iOS-设计模式
---

查看NSObject类[initialize方法](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSObject_Class/Reference/Reference.html#//apple_ref/occ/clm/NSObject/initialize)方法的文档时，发现其可以用来实现单例模块。

代码如下：

```objective-c

@implementation QBaseObject

static QBaseObject *_sharedBaseObject;
static BOOL _initialized = NO;

+ (void)initialize
{
    if (!_initialized)
    {
        _sharedBaseObject = [[QBaseObject alloc] init];
        _initialized = YES;
    }
}

@end

```