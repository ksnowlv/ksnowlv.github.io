---
title: "XCConfig文件的使用"
date: 2014-08-31
categories:
  - "Xcode"
tags:
  - "Xcode"
---
<!--more-->
**XCConfig:XCode**的**Config**文件，可以方便的对项目工程进行配置。只需要引入该工程配置文件即可。

<!--more-->

1.分别创建**ConfigDebug.xcconfig**/**ConfigRelease.xcconfig**文件

![image](/images/post/2014-08-31-xcconfig-wen-jian-de-shi-yong/xconfig_create.png)

2.分别把**ConfigDebug.xcconfig**/**ConfigRelease.xcconfig**引入到工程配置中

![image](/images/post/2014-08-31-xcconfig-wen-jian-de-shi-yong/xcconfig_use.png)

3.编辑**ConfigDebug.xcconfig**/**ConfigRelease.xcconfig**文件，分别**对other link flag**和**Preprocessor Macros**修改设置查看生效情况。

展开"**other link flag**"后，直接选择**Release**整行复制到**ConfigRelease.xcconfig**中，再设置**-ObjC**，**-weak_framework UIKit**，** -framework CoreLocation**参数。

相同方法修改**ConfigDebug.xcconfig**即可。

**ConfigDebug.xcconfig**内容如下:

``` objective-c 

//:configuration = Debug
OTHER_LDFLAGS = -ObjC -weak_framework UIKit  -framework CoreLocation


//DEBUG __TAOBAOTEST__
GCC_PREPROCESSOR_DEFINITIONS = __TAOBAOTEST__= 0  $(inherited)

```

**ConfigRelease.xcconfig**内容如下:

``` objective-c 

//:configuration = Release
OTHER_LDFLAGS = -ObjC -weak_framework UIKit  -framework CoreLocation

```

4.修改完毕后，切换到XCConfigTest **TARGETS**视图查看设置。

                                other link flag
![image](/images/post/2014-08-31-xcconfig-wen-jian-de-shi-yong/other_link_flag_test.png)

                                Preprocessor Macros
![image](/images/post/2014-08-31-xcconfig-wen-jian-de-shi-yong/debug_flag_test.png)

5.添加测试代码对 *\__TAOBAOTEST__*宏的测试。
查看`debug`状态下生效情况。

![image](/images/post/2014-08-31-xcconfig-wen-jian-de-shi-yong/xcconfig_test.png)

显然，*\__TAOBAOTEST__*在`debug`状态下是生效的。
再测试下`release`状态下，是不生效的。

其它:

* 1.[CocoaPods](https://github.com/cocoapods/cocoapods)中使用`XCConfig`来进行配置。
* 2.[xcconfigs](https://github.com/jspahrsummers/xcconfigs)，一个支持`XCConfig`的开源库，支持对**iOS**/**Mac OS**配置。

#### 总结:不同的项目中，如果可以共用相同的配置环境，这种方式再方便不过了。