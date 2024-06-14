---
title: "Flutter如何添加消息散列算法-Sha/Md5系列"
date: 2024-05-06T11:38:47+08:00
lastmod: 2024-05-06T11:38:47+08:00
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


### 1.消息摘要/散列算法

SHA系列，MD5都属于消息摘要算法（Message Digest Algorithm）或称为消息散列算法。这些算法接受输入，并生成固定长度的摘要（哈希值），用于验证消息的完整性和唯一性。


flutter中有crypto库提供支持，[https://pub-web.flutter-io.cn/packages/crypto](https://pub-web.flutter-io.cn/packages/crypto)

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



### 2.pubspec.yaml添加依赖

```yaml
    crypto: ^3.0.3
```

### 3.使用示例

#### 3.1 使用示例

```dart
enum CryptoType {
  sha1,
  sha224,
  sha256,
  sha384,
  sha512,
  sha512_224,
  sha512_256,
  md5,
}

class CryptoPage extends StatefulWidget {
  final String title;

  const CryptoPage({super.key, required this.title});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () => _hashString('hello world', CryptoType.sha1),
                child: const Text('sha1')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => _hashString('hello world', CryptoType.sha224),
                child: const Text('sha224')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => _hashString('hello world', CryptoType.sha256),
                child: const Text('sha256')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => _hashString('hello world', CryptoType.sha384),
                child: const Text('sha384')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => _hashString('hello world', CryptoType.sha512),
                child: const Text('sha512')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () =>
                    _hashString('hello world', CryptoType.sha512_224),
                child: const Text('sha512_224')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () =>
                    _hashString('hello world', CryptoType.sha512_256),
                child: const Text('sha512_256')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => _hashString('hello world', CryptoType.md5),
                child: const Text('md5')),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _hashString(String text, CryptoType type) {
    if (text.isEmpty) {
      return '';
    }
    var bytes = utf8.encode(text); // data being hashed
    var res = '';

    switch (type) {
      case CryptoType.sha1:
        res = sha1.convert(bytes).toString();
        break;
      case CryptoType.sha224:
        res = sha224.convert(bytes).toString();
        break;
      case CryptoType.sha256:
        res = sha256.convert(bytes).toString();
        break;

      case CryptoType.sha384:
        res = sha384.convert(bytes).toString();
        break;

      case CryptoType.sha512:
        res = sha512.convert(bytes).toString();
        break;

      case CryptoType.sha512_224:
        res = sha512224.convert(bytes).toString();
        break;

      case CryptoType.sha512_256:
        res = sha512256.convert(bytes).toString();
        break;

      case CryptoType.md5:
        res = md5.convert(bytes).toString();
        break;
        

      default:
    }

    debugPrint('_hashString:$res');

    return res;
  }
}


```

### 4.效果

```shell
flutter: _hashString:2aae6c35c94fcfb415dbe95f408b9ce91ee846ed
flutter: _hashString:2f05477fc24bb4faefd86517156dafdecec45b8ad3cf2522a563582b
flutter: _hashString:b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9
flutter: _hashString:fdbd8e75a67f29f701a4e040385e2e23986303ea10239211af907fcbb83578b3e417cb71ce646efd0819dd8c088de1bd
flutter: _hashString:309ecc489c12d6eb4cc40f50c902f2b4d0ed77ee511a7c7a9bcd3ca86d4cd86f989dd35bc5ff499670da34255b45b0cfd830e81f605dcf7dc5542e93ae9cd76f
flutter: _hashString:22e0d52336f64a998085078b05a6e37b26f8120f43bf4db4c43a64ee
flutter: _hashString:0ac561fac838104e3f2e4ad107b4bee3e938bf15f2b15f009ccccd61a913f017
flutter: _hashString:5eb63bbbe01eeed093cb22bb8f5acdc3
```


### 5.其它

#### 5.1.关于在项目中的使用
* 关于MD5的使用：因MD5存在安全漏洞，因此在安全敏感的应用中，更推荐使用SHA-256，SHA-384，甚至SHA-512。
* MD5消息摘要：非加解密算法，面试过许多小伙伴，提起安全方面，base64，MD5加密就来了，希望有缘人认清它们。
* 消息摘要算法：虽然提供许多种，考虑到安全，性能等因素，在多数情况下，选择SHA-256居多；有特殊需要，自行根据情况选择。


