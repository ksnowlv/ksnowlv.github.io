---
title: "iOS-lua打补丁"
date: 2015-08-10
lastmod: 2015-08-10
categories:
  - "iOS"
tags:
  - "iOS"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

### 一.目的
##### 1.更改线上App小的功能点。#### 2.修复线上App的Bug。#### 3.对于iOS来讲，避免了漫长的AppStore审核。

### 二.方案。
 ![image](/images/post/2015-08-10-ios-luada-bu-ding/diagram_overview.jpg)
            
            
 
### 三.接口#### loadPatch
##### 参数：
* 平台：OSType(int)
 	* 0表示无意义
 	* 1表示iOS
 	* 2表示Android
* App版本号:appVersion(String)


##### 实体数据：
* 补丁包Id：patchId(若无补丁包，空串;如果非空串，有补丁包。)
		
		客户端如果发现本次patchId与上次保存补丁id不一致，即下载该补丁包。如果一致，无需重复下载，直接使用上次补丁包即可。
* 补丁包地址:patchUrl(String)	

#### 四.iOS具体方案
##### 1.采用lua与objective-c交互的方式，通过lua脚本替换objective-c函数的实现。##### 2.通过Wax加载后改变了既有Objective-C实现方法的指向函数，从而改变了程序的行为。##### 3.示例
**patch.lua**代码如下：


```objective-c

require "YKHomeViewController"

```
**YKHomeViewController.lua**代码如下：

```objective-c
waxClass{"YKHomeViewController", UIViewController}


function loadCache(self)
	local localCache = YKLocalCache:sharedLocalCache()
	local  userModel = YKUserManager:sharedYKUserManager():currentUser()

	local cacheData

	if  userModel  and userModel:userId() then
		cacheData = localCache:cacheFromLocalFile_withUserId("KYKLocalCacheHomeLogin",userModel:userId())
	else
		cacheData = localCache:cacheFromLocalFile("KYKLocalCacheHomeUnLogin")
	end	

	if  cacheData and cacheData:length() > 0   then
		local jsonDic = NSJSONSerialization:JSONObjectWithData_options_error(cacheData,0,nil);
		if jsonDic then
			self:handleHomeParser_withResponseData(jsonDic,cacheData)
		end
	else
		self:setupRefreshTableViewDataArrayData()
	end			
end

```

##### 4.简单脚本把文件压缩
```objective-c

#!/bin/bash

zip -r  lua.zip  lua

```

#### !!!* 1.注意不要用zip工具压缩，不然，解压时会失败。
* 2.64位的适配参考[https://github.com/maxfong/WaxPatch_X64](https://github.com/maxfong/WaxPatch_X64)


 	           