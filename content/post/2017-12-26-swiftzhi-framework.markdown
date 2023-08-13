---
title: "swift之framework"
date: 2017-12-26
lastmod: 2017-12-26
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

## swift版本的framework
swift版本的framework有哪些关键点需要注意呢？

### 1.类需要公有
### 2.方法需要公有并且使用@objc修饰
### 3.引用framework注意事项。
	* 引用framework时，需要以Embedded Binaries方式引入，而不是Linked Frameworks and Libraries.不然，会出现dyld: Library not loaded: @rpath/YKBaseFrameWork.framework/YKBaseFrameWork
	
	![image](/images/post/2017-12-26-swiftzhi-framework/framework_use.png) 
