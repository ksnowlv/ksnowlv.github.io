---
title: "Flutter如何添加顶部tab切换页面"
date: 2024-05-05T18:13:26+08:00
lastmod: 2024-05-05T18:13:26+08:00
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


### 1.顶部tab切换页面

顶部tab切换页面，也是常见的一种交互；在flutter中如何实现呢？一般可以通过**DefaultTabController**和**TabBar**来实现，比iOS/Android简洁明了。


### 2.示例

```dart

import 'package:flutter/material.dart';

class MainTabBarView extends StatelessWidget {
  static final List<String> tabTitles = ['首页','通讯录','发现','我的'];

  const MainTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabTitles.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('flutter app'),
            bottom: TabBar(
              tabs: tabTitles.map((title) => Tab(text: title)).toList(),
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,//Colors.white
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontSize: 22,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 20,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              //若打开下述指示器效果，labelColor由Colors.blue更换为Colors.white
              // indicator: BoxDecoration(
              //   color:Colors.blue,// 背景颜色为蓝色
              //   border: Border.all(color: Colors.blue, width: 2),
              //   borderRadius: BorderRadius.circular(10),
              //   boxShadow: const [
              //     BoxShadow(
              //       color: Colors.blue,
              //       offset: Offset(3, 3),
              //       blurRadius: 5,
              //     ),
              //   ], // 阴影效果
              // ),
            ),
          ),
          body: const TabBarView(
            children: [
              HomeTab(),
              ContactsTab(),
              DiscoverTab(),
              MineTab(),
            ],
          ),
        ));
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('首页'),
    );
  }
}

class ContactsTab extends StatelessWidget {
  const ContactsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('通讯录'),
    );
  }
}
class DiscoverTab extends StatelessWidget {
  const DiscoverTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('发现'),
    );
  }
}

class MineTab extends StatelessWidget {
  const MineTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('我的'),
    );
  }
}


```

### 3.效果

默认效果如下

![image](/images/flutter/flutter如何添加顶部tab切换页面/result1.png)

打开**AppBar**中`indicator`和`labelColor`注释掉的代码，效果如下


![image](/images/flutter/flutter如何添加顶部tab切换页面/result2.png)

是不是很简单明了的想试试？那就下手吧~