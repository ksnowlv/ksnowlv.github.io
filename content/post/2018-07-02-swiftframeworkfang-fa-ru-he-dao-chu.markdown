---
title: "swiftframework方法如何导出"
date: 2018-07-02
categories:
  - "swift"
tags:
  - "swift"
---
<!--more-->

swift framework中的方法如何在objective-c中调用呢？

#### 类或属性加@objc public
[stackoverflow的解答](https://stackoverflow.com/questions/31099596/importing-swift-framework-into-a-objective-c-project)

To access a swift class in objc, that is not inherited from NSObject you need to:
@objc public class VeediUtils

A Swift class or protocol must be marked with the @objc attribute to be accessible and usable in Objective-C. This attribute tells the compiler that this piece of Swift code can be accessed from Objective-C. If your Swift class is a descendant of an Objective-C class, the compiler automatically adds the @objc attribute for you.

[https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html)

示例如下：

```objective-c

@objc public class YKFile: NSObject {
    
    @objc public var fileName : String?
    
    @objc public var myData : Data?
    
    @objc public func myFilePath() -> String {
        return "ksnowlv"
    }
    
    @objc public static func name() -> String {
        return "ksnowlv"
    }
}

```