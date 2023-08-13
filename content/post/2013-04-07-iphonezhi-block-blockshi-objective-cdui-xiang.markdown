---
title: "iPhone之block_block是objective-c对象"
date: 2013-04-07
lastmod: 2013-04-07
categories:
  - "iOS"
tags:
  - "iOS"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---


`block`是`objective-c`对象,一个新创建的块，就是在堆栈上创建的一个Objective-c对象的一个示例。苹果没有提供块类头文件，因此，无法子类化它或者以一种`objective-c`的意义对它做任何事情，除了向它们发送`copy`,`retain`,`release`,`autorelease`消息。

如果直接使用C编写程序，可以用Block_copy函数，如下所示：

```objective-c
- (void)testC_Block {
    typedef void (^showMessage)(NSString* todo);
    
    showMessage message =   ^(NSString* message){
        NSLog(@"message=%@",message);
    };
    
    showMessage myMessage =  Block_copy(message);
    
    myMessage(@"我和胖胖宝一起去超市了!");
    
    Block_release(myMessage);
}
```
运行上述代码，输出为：

	2013-04-08 10:48:16.096 test[3529:c303] message=我和胖胖宝一起去超市了!
记得使用Block_release释放。

在Objective-c中，可以向块发送一条copy消息：示例如下
```objective-c
- (void)testOC_Block
{
    typedef void (^showMessage)(NSString* todo);
    
    showMessage message =   ^(NSString* message){
        NSLog(@"message=%@",message);
    };
    
    showMessage myMessage = [message copy];
    
    myMessage(@"我去超市了!");
    
    [myMessage release];
    //[myMessage autorelease];
}
```

运行上述代码，输出为：

	2013-04-08 10:48:16.097 test[3529:c303] message=我去超市了!
可以使用release或autorelease释放。

上述两个示例是对等的，都可以使用一个块指针而不是块直接量。
如果返回一个块，使用Objective-c方式进行内存管理比较方便。

```objective-c
void(^getShowMessageBlock())(NSString* todo)
{
   void (^showMessage)(NSString* todo) =   ^(NSString* message){
        NSLog(@"message=%@",message);
    };
    
    return [[showMessage copy] autorelease];
}
```

调用如下：
```objective-c
    void (^showMessage)(NSString*) = getShowMessageBlock();
    showMessage(@"胖胖去超市了!");
     ```
     
输出如下：

	2013-04-08 10:32:03.538 test[2380:c303] message=胖胖去超市了!

当复制一个块时，新的块会获取块所引用的任何自动变量的值的副本（也就是说根据值来访问自动变量，当块对象创建时，该 变量的值会复制到块对象中）。

注意：
Block_copy和Block_release的调用不能与Objective-c的copy和release，或autorelease混合使用。


