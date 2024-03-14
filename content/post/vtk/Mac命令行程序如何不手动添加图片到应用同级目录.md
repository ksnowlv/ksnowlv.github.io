---
title: "Mac命令行程序如何不手动添加图片到应用同级目录"
date: 2024-03-14T09:56:58+08:00
lastmod: 2024-03-14T09:56:58+08:00
keywords: ["Mac","VTK","C++"]
tags: ["Mac","VTK","C++"]
categories: ["Mac","VTK","C++"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 1.问题

Mac程序是命令行程序的情况下，添加资源文件到XCode工程中，并不会打包到应用中。前文咱们给出两个解决方案

* 1.拷贝文件夹到应用同级目录。
* 2.图片转换代码头文件。

现在给出第三种方法。

### 2.解决方案

在项目**Targets**中，选择**Build Phases**选项中的**Embed Libraries**添加，如图

![image](/images/vtk/Mac命令行程序如何不手动添加图片到应用同级目录/xcode_add_images.jpg)

图片添加完后，编译整个项目，在Debug目录中效果如图

![image](/images/vtk/Mac命令行程序如何不手动添加图片到应用同级目录/xcode_build_dir.jpg)

项目中读取文件时，使用不带目录的图片文件名称即可。


