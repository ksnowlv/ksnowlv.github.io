---
title: "关于NSOperation的使用之一"
date: 2013-04-03
lastmod: 2013-04-03
categories:
  - "iOS"
tags:
  - "多线程"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

   Apple在OS X 10.5 Leopard上做了很多改进。`NSThread`本身就新增了很多新的方法，从而使得多线程变得更加容易。此外还新增了`NSOperation`和`NSOperationQueue`两个类，使多线程编程更加方便！

以`NSOperation`和`NSOperationQueue`为例   

#### 1.头文件```objective-c

//  QTileDownloadOperation.h
#import <Foundation/Foundation.h>

@interface QTileDownloadOperation : NSOperation

@property(nonatomic, retain)NSString* name;

- (void)clear;

@end

```


#### 2.实现文件
```objective-c
//  QTileDownloadOperation.m
#import "QTileDownloadOperation.h"

@implementation QTileDownloadOperation
@synthesize name;

- (void)dealloc {
    [name release];

    //......
    [super dealloc];
}


- (void)main
{
    if ([self isCancelled] || [self isFinished]) {
        return;
    }

    NSLog(@"%@start!",name);
    NSString* urlString = [@"你得URL" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* requestWithAgent = [NSMutableURLRequest requestWithURL:url];
    
    [requestWithAgent setValue:@"mapapi" forHTTPHeaderField:@"User-Agent"];
    [requestWithAgent setTimeoutInterval:120];
    
    NSError* error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:requestWithAgent returningResponse:nil error:&error];
    
    if (error == nil) {
        
        if (![self isCancelled])
        {
            [self didFinishWithData:data];
        }
    }
    else
    {
       //error handle
       //对外通知，注意线程同步
    }
}

- (void)didFinishWithData:(NSData*)data
{
    NSLog(@"%@complete!",name);
    //数据处理.........................
    //对外通知，注意线程同步
}

- (void)clear
{
    //可以进行取消网络，delegate置为nil,清理其他资源等。主要是防止线程对象释放时Crash
}

@end

```

可以使用使用自己创建的`OperationQueue`管理线程对象

```objective-c
    NSOperationQueue* q = [[NSOperationQueue alloc] init];
    self.myQueue = q;
    //设置允许最大并发数
    [myQueue setMaxConcurrentOperationCount:2];
    [q release];

```
向`NSOperationQueue`中添加`QTileDownloadOperation`对象

```objective-c    
    for (int i = 0; i < 8; ++i) {
        
        QTileDownloadOperation* op = [[QTileDownloadOperation alloc] init];
        NSString* name = [NSString stringWithFormat:@"op%d",i];
        op.name = name;
        [myQueue addOperation:op];
        [op release];
    }
```


释放线程队列如下：

```objective-c
    NSArray *allOperations = [myQueue operations];
    
    for (QTileDownloadOperation* op in allOperations) {
        
        if(![op isCancelled])
        {
            [op clear];
            [op cancel];
        }
    }
    
    [myQueue release];
    myQueue = nil;
```

那如何是取消呢？通常情况下，取消当前线程队列中当前待执行线程队列队首尚未取消的线程对象。如下所示：

```objective-c
    NSArray *allOperations = [myQueue operations];
    for (int i = [myQueue maxConcurrentOperationCount];  i < [allOperations count]; ++i) {
        QTileDownloadOperation* op = [allOperations objectAtIndex:i];
        
        if (!op.isCancelled) {
            
            [op clear];
            [op cancel];
        }
    }

```

为什么会allOperations暂存呢？因为线程队列中的对象在并发执行，其状态在任意时间点可能会改变。而这个取消的操作通常在其他线程中，比如说主线程，会因线程不同步引发Crash等异常。

