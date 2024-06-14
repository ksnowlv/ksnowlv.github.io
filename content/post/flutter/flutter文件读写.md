---
title: "Flutter文件读写"
date: 2024-04-07T18:18:07+08:00
lastmod: 2024-04-07T18:18:07+08:00
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

### Flutter文件读写
Flutter中文件读写是一个常见的操作，可以用于将数据保存到设备上的文件中，或者从文件中读取数据；

### 示例代码

```dart

import 'dart:io';

import 'package:base_demo/common/file_mgr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class FilePage extends StatefulWidget {
  final String title;
  const FilePage({super.key, required this.title});

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FutureBuilder(
              future: _readTxt(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error:${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Text('txt文件内容:${snapshot.data}');
                }
                return const Text('txt文件内容:正在加载');
              }),
          ElevatedButton(
              onPressed: () {
                _writeTxt();
              },
              child: const Text('write from txt')),
        ],
      ),
    );
  }

  Future<String> _readTxt() async {
    try {
      String txtContent = await rootBundle.loadString('assets/txt/test.txt');
      debugPrint('txtContent:$txtContent');
      return txtContent;
    } catch (e) {
      debugPrint('_writeTxt:$e');
      return '';
    }
  }

  Future<void> _writeTxt() async {
    try {
      const String data = 'Hello,World! /n测试';
      final directory = await FileMgr.instance.getTemporaryDirectoryPath();
      debugPrint('directory:$directory');
      final file = File('$directory/test.txt');
      await file.writeAsString(data);
    } catch (e) {
      debugPrint('_writeTxt:$e');
    }
  }
}


```

### 3.效果

![image](/images/flutter/flutter文件读写/result1.png)

![image](/images/flutter/flutter文件读写/result2.png)

### 4.小结

* 使用FutureBuilder通过_readTxt来异步加载数据，并显示。
* 使用_writeTxt向应用目录写入数据，因assets目录是只读的。
* 在iOS/Android移动设备上，注意权限处理。

