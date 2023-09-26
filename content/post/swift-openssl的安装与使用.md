---
title: "Swift Openssl的安装与使用"
date: 2023-09-21T21:07:53+08:00
lastmod: 2023-09-21T21:07:53+08:00
keywords: ["swift", "安全", "AES256"]
tags: ["swift", "安全"]
categories: ["swift", "安全"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## 一.swift下安装Openssl
使用podfile的方式引用OpenSSL库

那为什么不使用[OpenSSL-for-iPhone](https://github.com/x2on/OpenSSL-for-iPhone)?主要原因是该工程适用Objective-C，在swift下适配成本较高。

### 1.创建Podfile文件

```swift
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
platform :ios, '12.0'

target 'SwiftSecretTest' do
    # pod 'OpenSSL-Apple', :path => '.'
    pod 'OpenSSL-Universal'
end

```

### 2.pod安装

```terminal
pod install
Analyzing dependencies
Downloading dependencies
Installing OpenSSL-Universal (1.1.2200)
Generating Pods project
Integrating client project
Pod installation complete! There is 1 dependency from the Podfile and 1 total pod installed.
```
### 3.查看openssl支持的算法库

```terminal
(base) lvwei@lvweideMacBook-Pro SwiftSecretTest % openssl ciphers -V | column -t
0x13,0x02  -  TLS_AES_256_GCM_SHA384         TLSv1.3  Kx=any       Au=any    Enc=AESGCM(256)             Mac=AEAD
0x13,0x03  -  TLS_CHACHA20_POLY1305_SHA256   TLSv1.3  Kx=any       Au=any    Enc=CHACHA20/POLY1305(256)  Mac=AEAD
0x13,0x01  -  TLS_AES_128_GCM_SHA256         TLSv1.3  Kx=any       Au=any    Enc=AESGCM(128)             Mac=AEAD
0xC0,0x2C  -  ECDHE-ECDSA-AES256-GCM-SHA384  TLSv1.2  Kx=ECDH      Au=ECDSA  Enc=AESGCM(256)             Mac=AEAD
0xC0,0x30  -  ECDHE-RSA-AES256-GCM-SHA384    TLSv1.2  Kx=ECDH      Au=RSA    Enc=AESGCM(256)             Mac=AEAD
0x00,0x9F  -  DHE-RSA-AES256-GCM-SHA384      TLSv1.2  Kx=DH        Au=RSA    Enc=AESGCM(256)             Mac=AEAD
0xCC,0xA9  -  ECDHE-ECDSA-CHACHA20-POLY1305  TLSv1.2  Kx=ECDH      Au=ECDSA  Enc=CHACHA20/POLY1305(256)  Mac=AEAD
0xCC,0xA8  -  ECDHE-RSA-CHACHA20-POLY1305    TLSv1.2  Kx=ECDH      Au=RSA    Enc=CHACHA20/POLY1305(256)  Mac=AEAD
0xCC,0xAA  -  DHE-RSA-CHACHA20-POLY1305      TLSv1.2  Kx=DH        Au=RSA    Enc=CHACHA20/POLY1305(256)  Mac=AEAD
0xC0,0x2B  -  ECDHE-ECDSA-AES128-GCM-SHA256  TLSv1.2  Kx=ECDH      Au=ECDSA  Enc=AESGCM(128)             Mac=AEAD
0xC0,0x2F  -  ECDHE-RSA-AES128-GCM-SHA256    TLSv1.2  Kx=ECDH      Au=RSA    Enc=AESGCM(128)             Mac=AEAD
0x00,0x9E  -  DHE-RSA-AES128-GCM-SHA256      TLSv1.2  Kx=DH        Au=RSA    Enc=AESGCM(128)             Mac=AEAD
0xC0,0x24  -  ECDHE-ECDSA-AES256-SHA384      TLSv1.2  Kx=ECDH      Au=ECDSA  Enc=AES(256)                Mac=SHA384
0xC0,0x28  -  ECDHE-RSA-AES256-SHA384        TLSv1.2  Kx=ECDH      Au=RSA    Enc=AES(256)                Mac=SHA384
0x00,0x6B  -  DHE-RSA-AES256-SHA256          TLSv1.2  Kx=DH        Au=RSA    Enc=AES(256)                Mac=SHA256
0xC0,0x23  -  ECDHE-ECDSA-AES128-SHA256      TLSv1.2  Kx=ECDH      Au=ECDSA  Enc=AES(128)                Mac=SHA256
0xC0,0x27  -  ECDHE-RSA-AES128-SHA256        TLSv1.2  Kx=ECDH      Au=RSA    Enc=AES(128)                Mac=SHA256
0x00,0x67  -  DHE-RSA-AES128-SHA256          TLSv1.2  Kx=DH        Au=RSA    Enc=AES(128)                Mac=SHA256
0xC0,0x0A  -  ECDHE-ECDSA-AES256-SHA         TLSv1    Kx=ECDH      Au=ECDSA  Enc=AES(256)                Mac=SHA1
0xC0,0x14  -  ECDHE-RSA-AES256-SHA           TLSv1    Kx=ECDH      Au=RSA    Enc=AES(256)                Mac=SHA1
0x00,0x39  -  DHE-RSA-AES256-SHA             SSLv3    Kx=DH        Au=RSA    Enc=AES(256)                Mac=SHA1
0xC0,0x09  -  ECDHE-ECDSA-AES128-SHA         TLSv1    Kx=ECDH      Au=ECDSA  Enc=AES(128)                Mac=SHA1
0xC0,0x13  -  ECDHE-RSA-AES128-SHA           TLSv1    Kx=ECDH      Au=RSA    Enc=AES(128)                Mac=SHA1
0x00,0x33  -  DHE-RSA-AES128-SHA             SSLv3    Kx=DH        Au=RSA    Enc=AES(128)                Mac=SHA1
0x00,0xAD  -  RSA-PSK-AES256-GCM-SHA384      TLSv1.2  Kx=RSAPSK    Au=RSA    Enc=AESGCM(256)             Mac=AEAD
0x00,0xAB  -  DHE-PSK-AES256-GCM-SHA384      TLSv1.2  Kx=DHEPSK    Au=PSK    Enc=AESGCM(256)             Mac=AEAD
0xCC,0xAE  -  RSA-PSK-CHACHA20-POLY1305      TLSv1.2  Kx=RSAPSK    Au=RSA    Enc=CHACHA20/POLY1305(256)  Mac=AEAD
0xCC,0xAD  -  DHE-PSK-CHACHA20-POLY1305      TLSv1.2  Kx=DHEPSK    Au=PSK    Enc=CHACHA20/POLY1305(256)  Mac=AEAD
0xCC,0xAC  -  ECDHE-PSK-CHACHA20-POLY1305    TLSv1.2  Kx=ECDHEPSK  Au=PSK    Enc=CHACHA20/POLY1305(256)  Mac=AEAD
0x00,0x9D  -  AES256-GCM-SHA384              TLSv1.2  Kx=RSA       Au=RSA    Enc=AESGCM(256)             Mac=AEAD
0x00,0xA9  -  PSK-AES256-GCM-SHA384          TLSv1.2  Kx=PSK       Au=PSK    Enc=AESGCM(256)             Mac=AEAD
0xCC,0xAB  -  PSK-CHACHA20-POLY1305          TLSv1.2  Kx=PSK       Au=PSK    Enc=CHACHA20/POLY1305(256)  Mac=AEAD
0x00,0xAC  -  RSA-PSK-AES128-GCM-SHA256      TLSv1.2  Kx=RSAPSK    Au=RSA    Enc=AESGCM(128)             Mac=AEAD
0x00,0xAA  -  DHE-PSK-AES128-GCM-SHA256      TLSv1.2  Kx=DHEPSK    Au=PSK    Enc=AESGCM(128)             Mac=AEAD
0x00,0x9C  -  AES128-GCM-SHA256              TLSv1.2  Kx=RSA       Au=RSA    Enc=AESGCM(128)             Mac=AEAD
0x00,0xA8  -  PSK-AES128-GCM-SHA256          TLSv1.2  Kx=PSK       Au=PSK    Enc=AESGCM(128)             Mac=AEAD
0x00,0x3D  -  AES256-SHA256                  TLSv1.2  Kx=RSA       Au=RSA    Enc=AES(256)                Mac=SHA256
0x00,0x3C  -  AES128-SHA256                  TLSv1.2  Kx=RSA       Au=RSA    Enc=AES(128)                Mac=SHA256
0xC0,0x38  -  ECDHE-PSK-AES256-CBC-SHA384    TLSv1    Kx=ECDHEPSK  Au=PSK    Enc=AES(256)                Mac=SHA384
0xC0,0x36  -  ECDHE-PSK-AES256-CBC-SHA       TLSv1    Kx=ECDHEPSK  Au=PSK    Enc=AES(256)                Mac=SHA1
0xC0,0x21  -  SRP-RSA-AES-256-CBC-SHA        SSLv3    Kx=SRP       Au=RSA    Enc=AES(256)                Mac=SHA1
0xC0,0x20  -  SRP-AES-256-CBC-SHA            SSLv3    Kx=SRP       Au=SRP    Enc=AES(256)                Mac=SHA1
0x00,0xB7  -  RSA-PSK-AES256-CBC-SHA384      TLSv1    Kx=RSAPSK    Au=RSA    Enc=AES(256)                Mac=SHA384
0x00,0xB3  -  DHE-PSK-AES256-CBC-SHA384      TLSv1    Kx=DHEPSK    Au=PSK    Enc=AES(256)                Mac=SHA384
0x00,0x95  -  RSA-PSK-AES256-CBC-SHA         SSLv3    Kx=RSAPSK    Au=RSA    Enc=AES(256)                Mac=SHA1
0x00,0x91  -  DHE-PSK-AES256-CBC-SHA         SSLv3    Kx=DHEPSK    Au=PSK    Enc=AES(256)                Mac=SHA1
0x00,0x35  -  AES256-SHA                     SSLv3    Kx=RSA       Au=RSA    Enc=AES(256)                Mac=SHA1
0x00,0xAF  -  PSK-AES256-CBC-SHA384          TLSv1    Kx=PSK       Au=PSK    Enc=AES(256)                Mac=SHA384
0x00,0x8D  -  PSK-AES256-CBC-SHA             SSLv3    Kx=PSK       Au=PSK    Enc=AES(256)                Mac=SHA1
0xC0,0x37  -  ECDHE-PSK-AES128-CBC-SHA256    TLSv1    Kx=ECDHEPSK  Au=PSK    Enc=AES(128)                Mac=SHA256
0xC0,0x35  -  ECDHE-PSK-AES128-CBC-SHA       TLSv1    Kx=ECDHEPSK  Au=PSK    Enc=AES(128)                Mac=SHA1
0xC0,0x1E  -  SRP-RSA-AES-128-CBC-SHA        SSLv3    Kx=SRP       Au=RSA    Enc=AES(128)                Mac=SHA1
0xC0,0x1D  -  SRP-AES-128-CBC-SHA            SSLv3    Kx=SRP       Au=SRP    Enc=AES(128)                Mac=SHA1
0x00,0xB6  -  RSA-PSK-AES128-CBC-SHA256      TLSv1    Kx=RSAPSK    Au=RSA    Enc=AES(128)                Mac=SHA256
0x00,0xB2  -  DHE-PSK-AES128-CBC-SHA256      TLSv1    Kx=DHEPSK    Au=PSK    Enc=AES(128)                Mac=SHA256
0x00,0x94  -  RSA-PSK-AES128-CBC-SHA         SSLv3    Kx=RSAPSK    Au=RSA    Enc=AES(128)                Mac=SHA1
0x00,0x90  -  DHE-PSK-AES128-CBC-SHA         SSLv3    Kx=DHEPSK    Au=PSK    Enc=AES(128)                Mac=SHA1
0x00,0x2F  -  AES128-SHA                     SSLv3    Kx=RSA       Au=RSA    Enc=AES(128)                Mac=SHA1
0x00,0xAE  -  PSK-AES128-CBC-SHA256          TLSv1    Kx=PSK       Au=PSK    Enc=AES(128)                Mac=SHA256
0x00,0x8C  -  PSK-AES128-CBC-SHA             SSLv3    Kx=PSK       Au=PSK    Enc=AES(128)                Mac=SHA1

```

## Openssl 下AES加密和解密

### 1.引入OpenSSL

```swift
import OpenSSL
```

### 2.生成密钥和向量

AES256加解密，使用32位的密钥，16位的向量，可用随机数的方式生成密钥和向量

```swift
    func loadKeyAndIV() ->(key: [UInt8], iv: [UInt8])  {
        
        
        var key = [UInt8](repeating: 0, count: AES256Test.AESKeyLen)
        var iv = [UInt8](repeating: 0, count: AES256Test.AESIVLen)
        
        let aesKey = key.withUnsafeMutableBufferPointer { buf in
            
            RAND_bytes(buf.baseAddress, Int32(buf.count))
        }
        
        let aesIV = iv.withUnsafeMutableBufferPointer { buf in
            RAND_bytes(buf.baseAddress, Int32(buf.count))
        }
        
        print("Generated Key: \(key),\n key len:\(key.count)\nIV: \(iv)")
        
        
        return (key, iv)
    }
```

### 3.AES256加密

```swift
      func encryptedData(_ key: [UInt8], _ iv: [UInt8], _ text: String) -> Data? {
        
        guard let data = text.data(using: .utf8) else {
            return nil
        }
        
        var aesKey = AES_KEY()
        AES_set_encrypt_key(key, 256, &aesKey)
        
        var copiedData = Data(data)
        
        let appendDataLen = AES_BLOCK_SIZE - (Int32(data.count) % AES_BLOCK_SIZE)
        
        if appendDataLen > 0 {
            //AES_BLOCK_SIZE即16个字节一组，如果不足16个字节，补充至16个字节。PKCS7
            let fillBytes = Data(repeating: UInt8(appendDataLen), count: Int(appendDataLen))
            copiedData.append(fillBytes)
        }
        
        let loopNum = (Int32(copiedData.count)/AES_BLOCK_SIZE)
        var outData = Data(count: copiedData.count)
        
        copiedData.withUnsafeBytes { (inBuf: UnsafeRawBufferPointer) in
            outData.withUnsafeMutableBytes { (outBuf: UnsafeMutableRawBufferPointer) in
                guard let inBufPtr = inBuf.baseAddress?.assumingMemoryBound(to: UInt8.self),
                      let outBufPtr = outBuf.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return
                }
                
                for i in 0..<loopNum {
                    let offset = Int32(i) * AES_BLOCK_SIZE
                    AES_encrypt(inBufPtr.advanced(by: Int(offset)), outBufPtr.advanced(by: Int(offset)), &aesKey)
                }
            }
        }
        
        return outData
    }
```

### 4.AES256解密

```swift
func decryptedData(_ key: [UInt8], _ iv: [UInt8], _ data: Data) -> Data? {
        
        guard !data.isEmpty && Int32(data.count) % AES_BLOCK_SIZE == 0 else {
            return nil
        }
        
        var aesKey = AES_KEY()
        AES_set_decrypt_key(key, 256, &aesKey)
        
        var outData = Data(count: data.count)
        let loopNum = (Int32(data.count)/AES_BLOCK_SIZE)
        
        data.withUnsafeBytes({ (inBuf: UnsafeRawBufferPointer) in
            outData.withUnsafeMutableBytes { outBuf in
                guard let inBufPtr = inBuf.baseAddress?.assumingMemoryBound(to: UInt8.self),
                      let outBufPtr = outBuf.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return
                }
                for i in 0..<loopNum {
                    let offset = Int32(i) * AES_BLOCK_SIZE
                    AES_decrypt(inBufPtr.advanced(by: Int(offset)), outBufPtr.advanced(by: Int(offset)), &aesKey)
                }
            }
        })
        
        return removePKCS7Padding(outData, Int(AES_BLOCK_SIZE))
    }
```

### 5.AES256调用

```swift
    func test() {
        
        let result = self.loadKeyAndIV()
        let helloworld = "Hello world!1234567891011121314151617"
        print("---String:\(helloworld)---")
        let encryptedData = self.encryptedData(result.key, result.iv, helloworld)
        
        guard encryptedData != nil else {
            print("encryptedData fail")
            return
        }
        
        print("---encryptedData:\(encryptedData!)---")
        let decryptedData = self.decryptedData(result.key, result.iv, encryptedData!)
        
        guard decryptedData != nil else {
            print("decryptedData fail")
            return
        }
        
        let decryptedString = String(data: decryptedData!, encoding: .utf8)
        
        print("---decryptedString:\(decryptedString)---")
    }
```

执行情况
```terminal
Generated Key: [162, 231, 91, 155, 215, 253, 224, 101, 8, 143, 64, 142, 39, 11, 11, 237, 185, 127, 213, 147, 20, 20, 251, 88, 157, 96, 28, 28, 42, 174, 63, 45],
 key len:32
IV: [246, 239, 34, 73, 154, 100, 89, 195, 192, 52, 55, 235, 125, 80, 111, 165]
---String:Hello world!1234567891011121314151617---
---encryptedData:48 bytes---
---decryptedString:Optional("Hello world!1234567891011121314151617")---
```


