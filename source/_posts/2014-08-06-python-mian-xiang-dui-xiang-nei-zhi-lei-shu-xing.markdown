---
layout: post
title: "python面向对象-内置类属性"
date: 2014-08-06 20:20
comments: true
categories: python
---

python内置类属性

    __doc__:类的文档字符串.

    __name__:类名.

    __dict__:类的属性,包含一个字典，由类的数据属性组成

    __module__: 类定义所在的模块

    __base__:类的所有父类构成元素（包含了以个由所有父类组成的元组).

代码示例如下:

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

print "Teacher.__doc__",Teacher.__doc__
print "Teacher.__name__",Teacher.__name__
print "Teacher.__module__",Teacher.__module__
print "Teacher.__bases__",Teacher.__bases__
print "Teacher.__dict__",Teacher.__dict__

```

运行结果如下：

    ksnowlv@ksnowlvdeMacBook-Pro~/Documents/lvwei projects/python$python teacher_inner_property.py 
    Name :  张明 , Age:  24
    Name :  李海 , Age:  30
    Total Teacher 2
    张明 居住在北京市朝阳区
    张明 搬家到北京市海淀区
    Teacher.__doc__ Common base class for all teacher
    Teacher.__name__ Teacher
    Teacher.__module__ __main__
    Teacher.__bases__ ()
    Teacher.__dict__ {'__module__': '__main__', 
    'displayCount': <function displayCount at 0x10572c410>, 
    'displayTeacher': <function displayTeacher at 0x10572cb18>, 
    'teacherCount': 2, 
    '__doc__': 'Common base class for all teacher', 
    '__init__': <function __init__ at 0x105725d70>}    

