---
title: "NSMutableArray排序"
date: 2013-04-27
lastmod: 2013-04-27
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

主要使用sortUsingComparator，sortUsingFunction，sortUsingSelector进行排序。

#### 1.头文件。```objective-c
//
//  ArraryTest_OrderViewController.m
//  ArraryTest_Order
//
//  Created by lv wei on 13-4-27.
//  Copyright (c) 2013年 lv wei. All rights reserved.
//

#import "ArraryTest_OrderViewController.h"

@interface QStudent : NSObject

@property(nonatomic, retain) NSString* studentID;

-(NSComparisonResult) compare: (id)element;

@end

```

#### 2.实现文件。
```objective-c
@implementation QStudent
@synthesize studentID = _studentID;

- (void)dealloc
{
    [_studentID release];
    [super dealloc];
}
//主要用来演示NSMutableArray的sortUsingSelector如何使用
- (NSComparisonResult)compare:(QStudent*)element
{
    int num1 = [_studentID intValue];
    int num2 = [element.studentID intValue];

    if (num1 == num2) {
        return NSOrderedSame;
    }
    else if (num1 < num2)
    {
        return NSOrderedAscending;
    }
    
    return NSOrderedDescending;
}

@end


@interface ArraryTest_OrderViewController ()
@property(nonatomic, retain)NSMutableArray* stringList;
@end

@implementation ArraryTest_OrderViewController
@synthesize stringList = _stringList;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray* stringList = [NSMutableArray arrayWithObjects:@"90", @"23",@"1",@"1000",@"0",@"99",nil];
    self.stringList = stringList;
    
    [self sortUsingComparator];
    [self sortComparatorWithOptions];
    [self sortUsingFuction];
    [self sortUsingSelector];
}

- (void)sortUsingComparator
{
    NSLog(@"sortUsingComparator");
    NSMutableArray* stringList = [_stringList mutableCopy];
    
    NSLog(@"原始的：%@",stringList);
    
    [stringList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        if ([obj1 intValue] == [obj2 intValue]) {
            return NSOrderedSame;
        }
        else if([obj1 intValue] > [obj2 intValue] )
        {
            return NSOrderedDescending;
        }
        
        return NSOrderedAscending;
    }];
    
    NSLog(@"排序后:%@",stringList);
    
    [stringList release];
}

- (void)sortComparatorWithOptions
{
     NSLog(@"sortComparatorWithOptions");
    NSMutableArray* stringList = [_stringList mutableCopy];
    
    NSLog(@"原始的：%@",stringList);
    
    [stringList sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        if ([obj1 intValue] == [obj2 intValue]) {
            return NSOrderedSame;
        }
        else if([obj1 intValue] > [obj2 intValue] )
        {
            return NSOrderedDescending;
        }
        
        return NSOrderedAscending;
    }];
    
    
    
    NSLog(@"排序后:%@",stringList);
    
    [stringList release];
}

static NSComparisonResult ObjectCompare(id  obj1, id obj2, void* context)
{
    if ([obj1 intValue] == [obj2 intValue]) {
        return NSOrderedSame;
    }
    else if([obj1 intValue] > [obj2 intValue] )
    {
        return NSOrderedDescending;
    }
    
    return NSOrderedAscending;
}

- (void)sortUsingFuction
{
    NSLog(@"sortUsingFuction");
    NSMutableArray* stringList = [_stringList mutableCopy];
    
    NSLog(@"原始的：%@",stringList);
    
    [stringList sortUsingFunction:ObjectCompare context:nil];
    
    NSLog(@"排序后:%@",stringList);
    
    [stringList release];
}

- (void)sortUsingSelector
{
    NSLog(@"sortUsingSelector");
    const int KArrayLen = 6;
    int array[KArrayLen] = {90,23,1,1000,0,99};
    NSMutableArray* stringList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < KArrayLen; ++i) {
        QStudent* student = [[QStudent alloc] init];
        student.studentID = [NSString stringWithFormat:@"%d",array[i]];
        [stringList addObject:student];
        [student release];
    }
   
    
    NSLog(@"原始的：");
    for (int i = 0; i < KArrayLen; ++i) {
    
        NSLog(@"%@",[[stringList objectAtIndex:i] studentID]);
    }
    
    [stringList sortUsingSelector:@selector(compare:)];
    
    NSLog(@"排序后:");
    
    for (int i = 0; i < KArrayLen; ++i) {
        
        NSLog(@"%@",[[stringList objectAtIndex:i] studentID]);
    }
    NSLog(@"反序后:");
    NSEnumerator *enumerator = [stringList reverseObjectEnumerator];
    [stringList release];
	stringList =[[NSMutableArray alloc]initWithArray: [enumerator allObjects]];
    
    for (int i = 0; i < KArrayLen; ++i) {
        
        NSLog(@"%@",[[stringList objectAtIndex:i] studentID]);
    }
    [stringList release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

```

日志：

	2013-04-27 15:55:57.515 ArraryTest_Order[22759:11303] sortUsingComparator
	2013-04-27 15:55:57.516 ArraryTest_Order[22759:11303] 原始的：(
    90,
    23,
    1,
    1000,
    0,
    99
	)
	2013-04-27 15:55:57.517 ArraryTest_Order[22759:11303] 排序后:(
    0,
    1,
    23,
    90,
    99,
    1000
	)
	2013-04-27 15:55:57.517 ArraryTest_Order[22759:11303] sortComparatorWithOptions
	2013-04-27 15:55:57.517 ArraryTest_Order[22759:11303] 原始的：(
    90,
    23,
    1,
    1000,
    0,
    99
	)
	2013-04-27 15:55:57.518 ArraryTest_Order[22759:11303] 排序后:(
    0,
    1,
    23,
    90,
    99,
    1000
	)
	2013-04-27 15:55:57.518 ArraryTest_Order[22759:11303] sortUsingFuction
	2013-04-27 15:55:57.519 ArraryTest_Order[22759:11303] 原始的：(
    90,
    23,
    1,
    1000,
    0,
    99
	)
	2013-04-27 15:55:57.519 ArraryTest_Order[22759:11303] 排序后:(
    0,
    1,
    23,
    90,
    99,
    1000
	)
	2013-04-27 15:55:57.520 ArraryTest_Order[22759:11303] sortUsingSelector
	2013-04-27 15:55:57.520 ArraryTest_Order[22759:11303] 原始的：
	2013-04-27 15:55:57.520 ArraryTest_Order[22759:11303] 90
	2013-04-27 15:55:57.521 ArraryTest_Order[22759:11303] 23
	2013-04-27 15:55:57.521 ArraryTest_Order[22759:11303] 1
	2013-04-27 15:55:57.562 ArraryTest_Order[22759:11303] 1000
	2013-04-27 15:55:57.563 ArraryTest_Order[22759:11303] 0
	2013-04-27 15:55:57.563 ArraryTest_Order[22759:11303] 99
	2013-04-27 15:55:57.564 ArraryTest_Order[22759:11303] 排序后:
	2013-04-27 15:55:57.564 ArraryTest_Order[22759:11303] 0
	2013-04-27 15:55:57.564 ArraryTest_Order[22759:11303] 1
	2013-04-27 15:55:57.565 ArraryTest_Order[22759:11303] 23
	2013-04-27 15:55:57.565 ArraryTest_Order[22759:11303] 90
	2013-04-27 15:55:57.566 ArraryTest_Order[22759:11303] 99
	2013-04-27 15:55:57.566 ArraryTest_Order[22759:11303] 1000
	2013-04-27 15:55:57.566 ArraryTest_Order[22759:11303] 反序后:
	2013-04-27 15:55:57.567 ArraryTest_Order[22759:11303] 1000
	2013-04-27 15:55:57.567 ArraryTest_Order[22759:11303] 99
	2013-04-27 15:55:57.568 ArraryTest_Order[22759:11303] 90
	2013-04-27 15:55:57.568 ArraryTest_Order[22759:11303] 23
	2013-04-27 15:55:57.568 ArraryTest_Order[22759:11303] 1
	2013-04-27 15:55:57.569 ArraryTest_Order[22759:11303] 0

