---
title: "IB_DESIGNABLE与IBInspectable的使用"
date: 2017-11-27
lastmod: 2017-11-27
categories:
  - "iOS"
tags:
  - "UI"
comment: true
toc: false
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---


iOS开发中经常会用到一些自定义UI控件，控件的效果和属性可以通过**IB_DESIGNABLE**和**IBInspectable**预览和修改。


#### IB_DESIGNABLE自定义 UIView 可以在 XIB 中预览,，查看自定义控件的效果。

#### IBInspectable自定义 UIView 的属性出现在 XIB 中 Attributes inspector，可以通过修改属性，在XIB中查看效果 。

示例如下：

```objective-c

IB_DESIGNABLE//在 XIB 中预览控件
@interface YKNavigationBar : UIView
@property (nonatomic, strong) IBInspectable NSString *barTitle;
@property (nonatomic, assign) IBInspectable double titleFontSize;
@property (nonatomic, strong) IBInspectable UIColor *titleShadowColor;
@property (nonatomic, strong) IBInspectable UIColor *titleColor;
```
<!--![image](/images/post/2017-11-27-ib-designableyu-ibinspectablede-shi-yong/property-setting.png) -->

![image](/images/post/2017-11-27-ib-designableyu-ibinspectablede-shi-yong/xib-overview.png) 
