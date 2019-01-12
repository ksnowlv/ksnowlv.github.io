---
layout: post
title: "XML解析之NSXMLParser"
date: 2013-04-16 18:56
comments: true
categories: iOS-基础
---


NSXMLParser为IPHONE SDK 自带的，还是很方便的。

####1.头文件
```objective-c
//  ViewController.h
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSXMLParserDelegate>


@property(nonatomic,retain)NSXMLParser* xmlParser;

- (IBAction)testNSXMLParserEvent:(id)sender;

@end

```

#####2.实现文件

```objective-c
//  ViewController.m

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,retain) NSData* xmlData;
@end

@implementation ViewController
@synthesize xmlData = _xmlData;
@synthesize xmlParser = _xmlParser;

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
    
    str = [str stringByAppendingString:str];
    
    NSData *xmlData = [str dataUsingEncoding: NSUTF8StringEncoding];
    self.xmlData = xmlData;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_xmlData release];
    _xmlParser.delegate = nil;
    [_xmlParser release];
    [super dealloc];
}


#pragma mark----NSXMLParser----

- (IBAction)testNSXMLParserEvent:(id)sender
{
    //对xml进行解析需要使用NSXMLParser类，首先声明一个NSXMLParser对象
    //开始解析
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithData:_xmlData];//初始化NSXMLParser对象
    [xmlParser setDelegate:self];//设置NSXMLParser对象的解析方法代理
    [xmlParser parse];//调用代理解析NSXMLParser对象，看解析是否成功
    self.xmlParser = xmlParser;
    [xmlParser release];
    
}

////解析器，从两个结点之间读取内容
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    NSLog(@"foundCharacters  %@",string);
//}

//获得结点结尾的值
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"didEndElement  %@",elementName);
    
    if ([elementName isEqualToString:@"road"]) {
        //这样可以把road关于刚才记录的point数组放进来，组成road完整的数据
    }
}
//获得结点头的值
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    NSLog(@"didStartElement %@",elementName);
    if([elementName isEqualToString: @"poi"])
    {
        NSString* catalog = [attributeDict objectForKey:@"catalog"];
        NSString* name = [attributeDict objectForKey:@"name"];
        double x = [[attributeDict objectForKey:@"x"] doubleValue];
        double y = [[attributeDict objectForKey:@"y"] doubleValue];
        
        NSLog(@"poi data = {catalog=%@,name=%@,x =%lf,y = %lf}",catalog,name,x,y);
    }
    else if([elementName isEqualToString: @"point"])
    {
        NSInteger order = [[attributeDict objectForKey:@"order"] intValue];
        NSString* vid = [attributeDict objectForKey:@"vid"];
        double x = [[attributeDict objectForKey:@"x"] doubleValue];
        double y = [[attributeDict objectForKey:@"y"] doubleValue];
        
        NSLog(@"point data = {order=%d,vid=%@,x =%lf,y = %lf}",order,vid,x,y);
    }
    else if([elementName isEqualToString: @"road"])
    {

        NSString* name = [attributeDict objectForKey:@"name"];
        NSString* roadID = [attributeDict objectForKey:@"id"];
        NSInteger width = [[attributeDict objectForKey:@"width"] intValue];
        NSInteger valid = [[attributeDict objectForKey:@"valid"] intValue];
        
        NSLog(@"road data = {name=%@,roadID=%@,width=%d,valid  %d}",name,roadID,width,valid);
    }
}

@end

```

