---
layout: post
title: "swift属性访问"
date: 2014-09-10 10:35
comments: true
categories: swift
---

`objective-c`中`property`方法支持`assign/readonly/retain/readwrite`等。
`swift`也支持类似这些属性。

<!--more-->
###一.swift属性方法

####1.readonly
```objective-c

var name:String{
    get{
        return self.name
    }
}

```   

####2.read/write with backing store
如果发生`EXC_BAD_ACCESS`参考[http://stackoverflow.com/questions/24025340/property-getters-and-setters](http://stackoverflow.com/questions/24025340/property-getters-and-setters)

```objective-c

//read/write Setters/Getters用来计算和获取属性，
//并没有给成员变量实例分配存储,所以，会触发EXC_BAD_ACCESS.
private var realAge:Int = 0;

var age:Int{
    get{
        return realAge
    }
    
    set{
        realAge = newValue
    }
}

``` 

####3.read/write  with backing store,信息隐藏，监控属性变化，附加额外处理
类似 
```objective-c 
 
 @property(nonatomic, retain)NSString address;

``` 
  实例变量自动为_address

```objective-c

private var _address :String = ""{
    willSet{

          println("old Value = \(_address) will clear,new value = \(newValue) will set")
        
        self._address = newValue;
    }
    didSet{
        //可以追回一些额外的处理逻辑
         println("Property did set")
    }
}

var address :String{
    get{
        return self._address;
    }
    set(newAddress){
        if newAddress != _address{
            self._address = newAddress
        }
    }
}

``` 

###二.完整示例

####1.QBaseClass overview

```objective-c

class QBaseClass{
    
    //read only
    var name:String{
        get{
            return self.name
        }
    }
    
    //read/write Setters/Getters用来计算和获取属性，
    //并没有给成员变量实例分配存储,所以，会触发EXC_BAD_ACCESS.
    private var realAge:Int = 0;
    
    var age:Int{
        get{
            return realAge
        }
        
        set{
            realAge = newValue
        }
    }
    
    //read/write  with backing store，
    //类似 @property(nonatomic, assign)NSInter number;变量自动为_number
    private var _number:UInt = 0;
    
    var number :UInt{
        get{
            return self._number;
        }
        set(newNumber){
            if newNumber != number{
                self._number = newNumber
            }
        }
    }
    
    //read/write  with backing store,信息隐藏，监控属性变化，附加额外处理
     //类似 @property(nonatomic, retain)NSString address;变量自动为_address
    private var _address :String = ""{
        willSet{
    
            println("old Value = \(_address) will clear,new value = \(newValue) will set")
            
            self._address = newValue;
        }
        didSet{
            //可以追回一些额外的处理逻辑
             println("Property did set")
        }
    }
    
    var address :String{
        get{
            return self._address;
        }
        set(newAddress){
            if newAddress != _address{
                self._address = newAddress
            }
        }
    }
    
    
    init(){
        self.age = 0;
    }
    
}

```

####2.调用
```objective-c
var baseClass:QBaseClass = QBaseClass()

//baseClass.name = "ksnowlv"//报错
baseClass.address = "北京海淀区"
baseClass.age = 20;
baseClass.number = 0917;
println("address =\(baseClass.address),age =\(baseClass.age),number =\(baseClass.number)")   

```

####3.日志输出

```objective-c

old Value =  will clear,new value = 北京海淀区 will set
Property did set
address =北京海淀区,age =20,number =917


```

###三.小结
 与`objective-c`中属性方法的不同之处：

* 1.生成属性方法实例的方式不同。
 
   >1.`objective-c`中属性方法会自动为属性方法生成实例变量，为实例变量分配内存。
   
   > 2.而`swift`中属性方法仅仅是设置属性和获取属性，实例变量需要手动分配。
   
* 2.属性方法使用便捷性不同。
    > `objective-c`的属性方法比较方便   
   
