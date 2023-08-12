---
title: "python面向对象函数重载"
date: 2014-08-07
categories:
  - "python"
tags:
  - "python"
---
<!--more-->

#### python支持函数重载，和C++/Objective-c/Java类似。    适用场景:父类的方法不能满足你的需求.
  
  <!--more-->
    
代码示例如下：

``` python

#！/usr/bin/python

class QBaseClass(object):
	"""QBaseClass class"""
	def __init__(self, name):
		super(QBaseClass, self).__init__()
		self.name = name

	def showMessage(self):
		print "className = %s"  % (QBaseClass.__name__)



class QPerson(QBaseClass):
	"""QPerson class"""
	def __init__(self, name,address):
		super(QPerson, self).__init__(name)
		self.address = address

	def showMessage(self):
		print "className = %s, address = %s "  % (QPerson.__name__, self.address)




p1 = QPerson("ksnowlv","北京市朝阳区")
p1.showMessage()
#下面是调用p1父类的同名方法，看起来是不是和Objective-c类似
super(QPerson,p1).showMessage()
QBaseClass.showMessage(p1)

```

运行结果如下:

    ksnowlv@ksnowlvdeMacBook-Pro~/Documents/lvwei projects/python$python overloadmethod.py 
    className = QPerson, address = 北京市朝阳区
    className = QBaseClass
    className = QBaseClass


#### 下面两种写法虽然执行结果相同，那有什么不同呢？
``` python   

super(QPerson,p1).showMessage()
QBaseClass.showMessage(p1)

```