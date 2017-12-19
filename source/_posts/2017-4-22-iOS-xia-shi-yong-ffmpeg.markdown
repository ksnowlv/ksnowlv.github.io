---
layout: post
title: "iOS下使用ffmpeg"
date: 2017-4-22 11:55
comments: true
categories: iOS-基础 
---

iOS下如何使用FFmpeg呢？

<!--more-->

####1.[编译FFmpeg所需要的脚本文件gas-preprocessor.pl](https://github.com/mansr/gas-preprocessor) 
将脚本文件gas-preprocessor.pl复制到 */usr/bin/*目录

####2.[iOS平台下编译ffmpeg的脚本](https://github.com/kewlbear/FFmpeg-iOS-build-script)
执行**build-ffmpeg.sh**脚本。

```objective-c
 sudo ./build-ffmpeg.sh

```

![image](/images/post/2017-4-22-iOS-xia-shi-yong-ffmpeg/buildscript.png) 

编译成功后：

![image](/images/post/2017-4-22-iOS-xia-shi-yong-ffmpeg/buildscriptresult.png) 


####3.iOS工程集成。
#####1.头文件路径设置。

![image](/images/post/2017-4-22-iOS-xia-shi-yong-ffmpeg/libs.png) 

#####1.依赖库设置。
![image](/images/post/2017-4-22-iOS-xia-shi-yong-ffmpeg/pathsetting.png) 

####4.编译成功。