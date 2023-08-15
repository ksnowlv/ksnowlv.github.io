---
title: "swift-framework的合并"
date: 2018-07-04
lastmod: 2018-07-04
categories:
  - "swift"
tags:
  - "swift"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

swift framework如何支持合并呢？以YKBaseFramework.framework为例。

## 1.lipo合并静态库。
```terminal
 lipo -create Release-iphoneos/YKBaseFramework.framework/YKBaseFramework Debug-iphonesimulator/YKBaseFramework.framework/YKBaseFramework -output YKBaseFramework
```
生成YKBaseFramework，查看支持架构

```terminal
bogon:YKBaseSwiftFrameworkLib ksnowlv$ lipo -info YKBaseFramework 
Architectures in the fat file: YKBaseFramework are: armv7 i386 x86_64 arm64 
```

## 2. debug/release库合并

把**debug**库中的**swiftdoc**与**swiftmodule**文件拷贝到**release**库对应目录下。
![image](/images/post/2018-07-04-swift-frameworkde-he-bing/swiftframework-export.png) 

## 3.把合并后的YKBaseFramework文件拷贝到release库对应目录下.
![image](/images/post/2018-07-04-swift-frameworkde-he-bing/swift-framework.png)


 大功告成，可以支持swift/objective-c调用