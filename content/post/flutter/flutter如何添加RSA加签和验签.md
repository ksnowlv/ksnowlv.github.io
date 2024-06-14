---
title: "Flutter如何添加RSA加签和验签"
date: 2024-06-07T23:04:16+08:00
lastmod: 2024-06-07T23:04:16+08:00
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

### 1.RSA加签和验签

接上文

RSA不仅仅支持加密和解密，还支持加签和验签；

不同的是在加签和验签时使用私钥加签，用公钥验签

### 2.示例代码

```dart

    handleRSASignTest() async {
      String publicKeyString =
      await rootBundle.loadString('assets/rsa/rsa_public_key.pem');
      String privateKeyString =
      await rootBundle.loadString('assets/rsa/rsa_private_key.pem');
    
      debugPrint(
          'publicKeyString:$publicKeyString \n privateKeyString:$privateKeyString');
    
      final parser = encrypt_lib.RSAKeyParser();
      final publicKey = parser.parse(publicKeyString) as RSAPublicKey;
      final privateKey = parser.parse(privateKeyString) as RSAPrivateKey;
      final signer = encrypt_lib.Signer(encrypt_lib.RSASigner(
          encrypt_lib.RSASignDigest.SHA256,
          publicKey: publicKey,
          privateKey: privateKey));
    
      final signResult = signer.sign(sourceText);
    
      debugPrint(
          'signResult:$signResult,\n signResult base64 ${signResult.base64}');
      final verifyResult = signer.verify64(sourceText, signResult.base64);
      debugPrint('verifyResult:$verifyResult');
    }
```

### 3.效果

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
flutter: signResult:Instance of 'Encrypted',
flutter:  signResult base64 OXwpp9JOCQn4zqxYI4A1PNmGo5SncecCWIkqR3VbrRnX9BwXmN3g25SfWlJLrqIGEv6gggqT74uI/xKJCXNceuHw8Zj5ueP4G2YftI82wezI3L5UCSmATGwzftHFYo/yF5c2o7tcYsR8qtHdyTQ36La/gtuYZashUXrw5+8tCFM=
flutter: verifyResult:true

```

