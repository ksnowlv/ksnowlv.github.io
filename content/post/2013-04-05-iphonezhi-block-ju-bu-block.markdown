---
title: "iPhone之block_一局部block"
date: 2013-04-05
categories:
  - "iOS"
tags:
  - "iOS"
---
<!--more-->

iOS4在UIKit中引入了block,可以帮助我们组织独立的代码段，并提高复用性和可读性.

Block是符合如下要求的匿名内联的代码集：

* 和函数一样具有一个指定类型的参数列表
* 有一个可以推导或声明的返回值类型
* 可以从它被定义的词义范围中捕捉状态
* 可以在需要的时候改变词义范围的状态
* 可以和相同的词义范围中定义的其他的Block共享更改的可能。
* 可以在词义范围（堆栈帧）被销毁后继续共享和修改该词义范围（堆栈帧）的状态。
Block是一个自包含的小代码段，封装了用于遍历（线性遍历）或者回调，可以并发执行的任务单元。

#### 1.示例1```objective-c
typedef void(^printBlock)(NSString* toDo);
    printBlock pb;
    
    NSString* name = @"john";
    
    pb = ^(NSString* toDo){
        NSString* c = [NSString stringWithFormat:@"%@ %@",name,toDo];
        NSLog(@"infomation:%@", c);
    };
    
    name = @"tom";
    
    pb(@"go to park");
```

其输出为

	2013-04-05 13:59:16.039 test[15932:c303] infomation:john go to park
	
创建block对象时，此对象只会捕获当前引用值。以后引用值怎么变，只会使用之前的值。

#### 2.示例2
如果用__block修饰name

```objective-c
   typedef void(^printBlock)(NSString* toDo);
    printBlock pb;
    
   __block  NSString* name = @"john";
    
    pb = ^(NSString* toDo){
        NSString* c = [NSString stringWithFormat:@"%@ %@",name,toDo];
        NSLog(@"infomation:%@", c);
    };
    
    name = @"tom";
    
    pb(@"go to park");
```

其输出为：

	2013-04-05 14:05:56.893 test[16610:c303] infomation:tom go to park
	
#### 3.关于__block
__block 存储类型

你可以规定一个外部的变量是否可变——可读写——通过使用__block存储类型修饰符。__block存储类似但不同于register，auto和static存储类型。


__block变量在变量声明的作用域、所有同一作用域内的块，以及块拷贝之间同享存储。而且这个存储将在栈帧（stack frame）释放时得以保留，只要同一帧内申明的块的拷贝仍然存活（例如，被入栈以便再次使用）。在指定作用域内的多个块能同时使用共享变量。

作为一种优化，块存储使用栈存储，就如同块自身一样。如果使用Block_copy拷贝块（或者在O-C向块发送copy消息），变量被拷贝到堆里。而且，__block变量的地址随后就会改变。

__block变量有两个限制

* 不能是可变长度的数组
* 不能是包含C99可变长度数组的结构体	
