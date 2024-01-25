---
title: "Swift Openssl下aes Cfb1模式下加解密"
date: 2023-10-05T20:07:22+08:00
lastmod: 2023-10-05T20:07:22+08:00
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


## 一.AES CFB1 模式
### 1.CFB1 模式的块大小为 1 位（而不是字节），因此只能对每个比特进行加密和解密
### 2.CFB1 模式是比特级密钥流模式，因为其块大小就是 1 位。
### 3.CFB1 和 CFB8 模式可以为流密码提供更快的加密和解密速度，并且它们可以用于不同长度的消息
### 4. AES_cfb1_encrypt函数length参数，为输入数据的位数，即输入数据长度*8，而不是字节数。

## 二.swift Openssl aes cfb8模块加解密

### 1.swift 加密
```swift
 func encryptedDataWithCFB1(_ key: [UInt8], _ iv: [UInt8], _ text: String) -> Data? {
        
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

                AES_cfb1_encrypt(inBufPtr, outBufPtr, data.count * 8, &aesKey, ivData, &numBytesWritten, AES_ENCRYPT)
                print("AES_ENCRYPT outBufLen= \(numBytesWritten)")
                
            }
        }

        return outData
    }
```

### 2.swift 解密
```swift
func decryptedDataWithCFB1(_ key: [UInt8], _ iv: [UInt8], _ data: Data) -> Data? {
   
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
                
                AES_cfb1_encrypt(inBufPtr, outBufPtr, data.count * 8, &aesKey, ivData, &numBytesWritten, AES_DECRYPT)
                print("AES_DECRYPT outBufLen= \(numBytesWritten)")
            }
        }

        return outData
    }
```

### 3.swift 调用

```swift
 func testCFB1() {
        print("---AES testCFB1---")
        
        let result = self.loadKeyAndIV16()
        
        
//        let helloworld = "Hello world!012345678901011121314151617181920212223"
        let helloworld = "Hello world"
        print("---String:\(helloworld)---")
        let encryptedData = self.encryptedDataWithCFB1(result.key, result.iv, helloworld)
        
        guard encryptedData != nil else {
            print("encryptedData fail")
            return
        }
        
        print("---encryptedData:---")
        encryptedData?.printBytes()
        
        let decryptedData = self.decryptedDataWithCFB1(result.key, result.iv, encryptedData!)
        
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
---AES testCFB1---
Generated Key: [104, 247, 101, 146, 249, 6, 239, 133, 109, 115, 7, 13, 137, 243, 27, 4],
 key len:16
IV: [29, 184, 26, 181, 74, 103, 112, 236, 47, 132, 201, 215, 187, 4, 29, 32] 
IV len: 16
---String:Hello world---
72 101 108 108 111 32 119 111 114 108 100 AES_ENCRYPT outBufLen= 0
---encryptedData:---
139 74 80 56 132 130 171 117 222 210 42 AES_DECRYPT outBufLen= 0
---decryptedData:---
72 101 108 108 111 32 119 111 114 108 100 ---decryptedString:Optional("Hello world")---

```
