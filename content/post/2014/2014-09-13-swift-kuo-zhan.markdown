---
title: "Swift扩展"
date: 2014-09-13
lastmod: 2014-09-13
categories:
  - "swift"
tags:
  - "swift"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

### 一.Swift中扩展
语法格式，使用`extension`关键字修饰

#### 1.普通扩展  `extension` 扩展名{
  }
  
#### 2.对协议扩展  `extension` 扩展名: 协议1，协议2 {
}

#### 3.对类扩展  `extension` 扩展名: 类 {
}

#### 4.为扩展添加变量，使用运行时设置关联对象的方式。

* 1.声明运行时关联对象的key

```swift

// 设置关联对象的key的定义
var KUIViewExtraPropertySelector:Selector = 

``` 

* 2.获取关联属性

```swift
    
// 获取关联属性的对象
func getExtraPropertyFromObject(object: AnyObject) -> AnyObject? { // Returns optional
return objc_getAssociatedObject(object, &KUIViewExtraPropertySelector)
}
    
```

* 3.设置关联属性的对象,retain该属性的对象

```swift

//设置关联属性的对象,retain该属性的对象
func setExtraProperty(property: AnyObject, object: AnyObject) {
objc_setAssociatedObject(object, &KUIViewExtraPropertySelector, property, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
}

```

### 二.示例
#### 1.代码
``` swift

//设置关联对象的key的定义
var KUIViewExtraPropertySelector:Selector = "UIViewExtraPropertySelector"

extension UIView {
    
    func showBackgroundColor(color:UIColor){
        self.backgroundColor = color
        println("backgroundColor:\(color.description)")
    }
    
    
    // 获取关联属性的对象
    func getExtraPropertyFromObject(object: AnyObject) -> AnyObject? { // Returns optional
        return objc_getAssociatedObject(object, &KUIViewExtraPropertySelector)
    }
    
    //设置关联属性的对象,retain该属性的对象
    func setExtraProperty(property: AnyObject, object: AnyObject) {
        objc_setAssociatedObject(object, &KUIViewExtraPropertySelector, property, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    }
}

``` 

#### 2.调用
```swift
self.view.showBackgroundColor(UIColor.redColor())


var button:UIButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton

var  buttonRect:CGRect = button.bounds
buttonRect.origin.x = (CGRectGetWidth(self.view.frame) - CGRectGetWidth(buttonRect))/2
buttonRect.origin.y = 50

button.frame = buttonRect
self.view.addSubview(button)


button.setExtraProperty("string", object: "ksnowlv")
var viewObject: AnyObject = button.getExtraPropertyFromObject("ksnowlv")!

if viewObject is  String{
    println("object is String")
}
else{
    println("object is not String")
}

var list:Array<String> = ["kair","ksnowlv","snow","air","rain"];


button.setExtraProperty(list, object: "ksnowlv")
var listObject:AnyObject = button.getExtraPropertyFromObject("ksnowlv")!

if listObject is Array<String>{
     println("object is [Array<String>] \(listObject.description)")
}
else{
    println("object is not [Array<String>]")
}

```

#### 3.日志
``` objective-c
backgroundColor:UIDeviceRGBColorSpace 1 0 0 1
object is String
object is [Array<String>] (
    kair,
    ksnowlv,
    snow,
    air,
    rain
)


```

### 三.小结
 大体上使用方法与原`objective-c`类似
