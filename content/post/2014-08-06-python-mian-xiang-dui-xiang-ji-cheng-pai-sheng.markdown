---
title: "Python面向对象-继承派生"
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

## 一.python类继承派生

通过这种继承派生机制，我们可以实现代码重用。其实，与C++/Objective-c/Java类似。

## 二.语法格式    
    class 派生类名（基类名):
    
## 三.python继承中的一些特点

### 1.在继承中基类的构造（__init__()方法）`不会被自动调用`，它需要在其派生类的构造中手动调用。

### 2.在调用基类的方法时，需要加上基类的类名前缀，且需要带上self参数变量。区别于在类中调用普通函数时并不需要带上self参数

### 3.Python总是首先查找对应类型的方法，如果它不能在派生类中找到对应的方法，它才开始到基类中逐个查找。（先在本类中查找调用的方法，找不到才去基类中找）。

### 4.如果派生类继承的基类超过一个，那么该派生类就被称作"多重继承".

#### 语法格式如下：
    class 派生类名（基类名1，基类2，...,基类n):

#### 代码示例

``` python
#!/usr/bin/python

class QBaseObject(object): #define base class

	"base class"

	value = 0

	def __init__(self):
		print "QBaseObject no param"

	def __init__(self,name):
		self.name = name
		print "QBaseObject param name:",self.name

	def setName(self,name):
		self.name = name

	def getName(self):
		return self.name;		 	


class QPerson(QBaseObject):
	"""QPerson class"""

	def __init__(self, address):
		super(QPerson, self).__init__()
		self.address = address
		print "QPerson address"

	
	def __init__(self, name,address):
		super(QPerson, self).__init__(name)
		self.address = address
		print "QPerson name &address"

#p1 = QPerson("北京市朝阳区")
#print "p1 name = %s, address = %s value = %d" % (p1.name,p1.address,QPerson.value)

p2 = QPerson("ksnowlv","北京市朝阳区")
QPerson.value = 1
print "p2 name = %s, address = %s value = %d" % (p2.name,p2.address,QPerson.value)

p2.setName("kAir")
QPerson.value = 2
print "p1 name = %s, address = %s value = %d" % (p2.name,p2.address,QPerson.value)

p2.setName("ksnowlv")
print "p2 名字还原为",p2.getName()
	

```

#### 执行情况
```terminal
   ksnowlv@ksnowlvdeMacBook-Pro~/Documents/lvwei projects/python$
    python object_Inheritance.py 
    QBaseObject param name: ksnowlv
    QPerson name &address
    p2 name = ksnowlv, address = 北京市朝阳区 value = 1
    p1 name = kAir, address = 北京市朝阳区 value = 2
    p2 名字还原为 ksnowlv
    
```