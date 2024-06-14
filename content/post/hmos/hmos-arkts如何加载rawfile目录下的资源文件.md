---
title: "Hmos Arkts如何加载rawfile目录下的资源文件"
date: 2024-05-29T19:17:42+08:00
lastmod: 2024-05-29T19:17:42+08:00
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

### 1.鸿蒙`resources/rawfile`资源文件加载

如果`rawfile`目录的图片资源文件,可以通过资源ID的方式加载；

```js
    Image($rawfile('login/account.png'))
                .width(30)
                .height(30)
```

那如果是txt，json，音频等文件呢？

可以通过`ResourceManager`进行加载

### 2.示例

加载`rawfile`目录下的`json/user_info.json`文件

```js
	try {
        var context = getContext() as common.UIAbilityContext;
        ///json/article_info.json
        const rawFile = await context.resourceManager.getRawFileContent("/json/user_info.json")
        // let textDecoder = util.TextDecoder.create('gbk', { ignoreBOM: true });
        let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
        const result = textDecoder.decodeWithStream(rawFile, { stream: false })
        console.info(`${this.TAG} json content:${result}}`)
        this.jsonContent = result
    } catch (error) {
        console.info(`${this.TAG} json content:${JSON.stringify(error)}}`)
    }
```

记得添加相关库支持
```js
import common from '@ohos.app.ability.common';
import util from '@ohos.util';
```

### 3.效果

```js
05-29 11:12:39.271  20966-7914   0FEFE/JsApp                                        com.example.base_demo                          I  NetPage json content:{"article": {"id": 1234,"title": "Flutter JSON数据处理示例","content": "在Flutter中处理JSON数据的详细示例","author": {"id": 1234,"name": "ksnow"},"tags": ["Flutter","JSON","Dart"],"comments": [{"id": 1,"text": "非常详细，谢谢分享！","author": {"id": 1235,"name": "lucy"}},{"id": 2,"text": "JSON数据处理，非常好用","author": {"id": 1236,"name": "jack"}}]}}}

```

### 4.其它

如果是`txt/json/xml`等文本文件，注意文件本身的编码，不然，中文会乱码的。

