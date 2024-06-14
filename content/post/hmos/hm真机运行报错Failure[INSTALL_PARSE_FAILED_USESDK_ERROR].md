---
title: "鸿蒙真机运行报错Failure[INSTALL_PARSE_FAILED_USESDK_ERROR]"
date: 2024-05-10T15:25:49+08:00
lastmod: 2024-05-10T15:25:49+08:00
keywords: ["HMOS"]
tags: ["HMOS"]
categories: ["HMOS"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 1.问题


鸿蒙真机运行报错Failure[INSTALL_PARSE_FAILED_USESDK_ERROR]，如何解决呢？

    compileSdkVersion and releaseType of the app do not match the apiVersion and releaseType on the device.


### 2.原因

编译sdk版本高于真机SDK版本。先确定真机SDK版本

#### 2.1 查看设备版本信息

使用工具链为：`/Users/用户名/Library/Huawei/Sdk/hmscore/3.1.0/toolchains`目录

添加环境变量

    export HDC_HOME=/Users/ksnowlv/Library/Huawei/Sdk/hmscore/3.1.0/toolchains

先使用`hdc list targets`查看设备,再查看设备`apiversion`与`releasetype`

```shell
ksnowlv@MacBook-Pro-3 Hello_hoos_world % hdc list targets
GBG5T19710007532        device
emulator-5554   device

ksnowlv@MacBook-Pro-3 Hello_hoos_world % hdc -t GBG5T19710007532 shell getprop hw_sc.build.os.apiversion
6
ksnowlv@MacBook-Pro-3 Hello_hoos_world % hdc -t GBG5T19710007532 shell getprop hw_sc.build.os.releasetype
Release

```

![image](/images/hmos/hm真机运行报错Failure%5BINSTALL_PARSE_FAILED_USESDK_ERROR%5D/api_list.png)





### 2.解决方案

下载api版本为6的SDK版本

修改项目根目录下的`build-profile.json5`文件中的`compileSdkVersion`和`compatibleSdkVersion`

```json
{
  "app": {
    "signingConfigs": [
      {
        "name": "default",
        "type": "HarmonyOS",
        "material": {
          "certpath": "/Users/ksnowlv/.ohos/config/auto_debug_Hello_hoos_world_com.example.hello_hoos_world_420086000303510047.cer",
          "storePassword": "0000001BD2A2C2CD5BAB52C92ADB8CA3295B04BF0FCE4CE894A05DA06E0308B50980614A9526DA881CA8FB",
          "keyAlias": "debugKey",
          "keyPassword": "0000001BE1F52DE9FC961251900696A105654889C2594855940377CC0A21F378BF43D503B314BFC6590CC1",
          "profile": "/Users/ksnowlv/.ohos/config/auto_debug_Hello_hoos_world_com.example.hello_hoos_world_420086000303510047.p7b",
          "signAlg": "SHA256withECDSA",
          "storeFile": "/Users/ksnowlv/.ohos/config/auto_debug_Hello_hoos_world_com.example.hello_hoos_world_420086000303510047.p12"
        }
      }
    ],
    "compileSdkVersion": 9,
    "compatibleSdkVersion": 9,
    "products": [
      {
        "name": "default",
        "signingConfig": "default",
      }
    ]
  },
  "modules": [
    {
      "name": "entry",
      "srcPath": "./entry",
      "targets": [
        {
          "name": "default",
          "applyToProducts": [
            "default"
          ]
        }
      ]
    }
  ]
}
```

重新编译运行即可。
