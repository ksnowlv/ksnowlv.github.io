---
layout: post
title: "iPhone之block_成员block"
date: 2013-04-05 17:55
comments: true
categories: iOS-基础
---


块是基于栈的：当在一个函数或方法中定义一个块变量时，编译器会在栈上创建一个结构来保存块所引用的任何本地变量的值，它引用的读写变量的地址及指向块的可执行代码的指针。
  
  但block也可以作为成员使用，需要把块由栈拷贝到堆上。

####示例
#####1.头文件
```objective-c
//  QBlock.h
#import <Foundation/Foundation.h>
typedef void(^printBlock)(NSString* toDo);

@interface QBlock : NSObject
{
    printBlock _printBlock;
}

- (void)print:(NSString*)infomation;

@end

```

#####2.实现文件

```objective-c

//  QBlock.m
#import "QBlock.h"

@implementation QBlock

- (id)init  {
    self = [super init];
    
    if (self) {
        
        
      printBlock pb = ^(NSString* toDo){
            NSLog(@"infomation:%@", toDo);
        };
        
        _printBlock = [pb copy];
        
        NSLog(@"after block copy retainCount =%d", [_printBlock retainCount]); 
    }
    
    return self;
}

- (void)dealloc {
    [_printBlock release];
    
    NSLog(@"after block release retainCount =%d", [_printBlock retainCount]);
    
    [super dealloc];
}

- (void)print:(NSString*)infomation {
    _printBlock(infomation);
}

@end
```

#####3.调用

```objective-c
 QBlock* block = [[QBlock alloc] init];
 [block print:@"BLOCK以成员的形式使用"];
 [block release];
```
 
#####4.输出日志如下：
	2013-04-05 17:45:44.542 test[31997:c303] infomation:tom go to park
	2013-04-05 17:45:44.543 test[31997:c303] after block copy retainCount =1
	2013-04-05 17:45:44.543 test[31997:c303] infomation:BLOCK以成员的形式使用
	2013-04-05 17:45:44.544 test[31997:c303] after block release retainCount =1


#####5.为什么模拟器上不用[pb copy]也是可以的呢？再看下;
后来看其他资料上这么说的：
如果你尝试上面[pb copy]，有可能看上去可以正常工作。这可能是编译器在这个示例中已经安排了代码的一种偶然的方式。当代码超过作用域之后，编译器自由使用块在栈帧中所占用的空间。如果编译器重新使用该空间，尝试执行超过作用域的块，更有可能导致程序崩溃。

