---
title: "非对称加解密算法之ECC"
date: 2018-04-20
categories:
  - "iOS"
tags:
  - "安全"
---
<!--more-->


   ECC算法用途比RSA还厉害。
   
   * 支持加解密。
   * 支持签名验证。
   * 支持与DH结合使用，用于密钥磋商，这个密钥交换算法称为ECDH。
   	* 交换双方可以在不共享任何秘密的情况下协商出一个密钥。Openssl里面的ECC算法的套件支持是ECDSA/ECDH。

 
 开源组件见[https://github.com/ricmoo/GMEllipticCurveCrypto](https://github.com/ricmoo/GMEllipticCurveCrypto)