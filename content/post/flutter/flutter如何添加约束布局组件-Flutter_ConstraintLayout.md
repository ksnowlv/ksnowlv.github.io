---
title: "Flutter如何添加约束布局组件-Flutter_ConstraintLayout(登陆页面为例)"
date: 2024-05-03T21:43:20+08:00
lastmod: 2024-05-03T21:43:20+08:00
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


### 1.约束布局的核心

任何UI布局核心在于计算子控件的大小和位置。而约束布局的核心在于使用约束布局来计算子控件的大小和位置，

### 2.约束布局优势

* 2.1. 可以减少UI而已层级，使布局层次更加扁平化，可以提升渲染性能。
* 2.2. 所见即所得的灵活排版布局能力，可以更高效的开发UI页面。

Android 中有约束布局组件，而flutter也有开源的第三方组件[https://github.com/hackware1993/Flutter_ConstraintLayout](https://github.com/hackware1993/Flutter_ConstraintLayout)

支持Android/iOS/linux/MacOS/Web/Windows

### 3.pubspec.yaml添加依赖

```yaml
    flutter_constraintlayout: ^1.7.0-stable
```

### 4.使用示例

#### 4.1 使用示例

```dart
import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';

class ConstraintLayoutPage extends StatefulWidget {
  const ConstraintLayoutPage({Key? key}) : super(key: key);

  @override
  State<ConstraintLayoutPage> createState() => _ConstraintLayoutPageState();
}

class _ConstraintLayoutPageState extends State<ConstraintLayoutPage> {
  final ConstraintId appLogoId = ConstraintId('appLogoId');
  final ConstraintId appTitleId = ConstraintId('appTitleId');
  final ConstraintId appAccountId = ConstraintId('appAccountId');
  final ConstraintId passwordId = ConstraintId('passwordId');
  final ConstraintId loginId = ConstraintId('loginId');
  final ConstraintId registId = ConstraintId('registId');
  final ConstraintId otherId = ConstraintId('otherId');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConstraintLayout'),
      ),
      body: ConstraintLayout(
        children: <Widget>[
          _buildAppLogo(),
          _buildAppTitle(),
          _buildInputContainer(
            id: appAccountId,
            topConstraint: appTitleId.bottom.margin(40),
            hintText: '请输入账户名',
            icon: Icons.person,
          ),
          _buildInputContainer(
            id: passwordId,
            topConstraint: appAccountId.bottom.margin(20),
            hintText: '请输入密码',
            icon: Icons.password,
          ),
          _buildElevatedButton(
            id: loginId,
            topConstraint: passwordId.bottom.margin(70),
            buttonText: '登陆',
            backgroundColor: const Color(0xff5B70CF),
          ),
          _buildElevatedButton(
            id: registId,
            topConstraint: loginId.bottom.margin(30),
            buttonText: '注册',
            backgroundColor: const Color(0xffF8644E),
          ),
          _buildTextWithConstraints(
            id: otherId,
            text: '其他方式登录',
            topConstraint: registId.bottom.margin(60),
            centerHorizontalTo: parent,
          ),
          _buildSocialLoginRow(),
        ],
      ),
    );
    // // AppBar
  }
  // 构建logo
  Widget _buildAppLogo() {
    return Image.asset(
      'assets/images/login/app_logo.png',
      width: 120,
    ).applyConstraint(
      top: parent.top.margin(60),
      left: parent.left.margin(20),
      right: parent.right.margin(20),
      id: appLogoId,
    );
  }
  // 构建app的名称
  Widget _buildAppTitle() {
    return const Text(
      "APP Name",
      style: TextStyle(fontSize: 20, color: Color(0xFFBECEFA)),
    ).applyConstraint(
      id: appTitleId,
      top: appLogoId.bottom.margin(10),
      left: parent.left,
      right: parent.right,
    );
  }

  // 构建输入框:账号/密码
  Widget _buildInputContainer({
    required ConstraintId id,
    required ConstraintAlign topConstraint,
    required String hintText,
    required IconData icon,
  }) {
    return Container(
      color: const Color(0xFFF0F5FD),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(icon),
          const SizedBox(width: 20),
          Expanded(
            child: TextField(
              style: const TextStyle(
                color: Color(0xffA0ACD4),
                fontSize: 20,
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
    ).applyConstraint(
      id: id,
      width: matchConstraint,
      height: 60,
      top: topConstraint,
      left: parent.left.margin(20),
      right: parent.right.margin(20),
    );
  }

  // 构建登陆/注册
  Widget _buildElevatedButton({
    required ConstraintId id,
    required ConstraintAlign topConstraint,
    required String buttonText,
    required Color backgroundColor,
  }) {
    return ElevatedButton(
      onPressed: () {
        debugPrint('点击了按钮:$buttonText');
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    ).applyConstraint(
      id: id,
      top: topConstraint,
      width: matchConstraint,
      height: 60,
      left: parent.left.margin(120),
      right: parent.right.margin(120),
    );
  }

  // 构造说明文本
  Widget _buildTextWithConstraints({
    required ConstraintId id,
    required String text,
    required ConstraintAlign topConstraint,
    required ConstraintId centerHorizontalTo,
  }) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFFD5DFF2),
      ),
    ).applyConstraint(
      id: id,
      left: parent.left,
      right: parent.right,
      top: topConstraint,
      centerHorizontalTo: centerHorizontalTo,
    );
  }
  // 构建其它登录方式：微信，QQ，微博
  Widget _buildSocialLoginRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
        const SizedBox(width: 20),
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
        const SizedBox(width: 20),
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
      ],
    ).applyConstraint(
      width: matchParent,
      top: otherId.bottom.margin(20),
    );
  }
}


```

### 5.效果

![image](/images/flutter/flutter如何添加约束布局组件-Flutter_ConstraintLayout/result.png)

### 6.其它

#### 6.1. 和前文使用系统布局相比

* 使用上，UI层级有所减少；
* 性能上，性能提升多少和页面嵌套，复杂程度有关；对于一般简单页面，性能差异很很小。
* 学习成本上，有一定的提升；对熟悉Android约束布局的同学，无缝切换；
* 开发体验上，用法不当时，抛出一堆异常错误，没有系统原生布局直观，开发体验并不好。

选择使用哪种页面布局方式，可以根据项目，团队的情况，做出适当的选择；适合自己的就好。




