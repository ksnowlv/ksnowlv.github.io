---
title: "iOS中的静态库注意事项"
date: 2013-04-02
lastmod: 2013-04-02
categories:
  - "iOS"
tags:
  - "iOS"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---


### 1.确保静态库需要的文件全部编译

### 2.RELEASE版本可以去掉DEBUG信息

不然生成静态库会比较大。

![image](/images/post/2013-04-02-ioszhong-de-jing-tai-ku-zhu-yi-shi-xiang/1.jpg) 
### 3.加载静态库编译选项设置

如果加载静态库，分类的方法CRASH，请检查是否在“Linking”的编译选项中是否添加“－all_load”标记，不然，分类方法不会正常加载。![image](/images/post/2013-04-02-ioszhong-de-jing-tai-ku-zhu-yi-shi-xiang/2.jpg) 

### 4.确保当前工程编译的版本和静态库版本是匹配的

模拟器和真机版本各自对应。除非你加载的库同时包含这两个版本。合并库可以参考

```objc
lipo–create Release-iphoneos/libSOSOMapAPILib.a Release-iphonesimulator//libmapApi.a –output /libSOSOMapAPILib.a

```