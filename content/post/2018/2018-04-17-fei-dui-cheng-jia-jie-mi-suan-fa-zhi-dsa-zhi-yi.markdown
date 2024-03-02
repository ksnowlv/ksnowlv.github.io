---
title: "非对称加解密算法之DSA---dsa公钥与私钥 "
date: 2018-04-17
lastmod: 2018-04-17
categories:
  - "iOS"
tags:
  - "安全"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

DSA(Digital Signature Algorithm)：非对称加密算法，安全性与RSA相比差不多。
  *  DSA只是一种算法，和RSA不同之处在于它不能用作加密和解密，也不能进行密钥交换，只用于签名,比RSA要快很多.
  *  和RSA加密解密过程相反，在DSA数字签名和认证中，发送者使用自己的私钥对文件或消息进行签名，接受者收到消息后使用发送者的公钥来验证签名的真实性。

  
## 如何生成dsa公钥与私钥 
### 1. 进入openssl后，生成模长为1024bit的私钥文件

```terminal
 dsaparam.pemdsaparam -out dsaparam.pem 1024
```

### 2. 生成私钥dsa_private_key.pem

```terminal
gendsa -out dsa_private_key.pem dsaparam.pem
```

### 3. 将私钥转换成PKCS8格式的私钥

```terminal
pkcs8 -topk8 -inform PEM -in dsa_private_key.pem -outform PEM -nocrypt -out dsa_private_key_pkcs8.pem
```

### 4. 生成供iOS使用的公钥文件dsa_public_key.pem

```terminal
dsa -in dsa_private_key_pkcs8.pem -pubout -out dsa_public_key.pem
```

详细操作见下图：
![image](/images/post/2018-04-18-fei-dui-cheng-jia-jie-mi-suan-fa-zhi-dsa-zhi-yi/1.png) 