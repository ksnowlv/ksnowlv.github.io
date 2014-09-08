---
layout: post
title: "Swift的类-结构-协议-枚举"
date: 2014-09-08 15:38
comments: true
categories: swift
---

现在主要体验swift类(创建，销毁，继承/派生)，结构体，协议，枚举等方面的使用.


####1.结构体和常量定义。
结构体定义其实与c/c++大体类似。示例如下:

``` objective-c
let QMapPointZero:QMapPoint = QMapPoint(x:0,y:0);
let QMapSizeZero:QMapSize = QMapSize(width:0,height:0);

struct QMapPoint{
    var x:Int = 0;
    var y:Int = 0;
}

struct QMapSize{
    var width:Int = 0;
    var height:Int = 0;
}

```

####2.枚举定义(和c/c++中差别比较大)。

 `swift`中，像类和其它类型命名类似，枚举可以拥有和它关联的方法。
 
``` objective-c
 
enum QMapType:Int{
    case QMapTypeNone
    case QMapTypeNoraml
    case QMapTypeStreetView
    case QMapTypeTraffic
    
    func getMapType() ->Int{
        
        switch self{
        case .QMapTypeNone:
            return 0;
        case .QMapTypeNoraml:
            return 1;
            
        case .QMapTypeStreetView:
            return 2;
            
        case .QMapTypeTraffic:
            return 3;
            
        default:
            return -1;
        }
    }
}

```

如果访问这些枚举变量，需要通过枚举名来访问。以上为例就是通过`QMapType.QMapTypeNoraml`访问，如果要访问枚举变量的值，可通过`getMapType`访问。

####3.关于协议/接口。
与objetive-c类似，不支持多继承，同样需要通过`protocol`声明定义，同样，分为必选协议和可选协议。但是，swift中的协议可以有成员变量。

必选协议的声明

``` objective-c

protocol ShapeInterface{
    
    //成员变量
    var className: String { get }
    //协议默认属性为required
    func draw();
    func description() -> String
}

```

可选协议声明

``` objective-c

@objc protocol QMapViewInterface{
    
    //成员变量
    var className: String { get }
    func mapView(mapType:Int);
    //协议默认属性为required
    optional func draw();
}

``` 

####4.类的声明，定义，继承，派生等。
与**c++**/**objective-c**类似，支持面向对象，有构造初始化，有析构，支持继承/派生。

我们声明shape类，继承`ShapeInterface`协议。

``` objective-c

class Shape:ShapeInterface{
    
    var className: String = "Shape"
    
    var name:NSString;
    
    //可以看作初始化函数
    init(name:String){
        self.name = name;
    }
    
    //可以看作析构函数
    deinit{
        print("Shape deinit");
    }
    
    func draw(){
        print("shape name = \(name)\n");
    }
    
    func description() -> String {
        return name;
    }
    
    func area() ->Double {
        return 0;
    }
    
    func circumference() ->Double{
        
        return 0;
    }
}

```

###5.示例:地图类和图形类
####地图类相关

``` objective-c

/// 地图坐标相关数据结构和常量定义
let QMapPointZero:QMapPoint = QMapPoint(x:0,y:0);
let QMapSizeZero:QMapSize = QMapSize(width:0,height:0);


struct QMapPoint{
    var x:Int = 0;
    var y:Int = 0;
}



struct QMapSize{
    var width:Int = 0;
    var height:Int = 0;
}

struct QMapRect{
    var point:QMapPoint = QMapPointZero;
    var size:QMapSize = QMapSizeZero;
}

/**
地图支持底图类型

- QMapTypeNone:       初始化类型，无意义
- QMapTypeNoraml:     普通地图
- QMapTypeStreetView: 街景地图
- QMapTypeTraffic:    实时路况地图
*/
enum QMapType:Int{
    case QMapTypeNone
    case QMapTypeNoraml
    case QMapTypeStreetView
    case QMapTypeTraffic
    
    func getMapType() ->Int{
        
        switch self{
        case .QMapTypeNone:
            return 0;
        case .QMapTypeNoraml:
            return 1;
            
        case .QMapTypeStreetView:
            return 2;
            
        case .QMapTypeTraffic:
            return 3;
            
        default:
            return -1;
        }
    }
}

/**
*  地图View,支持地图显示，拖拽等
*/
class QMapView{
    var mapType:QMapType = QMapType.QMapTypeNone;
    var mapRect:QMapRect;
    
    init(mapType:QMapType){
        self.mapType = mapType;
        self.mapRect = QMapRect()
    }
    
    func setMapRect(mapRect:QMapRect){
        self.mapRect = mapRect;
    }
    
    func getMapRect() -> QMapRect{
        return mapRect
    }
    
    deinit{
        print("QMapView deinit\n")
    }
    
    func draw(){
        print("mapType = \(mapType.getMapType()) drawing\n");
    }
}


/**
*  地图协议，支持可选协议
*/
@objc protocol QMapViewInterface{
    
    //成员变量
    var className: String { get }
    func mapView(mapType:Int);
    //协议默认属性为required
    optional func draw();
}

```

调用：

``` objective-c

var mapView:QMapView = QMapView(mapType:QMapType.QMapTypeNoraml);      
var mapSize =  QMapSize(width: Int(self.view.frame.width), height:Int(self.view.frame.height));
mapView.setMapRect(QMapRect(point: QMapPointZero, size: mapSize));
mapView.draw();
print("mapView rect = {point = {\(mapView.mapRect.point.x),\(mapView.mapRect.point.y)},size = {\(mapView.mapRect.size.width),\(mapView.mapRect.size.height)}}\n");
        
``` 

日志输出：

``` objective-c
mapType = 1 drawing
mapView rect = {point = {0,0},size = {320,480}}
QMapView deinit
``` 

####图形类(Shape类族)相关

Shape类族
![image](/images/post/2014-09-08-swift-de-lei-jie-gou-xie-yi-mei-ju/shape_class.jpg)


``` objective-c

/**
*  图形接口
*/
protocol ShapeInterface{
    
    //成员变量
    var className: String { get }
    //协议默认属性为required
    func draw();
    func description() -> String
}


/**
*  图形基类
*/
class Shape:ShapeInterface{
    
    var className: String = "Shape"
    
    var name:NSString;
    
    //可以看作初始化函数
    init(name:String){
        self.name = name;
    }
    
    //可以看作析构函数
    deinit{
        print("Shape deinit\n");
    }
    
    func draw(){
        print("shape name = \(name)\n");
    }
    
    func description() -> String {
        return name;
    }
    
    func area() ->Double {
        return 0;
    }
    
    func circumference() ->Double{
        
        return 0;
    }
}


let KPI:Double = 3.14159265;
/**
*  圆类
*/
class Circle :Shape{
    var center:Point;
    var radius:Double;
    
    init(name:String, center:Point, radius:Double){
        
        self.center = center;
        self.radius = radius;
        super.init(name:name);
        super.className = "Circle";
    }
    
    deinit{
        print("Circle deinit\n");
    }
    
    override func description() -> String {
        return name;
    }
    
    override func area() ->Double{
        return 3.14159265 * sqrt(self.radius);
    }
    
    override func circumference() ->Double{
        
        return KPI * 2 * radius;
    }
}

/**
*  正方形类
*/
class Square: Shape{
    var _size:Double!;//加!后，可以不用添加self._size方法在init方法super.init之前
    
    init(name:String, size:Double){
        
        super.init(name: name);
        super.className = "Square";
        _size = size;
    }
    
    deinit{
        print("Square deinit\n");
    }
    
    override func area() -> Double {
        return sqrt(_size);
    }
    
    override func circumference() -> Double {
        return 4 * _size;
    }
}

``` 

调用

``` objective-c
var shape:Shape = Shape(name: "Shape");
shape.draw();
print("className = \(shape.className) shape:{description = \(shape.description()), area = \(shape.area()), circumference = \(shape.circumference())}\n");
        
var circle:Circle = Circle(name: "Circle", center: Point(v: 10, h: 20), radius: 10.5);
circle.draw();
print("className = \(circle.className) circle:{description = \(circle.description()), area = \(circle.area()), circumference = \(circle.circumference())}\n");
        
var square:Square = Square(name: "Square", size:4);
square.draw();
print("className = \(square.className) square:{description = \(square.description()), area = \(square.area()), circumference = \(square.circumference())}\n");

``` 
日志输出

``` objective-c

shape name = Shape
className = Shape shape:{description = Shape, area = 0.0, circumference = 0.0}
shape name = Circle
className = Circle circle:{description = Circle, area = 10.179923672337, circumference = 65.97344565}
shape name = Square
className = Square square:{description = Square, area = 2.0, circumference = 16.0}
Square deinit
Shape deinit
Circle deinit
Shape deinit
Shape deinit

``` 
小结:
    
    1.派生类的初始化顺序，先初始化基类，再初始化自身；析构顺序和初始化顺序相反，
    2.对象的创建顺序和析构顺序是相反的。
    3.如果派生类在类的外部调用基类的同名函数，如何调用呢？

参考链接：[http://stackoverflow.com/questions/24021093/error-in-swift-class-property-not-initialized-at-super-init-call/24150540#24150540](http://stackoverflow.com/questions/24021093/error-in-swift-class-property-not-initialized-at-super-init-call/24150540#24150540)