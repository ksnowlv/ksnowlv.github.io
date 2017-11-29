---
layout: post
title: "Swift基础初探"
date: 2014-09-07 21:25
comments: true
categories: swift
---

现在主要体验Swift基础语法，基本数据类型，集合类，控制逻辑(if-else,switch,for循环)等。

<!--more-->
示例及注释

``` objective-c

func baseTest(){

    //:后面表示类型，也可以不加。
    var name:String = "ksnow"
    //常量声明
    let KAge:UInt = 100;

    //Swift在字符串中插入变量名作为占位符，使用\()来提示Swift替换变量/常量名为其实际的值
    println("name =\(name),age = \(KAge)");

    //边界
    println("UInt8 min =\(UInt8.min),UInt8 max =\(UInt8.max),UInt min =\(UInt.min) UInt max =\(UInt.max)");

    //进制转换
    let KNum = 17//不带前缀，默认十进制。
    let KNumBinaryInteger = 0b10001 // 用前缀0b，表示二进制
    let KNumOctalInteger = 0o21 // 用0o前缀，表示八进制
    let KNumhexadecimalInteger = 0x11 // 以0x前缀 ,表示16进制。

    println("17的十进制:\(KNum),二进制:\(KNumBinaryInteger),八进制:\(KNumOctalInteger),十六进制:\(KNumhexadecimalInteger)");

    //强制类型转换
    let height = 3.24;
    let weigth = 4;
    //
    var totalNum = Double(weigth) + height;
    var totalValue =  weigth + Int(height);
    println("totalNum = \(totalNum),totalValue =\(totalValue) ");

    //bool
    var isHidden:Bool = true;
    var isShow:Bool = false;
    println("isHidden = \(isHidden),isShow = \(isShow)");

    //类型别名。
    typealias QInt8 = Int8;
    typealias QString = String;

    var value:QInt8 = 5;
    var key:QString = "ksnowlv";
    //集合类：数组和字典

    var fruitList = ["apple", "pear", "banana", "orange"]
    fruitList .append("tomato");

    println("fruitList = \(fruitList)");

    println("value = \(value),key = \(key)");

    var array =  Array<Int>();

    for i in 0...10{
        array.append(i);
    }

    println("array = \(array)");

    var count = 0;
    for num in array{
        count += num;
    }

    println("1...10 sum = \(count)");

    var personAddress:Dictionary = [
        "ksnow": "河南",
        "kair": "山东",
        "abc": "浙江",
    ]

    personAddress["snow"] = "北京";

    println("personAddress = \(personAddress)");
    personAddress["abc"] = nil;
    println("personAddress = \(personAddress)");

    var shoppingDic = ["milk":10,"apple":12,"meat":25,"water":3];

    for (name,price) in shoppingDic
    {
        println("shopping list:name = \(price)");
    }

    let http200Status = (statusCode: 200, description: "OK")
    println("The status code is \(http200Status.statusCode),description = \(http200Status.description)")

    //控制结构
    //if
    self.testIf(1);

    //switch
    var i = 0
    switch i {
    case 0:
        "0" //被输出
        fallthrough
    case 1:
        "1" //被输出
    case 2:
        "2"
    default:
        "default"
    }

    i = 15
    switch i {
    case 0 ... 10:
        "0~10"
    case 11 ... 20:
        "11~20" //被输出
    default:
        "default"
    }


    //while
    var sum = 0;

    i = 0;

    while i < 50{
        sum += i;
        ++i;
    }

    println("while:1 ... 50 sum = \(sum)");

    //do while
    i = 0;
    sum = 0;

    do{
        sum += i;
        ++i;
    }while(i < 50)

    println("do while:1 ... 50 sum = \(sum)");
}

func testIf(type:Int)
{
    if type == 1{
        println("type = 1,我出去了");
    }
        
    else if type == 2{
        println("type = 2,我回来了");
    }
    else {
        println("type 不是1，不是2，我在家里呢");
    }
}

```

日志输出：

``` objective-c

name =ksnow,age = 100
UInt8 min =0,UInt8 max =255,UInt min =0 UInt max =18446744073709551615
17的十进制:17,二进制:17,八进制:17,十六进制:17
totalNum = 7.24,totalValue =7 
isHidden = true,isShow = false
fruitList = [apple, pear, banana, orange, tomato]
value = 5,key = ksnowlv
array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
1...10 sum = 55
personAddress = [abc: 浙江, kair: 山东, snow: 北京, ksnow: 河南]
personAddress = [kair: 山东, snow: 北京, ksnow: 河南]
shopping list:name = 10
shopping list:name = 3
shopping list:name = 25
shopping list:name = 12
The status code is 200,description = OK
type = 1,我出去了
while:1 ... 50 sum = 1225
do while:1 ... 50 sum = 1225

```
