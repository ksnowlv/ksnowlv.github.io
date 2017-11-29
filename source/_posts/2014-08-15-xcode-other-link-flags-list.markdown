---
layout: post
title: Xcode-other-link-flags支持的参数
date: 2014-08-15 08:14
comments: true
categories: Xcode
---
####Xcode的"`other link flags`"都支持哪些选项呢？
<!--more-->

可参考[http://stackoverflow.com/questions/14497872/other-linker-flags-list](http://stackoverflow.com/questions/14497872/other-linker-flags-list)中提到的“ `man ld`”命令,在`Mac Terminal`下是有效的


    ksnowlv@ksnowlvdeMacBook-Pro~$man ld

![image](/images/post/2014-08-15-xcode-other-link-flags-list/overview.png)

####我们常用`-ObjC`,`-all_load`,`-force_load`

![image](/images/post/2014-08-15-xcode-other-link-flags-list/other_link_flag.png)




