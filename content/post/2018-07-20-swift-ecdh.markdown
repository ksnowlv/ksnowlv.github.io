---
title: "swift-ecdh"
date: 2018-07-20
lastmod: 2018-07-20
categories:
  - "swift"
tags:
  - "安全"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---


swift 在iOS10之后，支持ecdh加解密。

### 1.生成公钥和私钥

```swift
   func generateKey() {
        
        let attributes: [String: Any] = [kSecAttrKeySizeInBits as String: 256,
                                         kSecAttrKeyType as String: kSecAttrKeyTypeEC,
                                         kSecPrivateKeyAttrs as String: [kSecAttrIsPermanent as String: false]]
        var error: Unmanaged<CFError>?
        
        self.privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error)
        
        if self.privateKey != nil {
            self.publicKey = SecKeyCopyPublicKey(self.privateKey!)
        }
    }
```

### 2.加密

```swift
func encryptedData(sourceData: Data, algorithm:SecKeyAlgorithm) -> Data? {
        
        guard self.publicKey != nil else {
            return nil
        }
        
        var error: Unmanaged<CFError>?
        
        let encrypted =
            SecKeyCreateEncryptedData(self.publicKey!, algorithm,
                                      sourceData as CFData,
                                      &error)
        if error == nil {
            return encrypted! as Data
        }
        
        return nil
    }

```

### 3.解密

```swift
   func decryptedData(sourceData: Data, algorithm:SecKeyAlgorithm ) -> String? {
        
        var error: Unmanaged<CFError>?
        
        let resData = SecKeyCreateDecryptedData(self.privateKey! , algorithm,
                                                sourceData as CFData, &error)
        
        if error == nil {
            return String(data: resData! as Data, encoding: String.Encoding.utf8)
        }
        
        return nil
    }
```

### 4.示例

```swift
        let sign = YKEcdhSign()
        sign.generateKey()
        let enData =  sign.encryptedData(sourceData: originalData!, algorithm: SecKeyAlgorithm.eciesEncryptionStandardX963SHA512AESGCM)
        let string = sign.decryptedData(sourceData: enData!, algorithm: SecKeyAlgorithm.eciesEncryptionStandardX963SHA512AESGCM)
        print(string!)
```
