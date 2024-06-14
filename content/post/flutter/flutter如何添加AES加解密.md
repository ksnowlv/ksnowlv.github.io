---
title: "Flutter如何添加AES加解密"
date: 2024-06-07T21:31:13+08:00
lastmod: 2024-06-07T21:31:13+08:00
keywords: ["Flutter"]
tags: ["Flutter"]
categories: ["Flutter"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


### 1.AES加解密

flutter使用的是`encrypt`(https://pub.dev/packages/encrypt)支持库


AES支持的是PKCS7 padding

支持加解密模式如下

默认是加密模式为`AESMode.sic`, 

* CBC AESMode.cbc
* CFB-64 AESMode.cfb64
* CTR AESMode.ctr
* ECB AESMode.ecb
* OFB-64/GCTR AESMode.ofb64Gctr
* OFB-64 AESMode.ofb64
* SIC AESMode.sic


### 2.示例代码

#### 2.1.AES加解密测试方法
```dart

// CBC AESMode.cbc
// CFB-64 AESMode.cfb64
// CTR AESMode.ctr
// ECB AESMode.ecb
// OFB-64/GCTR AESMode.ofb64Gctr
// OFB-64 AESMode.ofb64
// SIC AESMode.sic

  handleAESTest({encrypt_lib.AESMode mode = encrypt_lib.AESMode.sic}) {

    debugPrint('---- :$mode---');
    
    final key = encrypt_lib.Key.fromSecureRandom(32);
    final iv = encrypt_lib.IV.fromSecureRandom(16);
    final encrypter = encrypt_lib.Encrypter(encrypt_lib.AES(key, mode: mode));

    final encryptedResult = encrypter.encrypt(sourceText, iv: iv);
    debugPrint(
        'encrypted bytes:${encryptedResult.bytes} \n base16 :${encryptedResult.base16} \nbase64 :${encryptedResult.base64}');

    final decryptedResult = encrypter.decrypt(encryptedResult, iv: iv);

    debugPrint('decrypted :$decryptedResult');
  }

```

### 2.2.调用

```dart

      ElevatedButton(
          onPressed: () {
            handleAESTest();
          },
          child: const Text(' 测试AES AESMode.sic加解密')),
      const SizedBox(
        height: 20,
      ),
      ElevatedButton(
          onPressed: () {
            handleAESTest(mode: encrypt_lib.AESMode.cbc);
          },
          child: const Text(' 测试AES AESMode.cbc加解密')),
      const SizedBox(
        height: 20,
      ),
      ElevatedButton(
          onPressed: () {
            handleAESTest(mode: encrypt_lib.AESMode.cfb64);
          },
          child: const Text(' 测试AES AESMode.cfb64加解密')),
      const SizedBox(
        height: 20,
      ),
      ElevatedButton(
          onPressed: () {
            handleAESTest(mode: encrypt_lib.AESMode.ctr);
          },
          child: const Text(' 测试AES AESMode.ctr加解密')),
      const SizedBox(
        height: 20,
      ),
      ElevatedButton(
          onPressed: () {
            handleAESTest(mode: encrypt_lib.AESMode.ecb);
          },
          child: const Text(' 测试AES AESMode.ecb加解密')),
      const SizedBox(
        height: 20,
      ),
      ElevatedButton(
          onPressed: () {
            handleAESTest(mode: encrypt_lib.AESMode.ofb64Gctr);
          },
          child: const Text(' 测试AES AESMode.ofb64Gctr加解密')),
      const SizedBox(
        height: 20,
      ),
      ElevatedButton(
          onPressed: () {
            handleAESTest(mode: encrypt_lib.AESMode.ofb64);
          },
          child: const Text(' 测试AES AESMode.ofb64加解密')),

```


### 3.效果

![image](/images/flutter/flutter如何添加AES加解密/result.png)

```shell
flutter: ---- :AESMode.sic---
flutter: encrypted bytes:[157, 219, 67, 151, 50, 251, 56, 119, 162, 246, 165, 77, 183, 211, 194, 59]
flutter:  base16 :9ddb439732fb3877a2f6a54db7d3c23b
flutter: base64 :ndtDlzL7OHei9qVNt9PCOw==
flutter: decrypted :Hello World!
flutter: ---- :AESMode.cbc---
flutter: encrypted bytes:[65, 185, 91, 128, 204, 243, 210, 137, 133, 131, 199, 189, 62, 186, 247, 248]
flutter:  base16 :41b95b80ccf3d2898583c7bd3ebaf7f8
flutter: base64 :QblbgMzz0omFg8e9Prr3+A==
flutter: decrypted :Hello World!
flutter: ---- :AESMode.cfb64---
flutter: encrypted bytes:[27, 231, 61, 33, 226, 216, 94, 60, 13, 215, 56, 16, 237, 67, 51, 133]
flutter:  base16 :1be73d21e2d85e3c0dd73810ed433385
flutter: base64 :G+c9IeLYXjwN1zgQ7UMzhQ==
flutter: decrypted :Hello World!
flutter: ---- :AESMode.ctr---
flutter: encrypted bytes:[184, 24, 196, 158, 223, 179, 227, 42, 244, 151, 81, 85, 86, 104, 35, 125]
flutter:  base16 :b818c49edfb3e32af49751555668237d
flutter: base64 :uBjEnt+z4yr0l1FVVmgjfQ==
flutter: decrypted :Hello World!
flutter: ---- :AESMode.ecb---
flutter: encrypted bytes:[253, 226, 37, 51, 58, 120, 60, 173, 32, 106, 121, 240, 7, 223, 192, 9]
flutter:  base16 :fde225333a783cad206a79f007dfc009
flutter: base64 :/eIlMzp4PK0gannwB9/ACQ==
flutter: decrypted :Hello World!
flutter: ---- :AESMode.ofb64Gctr---
flutter: encrypted bytes:[154, 139, 72, 174, 211, 44, 92, 113, 110, 11, 61, 144, 185, 143, 121, 47]
flutter:  base16 :9a8b48aed32c5c716e0b3d90b98f792f
flutter: base64 :motIrtMsXHFuCz2QuY95Lw==
flutter: decrypted :Hello World!
flutter: ---- :AESMode.ofb64---
flutter: encrypted bytes:[111, 45, 56, 81, 17, 145, 58, 225, 79, 162, 210, 193, 230, 237, 1, 153]
flutter:  base16 :6f2d385111913ae14fa2d2c1e6ed0199
flutter: base64 :by04URGROuFPotLB5u0BmQ==
flutter: decrypted :Hello World!

```

### 4.其它

* 相比较openssl中的，AES加解密，让你用起来欲仙欲死；flutter中，整体比较简单易用，不错~




