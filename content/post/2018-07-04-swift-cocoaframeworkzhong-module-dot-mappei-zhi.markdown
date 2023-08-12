---
title: "swift-cocoaframework中module.map配置"
date: 2018-07-04
categories:
  - "swift"
tags:
  - "swift"
---
<!--more-->
在swift framework中，如果要引用c库，可采用配置module.map.

那如何配置呢？我们以CommonCrypto为例。

##### 一.工程目录下创建CommonCrypto文件夹，并分别创建`module.map`和`YKBaseFramework-C.h`
* 1.`module.map`

```objective-c
module CommonCrypto [system] {
    //header "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/usr/include/CommonCrypto/CommonCrypto.h"

    //header "/usr/include/CommonCrypto/CommonCrypto.h"
    header "YKBaseFramework-C.h"
    link "CommonCrypto"
    export *
}

```
目录如下图，注意目录的相对路径
![image](/images/post/2018-07-04-swift-cocoaframeworkzhong-module-dot-mappei-zhi/modulemap_file.png) 

* 2.`YKBaseFramework-C.h`


```objective-c
//  YKBaseFramework-C.h
//  YKBaseFramework
//
//  Created by ksnowlv on 2018/7/4.
//  Copyright © 2018年 ksnowlv. All rights reserved.
//

#ifndef YKBaseFramework_C_h
#define YKBaseFramework_C_h

#include <CommonCrypto/CommonCrypto.h>

#endif /* YKBaseFramework_C_h */
```
	

##### 二.设置module.map编译器目录引用路径。在Build Settings, Swift Compiler – Search Paths 下 Import Paths中设置目录路径即可。

*注意与上图目录实际位置一致!!!*

![image](/images/post/2018-07-04-swift-cocoaframeworkzhong-module-dot-mappei-zhi/modulemap_setting.png) 

##### 三.引用`CommonCrypto`注意clean,在`swift code`直接引入`CommonCrypto`即可。

```objective-c
import Foundation
import Security
import CommonCrypto
```

#### 4.其它* 1.为什么不采用直接配置绝对路径引用CommonCrypto.h？

	配置为绝对路径，灵活性通用性实在太差，依赖于系统目录。
* 2.配置`CommonCrypto`时，注意目录所在路径
* 3.[https://github.com/IBM-Swift/CommonCrypto](https://github.com/IBM-Swift/CommonCrypto)

