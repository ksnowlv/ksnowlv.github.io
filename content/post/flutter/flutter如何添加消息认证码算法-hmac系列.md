---
title: "Flutter如何添加消息认证码算法-HMAC系列"
date: 2024-05-06T11:37:20+08:00
lastmod: 2024-05-06T11:37:20+08:00
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

### 1.HMAC算法

HMAC（Hash-based Message Authentication Code）是一种基于哈希函数的消息认证码算法。它使用哈希函数和密钥来生成一个消息摘要，用于验证消息的完整性和认证消息的发送者。

HMAC算法可以防止篡改和伪造，并提供了一种安全的消息认证方式。

* HMAC算法的一般流程

  * 1.选择一个合适的哈希函数（如MD5、SHA-1、SHA-256等）。
  * 2.使用密钥对消息进行加密处理。
  * 3.将加密后的结果与原消息再次哈希运算，并生成最终的认证码。



### 2.flutter的crypto库

由crypto库[https://pub-web.flutter-io.cn/packages/crypto](https://pub-web.flutter-io.cn/packages/crypto)提供支持

支持Android/iOS/linux/MacOS/Web/Windows平台
支持算法如下：

* SHA-1
* SHA-224
* SHA-256
* SHA-384
* SHA-512
* SHA-512/224
* SHA-512/256
* MD5
* HMAC (i.e. HMAC-MD5, HMAC-SHA1, HMAC-SHA256)



### 3.pubspec.yaml添加依赖

```yaml
    crypto: ^3.0.3
```

### 4.使用示例

#### 4.1 使用示例

```dart

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

enum CryptoType {
  sha1,
  sha224,
  sha256,
  sha384,
  sha512,
  sha512_224,
  sha512_256,
  md5,
  hmac224,
  hmac256,
  hmac384,
  hmac512,
  hmac512_224,
  hmac512_256,
  hmacmd5,
}

class CryptoPage extends StatefulWidget {
  final String title;

  const CryptoPage({super.key, required this.title});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  static final hmacKey = utf8.encode('test_p@assw0rd1_hamc');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: _buildButtons(),
            ),
          ),
        ));
  }

  List<Widget> _buildButtons() {
    List<CryptoType> types = CryptoType.values;
    return types.map((type) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: ElevatedButton(
          onPressed: () => _hashString('hello world', type),
          child: Text(_getButtonLabel(type)),
        ),
      );
    }).toList();
  }

  String _getButtonLabel(CryptoType type) {
    return type.toString().split('.').last; // 获取枚举项的字符串形式
  }

  String _hashString(String text, CryptoType type) {
    if (text.isEmpty) {
      return '';
    }
    var bytes = utf8.encode(text); // data being hashed

    var convert;

    switch (type) {
      case CryptoType.sha1:
        convert = sha1;
        break;
      case CryptoType.sha224:
        convert = sha224;
        break;
      case CryptoType.sha256:
        convert = sha256;
        break;

      case CryptoType.sha384:
        convert = sha384;
        break;

      case CryptoType.sha512:
        convert = sha512;
        break;

      case CryptoType.sha512_224:
        convert = sha512224;
        break;

      case CryptoType.sha512_256:
        convert = sha512256;
        break;

      case CryptoType.md5:
        convert = md5;
        break;

      case CryptoType.hmac224:
        convert = Hmac(sha224, hmacKey);

        break;

      case CryptoType.hmac256:
        convert = Hmac(sha256, hmacKey);

        break;

      case CryptoType.hmac384:
        convert = Hmac(sha384, hmacKey);

        break;

      case CryptoType.hmac512:
        convert = Hmac(sha512, hmacKey);

        break;

      case CryptoType.hmac512_224:
        convert = Hmac(sha512224, hmacKey);

        break;

      case CryptoType.hmac512_256:
        convert = Hmac(sha512256, hmacKey);

        break;

      case CryptoType.hmacmd5:
        convert = Hmac(md5, hmacKey);

        break;

      default:
    }

    var res = convert != null ? convert.convert(bytes).toString() : '';
    debugPrint('_hashString:$res');

    return res;
  }
}


```

### 5.效果

```shell
flutter: _hashString:4d4691650f812c9c2e0a3055a67c2cf23d6c897f5fee19d8dbf1352d
flutter: _hashString:ee2102a5e6c036fe91e158bafcf2456c10f429b65fd394197460f7e6b0449da9
flutter: _hashString:ff638e15105ba2bf5f15797d7863e10b854875368d57677332727c92943c16c3635a7339ed2da545239811ff08f5d00f
flutter: _hashString:ade38c86e6323b79089c2acd058ac3bab84897397d1853d1496e769fffcc1f7c68a28c62a4c2943a0857944292f4d1e3f8382f7e051d8593c29cb7372627618c
flutter: _hashString:5c91c50480d3256079dc81a5f160a84b86da0d61f59b88c32f97a137
flutter: _hashString:25e5230e69548155df3b56466d0a4461cb0657ba47e5e25862af8d3edb778e02
flutter: _hashString:7c1dd59f830bb79a9efba02657c3027d
```


### 6.其它

#### 6.1.关于在项目中的使用
* HMAC的选择，考虑性能，安全等因素，一般选择HMAC-SHA256居多。
* 
