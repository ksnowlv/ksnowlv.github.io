---
title: "Flutter如何添加布局-Flutter系统布局(登陆页面为例)"
date: 2024-05-04T23:39:29+08:00
lastmod: 2024-05-04T23:39:29+08:00
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


### 1.UI布局的核心

任何UI布局核心在于计算子控件的大小和位置,本质是指定子控件的上、下、左、右，这直接决定了子控件的位置和大小。

### 2.flutter系统布局

flutter提供了多种容器与布局，像Container，SizeBox,ConstrainedBox,Expanded,Padding,Center,Row,Column,Flex等等


### 3.使用示例

#### 3.1 使用示例

```dart
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 60),
            Image.asset('assets/images/login/app_logo.png', width: 120),
            const SizedBox(height: 10),
            const Text(
              "测试APP",
              style: TextStyle(fontSize: 20, color: Color(0xFFBECEFA)),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: _buildTextField('请输入账户名', Icons.person),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: _buildTextField('请输入密码', Icons.password_rounded),
            ),
            const SizedBox(height: 40),
            _buildCustomButton('登陆', const Color(0xff5B70CF), () {
              debugPrint('点击了登陆按钮');
            }),
            _buildCustomButton('注册', const Color(0xffF8644E), () {
              debugPrint('点击了注册按钮');
            }),
            const SizedBox(height: 60),
            const Text(
              '其他方式登录',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFD5DFF2),
              ),
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                onTap: () {
                  debugPrint('点击了微信登录');
                },
                child: Image.asset(
                  'assets/images/login/wechat.png',
                  width: 40,
                  height: 40,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  debugPrint('点击了QQ登录');
                },
                child: Image.asset(
                  'assets/images/login/qq.png',
                  width: 40,
                  height: 40,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  debugPrint('点击了微博登录');
                },
                child: Image.asset(
                  'assets/images/login/weibo.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, IconData iconData) {
    return Container(
      height: 60,
      color: const Color(0xFFF0F5FD),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 10, right: 20),
            child: Icon(iconData),
          ),
          Expanded(
            child: TextField(
              style: const TextStyle(
                color: Color(0xffA0ACD4),
                fontSize: 20,
                // fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(color: Color(0xffA0ACD4)),
                labelStyle: const TextStyle(color: Color(0xffA0ACD4)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton(
      String text, Color color, void Function()? onPressed) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(120, 30, 120, 0),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

```

### 4.效果

![image](/images/flutter/flutter如何添加约束布局-Flutter系统布局/result.png)

### 5.其它

#### 5.1.UI布局

UI布局是前端技术基础技能，给想入门的演示下一些基本用法，提供个简单示例，不要被系统提供的二三十种UI布局的工具所吓倒，再复杂的页面，也是常用布局的一些组合，练练就知深浅。

#### 5.2.和其它平台对比

使用flutter系统自带UI容器和布局，构建页面，是不是很自然？相比Android/iOS/各有优势，不再赘述。相比windows,Linux，大家可以自己体会。