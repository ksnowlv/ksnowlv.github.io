---
title: "XML解析之TinyXML"
date: 2013-04-17
lastmod: 2013-04-17
categories:
  - "iOS"
tags:
  - "iOS"
  - "XML"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

## iPhone TinyXML

TinyXML是一个开源的解析XML的解析库(下载地址:[http://sourceforge.net/projects/tinyxml/?source=dlp](http://sourceforge.net/projects/tinyxml/?source=dlp))，能够用于C++支持的平台，像windows，linux，iOS平台。这个解析库的模型通过解析XML文件，然后在内存中生成DOM模型，从而让我们很方便的遍历这棵XML树。
        
   DOM模型即文档对象模型，是将整个文档分成多个元素（如书、章、节、段等），并利用树型结构表示这些元素之间的顺序关系以及嵌套包含关系。
   
### 1.类的简介

* TiXmlBase：整个TinyXML模型的基类。
* TiXmlAttribute：对应于XML中的元素的属性。
* TiXmlNode：对应于DOM结构中的节点。
* TiXmlComment：对应于XML中的注释
* TiXmlDeclaration：对应于XML中的申明部分，即<？versiong="1.0" ?>。
* TiXmlDocument：对应于XML的整个文档。
* TiXmlElement：对应于XML的元素。
* TiXmlText：对应于XML的文字部分
* TiXmlUnknown：对应于XML的未知部分。 
* TiXmlHandler：定义了针对XML的一些操作。

下面显示XML的解析和生成

首先，引入这几个文件，如果编译有错，修改下编译器的设置。如果该库引入静态库，给第三方使用。

建议类，全局的常量，函数，重命名下，以避免可能的冲突。

### 2.代码示例
#### 1.头文件

```objective-c
//  ViewController.h
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(nonatomic,retain) NSString* xmlData;

/**XML的解析**/
- (void)xmlParse;
/**XML的生成**/
- (void)buildParse;

@end
```
#### 2.实现文件。
```objective-c
//
//  ViewController.mm
//  XMLTest_TinyXML
//
//  Created by lv wei on 13-4-17.
//  Copyright (c) 2013年 lv wei. All rights reserved.
//

#import "ViewController.h"
#include "tinyxml.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize xmlData = _xmlData;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString* str = @"<city>\
    \
    <pois>\
    <poi catalog=\"生活服务\"   name=\"火车票飞机票售票处\"  x=\"12960121.140000\" y=\"4864264.440000\" />\
    <poi catalog=\"购物\"   name=\"皂就人生\"  x=\"12960087.850000\" y=\"4864269.380000\" />\
    <poi catalog=\"美食\"   name=\"必胜客(惠新东桥店)\"  x=\"12960191.040000\" y=\"4864423.390000\" /> \
    <poi catalog=\"房产小区\"   name=\"惠中园小区(北门)\" x=\"12960001.910000\" y=\"4864271.850000\" />\
    </pois>\
    \
    <roads>\
    <road id=\"J50F001020_37715\" name=\"北四环东路\" valid=\"1\" width=\"2\" >\
    <points>\
    <point order=\"0\" vid=\"10011018120904120936600\" x=\"12960310.270000\" y=\"4864348.300000\" />\
    <point order=\"1\" vid=\"10011018120904120937600\" x=\"12960296.410000\" y=\"4864347.700000\" />\
    </points>\
    </road>\
    </roads>\
    </city>";
    
    self.xmlData = str;
    [self xmlParse];
    [self buildParse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---xml的解析-----
- (void)parsePois:(const TiXmlNode*)poiNode
{
    const TiXmlElement* rootElement = poiNode->ToElement();
    
    const TiXmlNode* node = rootElement->FirstChildElement();// This skips the "PDA" comment.
    
    while (node) {
        const char* value = node->Value();
        if (0 == strcmp(value, "poi")) {
            rootElement = node->ToElement();
            printf("poiIno:");
			const char* catolog = rootElement->Attribute("catalog");
			if (catolog) {
				printf("catolog=%s,",catolog);
			}
            const char* name = rootElement->Attribute("name");
			if (name) {
				printf("name=%s,",name);
			}
            
            double doublevalue = -1.0;
            int result = -1;
            
			result = rootElement->QueryDoubleAttribute( "x", &doublevalue);
			if (result == TIXML_SUCCESS) {
				printf("x=%lf,",doublevalue);
			}
			result = rootElement->QueryDoubleAttribute( "y", &doublevalue);
			if (result == TIXML_SUCCESS) {
				printf("y=%lf\n",doublevalue);
			}
        }
        
        node = node->NextSibling();
    }
}

- (void)parseRoads:(const TiXmlNode*)roadNode
{
    const TiXmlElement* rootElement = roadNode->ToElement();
    
    const TiXmlNode* node = rootElement->FirstChildElement();// This skips the "PDA" comment.
    
    while (node) {
        const char* value = node->Value();
        if (0 == strcmp(value, "road")) {
            rootElement = node->ToElement();
            
			const char* roadId = rootElement->Attribute("id");
			if (roadId) {
				printf("roadId=%s",roadId);
			}
            const char* name = rootElement->Attribute("name");
			if (name) {
				printf("roadname=%s",name);
			}
            
            int value = -1;
            int result = -1;
            
			result = rootElement->QueryIntAttribute( "valid", &value);
			if (result == TIXML_SUCCESS) {
				printf("valid=%d",value);
			}
			result = rootElement->QueryIntAttribute( "width", &value);
			if (result == TIXML_SUCCESS) {
				printf("width=%d\n",value);
			}
            
            //先找points
            const TiXmlNode* pointsNode = rootElement->FirstChildElement();
            
            //再找point 
            const TiXmlElement* pointElement = pointsNode->ToElement();
            const TiXmlNode* pointNode = pointElement->FirstChildElement();	// This skips the "PDA" comment.
            
            while (pointNode) {
                
                const char* pointValue = pointNode->Value();
                
                if (0 == strcmp(pointValue, "point")) {
                    
                    pointElement = pointNode->ToElement();
                    int  intValue = 0;
                    
                    result = pointElement->QueryIntAttribute("order", &intValue);
                    
                    if (result == TIXML_SUCCESS) {
                        printf("\t\t point info:order=%d,",intValue);
                    }
                    
                    const char* vid = pointElement->Attribute("vid");
                    
                    if (vid) {
                        printf("vid=%s",vid);
                    }
                    
                    double doublevalue = -1.0;
                    
                    result = pointElement->QueryDoubleAttribute( "x", &doublevalue);
                    if (result == TIXML_SUCCESS) {
                        printf("x=%lf,",doublevalue);
                    }
                    result = pointElement->QueryDoubleAttribute( "y", &doublevalue);
                    if (result == TIXML_SUCCESS) {
                        printf("y=%lf\n",doublevalue);
                    }
                }
                
                pointNode = pointNode->NextSibling();
            }
            
            
        }
        
        node = node->NextSibling();
    }
}

- (void)xmlParse
{
    NSLog(@"------------------XML 开始解析------------------\n");
    TiXmlDocument *myDocument = new TiXmlDocument();
    
    if (NULL == myDocument) {
        return;
    }
    
    myDocument->Parse(_xmlData.UTF8String);
    
    const TiXmlNode* rootNode = myDocument->FirstChild("city");
    
    if (NULL == rootNode) {
        delete myDocument;
        return;
    }
    
    const TiXmlElement* rootElement = rootNode->ToElement();
    
    const TiXmlNode* node = rootElement->FirstChildElement();// This skips the "PDA" comment.
    
    while (node) {
        const char* value = node->Value();
        if (0 == strcmp(value, "pois")) {
            NSLog(@"------开始解析pois-----");
            [self parsePois:node];
            NSLog(@"------完成解析pois-----");
        }
        else if (0 == strcmp(value, "roads"))
        {
            NSLog(@"------开始解析roads-----");
            [self parseRoads:node];
            NSLog(@"------完成解析roads-----");
        }
        
        node = node->NextSibling();
    }
    
    delete myDocument;
    NSLog(@"------------------XML 完成解析------------------");
}

#pragma mark---xml的生成-----
- (void)buildParse
{
    /*
     NSString* str = @"<city>\
     \
     <pois>\
     <poi catalog=\"生活服务\"   name=\"火车票飞机票售票处\"  x=\"12960121.140000\" y=\"4864264.440000\" />\
     <poi catalog=\"购物\"   name=\"皂就人生\"  x=\"12960087.850000\" y=\"4864269.380000\" />\
     <poi catalog=\"美食\"   name=\"必胜客(惠新东桥店)\"  x=\"12960191.040000\" y=\"4864423.390000\" /> \
     <poi catalog=\"房产小区\"   name=\"惠中园小区(北门)\" x=\"12960001.910000\" y=\"4864271.850000\" />\
     </pois>\
     \
     <roads>\
     <road id=\"J50F001020_37715\" name=\"北四环东路\" valid=\"1\" width=\"2\" >\
     <points>\
     <point order=\"0\" vid=\"10011018120904120936600\" x=\"12960310.270000\" y=\"4864348.300000\" />\
     <point order=\"1\" vid=\"10011018120904120937600\" x=\"12960296.410000\" y=\"4864347.700000\" />\
     </points>\
     </road>\
     </roads>\
     </city>";
     */
    
    NSLog(@"------------------XML 开始生成------------------");
    //创建一个XML的文档对象。
    TiXmlDocument*  myDocument = new TiXmlDocument();
    //创建一个根元素并连接。
    TiXmlElement*   rootElement = new TiXmlElement("city");
    myDocument->LinkEndChild(rootElement);
    //创建一个pois元素并连接。
    TiXmlElement* poisElement = new TiXmlElement("pois");
    rootElement->LinkEndChild(poisElement);
    
    //创建四个poi元素并连接。
    NSArray* poiCatalogArray = [NSArray arrayWithObjects:@"生活服务",@"购物",@"美食",@"房产小区", nil];
    NSArray* poiNameArray = [NSArray arrayWithObjects:@"火车票飞机票售票处",@"皂就人生",@"必胜客(惠新东桥店)",@"惠中园小区(北门)", nil];
    
    const int KArrayLen = 4;
    double pXArray[KArrayLen];
    pXArray[0] = 12960121.140000;
    pXArray[1] = 12960087.850000;
    pXArray[2] = 12960191.040000;
    pXArray[3] = 12960001.910000;
    
    double pYArray[KArrayLen];
    pYArray[0] = 4864264.440000;
    pYArray[1] = 4864269.380000;
    pYArray[2] = 4864423.390000;
    pYArray[3] = 4864271.850000;
    
    for (int i = 0; i< KArrayLen; ++i) {
        
        TiXmlElement* poiElement = new TiXmlElement("poi");
        poisElement->LinkEndChild(poiElement);
        NSString* str = [poiCatalogArray objectAtIndex:i];
        poiElement->SetAttribute("catalog", str.UTF8String);
        str = [poiNameArray objectAtIndex:i];
        poiElement->SetAttribute("name", str.UTF8String);
        poiElement->SetDoubleAttribute("x", pXArray[i]);
        poiElement->SetDoubleAttribute("y", pYArray[i]);
    }
    
    //创建roads元素并连接。
    TiXmlElement* roadsElement = new TiXmlElement("roads");
    rootElement->LinkEndChild(roadsElement);
    
    
    //创建road元素并连接。
    TiXmlElement* roadElement = new TiXmlElement("road");
    roadsElement->LinkEndChild(roadElement);
    
    roadElement->SetAttribute("id", "J50F001020_37715");
    roadElement->SetAttribute("name", "北四环东路");
    roadElement->SetAttribute("valid", 1);
    roadElement->SetAttribute("width", 2);
    
    TiXmlElement* roadPointsElement = new TiXmlElement("points");
    roadElement->LinkEndChild(roadPointsElement);
    
    //point1
    
    TiXmlElement* pointElement = new TiXmlElement("point");
    pointElement->SetAttribute("order", 0);
    pointElement->SetAttribute("vid", "10011018120904120936600");
    pointElement->SetDoubleAttribute("x", 12960310.270000);
    pointElement->SetDoubleAttribute("y", 4864348.300000);
    roadPointsElement->LinkEndChild(pointElement);
    
    pointElement = new TiXmlElement("point");
    pointElement->SetAttribute("order", 1);
    pointElement->SetAttribute("vid", "10011018120904120937600");
    pointElement->SetDoubleAttribute("x", 12960296.410000);
    pointElement->SetDoubleAttribute("y", 4864347.700000);
    roadPointsElement->LinkEndChild(pointElement);
    
     NSLog(@"----------XML生成的内容如下----------\n");
    myDocument->Print();
    
    delete myDocument;
    NSLog(@"------------------XML 完成生成------------------");

}

@end
```

### 3.执行情况
```terminal
	2013-04-17 14:16:59.966 XMLTest_TinyXML[1987:11303] ------------------XML 开始解析------------------
	2013-04-17 14:16:59.967 XMLTest_TinyXML[1987:11303] ------开始解析	pois-----
	poiIno:catolog=生活服务,name=火车票飞机票售票处,x=12960121.140000,y=4864264.440000
	poiIno:catolog=购物,name=皂就人生,x=12960087.850000,y=4864269.380000
	poiIno:catolog=美食,name=必胜客(惠新东桥店),x=12960191.040000,y=4864423.390000
	poiIno:catolog=房产小区,name=惠中园小区(北门),x=12960001.910000,y=4864271.850000
	2013-04-17 14:16:59.967 XMLTest_TinyXML[1987:11303] ------完成解析	pois-----
	2013-04-17 14:16:59.968 XMLTest_TinyXML[1987:11303] ------开始解析roads-----
	roadId=J50F001020_37715roadname=北四环东路valid=1width=2
		 point info:order=0,vid=10011018120904120936600x=12960310.270000,y=4864348.300000
		 point info:order=1,vid=10011018120904120937600x=12960296.410000,y=4864347.700000
	2013-04-17 14:16:59.968 XMLTest_TinyXML[1987:11303] ------完成解析roads-----
	2013-04-17 14:16:59.969 XMLTest_TinyXML[1987:11303] ------------------XML 完成解析------------------
	2013-04-17 14:16:59.969 XMLTest_TinyXML[1987:11303] ------------------XML 开始生成------------------
	2013-04-17 14:16:59.970 XMLTest_TinyXML[1987:11303] ----------XML生成的内容如下----------
	<city>
    <pois>
        <poi catalog="生活服务" name="火车票飞机票售票处" x="1.29601e+07" y="4.86426e+06" />
        <poi catalog="购物" name="皂就人生" x="1.29601e+07" y="4.86427e+06" />
        <poi catalog="美食" name="必胜客(惠新东桥店)" x="1.29602e+07" y="4.86442e+06" />
        <poi catalog="房产小区" name="惠中园小区(北门)" x="1.296e+07" y="4.86427e+06" />
    </pois>
    <roads>
        <road id="J50F001020_37715" name="北四环东路" valid="1" width="2">
            <points>
                <point order="0" vid="10011018120904120936600" x="1.29603e+07" y="4.86435e+06" />
                <point order="1" vid="10011018120904120937600" x="1.29603e+07" y="4.86435e+06" />
            </points>
        </road>
    </roads>
</city>

	2013-04-17 14:16:59.970 XMLTest_TinyXML[1987:11303] ------------------XML 完成生成------------------
```

挺好用吧！我比较偏爱使用这个！

