---
title: "鸿蒙arkts如何进行json数据和对象互转-使用JSON库"
date: 2024-05-29T11:20:29+08:00
lastmod: 2024-05-29T11:20:29+08:00
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

### 1.鸿蒙系统arkts使用JSON库

JSON库中提供json数据和对象互转方式

```js
interface JSON {
    /**
     * Converts a JavaScript Object Notation (JSON) string into an object.
     * @param text A valid JSON string.
     * @param reviver A function that transforms the results. This function is called for each member of the object.
     * If a member contains nested objects, the nested objects are transformed before the parent object is.
     */
    parse(text: string, reviver?: (this: any, key: string, value: any) => any): any;
    /**
     * Converts a JavaScript value to a JavaScript Object Notation (JSON) string.
     * @param value A JavaScript value, usually an object or array, to be converted.
     * @param replacer A function that transforms the results.
     * @param space Adds indentation, white space, and line break characters to the return-value JSON text to make it easier to read.
     */
    stringify(value: any, replacer?: (this: any, key: string, value: any) => any, space?: string | number): string;
    /**
     * Converts a JavaScript value to a JavaScript Object Notation (JSON) string.
     * @param value A JavaScript value, usually an object or array, to be converted.
     * @param replacer An array of strings and numbers that acts as an approved list for selecting the object properties that will be stringified.
     * @param space Adds indentation, white space, and line break characters to the return-value JSON text to make it easier to read.
     */
    stringify(value: any, replacer?: (number | string)[] | null, space?: string | number): string;
}
```

### 2.示例

#### 2.1.`Json`文件
```js
{
    "userInfo":{
      "name":"lili",
      "age":30,
      "address":"北京市",
      "account":"ksnowlv"
    },
    "subscriptions":[
      {
        "title":"Flutter入门指南",
        "subtitle":"从零开始学习Flutter",
        "content":"Flutter是一种用于创建跨平台移动应用程序的开源UI工具包。",
        "subscriptionId":"sub001",
        "likes":100
      },
      {
        "title":"Dart编程语言介绍",
        "subtitle":"学习Dart的基本语法和特性",
        "content":"Dart是一种由Google开发的面向对象、类似Java和JavaScript的新型编程语言。",
        "subscriptionId":"sub002",
        "likes":85
      }
    ]
   }
```

#### 2.2.`Json`转换为类

```js
export class MyUser {
	userInfo?: UserInfo
	subscriptions?: Subscriptions[]
}

export class Subscriptions {
	title?: string
	subtitle?: string
	content?: string
	subscriptionId?: string
	likes?: number
}

export class UserInfo {
	name?: string
	age?: number
	address?: string
	account?: string
}

```

#### 2.3.`Json`转换为对象

```js

    @State myUser: MyUser = null

    try {
        this.myUser = JSON.parse(this.jsonContent);
        const userInfo = this.myUser.userInfo;
        console.info(`${this.TAG} userInfo Name: ${userInfo.name} Age: ${userInfo.age} Address: ${userInfo.address} Account: ${userInfo.account}`)

        const subscriptions = this.myUser.subscriptions;

        subscriptions.forEach((subscription, index) => {
            console.info(`${this.TAG} Subscription ${index + 1}:`);
            console.info(`${this.TAG}  Title: ${subscription.title}`);
            console.info(`${this.TAG}  Subtitle: ${subscription.subtitle}`);
            console.info(`${this.TAG}  Content: ${subscription.content}`);
            console.info(`${this.TAG}  Subscription ID: ${subscription.subscriptionId}`);
            console.info(`${this.TAG}  Likes: ${subscription.likes}`);
        });
    } catch (error) {
        console.error(`${this.TAG} json content:${JSON.stringify(error)}}`)
    }
```

#### 2.4.对象转换`Json`

```js
	try {
        let json = JSON.stringify(this.myUser)
        console.info(`${this.TAG} objectToJson jsonString :${json}}`)
    } catch (error) {
        console.error(`${this.TAG} json content:${JSON.stringify(error)}}`)
    }
```

### 3.效果

前端页面显示
![image](/images/hmos/hmos-arkts如何进行json数据和对象互转-使用JSON库/result.png)



日志输出

```shell
05-29 11:32:26.418  20966-7914   0FEFE/JsApp                                        com.example.base_demo                          I  NetPage userInfo Name: lili Age: 30 Address: 北京市 Account: ksnowlv
05-29 11:32:26.419  20966-7914   0FEFE/JsApp                                        com.example.base_demo                          I  NetPage Subscription 1:
05-29 11:32:26.419  20966-7914   0FEFE/JsApp                                        com.example.base_demo                          I  NetPage  Title: Flutter入门指南
05-29 11:32:26.419  20966-7914   0FEFE/JsApp                                        com.example.base_demo                          I  NetPage  Subtitle: 从零开始学习Flutter
05-29 11:32:26.419  20966-7914   0FEFE/JsApp                                        com.example.base_demo                          I  NetPage  Content: Flutter是一种用于创建跨平台移动应用程序的开源UI工具包。
05-29 11:32:26.420  20966-7914   0FEFE/JsApp                                        com.example.base_demo                          I  NetPage  Subscription ID: sub001
05-29 11:32:26.420  20966-7914   0FEFE/JsApp                                        com.example.base_demo                          I  NetPage  Likes: 100
05-29 11:32:26.420  20966-7914   0FEFE/JsApp                                        com.example.base_demo                          I  NetPage Subscription 2:
05-29 11:32:26.420  20966-7914   0FEFE/JsApp                                        com.example.base_demo                          I  NetPage  Title: Dart编程语言介绍
05-29 11:32:26.420  20966-7914   0FEFE/JsApp                                        com.example.base_demo                          I  NetPage  Subtitle: 学习Dart的基本语法和特性
05-29 11:32:26.420  20966-7914   0FEFE/JsApp                                        com.example.base_demo                          I  NetPage  Content: Dart是一种由Google开发的面向对象、类似Java和JavaScript的新型编程语言。
05-29 11:32:26.420  20966-7914   0FEFE/JsApp                                        com.example.base_demo                          I  NetPage  Subscription ID: sub002
05-29 11:32:26.420  20966-7914   0FEFE/JsApp                                        com.example.base_demo                          I  NetPage  Likes: 85
05-29 11:32:44.805  20966-7914   0FEFE/JsApp                                        com.example.base_demo                          I  NetPage objectToJson jsonString :{"userInfo":{"name":"lili","age":30,"address":"北京市","account":"ksnowlv"},"subscriptions":[{"title":"Flutter入门指南","subtitle":"从零开始学习Flutter","content":"Flutter是一种用于创建跨平台移动应用程序的开源UI工具包。","subscriptionId":"sub001","likes":100},{"title":"Dart编程语言介绍","subtitle":"学习Dart的基本语法和特性","content":"Dart是一种由Google开发的面向对象、类似Java和JavaScript的新型编程语言。","subscriptionId":"sub002","likes":85}]}}

```




