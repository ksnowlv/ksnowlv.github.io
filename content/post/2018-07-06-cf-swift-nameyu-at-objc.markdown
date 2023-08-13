---
title: "NS_SWIFT_NAME与@objc区别与用途"
date: 2018-07-06
lastmod: 2018-07-06
categories:
  - "swift"
tags:
  - "swift"
comment: true
toc: false
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

NS_SWIFT_NAME与@objc有什么区别和用途呢？

* `NS_SWIFT_NAME `:在objective-c中，重新命名在swift中的名称
* `@objc` 在swift中，重新命名在objective-c中的名称。

示例1如下：

```objective-c
typedef NS_ENUM(NSUInteger, NetErrorType) {
    NetErrorTypeNone NS_SWIFT_NAME(None),
    NetErrorTypeNetError NS_SWIFT_NAME(NetError) ,
};

@interface YKBaseUIViewController : UIViewController 
- (void)handleConnectItem:(YKConnectionItem *)connectionItem withParser:(YKJsonParser *)parser NS_SWIFT_NAME(handleNetResponse(connectionItem:parser:));

@end

```

在swift中调用如下：

```objective-c
NetErrorType.None
let baseUIViewController : YKBaseUIViewController = YKBaseUIViewController()
baseUIViewController.handleNetResponse(connectionItem: nil, parser: nil)
```


示例2如下：

```objective-c
@objc(showMyAge: address:)
public static func showMyInfo(age: Int, address: String) -> String{
        return "ksnowlv"
    }
```

在objective-c中调用如下：

```objective-c
NSString *string =  [YKDevice showMyAge:0 address:@"abc"];
```
