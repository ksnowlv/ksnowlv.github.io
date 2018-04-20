---
layout: post
title: "常见非对称加密算法"
date: 2018-04-19 19:37
comments: true
categories: 安全
---

常见非对称加密算法有哪些呢？
<!--more-->
* 1.RSA。
* 2.DSA。
* 3.ECC/ECDH/ECDSA。
* 4.Elgamal：[Elgamal算法](https://baike.baidu.com/item/Elgamal)
* 5.背包算法：

简单从安全性，性能方面做下对比：

* 1.安全性：RSA和DSA差不多，而ECC系列好一些。
* 2.性能：RSA和DSA差不多，ECC系列有更好的性能。，包括处理速度，带宽要求，存储空间等等。
* 3.需要注意点：
	* RSA建议采用1024位的数字。
	* DSA只能用于数字签名,不能用于加解密，比RSA要快很多。
	* ECC建议采用160位。