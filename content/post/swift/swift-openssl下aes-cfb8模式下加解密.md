---
title: "Swift Openssl下aes Cfb8模式下加解密"
date: 2023-10-04T20:05:42+08:00
lastmod: 2023-10-04T20:05:42+08:00
keywords: ["swift","iOS", "安全", "AES128","AES192", "AES256"]
tags: ["swift","iOS", "安全"]
categories: ["swift","iOS", "安全"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


CFB（Cipher Feedback）模式是一种流密码模式，它允许将块密码转换成流密码，使其可以对数据进行连续加密和解密，而不是分块。

在 CFB 模式中，加密和解密的输出需要与明文或密文进行异或操作生成，以便生成加密或解密的数据流。

## 特别注意
### 1.CFB模式加密和解密均使用加密key，这一点反常规，务必注意。
### 2.CFB模式不需要对输入数据进行填充。

## 一.AES CFB8 模式
### 1.CFB8 模式的块大小为 8 位，因此可以对每个字节进行加密和解密.
### 2.CFB8 模式是字节级模式
### 3.CFB1 和 CFB8 模式可以为流密码提供更快的加密和解密速度，并且它们可以用于不同长度的消息

## 二.swift Openssl aes cfb8模块加解密

### 1.swift 加密

```swift
func encryptedDataWithCFB8(_ key: [UInt8], _ iv: [UInt8], _ text: String) -> Data? {
        
        guard let data = text.data(using: .utf8) else {
            return nil
        }
        
        data.printBytes()

        var aesKey = AES_KEY()
        let res = AES_set_encrypt_key(key, 128, &aesKey)
        
        guard res == 0 else {
            return nil
        }

        var outData = Data(count: data.count)
        var numBytesWritten: Int32 = 0

        let ivData = UnsafeMutablePointer<UInt8>.allocate(capacity: iv.count)
        ivData.initialize(from: iv, count: iv.count)
        
        defer {
            ivData.deallocate()
        }
        
        data.withUnsafeBytes { inBuf in
            
            outData.withUnsafeMutableBytes { outBuf in
                
                guard let inBufPtr = inBuf.baseAddress?.assumingMemoryBound(to: UInt8.self),
                      let outBufPtr = outBuf.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return
                }

                AES_cfb8_encrypt(inBufPtr, outBufPtr, data.count, &aesKey, ivData, &numBytesWritten, AES_ENCRYPT)
                print("AES_ENCRYPT outBufLen= \(numBytesWritten)")
                
            }
        }

        return outData
    }
   
```

### 2.swift 解密
```swift
func decryptedDataWithCFB8(_ key: [UInt8], _ iv: [UInt8], _ data: Data) -> Data? {
   
        guard !data.isEmpty else {
            return nil
        }

        var aesKey = AES_KEY()
        // 特别注意：CFB模式加密和解密均使用加密key。
        let res = AES_set_encrypt_key(key, 128, &aesKey)
        
        guard res == 0 else {
            return nil
        }
        
        var outData = Data(count: data.count)
        var numBytesWritten: Int32 = 0

        let ivData = UnsafeMutablePointer<UInt8>.allocate(capacity: iv.count)
        ivData.initialize(from: iv, count: iv.count)
        
        defer {
            ivData.deallocate()
        }
        
        data.withUnsafeBytes { inBuf in
            
            outData.withUnsafeMutableBytes { outBuf in
                
                guard let inBufPtr = inBuf.baseAddress?.assumingMemoryBound(to: UInt8.self),
                      let outBufPtr = outBuf.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return
                }
                
                AES_cfb8_encrypt(inBufPtr, outBufPtr, data.count, &aesKey, ivData, &numBytesWritten, AES_DECRYPT)
                print("AES_DECRYPT outBufLen= \(numBytesWritten)")
            }
        }

        return outData
    }
    
```

### 3.swift 调用

```swift
func testCFB8() {
        print("---AES testCFB8---")
        
        let result = self.loadKeyAndIV16()
        
        
        let helloworld = "Hello world!012345678901011121314151617181920212223"
        print("---String:\(helloworld)---")
        let encryptedData = self.encryptedDataWithCFB8(result.key, result.iv, helloworld)
        
        guard encryptedData != nil else {
            print("encryptedData fail")
            return
        }
        
        print("---encryptedData:---")
        encryptedData?.printBytes()
        
        let decryptedData = self.decryptedDataWithCFB8(result.key, result.iv, encryptedData!)
        
        guard decryptedData != nil else {
            print("decryptedData fail")
            return
        }
        
        print("---decryptedData:---")
        decryptedData?.printBytes()
        
        let decryptedString = String(data: decryptedData!, encoding: .utf8)
        
        print("---decryptedString:\(decryptedString)---")
        
    }
    
```

### 4.执行情况

```shell
---AES testCFB8---
Generated Key: [30, 249, 172, 111, 96, 217, 206, 190, 45, 33, 115, 28, 167, 127, 7, 168],
 key len:16
IV: [252, 59, 11, 113, 229, 50, 11, 143, 81, 195, 208, 14, 33, 129, 66, 124] 
IV len: 16
---String:Hello world!012345678901011121314151617181920212223---
72 101 108 108 111 32 119 111 114 108 100 33 48 49 50 51 52 53 54 55 56 57 48 49 48 49 49 49 50 49 51 49 52 49 53 49 54 49 55 49 56 49 57 50 48 50 49 50 50 50 51 AES_ENCRYPT outBufLen= 0
---encryptedData:---
8 196 49 141 186 195 167 221 143 39 78 240 108 114 108 178 152 84 187 156 84 174 198 178 233 226 217 238 223 8 103 78 162 160 250 208 39 34 132 208 47 66 196 27 59 11 137 253 77 36 68 AES_DECRYPT outBufLen= 0
---decryptedData:---
72 101 108 108 111 32 119 111 114 108 100 33 48 49 50 51 52 53 54 55 56 57 48 49 48 49 49 49 50 49 51 49 52 49 53 49 54 49 55 49 56 49 57 50 48 50 49 50 50 50 51 ---decryptedString:Optional("Hello world!012345678901011121314151617181920212223")---
-

```

