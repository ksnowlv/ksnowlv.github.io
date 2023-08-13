---
title: "readonly和retain结合使用"
date: 2013-04-02
lastmod: 2013-04-02
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

经常看到一些属性声明为
`@property(nonatomic,readonly,retain) UILabel      *textLabel __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);`
可能看起来比较费解，那什么情况下这样用呢？

**此方法中的setter方法外部禁止访问，内部可以重定义声明后，在类的内部使用。**

示例如下

```objective-c
// QCar.h
@interface QCar:NSObject {
}
@property (nonatomic, readonly, retain) NSString* carName;

@end

// QCar.m
@interface QCar ()
@property (nonatomic,readwrite,retain) NSString* carName;
-(void)testFunction:(NSString*)carName;
@end


@implememtation QCar
@synthesize carName;

-(void)testFunction:(NSString*)carName {
     self.carName= carName;//OK,编译运行一切ok
}

@end

```


如果在QCar类的外部调用QCar的方法，编译会报错!
