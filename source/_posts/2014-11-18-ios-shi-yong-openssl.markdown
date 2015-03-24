---
layout: post
title: "iOS使用OpenSSL"
date: 2014-11-18 17:18
comments: true
categories: iOS-安全
---
`iOS`中`OpenSSL`

    If your app depends on OpenSSL,you should compile OpenSSL yourself 
    and statically link a known version of OpenSSL into your app. 
    This use of OpenSSL is possible on both OS X and iOS. However, 
    unless you are trying to maintain source compatibility with an existing open source project, 
    you should generally use a different API.

苹果建议采用系统原生的

    Common Crypto and Security Transforms are the recommended alternatives for general encryption.
     CFNetwork and Secure Transport are the recommended alternatives for secure communications.

如果你必须使用`OpenSSL`，可以直接源代码的形式或库的形式引入Xcode工程中。
参考[OpenSSL-for-iPhone](https://github.com/x2on/OpenSSL-for-iPhone)