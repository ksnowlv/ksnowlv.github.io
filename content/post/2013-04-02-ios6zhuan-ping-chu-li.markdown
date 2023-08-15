---
title: "iOS6转屏处理"
date: 2013-04-02
lastmod: 2013-04-02
categories:
  - "iOS"
tags:
  - "UI"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

以前的 iOS 程式 (4.0 版以前) 都是用 addSubview 来将 app 的 root view 加到 window 上面，例如下面的作法：

```objective-c
[self.window addSubview:self.viewController.view];
```

我发现在 iOS 6 上面，这个作法会使 rotation 失效 (iOS 6 以前完全没问题)，必须改成这个方式：

```objective-c
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
        self.window.rootViewController = self.viewController;
    } else {
        [self.window addSubview:self.viewController.view];
    }
```

iOS 4 之后才支持self.window.rootViewController = self.viewController;的方式。

另外，相关的ViewController中，如果支持转屏需要添加如下CODE：

```objective-c
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation != UIDeviceOrientationPortraitUpsideDown);
}

- (BOOL)shouldAutorotate {
	return YES;
}

```

说明：如果你想禁止转屏，可以返回NO

```objective-c
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
```
如果VIEW需要处理转屏，需要添加如下代码处理：

```objective-c
self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
```

view会自动调整宽和高
要么重写view的`- (void) layoutSubviews`方法，调整view，添加对应的处理。推荐前者方法，后者方法除非在转屏时会修改重新调整某些UI的精确位置时使用
