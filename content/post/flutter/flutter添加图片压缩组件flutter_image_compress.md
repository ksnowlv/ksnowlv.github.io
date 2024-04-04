---
title: "Flutter添加图片压缩组件flutter_image_compress"
date: 2024-03-30T22:42:38+08:00
lastmod: 2024-03-30T22:42:38+08:00
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



## flutter_image_compress的使用

### 1.flutter_image_compress

官方链接见[https://pub-web.flutter-io.cn/packages/flutter_image_compress](https://pub-web.flutter-io.cn/packages/flutter_image_compress)

支持Android/iOS/MacOS/Web

### 2.pubspec.yaml添加依赖

```yaml
     flutter_image_compress: ^2.2.0
```

### 3.示例

image_compress_page.dart

```dart
import 'dart:io';
import 'dart:typed_data';

import 'package:base_demo/common/file_mgr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/services.dart' show rootBundle;

class ImageCompressPage extends StatefulWidget {
  const ImageCompressPage({super.key});

  @override
  State<ImageCompressPage> createState() => _ImageCompressPageState();
}

class _ImageCompressPageState extends State<ImageCompressPage> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_image_compress'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          _imageFile != null
              ? Image.file(
            _imageFile!,
            width: 500,
            height: 500,
            fit: BoxFit.contain,
          )
              : Container(),
          ElevatedButton(
              onPressed: () {
                compressImageAndDisplay();
              },
              child: const Text('图片压缩:compressImageAndDisplay')),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                compressImageWithQualityAndDisplay();
              },
              child: const Text('图片压缩:compressImageWithQualityAndDisplay')),
        ]),
      ),
    );
  }

  Future<void> compressImageAndDisplay() async {
    ByteData data = await rootBundle.load('assets/images/large_image.png');
    List<int> compressedImage = await FlutterImageCompress.compressWithList(
      data.buffer.asUint8List(),
      minHeight: 1920,
      minWidth: 1080,
      quality: 80,
    );

    debugPrint(
        'before compressImage data:${data.lengthInBytes}, after compressImage data:${compressedImage.length} ');

    final tempPath = await FileMgr.instance.getDocumentsDirectory();
    final File imgFile = await File('$tempPath/compressed_image.jpg')
        .writeAsBytes(compressedImage);

    setState(() {
      _imageFile = imgFile;
    });
  }

  // 1. compress file and get Uint8List
  Future<void> compressImageWithQualityAndDisplay() async {
    ByteData data = await rootBundle.load('assets/images/large_image.png');
    List<int> compressedImage = await FlutterImageCompress.compressWithList(
      data.buffer.asUint8List(),
      minHeight: 1920,
      minWidth: 1080,
      quality: 80,
      rotate: 90,
    );

    debugPrint(
        'before compressImage data:${data.lengthInBytes}, after compressImage data:${compressedImage.length} ');

    final tempPath = await FileMgr.instance.getDocumentsDirectory();
    final File imgFile = await File('$tempPath/compressed_image1.jpg')
        .writeAsBytes(compressedImage);

    setState(() {
      _imageFile = imgFile;
    });
  }

  Future<Widget> _compressImageToWidget() async {
    ByteData data = await rootBundle.load('assets/images/large_image.png');

    ImageProvider provider = MemoryImage(data.buffer.asUint8List());
    return Image(image: provider);
  }
}

```



### 4.效果

![image](/images/flutter/flutter添加图片压缩组件flutter_image_compress/result0.png)

![image](/images/flutter/flutter添加图片压缩组件flutter_image_compress/result1.png)
