---
layout: post
title: "swift类属性/方法"
date: 2014-09-09 11:22
comments: true
categories: swift
---

swift类的属性**setter/getter**，普通方法，类方法/变量，访问权限等。

####1.setter/getter方法

``` objective-c
 
 var 变量名:变量类型{
     get{
        return self.变量名;
     }
        
     set{
        self.变量名 = newValue;
     }
}

```

####2.类方法和变量
使用`class`修饰的方法或变量

`类变量`

``` objective-c

class var 变量名: 类型 {
  get{
     return  类名.变量名;
  }
}

```

`类方法`

``` objective-c
class func 方法名->参数{
  return 类名.类变量;
}

```

####3.常方法。使用final修饰的方法
 `final` func 方法名
 
####4.访问权限

>  * 类/方法/变量可以由关键字**public**/**internal**/**private**.
>  * 系统默认为`internal`,`private`可用于隐藏一些实现细节。
    
`public` 公有
   
    标记为public的代码块一般用来建立API，这是最开放的权限，使得任何人只要导入这个模块，都可以访问使用。
    
`internal` 内部

    标记为internal的代码块，在整个应用（App bundle）或者框架（framework）的范围内都是可以访问的。

`private` 私有

    在哪里写的，就在哪里用。无论是类、变量、常量还是函数，一旦被标记为私有的，就只能在定义他们的源文件里使用，不能为别的文件所用。




 
  
####5.willSet/didSet   
这两个属性用来监视属性的除初始化之外的属性值变化情况。

示例代码如下。

``` objective-c

class QPerson{

    ///类的全局变量
    class var sharedPersonNumber: UInt {
        // 这里返回一个 UInt 值
        get{
            return  QPerson.sharedPersonNumber;
        }
        
        set{
            QPerson.sharedPersonNumber = newValue;
        }
    }
    
    /**
    类方法
    :returns: 返回人员类的人数
    */
    final class func countPerson()->UInt{
        return QPerson.sharedPersonNumber;
    }
    
    /// 普通成员变量
    var _address:String;
    var _phoneNumber:String;
    
    /// setter/getter
    var name:String{
        get{
            return self.name;
        }
        
        set{
            self.name = newValue;
        }
    }

    
    /// setter/getter
    private var _number:String{
        get{
            return self._number;
        }
        
        set(number){
            self._number = number;
        }
    }
    
    var age: Int {
        willSet(age) {
            NSLog("old age = \(self.age),new age = \(age)")
        }
        didSet(age) {
            NSLog("new age = \(self.age)")
        }
    }

    init(name:String, number:String, address:NSString, phoneNumber:NSString){
        self.age = 0;
        self._address = address;
        self._phoneNumber = phoneNumber;
    }
    
    deinit{
        
    }
}

```