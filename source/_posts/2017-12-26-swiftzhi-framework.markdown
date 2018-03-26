---
layout: post
title: "swift之framework"
date: 2017-12-26 20:07
comments: true
categories: swift-基础框架
---

swift版本的framework有哪些关键点需要注意呢？
<!--more-->

* 1.类需要公有。
* 2.方法需要公有并且使用@objc修饰。不然
* 3.引用framework注意事项。
	* 引用framework时，需要以Embedded Binaries方式引入，而不是Linked Frameworks and Libraries.不然，会出现dyld: Library not loaded: @rpath/YKBaseFrameWork.framework/YKBaseFrameWork
	
	![image](/images/post/2017-12-26-swiftzhi-framework/framework_use.png) 
