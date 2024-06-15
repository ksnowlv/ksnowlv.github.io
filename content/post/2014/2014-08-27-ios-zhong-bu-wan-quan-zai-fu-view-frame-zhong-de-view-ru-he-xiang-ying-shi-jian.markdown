---
title: "iOS中不完全在父UIView frame中的UIView如何响应事件"
date: 2014-08-27
lastmod: 2014-08-27
categories:
  - "iOS"
tags:
  - "iOS"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

### 1.问题

iOS开发中，如何使一个不完全在父**UIView的frame**中的**UIView**响应事件呢？


### 2.解决方案

可以通过在父**UIView**中重写**pointInside:withEvent**即可.

``` objective-c

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *subview in self.subviews) {

        CGPoint subviewPoint = [self convertPoint:point toView:subview];

        if ([subview pointInside:subviewPoint withEvent:event]) {

            return YES;
        }
    }

    return [super pointInside:point withEvent:event];
}


```

在腾讯地图sdk中关于标注覆盖物**(QAnnotationView)**弹出的气泡采用该方法。
   
* 气泡是标注的子**UIView**,但是，并不完全在标注的**frame**中。
* 如果使气泡可以响应事件，则在**QAnnotationView**中重写**pointInside:withEvent**
