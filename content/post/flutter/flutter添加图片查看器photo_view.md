---
title: "Flutter添加图片查看器photo_view"
date: 2024-03-19T10:08:50+08:00
lastmod: 2024-03-19T10:08:50+08:00
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

## photo_view的使用

### 1.photo_view

官方链接见[https://pub-web.flutter-io.cn/packages/photo_view](https://pub-web.flutter-io.cn/packages/photo_view)

支持Android/iOS/linux/MacOS/Web/Windows

### 2.pubspec.yaml添加依赖

```yaml
   photo_view: ^0.14.0
```

### 3.示例

```dart
 import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewWidget extends StatefulWidget {
  const PhotoViewWidget({super.key});

  @override
  PhotoViewWidgetState createState() => PhotoViewWidgetState();
}

class PhotoViewWidgetState extends State<PhotoViewWidget> {
  var imageUrls = [
    'https://img1.baidu.com/it/u=2205810988,4283060315&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500',
    'https://p4.itc.cn/q_70/images03/20230512/32c7ad09b5904bea8506d74f96483000.png',
    'http://pic1.win4000.com/wallpaper/2/5859e7ee330bb.jpg',
    'http://pic1.win4000.com/wallpaper/9/594cc06f555e8.jpg',
    'http://pic1.win4000.com/wallpaper/3/59292bb874fde.jpg',
    'https://img-baofun.zhhainiao.com/fs/dea71801d2aef7bc36690c5ae4f0e454.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: PhotoView(
            imageProvider: const AssetImage("images/photo_view_test.png"),
          ),
        ),
        Expanded(
          child: PhotoViewGallery.builder(
            itemCount: imageUrls.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageUrls[index]),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes: PhotoViewHeroAttributes(tag: 'tag$index'),
              );
            },
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            pageController: PageController(), // 可以传递自定义的PageController
          ),
        ),
      ],
    );
  }
}


```

### 4.效果

![image](/images/flutter/flutter添加图片查看器photo_view/result_1.png)

![image](/images/flutter/flutter添加图片查看器photo_view/result_2.png)

![image](/images/flutter/flutter添加图片查看器photo_view/result_3.png)
