---
title: "swift闭包"
date: 2014-09-11
categories:
  - "swift"
tags:
  - "swift"
---
<!--more-->

### 一.swift中闭包
<!--more-->
swift中的闭包格式

```objective-c

{ (parameters) -> return type in
    statements
}

```

#### 1. swift block, without any arguments and without return value
```objective-c
 typealias funcBlockA = () -> ()
 typealias funcBlockAA = () -> Void
 
var _funcBlockA:funcBlockA = {
    
    () -> Void in
    
    println("***block without any arguments and without return value")
}   
```

#### 2.swift block with arguments and  return value
```objective-c
var _funcBlockB:funcBlockB = {
    (stringA:String, stringB:String) ->String in
    
    println("***swift block with arguments and without any return value")
    
    return (stringA + stringB)
}  

``` 

#### 3.swift block with arguments and  return value as function
```objective-c

var _funcBlockC:funcBlockC = {
    
    (stringA:String, stringB:String) ->(String)->() in
    
    blockC("***wift block with arguments and  return value:\(stringA) and \(stringB)")
    return blockC
}

```

#### 4.swift block as function parameter and  return value as function with parameter and return value
```objective-c

var _funcBlockD:funcBlockD = {
    (stringA:String, stringB:String) ->(String)->(String) in
    
    blockD("***swift block as function parameter:\(stringA) and \(stringB)")
    return blockD
}

```


### 二.示例
#### 1.示例代码
```objective-c

func blockC(name:String)  {
    
    println(" blockC= (\(name))")
}

func blockD(name:String)->String  {
    var result:String = "blockD = " + name
    
    println(result)
    
    return result;
}

class QBlock{
    
    //swift block, without any arguments and without return value
    typealias funcBlockA = () -> ()
    typealias funcBlockAA = () -> Void
    //swift block with arguments and return value
    typealias funcBlockB = (String, String) -> String
    //swift block with arguments and  return value as function
    typealias funcBlockC = (String, String) -> (String)->()
    //swift block as function parameter and  return value as function with parameter and return value
    typealias funcBlockD = (String, String) -> (String)->String
    
    var _funcBlockA:funcBlockA = {
        
        () -> Void in
        
        println("***block without any arguments and without return value")
    }
    
    var _funcBlockB:funcBlockB = {
        (stringA:String, stringB:String) ->String in
        
        println("***swift block with arguments and without any return value")
        
        return (stringA + stringB)
    }
    
    var _funcBlockC:funcBlockC = {
        
        (stringA:String, stringB:String) ->(String)->() in
        
        blockC("***wift block with arguments and  return value:\(stringA) and \(stringB)")
        return blockC
    }
    
    var _funcBlockD:funcBlockD = {
        (stringA:String, stringB:String) ->(String)->(String) in
        
        blockD("***swift block as function parameter:\(stringA) and \(stringB)")
        return blockD
    }
    
    
    init(){
        self.testMemberBlock()
    }
    
   private func testMemberBlock(){
        
        ///1. swift block, without any arguments and without return value
        self._funcBlockA()
        //swift block with arguments and without any return value
        var res =  self._funcBlockB("ksnowlv", "kair")
        println("_funcBlockB = result = \(res)")
        
        
        // //swift block with arguments and  return value as function
        var blockC  = self._funcBlockC("ksnowlv", "kair")
        blockC("go shopping")
        
        //swift block as function parameter and  return value as function with parameter and return value
        var blockD  = self._funcBlockD("ksnowlv", "kair")
        var result =  blockD("go shopping")
        println("result blockD = \(result)")
    }
}

```

#### 2.调用```objective-c

var block = QBlock()

```objective-c

#### 3.日志
```objective-c

***block without any arguments and without return value
***swift block with arguments and without any return value
_funcBlockB = result = ksnowlvkair
 blockC= (***wift block with arguments and  return value:ksnowlv and kair)
 blockC= (go shopping)
blockD = ***swift block as function parameter:ksnowlv and kair
blockD = go shopping
result blockD = blockD = go shopping

```

### 三.小结* 1.与objective-c中的闭包在使用方法上类似，大体上相同，语法格式上的差异。
* 2.在内存管理方面:objective-c中需要注意循环引用导致的内存泄漏。而swift依然需要注意该问题。

