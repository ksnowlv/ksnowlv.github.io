---
title: "swift-计时器"
date: 2017-12-15
lastmod: 2017-12-15
categories:
  - "swift"
tags:
  - "swift"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

iOS中计时器工具类如何设计呢？

## 1.需求

* 开启/关闭计时器。
* 设置计时器周期。
* 设置计时器是否周期触发。
* 回调计时器开启时到当前时间间隔。用于倒计时相关场景，前台切后端场景。

## 2.接口设计

```swift

var timeInterval:TimeInterval = 1.0
var isTimerLoopRepeate = true
var countTimerBlock:countTimerBlock!
func setIsOpen(isOpen:Bool) -> Void

```

源代码参考[KCountDownTimer](https://github.com/ksnowlv/KCountDownTimer)
