---
title: "swift调用C"
date: 2019-04-01
lastmod: 2019-04-01
categories:
  - "swift"
tags:
  - "swift"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---


swift中如何调用C代码呢？

*swift通过工程的桥接文件，调用OC或C相关代码!!!*


### 1.C文件
`test.h`和`test.c`

`test.h`

```c
#ifndef test_h
#define test_h

#include <stdio.h>

void showValue(int *value);

#endif /* test_h */

```

`test.c`


```c

#include "test.h"

void showValue(int *value) {
    printf("old value = %d\n",*value);
    *value = *value + 1;
    printf("new value = %d\n",*value);
}

```


### 2.swift桥接文件

加入`test.h`引用：`#include "test.h"`

### 3.swift中调用

```swift
   var value: Int32 = 0
   showValue(&value)
   
```

结果显而易见：

```terminal
old value = 0
new value = 1

```

