---
title: "Swift Openssl下aes Ofb128模式下加解密"
date: 2023-10-06T17:23:29+08:00
lastmod: 2023-10-06T17:23:29+08:00
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


## 一.AES OFB模式简介
AES OFB（Output Feedback）模式是一种基于反馈的密码模式，它将 AES 块密码转换成流密码，使其可以对数据进行连续加密和解密，而不是分块。

在 OFB 模式中，加密和解密的输出需要与明文或密文进行异或操作生成，以便生成加密或解密的数据流。OFB 模式与 CFB 模式的功能类似，但两者的块大小不同。

### 1.OFB 模式的工作原理

*  1.首先，需要创建一个随机的初始向量（IV），其长度等于块大小。
* 2.接下来，需要使用初始 IV 经过 AES 块加密算法生成一个密钥流。
* 3.使用生成的密钥流对明文进行异或操作，得到密文。
* 4.在加密后，使用生成的密钥流对密文进行异或操作即可得到原始的明文，无需使用解密函数。

### 2.OFB工作模式注意事项
* OFB模式加密和解密均使用加密key，反常规，务必注意。
* OFB模式不需要对输入数据进行填充。
* AES_ofb128_encrypt函数既可以加密，又可以解密。
  * 当输入为明文时，执行的是加密操作，输出是密文。
  * 当输入为密文时，执行的是解密操作，输出是明文。
  * 其加解密是对等的。

## 二.swift Openssl aes ofb加解密

### 1.swift 加解密
```swift
 func encryptedDecryptedDataWithOFB(_ key: [UInt8], _ iv: [UInt8], _ data: Data) -> Data? {
        
        guard !data.isEmpty else {
            return nil
        }
        
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
//              OFB模式下，如果输入是明文，输出是密文；如果输入是密文，输出明文
                AES_ofb128_encrypt(inBufPtr, outBufPtr, data.count, &aesKey, ivData, &numBytesWritten)
            }
        }

        return outData
    }
```


### 2.swift 调用

```swift
 func loadKeyAndIV16() ->(key: [UInt8], iv: [UInt8])  {
        
        
        var key = [UInt8](repeating: 0, count: AES256Test.AESKeyLen16)
        var iv = [UInt8](repeating: 0, count: AES256Test.AESIVLen)
        
        let aesKey = key.withUnsafeMutableBufferPointer { buf in
            
            let res = RAND_bytes(buf.baseAddress, Int32(buf.count))
            if res != 1 {
                print("key res = \(res)")
            }
        }
        
        let aesIV = iv.withUnsafeMutableBufferPointer { buf in
            let res = RAND_bytes(buf.baseAddress, Int32(buf.count))
            
            if res != 1 {
                print("iv res = \(res)")
            }
        }
        
        print("Generated Key: \(key),\n key len:\(key.count)\nIV: \(iv) \nIV len: \(iv.count)")
        
        
        return (key, iv)
        
    }


  func testOFB() {
        print("---AES test OFB---")
        
        let result = self.loadKeyAndIV16()
        
        let helloworld = "Hello world!012345678901011121314151617181920212223"
//        let helloworld = "Hello world"
        print("---String:\(helloworld)---")
        guard let data = helloworld.data(using: .utf8) else { return  }
        
        let encryptedData = self.encryptedDecryptedDataWithOFB(result.key, result.iv, data)
        
        guard encryptedData != nil else {
            print("encryptedData fail")
            return
        }
        
        print("---encryptedData:---")
        encryptedData?.printBytes()
        
        let decryptedData = self.encryptedDecryptedDataWithOFB(result.key, result.iv, encryptedData!)
        
        guard decryptedData != nil else {
            print("decryptedData fail")
            return
        }
        
        print("\n---decryptedData:---")
        decryptedData?.printBytes()
        
        let decryptedString = String(data: decryptedData!, encoding: .utf8)
        
        print("\n---decryptedString:\(decryptedString ?? "")---")
        
    }
```

### 3.执行情况

```terminal
---AES test OFB---
Generated Key: [156, 128, 85, 45, 109, 126, 221, 53, 67, 104, 129, 204, 168, 219, 70, 153],
 key len:16
IV: [103, 193, 208, 69, 17, 164, 71, 246, 153, 152, 10, 215, 4, 179, 23, 85] 
IV len: 16
---String:Hello world!012345678901011121314151617181920212223---
---encryptedData:---
183 41 247 12 72 183 46 105 222 225 177 139 172 48 239 250 46 161 175 32 28 183 130 130 242 223 4 195 37 42 203 216 179 235 199 100 143 131 198 106 238 82 84 139 108 242 248 129 180 9 240 
---decryptedData:---
72 101 108 108 111 32 119 111 114 108 100 33 48 49 50 51 52 53 54 55 56 57 48 49 48 49 49 49 50 49 51 49 52 49 53 49 54 49 55 49 56 49 57 50 48 50 49 50 50 50 51 
---decryptedString:Hello world!012345678901011121314151617181920212223---

```
