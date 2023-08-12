---
title: "XML解析之libxml2"
date: 2013-04-18
categories:
  - "iOS"
tags:
  - "iOS"
---
<!--more-->


首先，添加系统库`libxml2`.dylib.

另外，引入`#import <libxml/tree.h>`.

#### 一.重要函数简介如下： * 1.得到一个节点的内容
 
   xmlChar *value = xmlNodeGetContent(node);返回值value应该使用xmlFree(value)释放内存

 * 2.得到一个节点的某属性值：
   xmlChar *value = xmlGetProp(node, (const xmlChar *)"prop1");返回值需要xmlFree(value)释放内存

 * 3.设置一个节点的内容：
 
   xmlNodeSetContent(node, (const xmlChar *)"test");
  
 *  4.设置一个节点的某属性值：
 
   xmlSetProp(node, (const xmlChar *)"prop1", (const xmlChar *)"v1");

 * 5.添加一个节点元素：
 
   xmlNewTextChild(node, NULL, (const xmlChar *)"keyword", (const xmlChar *)"test Element");
 
 * 6.添加一个节点属性：
   
   xmlNewProp(node, (const xmlChar *)"prop1", (const xmlChar *)"test Prop");

#### 二.示例：本文采用DOM的方式解析XML

```objective-c

实现文件如下：
//
//  ViewController.m
//  XMLTest_Libxml2
//
//  Created by lv wei on 13-4-18.
//  Copyright (c) 2013年 lv wei. All rights reserved.
//

#import "ViewController.h"
#import <libxml/tree.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self xmlParse];
    [self xmlBuild];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)xmlParse
{
    NSString* str = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\
    <city>\
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
    
    
    NSLog(@"----------开始XML解析----------");
    xmlDocPtr pDoc;
    //[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding]这个特别坑，注意!!!!!!
    pDoc = xmlParseMemory(str.UTF8String,[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
    if (NULL == pDoc) {
        fprintf(stderr,"Document not parsed successfully. \n");
        return;
    }
    
    xmlNodePtr cur = xmlDocGetRootElement(pDoc);
    
    if (NULL == cur) {
        fprintf(stderr,"empty document\n");
        xmlFreeDoc(pDoc);
        return;
    }
    
    if (xmlStrcmp(cur->name, (const xmlChar *) "city")) {
        fprintf(stderr,"document of the wrong type, root node != city");
        xmlFreeDoc(pDoc);
        return;
    }
    
    for (cur = cur->xmlChildrenNode; cur != NULL; cur = cur->next) {
        
        const char* pName = (const char*)cur->name;
       // printf("------------------%s\n",cur->name);
        //pois
        if (0 == strcmp(pName, "pois")) {
            
            //poi
            for (xmlNodePtr poiNode = cur->children; poiNode != NULL; poiNode = poiNode->next) {
                
                if (0 != strcmp((const char*)poiNode->name, "poi"))
                {
                    continue;
                }
                
                xmlChar* catalog = xmlGetProp(poiNode, (const xmlChar *)"catalog");
                xmlChar* name = xmlGetProp(poiNode, (const xmlChar *)"name");
                xmlChar* x = xmlGetProp(poiNode, (const xmlChar *)"x");
                xmlChar* y = xmlGetProp(poiNode, (const xmlChar *)"y");
                
                printf("poiInfo:catalog = %s,name = %s, x = %s, y = %s\n",catalog,name,x,y);
                xmlFree(y);
                xmlFree(x);
                xmlFree(name);
                xmlFree(catalog);
                
                /*
                //查看各个属性
                struct _xmlAttr* attr = NULL;
                for (attr = poiNode->properties; attr!=NULL; attr = attr->next) {
                    printf("poiattr=%s",attr->name);
                    
                }*/
            }
        }
        else if(0 == strcmp(pName, "roads"))//roads
        {
            for (xmlNodePtr roadNode = cur->children; roadNode != NULL; roadNode = roadNode->next) {
                
                if (0 != strcmp((const char*)roadNode->name, "road")) {
                    continue;
                }
                
                xmlChar* roadID = xmlGetProp(roadNode, (const xmlChar *)"id");
                xmlChar* roadName = xmlGetProp(roadNode, (const xmlChar *)"name");
                xmlChar* roadValid = xmlGetProp(roadNode, (const xmlChar *)"valid");
                xmlChar* roadWidth = xmlGetProp(roadNode, (const xmlChar *)"width");
                
                printf("road id= %s,roadname = %s, valid = %s, width = %s\n",roadID,roadName,roadValid,roadWidth);
                
                xmlFree(roadWidth);
                xmlFree(roadValid);
                xmlFree(roadName);
                xmlFree(roadID);
                
                 //find points
                 for (xmlNodePtr pointsNode = roadNode->children; pointsNode != NULL; pointsNode = pointsNode->next) {
            
                     
                     if (0 != strcmp((const char*)pointsNode->name, "points")) {
                         continue;
                     }
                    
                    for (xmlNodePtr pointNode = pointsNode->children; pointNode != NULL; pointNode = pointNode->next) {
                        
                        if (0 != strcmp((const char*)pointNode->name, "point")) {
                            continue;
                        }
                        
                        //printf("%s",pointNode->name);
                        xmlChar* order = xmlGetProp(pointNode, (const xmlChar *)"order");
                        xmlChar* vid = xmlGetProp(pointNode, (const xmlChar *)"vid");
                        xmlChar* x = xmlGetProp(pointNode, (const xmlChar *)"x");
                        xmlChar* y = xmlGetProp(pointNode, (const xmlChar *)"y");
                        
                        printf("\t\tpoint:order = %s,vid = %s, x = %s, y = %s\n",order,vid,x,y);
                        xmlFree(y);
                        xmlFree(x);
                        xmlFree(vid);
                        xmlFree(order);
                    }
                        
                }
            }
        }
    }
    
    xmlSaveFormatFileEnc ([self buildFullFilePath:@"parsexml.xml"].UTF8String, pDoc,"UTF-8",1);
    
    xmlFreeDoc(pDoc);
    xmlCleanupParser ();
    xmlMemoryDump ();
    
    NSLog(@"----------完成XML解析----------");
}

- (void)xmlBuild
{
    //    NSString* str = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\
    //    <city>\
    //    \
    //    <pois>\
    //    <poi catalog=\"生活服务\"   name=\"火车票飞机票售票处\"  x=\"12960121.140000\" y=\"4864264.440000\" />\
    //    <poi catalog=\"购物\"   name=\"皂就人生\"  x=\"12960087.850000\" y=\"4864269.380000\" />\
    //    <poi catalog=\"美食\"   name=\"必胜客(惠新东桥店)\"  x=\"12960191.040000\" y=\"4864423.390000\" /> \
    //    <poi catalog=\"房产小区\"   name=\"惠中园小区(北门)\" x=\"12960001.910000\" y=\"4864271.850000\" />\
    //    </pois>\
    //    \
    //    <roads>\
    //    <road id=\"J50F001020_37715\" name=\"北四环东路\" valid=\"1\" width=\"2\" >\
    //    <points>\
    //    <point order=\"0\" vid=\"10011018120904120936600\" x=\"12960310.270000\" y=\"4864348.300000\" />\
    //    <point order=\"1\" vid=\"10011018120904120937600\" x=\"12960296.410000\" y=\"4864347.700000\" />\
    //    </points>\
    //    </road>\
    //    </roads>\
    //    </city>";
    
    NSLog(@"----------xml文档开始生成----------");
    // 创建一个新文档并设置 root 节点
    xmlDocPtr  pDoc = xmlNewDoc (BAD_CAST "1.0");
    
    xmlNodePtr  rootNode = xmlNewNode (NULL, (const xmlChar *)"city");
    xmlDocSetRootElement (pDoc, rootNode);
    
    //pois
    xmlNodePtr poisNode = xmlNewNode(NULL, (const xmlChar*)"pois");
    xmlAddChild(rootNode, poisNode);
    
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
    
    const int KStrLen = 48;
    char numStr[KStrLen];
    
    for (int i = 0; i < KArrayLen; ++i) {
        //poi
        xmlNodePtr poiNode =  xmlNewNode(NULL, (const xmlChar*)"poi");
        xmlSetProp(poiNode, (const xmlChar*)"catalog", (const xmlChar*)[[poiCatalogArray objectAtIndex:i] UTF8String]);
        xmlSetProp(poiNode, (const xmlChar*)"name", (const xmlChar*)[[poiNameArray objectAtIndex:i] UTF8String]);
        
        memset(numStr, 0, KStrLen * sizeof(char));
        sprintf(numStr, "%f",pXArray[i]);
        xmlSetProp(poiNode, (const xmlChar*)"x", (const xmlChar*)numStr);
        memset(numStr, 0, KStrLen * sizeof(char));
        sprintf(numStr, "%f",pYArray[i]);
        xmlSetProp(poiNode, (const xmlChar*)"y", (const xmlChar*)numStr);
        xmlAddChild(poisNode, poiNode);
    }
    
    //roads
    xmlNodePtr roadsNode = xmlNewNode(NULL, (const xmlChar*)"roads");
    xmlAddChild(rootNode, roadsNode);
    
    xmlNodePtr roadNode = xmlNewNode(NULL,(const xmlChar*) "road");
    xmlAddChild(roadsNode, roadNode);
    //
    xmlSetProp(roadNode, (const xmlChar*)"id", (const xmlChar*)"J50F001020_37715");
    xmlSetProp(roadNode, (const xmlChar*)"name", (const xmlChar*)"北四环东路");
    xmlSetProp(roadNode, (const xmlChar*)"valid", (const xmlChar*)"1");
    xmlSetProp(roadNode, (const xmlChar*)"width", (const xmlChar*)"2");
   
    //add points
    xmlNodePtr pointsNode = xmlNewNode(NULL, (const xmlChar *)"points");
    xmlAddChild(roadNode, pointsNode);
    
    //add point
    xmlNodePtr pointNode =  xmlNewNode(NULL, (const xmlChar *)"point");
    xmlSetProp(pointNode, (const xmlChar*)"order", (const xmlChar*)"0");
    xmlSetProp(pointNode, (const xmlChar*)"vid", (const xmlChar*)"10011018120904120936600");
    xmlSetProp(pointNode, (const xmlChar*)"x", (const xmlChar*)"12960310.270000");
    xmlSetProp(pointNode, (const xmlChar*)"y", (const xmlChar*)"4864348.300000");
    xmlAddChild(pointsNode, pointNode);
    
    //add point
    pointNode =  xmlNewNode(NULL, (const xmlChar *)"point");
    xmlSetProp(pointNode, (const xmlChar*)"order", (const xmlChar*)"1");
    xmlSetProp(pointNode, (const xmlChar*)"vid", (const xmlChar*)"10011018120904120937600");
    xmlSetProp(pointNode, (const xmlChar*)"x", (const xmlChar*)"12960296.410000");
    xmlSetProp(pointNode, (const xmlChar*)"y", (const xmlChar*)"4864347.700000");
    xmlAddChild(pointsNode, pointNode);
    

    xmlSaveFormatFileEnc ([self buildFullFilePath:@"buildxml.xml"].UTF8String, pDoc,"UTF-8",1);
    // 释放资源
    xmlFreeDoc (pDoc);
    xmlCleanupParser ();
    xmlMemoryDump ();
    
    NSLog(@"----------xml文档完成生成----------");
}

- (NSString*)buildFullFilePath:(NSString*)fileName
{
    NSArray *cachesDirectories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *fullFilePath = nil;
    if ([cachesDirectories count] > 0) {
        NSString* rootDirectory = [[cachesDirectories objectAtIndex:0] stringByAppendingString:@"/xmlSaveDic"];
        
        fullFilePath = rootDirectory;
        NSFileManager* fileManager = [NSFileManager defaultManager];
        BOOL isExist = [fileManager fileExistsAtPath:fullFilePath];
        
        if (!isExist) {
            [fileManager createDirectoryAtPath:fullFilePath
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:nil];
        }
        
        fullFilePath = [rootDirectory stringByAppendingString:@"/"];
    }
    
    fullFilePath = [fullFilePath stringByAppendingString:fileName];
    NSLog(@"xml生成目录=%@",fullFilePath);
    return fullFilePath;
}


@end

```


#### 三.运行结果如下：
	2013-04-19 12:52:24.966 XMLTest_Libxml2[1301:11303] ----------开始XML解析----------
	poiInfo:catalog = 生活服务,name = 火车票飞机票售票处, x = 12960121.140000, y = 4864264.440000
	poiInfo:catalog = 购物,name = 皂就人生, x = 12960087.850000, y = 4864269.380000
	poiInfo:catalog = 美食,name = 必胜客(惠新东桥店), x = 12960191.040000, y = 4864423.390000
	poiInfo:catalog = 房产小区,name = 惠中园小区(北门), x = 12960001.910000, y = 4864271.850000
	road id= J50F001020_37715,roadname = 北四环东路, valid = 1, width = 2
		point:order = 0,vid = 10011018120904120936600, x = 12960310.270000, y = 4864348.300000
		point:order = 1,vid = 10011018120904120937600, x = 12960296.410000, y = 4864347.700000
	2013-04-19 12:52:24.967 XMLTest_Libxml2[1301:11303] xml生成目录=/Users/lvwei/Library/Application Support/iPhone Simulator/6.0/Applications/836D7AFA-DE7E-4351-83CD-536E17814C82/Library/Caches/xmlSaveDic/parsexml.xml
	2013-04-19 12:52:24.968 XMLTest_Libxml2[1301:11303] ----------完成XML解析----------
	2013-04-19 12:52:24.968 XMLTest_Libxml2[1301:11303] ----------xml文档开始生成----------
	2013-04-19 12:52:24.969 XMLTest_Libxml2[1301:11303] xml生成目录=/Users/lvwei/Library/Application Support/iPhone Simulator/6.0/Applications/836D7AFA-DE7E-4351-83CD-536E17814C82/Library/Caches/xmlSaveDic/buildxml.xml
	2013-04-19 12:52:24.969 XMLTest_Libxml2[1301:11303] ----------xml文档完成生成----------

#### 四。buildxml.xml文件中的内容
```objective-c

<?xml version="1.0" encoding="UTF-8"?>
<city>
  <pois>
    <poi catalog="生活服务" name="火车票飞机票售票处" x="12960121.140000" y="4864264.440000"/>
    <poi catalog="购物" name="皂就人生" x="12960087.850000" y="4864269.380000"/>
    <poi catalog="美食" name="必胜客(惠新东桥店)" x="12960191.040000" y="4864423.390000"/>
    <poi catalog="房产小区" name="惠中园小区(北门)" x="12960001.910000" y="4864271.850000"/>
  </pois>
  <roads>
    <road id="J50F001020_37715" name="北四环东路" valid="1" width="2">
      <points>
        <point order="0" vid="10011018120904120936600" x="12960310.270000" y="4864348.300000"/>
        <point order="1" vid="10011018120904120937600" x="12960296.410000" y="4864347.700000"/>
      </points>
    </road>
  </roads>
</city>

```
总结：使用起来和tinyxml差别不小，但是也挺好用的！出于测试的目的，没有在继续切分函数！
推荐一篇相关的博客，可以参考下：[http://jianlee.ylinux.org/Computer/C/libxml.html](http://jianlee.ylinux.org/Computer/C/libxml.html)
