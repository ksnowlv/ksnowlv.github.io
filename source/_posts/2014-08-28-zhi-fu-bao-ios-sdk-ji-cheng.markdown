---
layout: post
title: "支付宝iOS-SDK集成"
date: 2014-08-28 19:33
comments: true
categories: iOS
---

####1.下载SDK.
   支付宝API网址：[支付宝SDK](http://club.alipay.com/read-htm-tid-9976972.html)。iOS版本的，可以在无线产品中下载。

<!--more-->

![image](/images/post/2014-08-28-zhi-fu-bao-ios-sdk-ji-cheng/iOS_Android_API_download.png)

####2.集成**iOS SDK**前的准备。

![image](/images/post/2014-08-28-zhi-fu-bao-ios-sdk-ji-cheng/API_use.png)

####3.iOS SDK配置信息更新。
签约通过后，在**iOS**版本**AlipaySdkDemo**目录下找到**PartnerConfig.h**文件，更新配置信息。

``` objective-c

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @""
//收款支付宝账号
#define SellerID  @""

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @""

//商户私钥，自助生成
#define PartnerPrivKey @""


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

```

####4.集成支付相关功能。

**总体感受:支付宝SDK官网真做的粗糙呃。**
