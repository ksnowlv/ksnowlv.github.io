---
layout: post
title: "uml组件图"
date: 2014-11-04 16:09
comments: true
categories: UML
---
###组件图(Component diagram)
    显示系统组件间的结构关系组件图,有助于直观显示系统的高级结构以及这些结构通过接口提供和使用的服务行为.
    
 <!--more-->
###组件图示例
![image](/images/post/2014-11-04-uml-zu-jian-tu/component_diagram.png)

Store组件提供了**OrderEntry** 接口,并要求使用**Account**接口。
Store组件由三个组件组成：

* 1.Order组件
* 2.Customer组件
* 3.Product组件。

> 注意Store的 OrderEntry 和Account接口符号在组件的边缘上为何有一个方块？

> 这一个方块被称为一个端口。单纯感觉来说，端口提供一种方法，它显示建模组件所 提供/要求 的接口如何与它里面的部分相关联。 通过使用端口，我们可以从外部实例中分离出Store组件的内部部件。


 OrderEntry 端口代表Order组件的 OrderEntry 接口，表示Store组件提供该接口。
Account端口代表内部的Customer组件要求使用的Account接口必须分配给Store组件，表示Store组件要求使用该接口。
