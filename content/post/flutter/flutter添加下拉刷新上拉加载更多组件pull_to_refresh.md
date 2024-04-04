---
title: "Flutter添加下拉刷新上拉加载更多组件pull_to_refresh"
date: 2024-03-27T09:14:32+08:00
lastmod: 2024-03-27T09:14:32+08:00
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


## pull_to_refresh的使用

### 1.pull_to_refresh

官方链接见[https://pub-web.flutter-io.cn/packages/pull_to_refresh](https://pub-web.flutter-io.cn/packages/pull_to_refresh)

支持Android/iOS/linux/MacOS/Web/Windows

### 2.pubspec.yaml添加依赖

```yaml
  pull_to_refresh: ^2.0.0 
```

### 3.示例

* pull_to_refresh_page.dart

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PullToRefreshWidget extends StatefulWidget {
  const PullToRefreshWidget({super.key});

  @override
  PullToRefreshWidgetState createState() => PullToRefreshWidgetState();
}

class PullToRefreshWidgetState extends State<PullToRefreshWidget> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  List<String> _items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('支持下拉的列表'),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(
          complete: Text(
            '刷新完成',
            style: TextStyle(color: Colors.blue),
          ),
          failed: Text(
            '刷新失败',
            style: TextStyle(color: Colors.red),
          ),
        ),
        footer: CustomFooter(
          builder: (context, mode) {
            Widget body;

            if (mode == LoadStatus.idle) {
              body = const Text('卡拉刷新');
            } else if (mode == LoadStatus.loading) {
              body = const CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = const Text('加载失败，请重试');
            } else if (mode == LoadStatus.canLoading) {
              body = const Text('释放加载更多');
            } else {
              body = const Text('没有更多数据了');
            }
            debugPrint('mode:$mode');

            return SizedBox(
              height: 40,
              child: Center(
                child: body,
              ),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh, // 下拉刷新
        onLoading: _onLoading, // 上拉加载更多
        child: ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(title: Text('列表项 显示内容:${_items[index]} '));
            },
            itemCount: _items.length),
      ),
    );
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 500));

    _items.clear();

    for (int i = 0; i < 10; i++) {
      _items.add('${i + 1}');
    }

    ++_count;

    if (mounted) setState(() {});

    if (_count > 3) {
      _refreshController.refreshFailed();
      _count = 0;
    } else {
      _refreshController.refreshCompleted();
    }
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 500));

    int count = _items.length + 1;

    for (int i = 0; i < 10; i++) {
      _items.add('${i + count}');
    }

    if (mounted) setState(() {});

    _refreshController.loadComplete();
  }
}


```
### 4.小结

* 同类组件对比（2024年3月27日）

| 组件 | LIKES | PUB PINTS | POPULARITY | 
|----|-------|-----------|------------|
| pull_to_refresh   | 2472  | 120       | 99%        | 
| flutter_refresh   | 0     | 30        | 71%        |  
|  easy_refresh  | 347   | 130       | 98%        |  
| smart_refresher   | 3     | 100       | 82%        |  

建议优先**pull_to_refres**h；其它的如何选择，大家各任所爱，想尝试新的组件也可以体验下。

* pull_to_refres组件
  * 提供了丰富的自定义选项，可以定制下拉刷新和上拉加载更多的样式。
  * 支持多种刷新指示器（indicator）以及自定义indicator的功能。 上述示例，仅仅作为展示。

