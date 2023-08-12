---
title: "swift自动引用计数"
date: 2014-09-12
categories:
  - "swift"
tags:
  - "swift"
---
<!--more-->

### 一.swift中自动引用计数
<!--more-->
#### 1.概况
`Swift`使用自动引用计数(`ARC`)来跟踪并管理应用使用的内存。当实例不再被使用时，ARC会自动释放这些类的实例所占用的内存。

> 引用计数只应用在类的实例对象中。

> 结构体(`Structure`)和枚举类型是值传递类型的，并非引用类型，不是以引用的方式来存储和传递的


#### 2.`swift`中容易导致内存泄漏的两种场景
1.类实例间的强引用环

 解决办法
#### a.弱引用，`weak`关键字修饰
   弱引用不会增加实例变量的引用计数，因此不会阻止ARC销毁被引用的实例。
   
   这种特性使得引用不会变成强引用环。声明属性或者变量的时候，关键字weak表明引用为弱引用

>弱引用只能声明为变量类型，因为运行时它的值可能改变。弱引用绝对不能声明为常量

#### b.无主引用，`unowned`关键字修饰
  在属性、变量前添加unowned关键字，可以声明一个无主引用

  无主引用也不强持有实例。无主引用默认始终有值。
  
  无主引用只能定义为非可选类型（non-optional type），因为是非可选类型，因此当使用无主引用的时候，不需要展开，可以直接访问。不过非可选类型变量不能赋值为nil，因此当实例被销毁的时候，ARC无法将引用赋值为nil

> 当实例被销毁后，试图访问该实例的无主引用会触发运行时错误。使用无主引用时请确保引用始终指向一个未销毁的实例。 上面的非法操作会百分百让应用崩溃，不会发生无法预期的行为。 

#### c.解除对象的强引用
* 2.闭包产生的强引用环

`Swift`解除闭包和实例对象之间的强引用环的方法:闭包占用列表(closuer capture list)




### 二.示例
#### 1.代码
```objective-c

class QClassA {
    
    var _classB:QClassB?
    var _classBB:QClassB?
    var _classC:QClassC?
    
    init(){
        println("QClassA init")
    }
    
    deinit{
        println("QClassA deinit")
    }
}


class QClassB {
    
    var _classA:QClassA?
    //使用weak
    weak var _classAA:QClassA?

    
    init(){
        println("QClassB init")
    }
    
    init(classA: QClassA){
        println("QClassB init")
    }
    
    deinit{
        println("QClassB deinit")
    }
}

class QClassC {
    //使用无主引用
    unowned let  _classA:QClassA
    
    init(classA: QClassA){
        println("QClassC init")
        self._classA = classA
    }
    
    deinit{
        println("QClassC deinit")
    }
}

///实例和闭包
class QClassD {
    
    var _value:String?
    
    
    lazy var _funcBlockA:() -> Void = {
        //去掉下面[unowned self]，当调用_funcBlockA时，
        //会导致block和QClassD实例对象相互强引用
        [unowned self]  () -> Void in
        
        if self._value != nil {
            
            println(" ***_funcBlockA value =  \(self._value) ")
        }
        else{
           println(" ***_funcBlockA value =  \(self._value) ")
        }
    }
    
    init(){
        println("QClassD init")
    }
    
    deinit{
        println("QClassD deinit")
    }
}
```

#### 2.调用```objective-c

//解除对象的强引用 
var a:QClassA = QClassA()
var b:QClassB = QClassB()
a._classB = b
b._classA = a

a._classB = nil//或b._classA = nil

//weak
var aa:QClassA = QClassA()
var bb:QClassB = QClassB()
aa._classBB = bb
bb._classAA = aa

//无主引用
var aaa:QClassA = QClassA()
var ccc:QClassC = QClassC(classA: aaa)
aa._classC = ccc

//解除闭包和实例之间的强引用
var d:QClassD = QClassD()
d._funcBlockA()

```

#### 3.日志
```objective-c

QClassA init
QClassB init
QClassA init
QClassB init
QClassA init
QClassC init
QClassD init
 ***_funcBlockA value =  nil 
QClassD deinit
QClassA deinit
QClassA deinit
QClassB deinit
QClassC deinit
QClassB deinit
QClassA deinit

```


### 三.小结`swift`与`objective-c`

* 1.都是通过引用计数来管理内存的。
* 2.都存在循环引用导致的内存泄漏，需要注意发生这种内存泄漏的场景。
* 3.闭包都存在强引用环，需要打破引用环。
