---
layout: post
title: "swift协议"
date: 2014-09-10 20:12
comments: true
categories: swift
---
###一.swift协议格式

```objective-c

protocol 协议名 {
    // protocol 
}

```

####1.协议支持属性
> * 要求声明为变量属性，用var关键字做前缀。
> * 支持setter/getter
> 
其格式

```objective-c
protocol 协议名 {
    var 属性名: 类型 { get set }
}


```

####2.协议支持方法(普通方法/类方法)
与类的普通方法和类方法声明语法相同，只是不用添加实现体。

    协议是不允许给方法参数指定默认值。
####3.协议支持Mutating方法   

   对值类型实例方法（即结构和枚举），你将可以将mutating关键字放在方法func关键字之前，表明该方法允许修改所属实例和/或实例的任何属性。
   
>1.如果你标记一个协议实例方法为mutating， 当为一个类写此方法的实现时，你不需要写mutating关键字。

>2.mutating关键字只用于结构和枚举。

####4.协议可以组合，但是不会产生新协议
格式
```objective-c
protocol<协议1, 协议2，...,协议n>
 
```  

####5.协议支持required/optional
如果协议是optional协议

> 1.协议接口存在与否的判断

> 2.声明与必选协议的不同之处。可选协议需要@objc


###二.参考示例。

####1.完整示例

```objective-c

protocol QBaseClassProtocol{
    
    var className:String{get}
}

@objc protocol QOutActionProtocol{
    optional func gotoPark() ->Bool
    optional var goShopping:Bool{get}
}


class QBaseClass :QBaseClassProtocol, QOutActionProtocol{
    
    
    private var _className:String = "QBaseClass"
    
    init(){
        
    }
    
    //from QBaseClassProtocol
    var className:String{
        get{
            
            return _className;
        }
    }
    
    //from QOutActionProtocol
    func gotoPark() -> Bool {
        
        return true
    }
    
    func test(){
        
        println("className = \(_className)")
        
        var gotoPark:Bool  = self.gotoPark()
        
        if gotoPark{
            println("I can go to park")
        }
        else{
            println("I can't go to park")
        }
        /// 'QBaseClass' does not have a member named 'goShopping'
        //self.goShopping()
    }
}
 
```

####2.调用

```objective-c
var baseClass =  QBaseClass()
baseClass.test();
 
```  

####3.日志

```objective-c
className = QBaseClass
I can go to park

```
###三.小结

`swift`中协议大体与`objective-c `协议相同。主要区别点

* 1. `swift`支持属性，`objective-c`而不支持。  
    