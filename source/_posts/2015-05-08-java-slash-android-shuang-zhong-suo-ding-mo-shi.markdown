---
layout: post
title: "Java/Android双重锁定模式"
date: 2015-05-08 17:51
comments: true
categories: Android多线程
---

**双重检查锁定模式**(*DCLP*)是一种软件设计模式,用来减少并发系统中竞争和同步的开销.

#####适用性方面：在J2SE 5.0之前的版本使用，有隐患。在J2SE 5.0开始的版本，可以放心使用，已经解决了原有的问题。可参考链接[双重检查锁定模式](http://zh.wikipedia.org/zh-cn/双重检查锁定模式)

```java

	private volatile static ImageLoader instance;

	/** Returns singleton class instance */
	public static ImageLoader getInstance() {
		if (instance == null) {
			synchronized (ImageLoader.class) {
				if (instance == null) {
					instance = new ImageLoader();
				}
			}
		}
		return instance;
	}

	//构造函数私有
	protected ImageLoader() {
	}
	
```