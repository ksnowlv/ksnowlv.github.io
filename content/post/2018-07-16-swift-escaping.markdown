---
title: "swift中escaping与noescaping之区别"
date: 2018-07-16
lastmod: 2018-07-16
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

`Swift3之前`：
	
	默认escaping，逃逸闭包，是不安全的。对于非逃逸闭包，你需要标记@noescaping

`Swift3及之后`

	默认是noescaping，非逃逸的,默认是安全的：如果一个函数参数可能导致引用循环，那么它需要被escaping显示地标记出来.

## 一.具体区别

先举例说明。

### 1 声明testBlock

```swift
typealias testBlock = (_ type: Int, _ contextObject: Any) -> Void
```

### 2 `noescaping`

```swift
    func testBlock1(block:testBlock) {
        block(0,"hello");
    }
```

### 3 `escaping`

```swift
   func testBlock2(block:@escaping testBlock) {
        DispatchQueue.global().async {
            block(1,"world")
        }
    }
```

### 4 调用

```swift
      testBlock1(block:{ (type: Int, contextObject: Any) in
            print("type=\(type),contextObject=\(contextObject)")
        } )
        testBlock2(block: {(type: Int, contextObject: Any) in
            print("type=\(type),contextObject=\(contextObject)")
        })
```

### 5 输出日志

```swift
type=0,contextObject=hello
type=1,contextObject=world
```

## 二.总结
### 1.`@escaping`会“逃逸”
通俗点来讲，这个闭包的作用域可能超过该函数的作用域，也就是说，该闭包在函数执行完成之后才被调用。

### 2.`@noescaping`非逃逸
标明非逃逸的闭包的作用域是不会超过函数作用域的，我们不需要担心在闭包内持有self。

