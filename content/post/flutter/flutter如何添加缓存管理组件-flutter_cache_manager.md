---
title: "Flutter如何添加缓存管理组件-Flutter_cache_manager"
date: 2024-05-03T21:20:07+08:00
lastmod: 2024-05-03T21:20:07+08:00
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


### 1.flutter_cache_manager

官方链接见[https://pub-web.flutter-io.cn/packages/flutter_cache_manager](https://pub-web.flutter-io.cn/packages/flutter_cache_manager)

支持Android/iOS/linux/MacOS/Web/Windows

### 2.pubspec.yaml添加依赖

```yaml
    flutter_cache_manager: ^3.3.2
```

### 3.使用示例

#### 3.1 缓存使用示例

```dart
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class FlutterCacheManagerPage extends StatefulWidget {
  const FlutterCacheManagerPage({super.key});

  @override
  State<FlutterCacheManagerPage> createState() =>
      _FlutterCacheManagerPageState();
}

class _FlutterCacheManagerPageState extends State<FlutterCacheManagerPage> {
  final url =
      'https://u7.iqiyipic.com/image/20240328/b7/69/pv_2448711522921100_d_601_480_270.jpg';

  Stream<FileResponse>? fileStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FlutterCacheManagerPage'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('FlutterCacheManager的使用'),
              FutureBuilder(
                future: DefaultCacheManager().getSingleFile(url),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                  } else if (snapshot.hasData) {
                    return Image.file(snapshot.data!);
                  } else if (snapshot.hasError) {
                    debugPrint('Error: ${snapshot.error}');
                    return Text('Error: ${snapshot.error}');
                  }

                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  await DefaultCacheManager().emptyCache();
                },
                child: const Text('clear all cache file'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  await DefaultCacheManager().removeFile(url);
                },
                child: const Text('clear single cache file'),
              ),

            ],
          ),
        ));
  }
}
```


主要代码介绍

* FutureBuilder：是一个 Flutter 小部件，用于从异步操作中获取数据并构建界面。在本例中，它用于从 DefaultCacheManager().getSingleFile(url) 获取图片文件。FutureBuilder 的 builder 回调根据 snapshot 的状态显示不同的内容：
如果连接状态是 ConnectionState.waiting，则不显示任何内容。
如果 snapshot 有数据，则显示一个 Image.file 小部件，使用获取的文件数据来显示图片。
如果 snapshot 有错误，则打印错误并显示一个文本错误消息。

* 第一个ElevatedButton按钮：用于清空所有缓存文件，当按下时，调用 DefaultCacheManager().emptyCache() 来清空缓存。
* 第二个ElevatedButton按钮：用于清除特定 URL 的缓存文件，当按下时，调用 DefaultCacheManager().removeFile(url) 来移除对应 URL 的缓存文件。

#### 3.2.关于DefaultCacheManager

flutter_cache_manager包提供的一个类，用于管理网络资源的缓存，如图片、视频，其它资源文件等，也支持自定义缓存类。

### 4.效果

![image](/images/flutter/flutter如何添加缓存管理组件-flutter_cache_manager/result.png)


