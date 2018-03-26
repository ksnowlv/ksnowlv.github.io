---
layout: post
title: "swift-framework中objective-c与swift互调"
date: 2017-12-29 13:49
comments: true
categories: swift-基础框架
---

swift-framework中objective-c与swift互调实际上与普通工程中的互调类似。

<!--more-->

背景：YKDeviceInfo为objective-c的类，KAppInfo为swift类。

#####1.objective-c调用swift.

* 引入桥接头文件。

```objective-c
    #import "YKBaseFrameWork/YKBaseFrameWork-Swift.h"

```

* 调用对应swift类的相关方法。
 
 	{% codeblock lang:objective-c %} 
 
	+(NSString *)packageNameX {
   	 return [KAppInfo packageName];
	 }

	{% endcodeblock %}
`

#####2.swift.调用objective-c

``` objective-c

@objc public class func deviceId() ->String {
        return YKDeviceInfo.deviceId()
    }
    
```

####3.导出头文件。

``` objective-c

//添加需要导出的头文件，需要在targets->Build Phases->Headers中同时设置。
  #import <YKBaseFrameWork/YKDeviceInfo.h>

```

![image](/images/post/2017-12-29-swift-frameworkzhong-objective-cyu-swifthu-diao/header_file_setting.png) 

