---
title: "iPhone-OpenGL绘图坐标和纹理坐标问题"
date: 2013-04-12
lastmod: 2013-04-12
categories:
  - "iOS"
tags:
  - "iOS"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

当我们使用标准的OpenGL 绘制纹理图像时，我们得到了一个翻转的图像。为什么呢？

    iPhone中用于Core Graphics的图像坐标系统，其y轴在屏幕从上到下而增加，与OpenGL ES中的坐标系正好相反，OpenGL ES坐标系的y轴从下向上增加。其结果就是我们早先传递给OpenGL ES中的图像数据从OpenGL ES的角度看完全颠倒了。所以，如果我们要保证显示的纹理正常，需要把纹理坐标的上下颠倒下。当然，你也可以修改投影来正常显示纹理
