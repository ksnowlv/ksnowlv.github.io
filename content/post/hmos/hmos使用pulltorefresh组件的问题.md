---
title: "HMOS使用pulltorefresh组件的问题"
date: 2024-05-23T14:46:26+08:00
lastmod: 2024-05-23T14:46:26+08:00
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


### 问题1：ohpm环境

    ohpm has not been initialized yet.Execute the init script to initialize it first.

#### 解决方案

我本地node版本较老，切换node版本

例如可切换到node 16

```shell

ksnowlv@MacBook-Pro-3 base_demo % ohpm install @ohos/PullToRefresh
ERROR: ohpm has not been initialized yet. Execute the init script to initialize it first.
ksnowlv@MacBook-Pro-3 base_demo % nvm ls
->     v10.24.1
v16.20.2
system
default -> 10.24.1 (-> v10.24.1)
iojs -> N/A (default)
unstable -> N/A (default)
node -> stable (-> v16.20.2) (default)
stable -> 16.20 (-> v16.20.2) (default)
lts/* -> lts/iron (-> N/A)
lts/argon -> v4.9.1 (-> N/A)
lts/boron -> v6.17.1 (-> N/A)
lts/carbon -> v8.17.0 (-> N/A)
lts/dubnium -> v10.24.1
lts/erbium -> v12.22.12 (-> N/A)
lts/fermium -> v14.21.3 (-> N/A)
lts/gallium -> v16.20.2
lts/hydrogen -> v18.20.2 (-> N/A)
lts/iron -> v20.13.0 (-> N/A)
ksnowlv@MacBook-Pro-3 base_demo % nvm use 16
Now using node v16.20.2 (npm v8.19.4)

```

### 问题2.pulltorefresh安装失败

    ohpm install @ohos/pulltorefresh Sorry, 报错 name contains invalid characters

#### 解决方案

`ohpm init`执行后，重新手动输入ohpm install @ohos/pulltorefresh


```shell
ksnowlv@MacBook-Pro-3 base_demo % ohpm init 
ksnowlv@MacBook-Pro-3 base_demo % ohpm install @ohos/pulltorefresh

ohpm INFO: fetch meta info of package '@ohos/pulltorefresh' success https://repo.harmonyos.com/ohpm/@ohos/pulltorefresh
ohpm INFO: fetch package done  1 @ohos/pulltorefresh https://contentcenter-drcn.dbankcdn.cn/pub_1/DevEcoSpace_DevEcoSpace_901_9/af/v3/154e3006-30bb-4951-82df-57abe0ffda37/pulltorefresh-2.0.5.har
install completed in 0s 509ms
```

### 3.问题3.pulltorefresh编译时报错

    hvigor ERROR: The compatibleSdkVersion 9 cannot be smaller than version 10 declared in library [:library]
              as the library might be using APIS not available in 9

#### 第一种解决方案

*  oh-package.json5 中@ohos/pulltorefresh的版本降级为2.0.1

````json
{
  "name": "base_demo",
  "version": "1.0.0",
  "description": "Please describe the basic information.",
  "main": "",
  "author": "",
  "license": "",
  "dependencies": {
    "@ohos/pulltorefresh": "^2.0.1"
  },
  "devDependencies": {
    "@ohos/hypium": "1.0.6"
  }
}
````
修改为


````json
{
  "name": "base_demo",
  "version": "1.0.0",
  "description": "Please describe the basic information.",
  "main": "",
  "author": "",
  "license": "",
  "dependencies": {
    "@ohos/pulltorefresh": "2.0.1"
  },
  "devDependencies": {
    "@ohos/hypium": "1.0.6"
  }
}
````

#### 第二种解决方案

升级`HUAWEI DevEco Studio`到4.0，同时API升级到10

见链接https://docs.openharmony.cn/pages/v4.0/zh-cn/release-notes/OpenHarmony-v4.0-release.md/#配套关系
