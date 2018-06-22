---
layout: post
title: "iOS指针集合类"
date: 2018-04-23 15:33
comments: true
categories: iOS-基础
---


Collections之[Pointer Collections](https://developer.apple.com/documentation/foundation/collections?language=objc)
：指针集合类

* 1. NSPointerArray
* 2. NSHashTable
* 3. NSMapTable


####1.NSPointerFunctionsOptions
Defines the memory and personality options for an NSPointerFunctions object.

* NSPointerFunctionsMachVirtualMemory
* NSPointerFunctionsMallocMemory

	     Use free() on removal, calloc() on copy in.
	
* NSPointerFunctionsOpaqueMemory
* NSPointerFunctionsStrongMemory
* NSPointerFunctionsWeakMemory
	
	    Uses weak read and write barriers appropriate for ARC or GC. Using NSPointerFunctionsWeakMemory object references will turn to NULL on last release.
	
* NSMapTableStrongMemory

	 Equivalent to  NSPointerFunctionsStrongMemory
.
* NSMapTableWeakMemory

		Equivalent to NSPointerFunctionsWeakMemory.
		

####2. NSPointerArray/NSHashTable/NSMapTable

* 可以存储所有指针类型的数据包括nil
* 可以添加或删除nil values
* 可以弱引用或强引用对象。
* 添加元素时，性能很差。慎用！！！
		