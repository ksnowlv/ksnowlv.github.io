---
title: "swift call c"
date: 2019-04-01
categories:
  - "swift"
tags:
  - "swift"
---
<!--more-->


如何在swift调整c代码呢？

*swift通过工程的桥接文件，调用oc或c的相关代码!!!*


#### 1.创建c文件：`test.h`和`test.c`
`test.h`内容如下：

```objective-c
#ifndef test_h
#define test_h

#include <stdio.h>

void showValue(int *value);

#endif /* test_h */

```

`test.c`内容如下


```objective-c

#include "test.h"

void showValue(int *value) {
    printf("old value = %d\n",*value);
    *value = *value + 1;
    printf("new value = %d\n",*value);
}

```


#### 2.在桥接文件中,加入`test.h`引用：`#include "test.h"`
#### 3.swift中调用
```objective-c
   var value: Int32 = 0
   showValue(&value)
   
```

结果显而易见：

```objective-c
old value = 0
new value = 1

```

