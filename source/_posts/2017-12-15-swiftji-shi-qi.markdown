---
layout: post
title: "swift-计时器"
date: 2017-12-15 15:06
comments: true
categories: swift-基础框架
---

iOS中计时器工具类如何设计呢？
<!--more-->

1.需求

* 开启/关闭计时器。
* 设置计时器周期。
* 设置计时器是否周期触发。
* 回调计时器开启时到当前时间间隔。用于倒计时相关场景，前台切后端场景。

2.接口设计

```objective-c

var timeInterval:TimeInterval = 1.0
var isTimerLoopRepeate = true
var countTimerBlock:countTimerBlock!
func setIsOpen(isOpen:Bool) -> Void

```

源代码参考[KCountDownTimer](https://github.com/ksnowlv/KCountDownTimer)