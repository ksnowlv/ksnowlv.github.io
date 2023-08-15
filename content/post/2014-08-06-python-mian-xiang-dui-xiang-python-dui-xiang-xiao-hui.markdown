---
title: "Python面向对象-python对象销毁"
date: 2014-08-06
lastmod: 2014-08-06
categories:
  - "python"
tags:
  - "python"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

## Python内存管理

 同Java/Objective-c语言一样，Python使用了引用计数这一简单技术来追踪内存中的对象。

### Python引用计数

在Python内部记录着所有使用中的对象各有多少引用。一个内部跟踪变量，称为一个引用计数器。

### Python引用计数规则

* 当对象被创建时， 就创建了一个引用计数；
* 当这个对象不再需要时， 也就是说， 这个对象的引用计数变为0 时， 它被垃圾回收。但是回收不是"立即"的， 由解释器在适当的时机，将垃圾对象占用的内存空间回收。 
  
	    a = 1 #创建对象a
	    b = a #对象a引用计数+1 
	    c = a #对象a引用计数+1
	    
	    del a #对象a引用计数-1
	    b = 2 #对象a引用计数-1
	    c = 2 #对象a引用计数-1，此时对象a引用计数为0，可能会被回收

### 垃圾回收机制

不仅针对引用计数为0的对象;也可以处理循环引用的情况。   

循环引用指的是，两个对象相互引用，但是没有其他变量引用他们。

   这种情况下，仅使用引用计数是不够的。
    Python 的垃圾收集器实际上是一个引用计数器和一个循环垃圾收集器。
    作为引用计数的补充， 垃圾收集器也会留心被分配的总量很大（及未通过引用计数销毁的那些）的对象。 
    在这种情况下， 解释器会暂停下来， 试图清理所有未引用的循环。
    
    
### 代码示例

``` python

#!/usr/bin/python

class QPoint(object):
	"point for QPoint"

	def __init__(self, x = 0, y = 0, z = 0):
		self.x = x
		self.y = y
		self.z = z

	def __del__(self):
			class_name = self.__class__.__name__
			print class_name,"destroyed"



point1 = QPoint()
point2 = point1;

point3 = QPoint(2,3,4)

print id(point1), id(point2), id(point3) #输出对象的id

#del point1
#del point2
#del point3


```

### 执行情况
```terminal
    ksnowlv@ksnowlvdeMacBook-Pro~/Documents/lvwei projects/python$python object_destroy.py 
    4324792912 4324792912 4324954192
    QPoint destroyed
    QPoint destroyed
```