---
title: "Flutter如何添加RSA加解密"
date: 2024-06-07T21:31:20+08:00
lastmod: 2024-06-07T21:31:20+08:00
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


### 1.Mac 生成公钥和私钥

使用`openssl genrsa -out rsa_private_key1.pem 1024`生成私钥

然后，`openssl rsa -in rsa_private_key1.pem -out rsa_public_key.pem -pubout`导出公钥

详细操作如下

```shell
ksnowlv@MacBook-Pro-3 certs % openssl genrsa -out rsa_private_key1.pem 1024
Generating RSA private key, 1024 bit long modulus
...................................................+++++
............+++++
e is 65537 (0x10001)
ksnowlv@MacBook-Pro-3 certs % ls 
private_key.pem		public_key.pem		rsa_private_key1.pem
ksnowlv@MacBook-Pro-3 certs % cat rsa_private_key1.pem 
-----BEGIN RSA PRIVATE KEY-----
MIICXQIBAAKBgQDDFYnqtgx7idhYnakb4j2X30GOLgcg7dka1jBw/rHijcdkjySY
H08cC4XZwTG+OF7jJN4WOzkl4vp63vAZuYWwcidHCbdsfzDhWEb7992Rjziui+Kn
Ie5+QRrAKSJRSdd9MnEsMZQT0MPBEBDVfD1kw9imezBdWvPwGWR9QniY/wIDAQAB
AoGBAKhxUYs6s1578DTbtOehmkMm/wiPz5HsLLhSVrNKBzgx6Qd33UYISptRi7ow
aQ3wyGViMOyLKFYBPPuYwUHFAZuNmKoxKwRyUk096P6pf2CmRsZorTiNnGWBn3g/
yit37mHGrs1vaXduwmuttx2DnVW0Kctr+Nh1qC2UkOix3KR5AkEA4Hl4UOtn2Dcy
eC7Lg8AV9522IymM9Nigmn4f3VrHYm1uR3KV+0Qas/x1Rzpz77eUuPAMtadRYeQj
SaGbf9N4owJBAN57Zb9fuD6oSgVNqjusaLlhMhe3xWpCX1qhmBaaNPu9x+eA/HjL
ClWT/L62sHiwrRshInFkYdvhBU77sXQ6l/UCQBFmWQUsuifwX2Ehf3T+9rTy7KNd
HSf9grV3AVFPMBVZFitDnoyTgt5gu1aCGWqDeGu9b77E8XH9FR8n/72wzrECQQCQ
F//IOOiNvFVkpe6Rg5K4LhlRfzafIam8e1iTmwCh40Krz8C1Q1vIHXbe1lfpcxRK
s+Uo58jxrgXQJ/fAvYpZAkBE5gCTfZkGWmwSZpZ2Lq1UL/uCQeFTR47D7pRrqTag
9gy47coTRUrZ94B+KwFwIjZExgSqNEvE/9OcaN7naEWh
-----END RSA PRIVATE KEY-----
ksnowlv@MacBook-Pro-3 certs % openssl rsa -in rsa_private_key1.pem -out rsa_public_key.pem -pubout
writing RSA key
ksnowlv@MacBook-Pro-3 certs % ls
private_key.pem		public_key.pem		rsa_private_key1.pem	rsa_public_key.pem
ksnowlv@MacBook-Pro-3 certs % cat rsa_public_key.pem 
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDFYnqtgx7idhYnakb4j2X30GO
Lgcg7dka1jBw/rHijcdkjySYH08cC4XZwTG+OF7jJN4WOzkl4vp63vAZuYWwcidH
CbdsfzDhWEb7992Rjziui+KnIe5+QRrAKSJRSdd9MnEsMZQT0MPBEBDVfD1kw9im
ezBdWvPwGWR9QniY/wIDAQAB
-----END PUBLIC KEY-----
ksnowlv@MacBook-Pro-3 certs % 

```

### 2.`pubspec.yaml`配置

添加`encrypt`和`pointycastle`依赖库
添加公钥和私钥文件配置

```yaml

    encrypt: ^5.0.3
    pointycastle: ^3.9.1

     assets:
     - assets/images/
     - assets/images/login/
     - assets/lottie/
     - assets/audio/
     - assets/txt/
     - assets/json/
     - assets/rsa/

```

### 3.示例代码

```dart

  handleRSATest() async {
  
    String publicKeyString = await rootBundle.loadString('assets/rsa/rsa_public_key.pem');
    String privateKeyString = await rootBundle.loadString('assets/rsa/rsa_private_key.pem');

    debugPrint('publicKeyString:$publicKeyString \n privateKeyString:$privateKeyString');

    final parser = encrypt_lib.RSAKeyParser();
    final publicKey = parser.parse(publicKeyString) as RSAPublicKey; 
    final privKey = parser.parse(privateKeyString) as RSAPrivateKey;
    
    // final publicKey = await parseKeyFromFile<RSAPublicKey>('rsa/rsa_public_key.pem');
    // final privKey = await parseKeyFromFile<RSAPrivateKey>('rsa/rsa_private_key.pem');

    encrypt_lib.Encrypter encrypter;
    encrypt_lib.Encrypted encrypted;
    String decrypted;

    // PKCS1 (Default)
    encrypter = encrypt_lib.Encrypter(
        encrypt_lib.RSA(publicKey: publicKey, privateKey: privKey));
    encrypted = encrypter.encrypt(sourceText);
    debugPrint('\nPKCS1 (Default) encrypted ${encrypted} \n bytes:${encrypted.bytes} \n base16 :${encrypted.base16} \n base64 :${encrypted.base64}');
    
    decrypted = encrypter.decrypt(encrypted);

    debugPrint('PKCS1 (Default) decrypted :$decrypted');

 
    // OAEP (SHA1)
    encrypter = encrypt_lib.Encrypter(
      encrypt_lib.RSA(
          publicKey: publicKey,
          privateKey: privKey,
          encoding: encrypt_lib.RSAEncoding.OAEP),
    );
    encrypted = encrypter.encrypt(sourceText);

    debugPrint('\nOAEP (SHA1) encrypted ${encrypted} \n bytes:${encrypted.bytes} \n base16 :${encrypted.base16} \n base64 :${encrypted.base64} ');
    
    decrypted = encrypter.decrypt(encrypted);

    debugPrint('OAEP (SHA1) decrypted :$decrypted');

    // OAEP (SHA256)
    encrypter = encrypt_lib.Encrypter(encrypt_lib.RSA(
      publicKey: publicKey,
      privateKey: privKey,
      encoding: encrypt_lib.RSAEncoding.OAEP,
      digest: encrypt_lib.RSADigest.SHA256,
    ));
    encrypted = encrypter.encrypt(sourceText);

    debugPrint('\nOAEP (SHA256) encrypted ${encrypted} \n bytes:${encrypted.bytes} \n base16 :${encrypted.base16} \n base64 :${encrypted.base64} ');

    decrypted = encrypter.decrypt(encrypted);
    debugPrint('OAEP (SHA256) decrypted :$decrypted');
  }
```

上述示例代码演示了`RSA`在`PKCS1`，`OAEP (SHA1)`，`OAEP (SHA256)`模式下加解密。
注意证书路径

### 4.效果

```shell
flutter: publicKeyString:-----BEGIN PUBLIC KEY-----
flutter: MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDFYnqtgx7idhYnakb4j2X30GO
flutter: Lgcg7dka1jBw/rHijcdkjySYH08cC4XZwTG+OF7jJN4WOzkl4vp63vAZuYWwcidH
flutter: CbdsfzDhWEb7992Rjziui+KnIe5+QRrAKSJRSdd9MnEsMZQT0MPBEBDVfD1kw9im
flutter: ezBdWvPwGWR9QniY/wIDAQAB
flutter: -----END PUBLIC KEY-----
flutter:
flutter:  privateKeyString:-----BEGIN RSA PRIVATE KEY-----
flutter: MIICXQIBAAKBgQDDFYnqtgx7idhYnakb4j2X30GOLgcg7dka1jBw/rHijcdkjySY
flutter: H08cC4XZwTG+OF7jJN4WOzkl4vp63vAZuYWwcidHCbdsfzDhWEb7992Rjziui+Kn
flutter: Ie5+QRrAKSJRSdd9MnEsMZQT0MPBEBDVfD1kw9imezBdWvPwGWR9QniY/wIDAQAB
flutter: AoGBAKhxUYs6s1578DTbtOehmkMm/wiPz5HsLLhSVrNKBzgx6Qd33UYISptRi7ow
flutter: aQ3wyGViMOyLKFYBPPuYwUHFAZuNmKoxKwRyUk096P6pf2CmRsZorTiNnGWBn3g/
flutter: yit37mHGrs1vaXduwmuttx2DnVW0Kctr+Nh1qC2UkOix3KR5AkEA4Hl4UOtn2Dcy
flutter: eC7Lg8AV9522IymM9Nigmn4f3VrHYm1uR3KV+0Qas/x1Rzpz77eUuPAMtadRYeQj
flutter: SaGbf9N4owJBAN57Zb9fuD6oSgVNqjusaLlhMhe3xWpCX1qhmBaaNPu9x+eA/HjL
flutter: ClWT/L62sHiwrRshInFkYdvhBU77sXQ6l/UCQBFmWQUsuifwX2Ehf3T+9rTy7KNd
flutter: HSf9grV3AVFPMBVZFitDnoyTgt5gu1aCGWqDeGu9b77E8XH9FR8n/72wzrECQQCQ
flutter: F//IOOiNvFVkpe6Rg5K4LhlRfzafIam8e1iTmwCh40Krz8C1Q1vIHXbe1lfpcxRK
flutter: s+Uo58jxrgXQJ/fAvYpZAkBE5gCTfZkGWmwSZpZ2Lq1UL/uCQeFTR47D7pRrqTag
flutter: 9gy47coTRUrZ94B+KwFwIjZExgSqNEvE/9OcaN7naEWh
flutter: -----END RSA PRIVATE KEY-----
flutter: 
flutter:
flutter: PKCS1 (Default) encrypted Instance of 'Encrypted'
flutter:  bytes:[26, 73, 86, 240, 87, 15, 160, 122, 179, 186, 172, 233, 5, 43, 149, 90, 247, 236, 173, 123, 240, 69, 72, 45, 154, 3, 241, 123, 143, 11, 182, 237, 37, 33, 160, 18, 40, 23, 145, 200, 254, 39, 20, 26, 253, 223, 36, 108, 197, 243, 209, 244, 243, 229, 223, 128, 202, 49, 173, 13, 240, 215, 122, 210, 134, 82, 147, 173, 77, 65, 121, 11, 131, 235, 94, 18, 50, 214, 126, 188, 22, 108, 138, 221, 105, 60, 65, 98, 107, 253, 25, 129, 31, 45, 189, 94, 106, 202, 88, 69, 118, 139, 94, 239, 90, 183, 49, 170, 149, 36, 223, 146, 17, 44, 88, 220, 244, 84, 94, 204, 211, 94, 113, 108, 100, 98, 156, 69]
flutter:  base16 :1a4956f0570fa07ab3baace9052b955af7ecad7bf045482d9a03f17b8f0bb6ed2521a012281791c8fe27141afddf246cc5f3d1f4f3e5df80ca31ad0df0d77ad2865293ad4d41790b83eb5e1232d67ebc166c8add693c41626bfd19811f2dbd5e6aca5845768b5eef5ab731aa9524df92112c58dcf4545eccd35e716c64629c45
flutter:  base64 :GklW8FcPoHqzuqzpBSuVWvfsrXvwRUgtmgPxe48Ltu0lIaASKBeRyP4nFBr93yRsxfPR9PPl34DKMa0N8Nd60oZSk61NQXkLg+teEjLWfrwWbIrdaTxBYmv9GYEfLb1easpYRXaLXu9atzGqlSTfkhEsWNz0VF7M015xbGRinEU=
flutter: PKCS1 (Default) decrypted :Hello World!
flutter:
flutter: OAEP (SHA1) encrypted Instance of 'Encrypted'
flutter:  bytes:[99, 35, 32, 40, 69, 186, 118, 121, 128, 50, 95, 232, 204, 23, 26, 228, 239, 166, 118, 49, 90, 157, 21, 115, 197, 149, 74, 173, 140, 133, 30, 121, 97, 216, 146, 65, 232, 244, 93, 106, 146, 240, 41, 122, 182, 170, 159, 227, 213, 230, 11, 243, 54, 179, 11, 230, 70, 118, 244, 125, 130, 190, 227, 75, 62, 215, 183, 69, 187, 68, 70, 194, 173, 79, 20, 5, 230, 65, 252, 193, 151, 132, 38, 6, 92, 14, 117, 43, 20, 184, 90, 21, 212, 133, 184, 61, 76, 216, 175, 248, 121, 208, 235, 110, 113, 137, 42, 132, 68, 190, 224, 200, 162, 226, 24, 71, 47, 229, 49, 38, 100, 38, 179, 211, 13, 63, 236, 89]
flutter:  base16 :6323202845ba767980325fe8cc171ae4efa676315a9d1573c5954aad8c851e7961d89241e8f45d6a92f0297ab6aa9fe3d5e60bf336b30be64676f47d82bee34b3ed7b745bb4446c2ad4f1405e641fcc1978426065c0e752b14b85a15d485b83d4cd8aff879d0eb6e71892a8444bee0c8a2e218472fe531266426b3d30d3fec59
flutter:  base64 :YyMgKEW6dnmAMl/ozBca5O+mdjFanRVzxZVKrYyFHnlh2JJB6PRdapLwKXq2qp/j1eYL8zazC+ZGdvR9gr7jSz7Xt0W7REbCrU8UBeZB/MGXhCYGXA51KxS4WhXUhbg9TNiv+HnQ625xiSqERL7gyKLiGEcv5TEmZCaz0w0/7Fk=
flutter: OAEP (SHA1) decrypted :Hello World!
flutter:
flutter: OAEP (SHA256) encrypted Instance of 'Encrypted'
flutter:  bytes:[126, 114, 224, 132, 108, 133, 142, 199, 53, 110, 243, 61, 58, 25, 152, 171, 117, 111, 138, 79, 14, 11, 58, 233, 208, 78, 247, 65, 157, 5, 221, 224, 117, 74, 243, 255, 98, 125, 96, 165, 206, 55, 208, 200, 164, 8, 189, 174, 203, 157, 179, 5, 54, 175, 81, 203, 30, 41, 44, 11, 134, 129, 124, 61, 226, 249, 237, 93, 140, 112, 231, 148, 167, 138, 98, 131, 129, 124, 238, 18, 57, 30, 165, 11, 230, 125, 99, 115, 131, 248, 14, 22, 208, 211, 150, 141, 77, 246, 161, 241, 214, 203, 203, 97, 94, 46, 155, 45, 168, 130, 16, 186, 133, 38, 19, 206, 138, 32, 63, 214, 104, 70, 135, 23, 251, 88, 34, 129]
flutter:  base16 :7e72e0846c858ec7356ef33d3a1998ab756f8a4f0e0b3ae9d04ef7419d05dde0754af3ff627d60a5ce37d0c8a408bdaecb9db30536af51cb1e292c0b86817c3de2f9ed5d8c70e794a78a6283817cee12391ea50be67d637383f80e16d0d3968d4df6a1f1d6cbcb615e2e9b2da88210ba852613ce8a203fd668468717fb582281
flutter:  base64 :fnLghGyFjsc1bvM9OhmYq3Vvik8OCzrp0E73QZ0F3eB1SvP/Yn1gpc430MikCL2uy52zBTavUcseKSwLhoF8PeL57V2McOeUp4pig4F87hI5HqUL5n1jc4P4DhbQ05aNTfah8dbLy2FeLpstqIIQuoUmE86KID/WaEaHF/tYIoE=
flutter: OAEP (SHA256) decrypted :Hello World!

```

### 5.其它

* 1.如果报错证书格式错误，请重新生成正确的RSA的证书。上述输出证书内容，方便大家确认证书的正确性
* 2.证书一般动态下发，避免直接打包到文件中。注意注意注意
* 3.注意RSA加密模式的区别，像`PKCS1`，`OAEP (SHA1)`，`OAEP (SHA256)`
