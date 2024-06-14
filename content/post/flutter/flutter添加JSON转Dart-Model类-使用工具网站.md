---
title: "Flutter添加JSON转Dart-Model类使用工具网站"
date: 2024-04-19T10:35:30+08:00
lastmod: 2024-04-19T10:35:30+08:00
keywords: ["flutter"]
tags: ["flutter"]
categories: ["flutter"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


### JSON转Dart-Model类使用工具网站
由于Flutter禁用运行时反射，所以Flutter中是没有类似GSON的库；我们借助第三方工具网站可以Json直接转对象。

例如： [app.quicktype.io](app.quicktype.io)提供JSON转换成模型，支持大部分常用语言，像Swift，C++，C，C#，GO，Rust，TS，JAVA，Python,JS等，还支持一些常用的选项。

### JSON转Dart-Model类示例

```json
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

转换为Dart-Model类后

```dart
// To parse this JSON data, do
//
//     final myUserInfo = myUserInfoFromJson(jsonString);

import 'dart:convert';

MyUserInfo myUserInfoFromJson(String str) => MyUserInfo.fromJson(json.decode(str));

String myUserInfoToJson(MyUserInfo data) => json.encode(data.toJson());

class MyUserInfo {
    UserInfo userInfo;
    List<Subscription> subscriptions;

    MyUserInfo({
        required this.userInfo,
        required this.subscriptions,
    });

    factory MyUserInfo.fromJson(Map<String, dynamic> json) => MyUserInfo(
        userInfo: UserInfo.fromJson(json["userInfo"]),
        subscriptions: List<Subscription>.from(json["subscriptions"].map((x) => Subscription.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "userInfo": userInfo.toJson(),
        "subscriptions": List<dynamic>.from(subscriptions.map((x) => x.toJson())),
    };
}

class Subscription {
    String title;
    String subtitle;
    String content;
    String subscriptionId;
    int likes;

    Subscription({
        required this.title,
        required this.subtitle,
        required this.content,
        required this.subscriptionId,
        required this.likes,
    });

    factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        title: json["title"],
        subtitle: json["subtitle"],
        content: json["content"],
        subscriptionId: json["subscriptionId"],
        likes: json["likes"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "content": content,
        "subscriptionId": subscriptionId,
        "likes": likes,
    };
}

class UserInfo {
    String name;
    int age;
    String address;
    String account;

    UserInfo({
        required this.name,
        required this.age,
        required this.address,
        required this.account,
    });

    factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        name: json["name"],
        age: json["age"],
        address: json["address"],
        account: json["account"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "age": age,
        "address": address,
        "account": account,
    };
}

```

### pubspec.yaml添加user_info.json配置文件

```yaml


  assets:
    - assets/images/
    - assets/lottie/
    - assets/audio/
    - assets/txt/
    - assets/json/

```

### 调用

```dart
void _jsonWithDartConvert() async {
    try {
      // 加载本地JSON文件
      String data = await rootBundle.loadString('assets/json/user_info.json');
      Map<String, dynamic> jsonMap = json.decode(data);
  
      MyUserInfo myUserInfo = MyUserInfo.fromJson(jsonMap);
      debugPrint('反序列化后 userInfo{ name :${myUserInfo.userInfo.name} age: ${myUserInfo.userInfo.age} address: ${myUserInfo.userInfo.address}  account :${myUserInfo.userInfo.account} ');
      
      for (var subscription in myUserInfo.subscriptions) {
        debugPrint('反序列化后subscription对象  { title :${subscription.title} subtitle: ${subscription.subtitle}}, content: ${subscription.content} likes: ${subscription.likes} }');
      }
      
      Map<String, dynamic> myUserJson = myUserInfo.toJson();
      debugPrint('序列化后Json数据: ${json.encode(myUserJson)}');
    } catch (e) {
      debugPrint('JSON deserialization error:$e');
    }
  }
```

### 效果

```shell
flutter: 反序列化后 userInfo{ name :li li age: 30 address: 北京市  account :ksnowlv 
flutter: 反序列化后subscription对象  { title :Flutter入门指南 subtitle: 从零开始学习Flutter}, content: Flutter是一种用于创建跨平台移动应用程序的开源UI工具包。 likes: 100 }
flutter: 反序列化后subscription对象  { title :Dart编程语言介绍 subtitle: 学习Dart的基本语法和特性}, content: Dart是一种由Google开发的面向对象、类似Java和JavaScript的新型编程语言。 likes: 85 }
flutter: 序列化后Json数据: {"userInfo":{"name":"li li","age":30,"address":"北京市","account":"ksnowlv"},"subscriptions":[{"title":"Flutter入门指南","subtitle":"从零开始学习Flutter","content":"Flutter是一种用于创建跨平台移动应用程序的开源UI工具包。","subscriptionId":"sub001","likes":100},{"title":"Dart编程语言介绍","subtitle":"学习Dart的基本语法和特性","content":"Dart是一种由Google开发的面向对象、类似Java和JavaScript的新型编程语言。","subscriptionId":"sub002","likes":85}]}
```

