---
title: "Flutter绘图优化 慎用saveLayer"
date: 2024-04-06T20:42:47+08:00
lastmod: 2024-04-06T20:42:47+08:00
keywords: ["Flutter"]
tags: ["Flutter"]
categories: ["Flutter"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## 谨慎使用 saveLayer
Flutter代码调用了性能代价很大的**saveLayer**方法来实现UI中的各种视觉效果。你的应用程序如果会大量调用 **saveLayer**，很可能会导致卡顿。

### saveLayer代价很大的原因

调用saveLayer开辟离屏缓冲区，并将内容绘制到离屏缓冲区，可能会触发渲染目标切换。 

GPU希望直达目标地运行，但渲染目标迫使GPU暂时重定向到该数据流，然后又直接把它切回来。这样会对渲染吞吐量造成特别大的破坏性。

### 什么时候需要 saveLayer
在运行时，如果你需要动态地显示各种形状效果（例如），每个形状都有一定地透明度，可能（或可能不）重叠，那么你几乎必须使用saveLayer()。


### 尽量减少saveLayer 的调用
如果这些调用，是来自于你的代码，你能减少或消除它们吗？例如，也许你的用户界面重叠了两个形状，每个形状都有非零的透明度：

如果它们总是以相同的数量、相同的方式、相同的透明度进行重叠，你就可以预先计算出这个重叠的、半透明物体的样子，将其缓存起来，然后用它代替调用 saveLayer()。这适用于任何你可以预先计算的静态形状。


其他会触发 saveLayer() 的 widget，也有潜在的性能代价：

* ShaderMask
* ColorFilter
* Chip—当 disabledColorAlpha != 0xff 的时候，会调用 saveLayer()
* Text— 当有 overflowShader 时，会调用saveLayer()


