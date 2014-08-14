---
layout: post
title: \"selector not recognized\"的crash原因及解决办法
date: 2014-08-14 19:17
comments: true
categories: iOS
---

####在iOS开发中,经常会遇见"selector not recognized"这种类型的crash,其原因:

####1.该方法实际上不存在.
####解决办法:
    
    1.检查是否拼写错误。
    2.检查该方法在iOS SDK版本中的适用版本范围。
    3.检查对象传递是否传递有误。

####2.内存管理不当。
  
    1.你的App试图引用一个已经被释放的对象.可以使用Zombies检查下问题原因。
    2.检查是否有内存越界的问题,可以开启内存防护，日志等选项,再添加异常断点。
    
####内存防护，日志等选项开启
![image](/images/post/2014-08-14-selector-not-recognized-fix/memory_option.png)

####异常断点开启
![image](/images/post/2014-08-14-selector-not-recognized-fix/exceptions_breakpoint.png);

####3.使用静态库分类方法加载不当。

    静态库的分类方法默认是不加载的,-需要检查编译选项设置。
       -ObjC,-all_load,-force_load 
  
  详情见[本文](http://ksnowlv.github.io/blog/2014/08/12/xcode-zhi-forceload/)
   
 
    
