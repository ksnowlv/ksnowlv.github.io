---
title: "takeUnretainedValue与takeRetainedValue区别"
date: 2018-06-29
lastmod: 2018-06-29
categories:
  - "swift"
tags:
  - "swift"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

## 1. perform时警告
swift中，如果我们使用perform相关函数时，例如

```swift
 if let object = connectionItem.perform(connectionSEL, with: nil) {
                    (object as! YKURLConnection).cancel()
                    
                }
```

此时会报警告

	 Cast from 'Unmanaged<AnyObject>' to unrelated type 'YKURLConnection' always fails

虽然代码可以正常运行，报这种警告，也是让人心理很不爽。

## 解决方案
如何解决呢？使用Unmanaged<AnyObject>的takeUnretainedValue()即可解决。


### 1.takeUnretainedValue
Gets the value of this unmanaged reference as a managed reference without consuming an unbalanced retain of it.
This is useful when a function returns an unmanaged reference and you know that you’re not responsible for releasing the result.
Returns	
The object referenced by this Unmanaged instance.

## 2.takeRetainedValueGets 

the value of this unmanaged reference as a managed reference and consumes an unbalanced retain of it.
This is useful when a function returns an unmanaged reference and you know that you’re responsible for releasing the result.
Returns	
The object referenced by this Unmanaged instance.

## 3.区别

### takeUnretainedValue不需要负责对象的释放。
### takeRetainedValue需要调用者负责对象的释放，通常是一些copy/create产生的对象，

也可看下stackoverflow上一些[解释](https://stackoverflow.com/questions/28978200/whats-the-difference-between-takeunretainedvalue-and-takeretainedvalue)