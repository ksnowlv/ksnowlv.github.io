---
title: "iOS集合类深拷贝"
date: 2014-08-19
categories:
  - "iOS-基础"
tags:
  - "iOS-基础"
---
<!--more-->

iOS集合类默认是浅拷贝，那如何深拷贝呢？

<!--more-->

#### 1.集合类的浅拷贝:
``` objective-c

NSMutableArray *newNames =  [[NSMutableArray alloc] initWithArray:names];

```

#### 2.集合类的深拷贝:
``` objective-c

NSMutableArray *newNames =  [[NSMutableArray alloc] initWithArray:names copyItems:YES];

```

#### 3.特殊场景下的集合类真正的深拷贝:
如果对于集合类中含有集合类的情况呢？
要实现真正的深拷贝,可以通过序列化(`archive`)和反序列化(`unarchive`)该集合类。

``` objective-c

NSArray* trueDeepCopyArray = [NSKeyedUnarchiver unarchiveObjectWithData:
                                      [NSKeyedArchiver archivedDataWithRootObject:names]];
                                      
```                                      

但是，这种代价相比较而言比较高，慎用!