---
title: "iOS-64位适配"
date: 2015-01-06
lastmod: 2015-01-06
categories:
  - "iOS"
tags:
  - "iOS"
comment: true
toc: false
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

请参考苹果文档链接：[https://developer.apple.com/library/ios/documentation/General/Conceptual/CocoaTouch64BitGuide/ConvertingYourAppto64-Bit/ConvertingYourAppto64-Bit.html](https://developer.apple.com/library/ios/documentation/General/Conceptual/CocoaTouch64BitGuide/ConvertingYourAppto64-Bit/ConvertingYourAppto64-Bit.html)

摘取几条如下：
### 指针不要转换为整数   将指针类型转换成整型的情况一般很少,但是非要用指针类型的话,请确保你的变量地址足够大。
   
   在 32 位中,这段代码运行正常,是因为 int 类型和 指针类型大小相同。 
   在 64 位中指针类型是比int类型的大,所以这个赋值将会丢失指针类型的数据。

```objective-c
int *c = something passed in as an argument.... 
int *d = (int *)((int)c + 4); // Incorrect.
int *d = c + 1; // Correct!

```

### 数据类型保持一致   许多常见的程序错误都是应为数据类型用的不一致性导致的,尽管当你用了不 一样的数据类型的时候编译器给出了警告,如果你留意这些改变的话,它将会帮助你意识到这些问题。
   方法调用的时候,方法接受的参数应该和调用的参数类型匹配。如果调用方法的参数比接收的方法的参数要大,这个值将会被截取。

```objective-c
NSInteger PerformCalculation(void);
int x = PerformCalculation(); // incorrect
NSInteger y = PerformCalculation(); // correct!
```

### 使用方法函数的原型调度Objective-C的消息
```objective-c
- (int) doSomething:(int) x { ... }
- (void) doSomethingElse {
    int (*action)(id, SEL, int) = (int (*)(id, SEL, int)) objc_msgSend;
    action(self, @selector(doSomething:), 0);
}

```

### 检查可变参数函数
如果你的方法使用了可变参数如fun(id self, SEL cmd, ...)或者va_start, va_list, va_arg等宏，在iphone6真机测试此函数接收的参数是否正确。

### isa指针不能直接访问