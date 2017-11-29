---
layout: post
title: "iOS中clean memory/dirty memory"
date: 2014-08-17 16:45
comments: true
categories: iOS-Memory
---

iOS系统中,有`clean memory`/`dirty memory`之分；

<!--more-->

####1.`clean memory`:可以被重新创建的内存块。包含以下三方面：

    1.系统framework
    2.应用的二进制执行文件.
    3.内存数据映射到文件。
####  当你的App链接一个`framewrok`,`clean memory`会增加。绝大多数情况下，只有部分framework的二进制文件是通过物理内存加载的。
  
  
####2.`dirty memory`:除了`clean memory`之外所有的内存统称为`dirty memory`.`dirty memory`不能由系统重新创建。

   
####3.系统有内存压力时，例如内存警告。
 
####   当有内存压力时，系统将会卸载一些`clean memory`。当系统需要该clean memory的数据时，系统将会重新创建。
####   但是，有内存压力时，系统不能卸载`dirty memory`,因为iOS没有内存置换机制，`dirty memory`经常占有物理内存，当`dirty memory`达到一个上限，应用就会被"杀死".所有的内存由系统回收。  
    
####4.如何减少dirty memory呢？例如:
  
      1.[NSData dataWithContentsOfMappedFile:]替代内存加载。
      可惜该API现在不推荐使用。
      2.使用[UIImage imageWithContentsOfFile:]替代[UIImage imageNamed]
      3.降低内存占用。
      4.适当的cache.

####5.如何发现定位dirty memory呢?可以参考[Finding iOS memory](http://liam.flookes.com/wp/2012/05/03/finding-ios-memory/)