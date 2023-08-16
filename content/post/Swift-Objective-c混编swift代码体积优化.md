---
title: "Swift Objective C混编swift代码体积优化"
date: 2021-04-14T19:46:06+08:00
lastmod: 2021-04-14T19:46:06+08:00
keywords: ["swift", "iOS", "代码体积", "优化"]
tags: ["swift", "iOS", "优化"]
categories: ["swift", "iOS", "优化"]

comment: true
toc: true
autoCollapseToc: true
reward: true


---

## 一.swift与Objective-c混编下减小包大小

在Swift&Objective-c混编优化下，如何进一步减小代码体积大小？

<!--more-->

## 二.解决方案

### 1.取消整个类导出Objective-c方法

例如：类只在swift模块调用的情况

```swift
@objc class STXXXXXBuilder: NSObject {
}
```
调整为
```swift
class STXXXXXBuilder{
}
  ```

### 2.取消类中非公有方法或扩展导出


```swift

/// XXXX页面
class STXXXXController: STBaseTableViewController

}
extension STXXXXController {

}

```

调整为

```swift

fileprivate extension STXXXXController {

}

```

### 3.取消类中部分swift方法导出Objective-c方法

例如：像UI控件，列表之类

```objective-c

SWIFT_CLASS("_TtC24SogouTranslatorDeveloper19STBaseTableViewCell")
@interface STBaseTableViewCell : UITableViewCell
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end

```

若STBaseTableViewCell的基类不想导出
initWithCoder和initWithStyle方法，减小文件大小，可禁止这两个方法的oc方法导出，如下所示

```swift

class STXXXXCell: STBaseTableViewCell {
    
    @IBOutlet var buttons: [STXXXXButton]!
    
    @nonobjc override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @nonobjc required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

```

## 三.优化效果

![image](/images/post/Swift-Objective-c混编swift代码体积优化/result.png)

## 四.其它
可以想下swift类中IBOutlet/IBAction为什么是导出objective-c方法的？


