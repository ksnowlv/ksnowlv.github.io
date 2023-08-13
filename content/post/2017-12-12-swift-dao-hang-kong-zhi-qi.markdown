---
title: "swift-导航控制器"
date: 2017-12-12
lastmod: 2017-12-12
categories:
  - "swift"
tags:
  - "swift"
comment: true
toc: false
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---


导航控制器作为iOS工程常用的容器类，在定制的时候，
需要考虑几个关键点。


#### 1.状态栏风格。#### 2.导航栏。#### 3. 右侧滑关闭手势与页面UITableView滑动手势冲突。#### 4. push/present/pop动画，某些场景下需要需要禁止。#### 5.与UITabBarController配合使用。
```objective-c
    if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
``` 

源代码见[demo](https://github.com/ksnowlv/KNavigationViewControllerTest.git)