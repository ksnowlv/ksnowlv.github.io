---
layout: post
title: "iOS镂空UIView"
date: 2015-05-14 22:46
comments: true
categories: iOS-UI
---

如果想把UIView挖空一块，使用遮罩图。
<!--more-->
效果图如下：

![image](/images/post/2015-05-14-ios-lou-kong-uiview/overview.png)

示例代码如下：

```objective-c
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CALayer *mask = [CALayer layer];
    mask.frame = self.maskView.bounds;
    mask.contents = (id)[[UIImage imageNamed:@"mask"] CGImage];
    _maskView.layer.mask = mask;
    _maskView.layer.masksToBounds = YES;
}
```

代码见[链接](https://github.com/ksnowlv/maskTest.git)

