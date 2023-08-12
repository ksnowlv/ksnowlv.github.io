---
title: "pthread的使用"
date: 2013-04-03
categories:
  - "iOS-多线程"
tags:
  - "iOS-多线程"
---
<!--more-->

`pthread`与`pthread_mutex_t`在一些场景下，会经常结合使用。

示例

#### 1.头文件。
```objective-c
//  QBKThread.h
@interface QBKThread : NSObject
{
    pthread_t _tid;
    pthread_mutex_t theTaskMutex;
}

- (void*)run;

- (void)start;
- (void)stop;

@end

```

#### 2.实现文件。
```objective-c

//  QBKThread.m
#import "QBKThread.h"
#import <pthread.h>

void *backgroundProcessThread(void *p)
{
    QBKThread*  t = (QBKThread *)p;
    return [t run];
}

@interface QBKThread()
{
    BOOL _isRunnig;
}


@end

@implementation QBKThread

- (id)init {
    self = [super init];
    
    if (self) {
        
        pthread_mutex_init(&theTaskMutex, NULL);
    }
    
    return self;
}

- (void)dealloc {
    [self stop];
    pthread_mutex_destroy(&theTaskMutex);
    [super dealloc];
}

-(void*)run  {
    while (_isRunnig) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        pthread_mutex_lock(&theTaskMutex);
        
        NSLog(@"01");
        
        pthread_mutex_unlock(&theTaskMutex);
        
        [NSThread sleepForTimeInterval:0.16];
        [pool release];

    }
    
    return 0;
}

- (void)start {
    pthread_mutex_lock(&theTaskMutex);
    
    
    if (!_isRunnig)  {
        _isRunnig = YES;
        pthread_create(&_tid, NULL, backgroundProcessThread, self);
    }
    
    pthread_mutex_unlock(&theTaskMutex);
}

- (void)stop {
     pthread_mutex_lock(&theTaskMutex);
    if (_isRunnig) {
        _isRunnig = NO;
        //printf("exitThread:(BOOL)bHandleCancel exitNow = YES;\n");
        pthread_join(_tid, NULL);
        NSLog(@"thread close");
    }
    pthread_mutex_unlock(&theTaskMutex);
}


```