---
layout: post
title: "iphone之block_block作为成员使用时的陷阱"
date: 2013-04-27 11:43
comments: true
categories: iOS-基础
---


`block`作为成员使用时，避免直接引用成员变量，造成block和所在的类相互retain引发内存泄露。

#####解决方法：
* 1.解除相互引用关系，在释放对象时先把成员BLOCK释放，再释放自己。
* 2.间接使用成员变量，调整BLOCK参数和相关代码，避免出现问题。

首先声明一个块。

```objective-c
//
//  Block_common.h
//  memorytest_block
//
//  Created by lv wei on 13-4-27.
//  Copyright (c) 2013年 lv wei. All rights reserved.
//

#ifndef memorytest_block_Block_common_h
#define memorytest_block_Block_common_h

typedef void (^output)();

#endif

声明一个BLOCK作为非成员使用的类
//
//  Block_notmember.h
//  memorytest_block
//
//  Created by lv wei on 13-4-27.
//  Copyright (c) 2013年 lv wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Block_notmember : NSObject

- (void)output;
@end

//
//  Block_notmember.m
//  memorytest_block
//
//  Created by lv wei on 13-4-27.
//  Copyright (c) 2013年 lv wei. All rights reserved.
//

#import "Block_notmember.h"
#import "Block_common.h"

@interface Block_notmember ()
@property(nonatomic, retain)NSString* infomation;

@end

@implementation Block_notmember
@synthesize infomation = _infomation;


- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.infomation = @"ksnowlv";
    }
    
    return self;
}

- (void)output
{
    output o =  ^()
    {
        NSLog(@"Block_notmember information:%@",_infomation);
    };
    
    o();
}

- (void)dealloc
{
    NSLog(@"Block_notmember Object destory");
    [super dealloc];
}
@end


声明一个BLOCK作为成员使用的类
//
//  Block_member.h
//  memorytest_block
//
//  Created by lv wei on 13-4-27.
//  Copyright (c) 2013年 lv wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Block_common.h"


@interface Block_member : NSObject
- (void)output;
- (void)destroy;
@end

//
//  Block_member.m
//  memorytest_block
//
//  Created by lv wei on 13-4-27.
//  Copyright (c) 2013年 lv wei. All rights reserved.
//

#import "Block_member.h"

@interface Block_member ()
{
    output _myOutput;
}

@property(nonatomic, retain)NSString* infomation;
@end

@implementation Block_member
@synthesize infomation = _infomation;

- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.infomation = @"kair";
        
       // NSString* info = _infomation;
        
        output o =  ^()
        {
            NSLog(@"Block_member information:%@",_infomation);
        };
        
        _myOutput = [o copy];
    }
    
    return self;
}

- (void)output
{
    _myOutput();
}

- (void)destroy
{
    if (_myOutput) {
        [_myOutput release];
        _myOutput = nil;
    }
}

- (void)dealloc
{
    NSLog(@"Block_member Object destory");
    [super dealloc];
}

@end

```

如下方式调用：

```objective-c
    Block_member* member = [[Block_member alloc] init];
    [member output];
    [member release];
    
    Block_notmember* notMember = [[Block_notmember alloc] init];
    [notMember output];
    [notMember release];
    
```
    
运行结果如下：

	2013-04-27 11:25:08.569 memorytest_block[9073:11303] Block_member information:kair
	2013-04-27 11:25:08.570 memorytest_block[9073:11303] Block_notmember information:ksnowlv
	2013-04-27 11:25:08.570 memorytest_block[9073:11303] Block_notmember Object destory

从上面日志看，member并没有正常释放，造成内存泄露。
如果对Block_member如下调用，替换上面的。

```objective-c
    Block_member* member = [[Block_member alloc] init];
    [member output];
    [member destroy];
    [member release];
    
```

运行结果如下：

	2013-04-27 11:39:04.187 memorytest_block[10853:11303] Block_member information:kair
	2013-04-27 11:39:04.188 memorytest_block[10853:11303] Block_member Object destory
	2013-04-27 11:39:04.188 memorytest_block[10853:11303] Block_notmember information:ksnowlv
	2013-04-27 11:39:04.189 memorytest_block[10853:11303] Block_notmember Object destory
	
从上面日志看，member对象得到了正常释放。
以上仅仅是演示，不一一列举解决方法。重在产生问题的原因。
你也许会问，为什么非成员的BLOCK直接引用了成员为啥没有出现问题呢？

原因是块是临时的，块的生命周期结束后会释放对self的引用，就不存在相互retain的问题。和Timer,runloop等类似，只要没有导致相互retain这种循环引用，会避免这种情况下的内存泄露。
