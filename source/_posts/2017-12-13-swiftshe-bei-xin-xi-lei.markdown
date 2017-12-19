---
layout: post
title: "swift-设备信息类"
date: 2017-12-13 16:02
comments: true
categories: swift-基础框架
---

设备信息类是iOS开发框架中必备工具类，通常包含哪些属性呢？
<!--more-->

* UUID
* 广告标识idfa
* 机型
* 屏幕尺寸
* 屏幕类型。
* UI放大比例：做多屏幕适配，此处使用的是6PLUS作为基准。
* UI横向的放大比例：屏幕适配时使用，通常用于图片。
* 1像素线条比例

```objective-c
    public static func deviceUUID() ->String{
        return sharedDevice.uuid
    }
    
    public static func deviceModel() ->String {
        return sharedDevice.model()
    }
    
    public static func deviceName() ->String {
        return  UIDevice.current.name
    }
    
    public static func systemVersion() ->String {
        return UIDevice.current.systemName
    }
    
    public static func idfaString() ->String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    public static func screenSize() ->CGSize {
        return sharedDevice.deviceScreenSize
    }
    
    public static func screenSizeType() ->KDeviceScreenSizeType {
        return sharedDevice.deviceScreenSizeType
    }
    
    public static func appUIScale() ->CGFloat {
        return sharedDevice.uiScale
    }
    
    public static func appUIScaleForWidth() -> CGFloat {
        return sharedDevice.uiScaleForWidth
    }
    
    public static func appUIScaleForSinglePixel()->CGFloat {
        return sharedDevice.uiScaleForSinglePixel
    }
    
```

源代码见[demo](https://github.com/ksnowlv/KDeviceTest)

注：没有考虑横竖屏切换时的情况。