---
title: "JSONKIT初体验"
date: 2013-04-05
lastmod: 2013-04-05
categories:
  - "iOS"
tags:
  - "iOS"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---
以下面数据作为样例

```objective-c
{
"info":{
"type":34,
"error":0
},
"poilist":[
{
"x":116.345,
"name":"银科大厦",
"y":39.333399999999997
},
{
"x":116.3451,
"name":"中国技术交易大厦",
"y":39.313339999999997
}
]
}
```

进行json数据组装与解析

#### 1.json数据组装
```objective-c
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
    
    NSString* string = [jsonDic JSONString];
    
    NSLog(@"jsonString=%@",string);
    [jsonDic release];
```

#### 2.json数据解析
```objective-c
NSString* jsonString =   @"{\"info\":{\"error\":0,\"type\":34},\"poilist\":[{\"name\":\"银科大厦\",\"x\":116.345,\"y\":39.3334},{\"name\":\"中国技术交易大厦\",\"x\":116.3451,\"y\":39.31334}]}";
    
    id root = [jsonString objectFromJSONString];
    
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

```