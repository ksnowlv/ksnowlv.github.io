---
title: "XCode6下Too many arguments to function call, expected 0, have 2解决办法"
date: 2014-09-07
categories:
  - "iOS"
tags:
  - "iOS"
---
<!--more-->

#### 在XCode6下，写了如下一段代码：
``` objective-c


   NSLock *myLock = [NSLock new];
   IMP lockIMP = [myLock methodForSelector:lockSEL];
   lockIMP(myLock,lockSEL);
```
总是报错

    “Too many arguments to function call, expected 0, have 2”

<!--more-->
#### 后来发现在使用objc_msgSend编译时，与IMP报错类似。
#### 原来是LLVM升级后，增加一些默认设置    
    objc_msgSend without a typecast is usually an error  
    Recommended build setting for strict checking

  那我们在**Build Setting**->**Apple LLVM 6.0 - Preprocessing**下，把**Enable Strict Check for objc_msgSend Call**设置为`NO`即可。
  
   ![image](/images/post/2014-09-07-xcode6-too-many-arguments-to-function-call-expected-0-have-2/xcode_build_error_process.png) 
