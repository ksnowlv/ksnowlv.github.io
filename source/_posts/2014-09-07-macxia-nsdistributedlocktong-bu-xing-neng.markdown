---
layout: post
title: "Mac下NSDistributedLock同步性能"
date: 2014-09-07 14:56
comments: true
categories: Mac-多线程
---

####Mac下[NSDistributedLock](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSDistributedLock_Class/Reference/Reference.html)也可以用来同步。

 <!--more-->
 
> * 可以用来限制对某些共享资源的访问，比如一个文件。
 * 没有实现**NSLocking**协议，所有没有`lock`方法。一个`lock`方法将会阻塞线程的执行，并要求系统以预定的速度轮询锁。
 * 它提供了一个`tryLock`方法，并让你决定是否轮询。访问结束后，可以通过调用unlock方法来释放它。

我们使用该锁对`doucument`目录访问。

``` objective-c

    ...        
    NSString *doucumentDir = [paths objectAtIndex:0];
    NSLog(@"doucumentDir = %@", doucumentDir);
    
    const NSInteger KRunTimes = 1000 * 1000;
    double curTime, lastTime;
    
    // NSDistributedLock
    NSDistributedLock *lock = [NSDistributedLock lockWithPath:doucumentDir];
    lastTime = CFAbsoluteTimeGetCurrent();
    
    for (NSInteger i = 0; i < KRunTimes; ++i) {
        
        if ([lock tryLock]) {
            [lock unlock];
        }
    }

    curTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"@synchronized: %f ms", (curTime - lastTime) * 1000);
    
```

####日志输出:

    2014-09-07 14:55:32.438 NSDistributedLockTest[4131:303] doucumentDir = /Users/ksnowlv/Documents
    2014-09-07 14:55:33.703 NSDistributedLockTest[4131:303] @synchronized: 1264.391005 ms

####结论：和其它同步锁相比，耗时是比较高的。
    
