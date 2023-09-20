---
title: "Swift ECDHE加解密"
date: 2023-09-20T19:30:29+08:00
lastmod: 2023-09-20T19:30:29+08:00
keywords: ["Swift", "ECDHE", "加解密"]
tags: ["Swift", "iOS", "安全"]
categories: ["Swift", "iOS", "安全"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## 一. Mac上生成 ECDHE（Elliptic Curve Diffie-Hellman Ephemeral）公钥和私钥

### 1.Mac安装OpenSSL

```terminal
brew install openssl
```
### 2.生成 ECDHE 密钥对

```terminal
openssl ecparam -name prime256v1 -genkey -noout -out private_key.pem
```
终端命令将生成一个 prime256v1（也称为 P-256）曲线的 ECDHE 私钥，并将私钥保存到 private_key.pem 文件中。

### 3.导出公钥
```terminal
openssl ec -in private_key.pem -pubout -out public_key.pem
```

终端命令将从 private_key.pem 文件中导出公钥，并保存到 public_key.pem 文件


## 二.iOS中的使用

### 1.工程引入公钥和私钥文件

### 2.工程引入CryptoKit库

### 3.加载公钥和私钥

```swift
    func loadKeyAndSecret() -> SymmetricKey? {
        
        // 加载本地私钥文件
        guard let privateKeyURL = Bundle.main.url(forResource: EcdheTest.PrivateKeyFile, withExtension: "pem"),
              let privateKeyString = try? String(contentsOf: privateKeyURL) else {
            fatalError("Failed to load private key")
        }
        
        // 解析本地私钥
        let privateKey = try! P256.KeyAgreement.PrivateKey(pemRepresentation: privateKeyString)
        
        // 加载对方的公钥文件
        guard let publicKeyURL = Bundle.main.url(forResource: EcdheTest.PublicKeyFile, withExtension: "pem"),
              let publicKeyString = try? String(contentsOf: publicKeyURL) else {
            fatalError("Failed to load peer's public key")
        }
        
        // 解析对方的公钥
        let peerPublicKey = try! P256.KeyAgreement.PublicKey(pemRepresentation: publicKeyString)
        
        // 计算共享密钥
        let sharedSecret = try! privateKey.sharedSecretFromKeyAgreement(with: peerPublicKey)
        
        // 打印共享密钥
        let sharedSecretData = sharedSecret.withUnsafeBytes { bytes in
            return Data(bytes: bytes.baseAddress!, count: bytes.count)
        }
        // Print shared secret
        print("Shared Secret: \(sharedSecretData)")
        
        let hexString = sharedSecretData.map { String(format: "%02hhx", $0) }.joined()
//        print("Hex String: \(hexString)")
        
        // 使用共享的密钥进行加密/解密
        return sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self, salt: Data(), sharedInfo: Data(), outputByteCount: 32)
        
    }
```

### 4.数据加密

```swift
    func encryptedData(_ symmetricKey: SymmetricKey, _ text: String) -> Data? {
        
        guard let plaintext = text.data(using: .utf8) else {
            return nil
        }
        
        return try? ChaChaPoly.seal(plaintext, using: symmetricKey).combined
        
    }
    
```


### 5.数据解密

```swift
    func decryptedData(_ symmetricKey: SymmetricKey, _ encryptedData: Data) -> Data? {
        // 使用共享的密钥进行解密
        guard let sealedBox = try? ChaChaPoly.SealedBox(combined: encryptedData) else {
            return nil
        }
        
        return try? ChaChaPoly.open(sealedBox, using: symmetricKey)
    }
    
```

### 6.测试

```swift
    func test() {
        
        let symmetricKey = self.loadKeyAndSecret()
        
        guard symmetricKey != nil else {
            fatalError("---loadKeyAndSecret load faile---")
        }
        
        let helloWorld = "Hello World!"
        
        print("---helloWorld :\(helloWorld)")
        
        let encryptedData = self.encryptedData(symmetricKey!, helloWorld)
        
        guard encryptedData != nil else {
            fatalError("---encryptedData faile---")
        }
        
        print("---encryptedData :\(String(describing: encryptedData))")
        
        let decryptedData = self.decryptedData(symmetricKey!, encryptedData!)
        
        guard decryptedData != nil else {
            fatalError("---decryptedData faile---")
        }
        
        
        let decryptedString = String(data: decryptedData!, encoding: .utf8)
        
        print("---decryptedData:\(decryptedString ?? "" )")
        
    }
    
```

### 7.执行情况

```terminal
Shared Secret: 32 bytes
---helloWorld :Hello World!
---encryptedData :Optional(40 bytes)
---decryptedData:Hello World!
```
