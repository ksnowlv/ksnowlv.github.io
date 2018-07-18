---
layout: post
title: "swift中escaping与noescaping之区别"
date: 2018-07-16 16:10
comments: true
categories: swift
---

`Swift3之前`：
	
	默认escaping，逃逸闭包，是不安全的。对于非逃逸闭包，你需要标记@noescaping

`Swift3及之后`

	默认是noescaping，非逃逸的,默认是安全的：如果一个函数参数可能导致引用循环，那么它需要被escaping显示地标记出来.

####一.区别
具体什么区别呢？先举例说明。

* 1 声明testBlock

```objective-c
typealias testBlock = (_ type: Int, _ contextObject: Any) -> Void
```

* 2 `noescaping`

```objective-c
    func testBlock1(block:testBlock) {
        block(0,"hello");
    }
```

* 3 `escaping`

```objective-c
   func testBlock2(block:@escaping testBlock) {
        DispatchQueue.global().async {
            block(1,"world")
        }
    }
```

* 4 调用

```objective-c
      testBlock1(block:{ (type: Int, contextObject: Any) in
            print("type=\(type),contextObject=\(contextObject)")
        } )
        testBlock2(block: {(type: Int, contextObject: Any) in
            print("type=\(type),contextObject=\(contextObject)")
        })
```

* 5 输出日志

```objective-c
type=0,contextObject=hello
type=1,contextObject=world
```

###二.区别总结
* 1.`@escaping`标明这个闭包是会“逃逸”，通俗点来讲，这个闭包的作用域可能超过该函数的作用域，也就是说，该闭包在函数执行完成之后才被调用。

* 2.`@noescaping`标明非逃逸的闭包的作用域是不会超过函数作用域的，我们不需要担心在闭包内持有self。

