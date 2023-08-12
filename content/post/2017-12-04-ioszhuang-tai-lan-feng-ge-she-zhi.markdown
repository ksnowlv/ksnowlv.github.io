---
title: "iOS状态栏风格设置"
date: 2017-12-04
categories:
  - "iOS-UI"
tags:
  - "iOS-UI"
---
<!--more-->



iOS 的状态栏风格如何更改呢？iOS9及之前使用*UIApplication* 的*setStatusBarStyle*修改状态栏风格。遗憾的9之后，成为过时API。如何解决呢？

<!--more-->
 
 * 通过重写*UIViewController*的*prefersStatusBarHidden*与*preferredStatusBarStyle*控制各种页面状态栏风格
 * plist配置文件中*UIViewControllerBasedStatusBarAppearance*属性设置为YES。

分几种情况。

#### 1.根控制器为普通的页面控制器UIViewController
```objective-c

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

```

  
#### 2.如果根控制器为导航控制器UINavigationController或UITabBarController
状态栏的风格会交由导航控制器管理，你只需要在容器 controller 中修改属性即可。

```objective-c

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

```

#### 3.同一页面UIViewController不同状态下的切换。
* 添加一成员变量。
例如：

```objective-c
  @property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
  
```
  
* 重写preferredStatusBarStyle方法。
  
```objective-c
  - (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

```

* 切换状态栏风格。

```objective-c
 self.statusBarStyle = UIStatusBarStyleLightContent;
 [self setNeedsStatusBarAppearanceUpdate];
```

#### 4.容器套容器。
通过重写*childViewControllerForStatusBarStyle*实现。指定是使用容器的状态栏风格或子页面的状态栏风格。

##小结
#### 1.修改状态栏风格需要考虑好页面层级的管理。#### 2.能复用窗口风格的尽量不要在子页面管理器中定义。



