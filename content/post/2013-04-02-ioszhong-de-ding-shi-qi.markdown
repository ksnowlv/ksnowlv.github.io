---
title: "iOS中的定时器"
date: 2013-04-02
categories:
  - "iOS"
tags:
  - "iOS"
---
<!--more-->


#### 一.背景  在做街景iPhone SDK时，OpenGL的渲染需要启用一个类Timer来驱动，而SDK中，提供的是一个街景view。鉴于UIView一般释放时不需要手动调用清理函数，而Timer如果直接添加到街景View中会造成相互retain，导致即使在街景View中添加Timer的释放,也不能完成正常的释放.
  
#### 二. QOpenGLRenderTimer
#### 1.头文件```objective-c
//
//  QOpenGLTimer.h
//  SOSOStreetViewMapAPI
//
//  Created by lv wei on 13-3-27.
//  Copyright (c) 2013年 lv wei. All rights reserved.
//

/**
 *QOpenGLRenderTimer的Delegate,通知绘制OPENGL
 *Author:ksnowlv
 **/
@protocol QOpenGLRenderTimerDelegate <NSObject>
@optional

/**
 *地图区域即将改变时会调用此接
 */
- (void)renderOpenGLEvent;

@end

@interface QOpenGLRenderTimer : NSObject

@property (nonatomic, assign) id<QOpenGLRenderTimerDelegate> delegate;
@property (nonatomic, assign) CADisplayLink *displayLink;

-(void)startOpenGLRenderTimer;
-(void)stopOpenGLRenderTimer;


@end

``` 


#### 2.实现文件  ```objective-c
  //
//  QOpenGLRenderTimer.m
//  SOSOStreetViewMapAPI
//
//  Created by lv wei on 13-3-27.
//  Copyright (c) 2013年 lv wei. All rights reserved.
//

#import "QOpenGLRenderTimer.h"
#import <QuartzCore/QuartzCore.h>


@implementation QOpenGLRenderTimer
@synthesize delegate = _delegate;
@synthesize displayLink = _displayLink;

- (void)dealloc {
    [self stopOpenGLRenderTimer];
    [super dealloc];
}

- (void)startOpenGLRenderTimer{
    
    if (self.displayLink != nil)
    {
        [self.displayLink invalidate];
    }
    
    CADisplayLink *aDisplayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(renderOpenGL)];
    [aDisplayLink setFrameInterval:1.0f];

    [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self.displayLink = aDisplayLink;
}

- (void)stopOpenGLRenderTimer
{
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)renderOpenGL
{
    [_delegate renderOpenGLEvent];
}

  ```
  
 
#### 三. QOpenGLRenderTimer的使用
##### 1.街景View中开启OpenGL渲染循环如下：
```objective-c
        QOpenGLRenderTimer* timer = [[QOpenGLRenderTimer alloc] init];
        timer.delegate = self;
        [timer startOpenGLRenderTimer];
        self.openGLRenderTimer = timer;
        [timer release];
 ```
 
##### 2.在街景View的dealloc 方法中 停止OpenGL渲染循环.
 
 ```objective-c
- (void)dealloc  {
    if (_openGLRenderTimer) {
        _openGLRenderTimer.delegate = nil;
        [_openGLRenderTimer stopOpenGLRenderTimer];
        [_openGLRenderTimer release];
        _openGLRenderTimer = nil;
    }
}
```

#### 四.其它。##### 1.当时考虑过放在街景的代理中，根据代理设置的是否为空，启用或停止OPENGL渲染的逻辑。但是，为什么没有那么做呢？* 1.开发者使用街景View，不一定会设置代理。
* 2.即使创建街景View设置代理了，这种设计和实现不太好。
* 3.有更好的解决方案。
