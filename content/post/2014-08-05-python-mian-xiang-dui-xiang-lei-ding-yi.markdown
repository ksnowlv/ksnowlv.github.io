---
title: "python面向对象-类定义"
date: 2014-08-05
categories:
  - "python"
tags:
  - "python"
---
<!--more-->
#### 1.python类的定义
使用class语句定义一个类，class之后为类的名称并以冒号结尾，

<!--more-->

如下实例:

    class ClassName:

       'Optional class documentation string'#类文档字符串

       class_body  #类体

 `类的帮助信息`可以通过`ClassName.__doc__`查看。

`class_body` 由`类成员`，`方法`，`数据属性`组成。

#### 2.创建老师类，类成员，方法，属性。
#### 代码示例如下
``` python

#!/usr/bin/python

class Teacher:
   'Common base class for all teacher'
   teacherCount = 0

   def __init__(self, name, age):
      self.name = name
      self.age = age
      Teacher.teacherCount += 1
   
   def displayCount(self):
     print "Total Teacher %d" % Teacher.teacherCount

   def displayTeacher(self):
      print "Name : ", self.name,  ", Age: ", self.age

"This would create first object of Teacher class"
t1 = Teacher("张明", 24)
"This would create second object of Teacher class"
t2 = Teacher("李海", 30)
t1.displayTeacher()
t2.displayTeacher()
print "Total Teacher %d" % Teacher.teacherCount 

"添加一属性address"
t1.address = "北京市朝阳区"
print "%s 居住在%s" % (t1.name,t1.address)

"修改一属性address"
t1.address = "北京市海淀区"
print "%s 搬家到%s" % (t1.name,t1.address)

"删除属性address"
del t1.address

```

运行情况如下:

    Name :  张明 , Age:  24
    Name :  李海 , Age:  30
    Total Teacher 2
    张明 居住在北京市朝阳区
    张明 搬家到北京市海淀区