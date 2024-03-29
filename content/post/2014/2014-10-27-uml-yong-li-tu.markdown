---
title: "uml-用例图"
date: 2014-10-27
lastmod: 2014-10-27
categories:
  - "UML"
tags:
  - "UML"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

### 用例图(Use Case)
   
   主要用来描述“用户、需求、系统功能单元”之间的关系.

### 用例图元素
用例图所包含的元素

* 1.参与者(Actor)
* 2.用例(Use Case)    外部可见的系统功能,用椭圆表示
* 3.子系统(Subsystem)    用来展示系统的一部分功能，这部分功能联系紧密。
* 4.关系    用例图中涉及的关系有：关联、泛化、包含、扩展。

	* a.关联(Association):表示参与者与用例之间的通信，任何一方都可发送或接受消息.  
	* b.泛化(Inheritance):继承关系，子用例和父用例相似，但表现出更特别的行为.
	* c.包含(Include):包含关系用来把一个较复杂用例所表示的功能分解成较小的功能.
	* d.扩展(Extend):指用例功能的延伸，相当于为基础用例提供一个附加功能.
　   
### 用例图示例

![image](/images/post/2014-10-27-uml-yong-li-tu/case_diagram.jpg)
　　
用例图也许并不能很好地表达系统的需求，有时需要添加用例描述表来说明.
