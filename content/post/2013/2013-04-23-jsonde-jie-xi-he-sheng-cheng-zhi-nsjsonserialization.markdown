---
title: "json的解析和生成之_NSJSONSerialization"
date: 2013-04-23
lastmod: 2013-04-23
categories:
  - "iOS"
tags:
  - "iOS"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---


## JSON库使用

`NSJSONSerialization`在(10_7, 5_0)版本中开始出现的，因此，如果使用系统自带的JSON API,需要对系统版本做一下校验或其他方式校验来确定是否使用该类。

### 1.示例代码

```objective-c
//
//  ViewController.m
//  JsonTest_NSJSONSerialization
//
//  Created by lv wei on 13-4-23.
//  Copyright (c) 2013年 lv wei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    //NSJSONSerialization (10_7, 5_0)
    if (version >=5.0) {
        [self jsonParse];
        [self jsonBuild];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)jsonParse
{
    NSString* jsonString =   @"{\"info\":{\"error\":0,\"type\":34},\"poilist\":[{\"name\":\"银科大厦\",\"x\":116.345,\"y\":39.3334},{\"name\":\"中国技术交易大厦\",\"x\":116.3451,\"y\":39.31334}]}";
    NSData* jsonData = [NSData dataWithBytes:[jsonString UTF8String] length:[jsonString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"-----NSJSONSerialization-----开始解析");
    __autoreleasing NSError* error = nil;
    id root = [NSJSONSerialization JSONObjectWithData:jsonData
                                                options:kNilOptions error:&error];
    
    if (error) {
        NSLog(@"-----NSJSONSerialization-----解析出错");
        return;
    }
    
    if ([root isKindOfClass:[NSDictionary class]]) {
        
        id jsonInfo = [root objectForKey:@"info"];
        
        if ([jsonInfo isKindOfClass:[NSDictionary class]]) {
            NSInteger error = [[jsonInfo objectForKey:@"error"] intValue];
            NSInteger type = [[jsonInfo objectForKey:@"type"] intValue];
            
            NSLog(@"error = %d,type = %d",error,type);
        }
        
        id jsonPoiList = [root objectForKey:@"poilist"];
        
        if ([jsonPoiList isKindOfClass:[NSArray class]]) {
            NSArray* jsonPoiArray = (NSArray*)jsonPoiList;
            
            for (id jsonPoiDic in jsonPoiArray) {
                
                if ([jsonPoiDic isKindOfClass:[NSDictionary class]]) {
                    NSString* name = [jsonPoiDic objectForKey:@"name"];
                    double x = [[jsonPoiDic objectForKey:@"x"] doubleValue];
                    double y = [[jsonPoiDic objectForKey:@"y"] doubleValue];
                    
                    NSLog(@"poi:{name=%@,x=%f,y=%f}",name,x,y);
                    
                }
            }
        }
    }
    
    NSLog(@"-----NSJSONSerialization-----完成解析");
}

- (void)jsonBuild
{
    NSLog(@"-----NSJSONSerialization-----开始生成jSON数据");
    NSDictionary* jsonDic = [[NSMutableDictionary alloc] init];
    //添加info字段
    NSDictionary* jsonInfoDic = [[NSMutableDictionary alloc] init];
    [jsonInfoDic setValue:[NSNumber numberWithInteger:0] forKey:@"error"];
    [jsonInfoDic setValue:[NSNumber numberWithInteger:34] forKey:@"type"];
    [jsonDic setValue:jsonInfoDic forKey:@"info"];
    [jsonInfoDic release];
    
    //添加poilist字段
    NSDictionary* poi1 = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"银科大厦",@"name",
                          [NSNumber numberWithDouble:116.345],@"x",
                          [NSNumber numberWithDouble:39.3334],@"y",
                          nil];
    
    NSDictionary* poi2 = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"中国技术交易大厦",@"name",
                          [NSNumber numberWithDouble:116.3451],@"x",
                          [NSNumber numberWithDouble:39.31334],@"y",
                          nil];
    NSArray* jsonPoiList = [NSArray arrayWithObjects:poi1,poi2, nil];
    [jsonDic setValue:jsonPoiList forKey:@"poilist"];
    
  
    __autoreleasing NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
   __autoreleasing NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonString=%@",jsonString);
    
    [jsonDic release];
    NSLog(@"-----NSJSONSerialization-----完成生成jSON数据");
}

@end

```

### 2.执行情况
```terminal
	2013-04-23 10:06:11.667 JsonTest_NSJSONSerialization[2028:11303] -----NSJSONSerialization-----开始解析
	2013-04-23 10:06:11.705 JsonTest_NSJSONSerialization[2028:11303] error = 0,type = 34
	2013-04-23 10:06:11.705 JsonTest_NSJSONSerialization[2028:11303] poi:{name=银科大厦,x=116.345000,y=39.333400}
	2013-04-23 10:06:11.706 JsonTest_NSJSONSerialization[2028:11303] poi:{name=中国技术交易大厦,x=116.345100,y=39.313340}
	2013-04-23 10:06:11.706 JsonTest_NSJSONSerialization[2028:11303] -----NSJSONSerialization-----完成解析
	2013-04-23 10:06:12.892 JsonTest_NSJSONSerialization[2028:11303] -----NSJSONSerialization-----开始生成jSON数据
	2013-04-23 10:06:12.893 JsonTest_NSJSONSerialization[2028:11303] jsonString={
  	"poilist" : [
    {
      "x" : 116.345,
      "name" : "银科大厦",
      "y" : 39.3334
    },
    {
      "x" : 116.3451,
      "name" : "中国技术交易大厦",
      "y" : 39.31334
    }
 	 ],
  	"info" : {
    "type" : 34,
    "error" : 0
  	}
    }
	2013-04-23 10:06:12.893 JsonTest_NSJSONSerialization[2028:11303] -----NSJSONSerialization-----完成生成jSON数据
```