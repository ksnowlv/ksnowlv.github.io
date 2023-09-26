---
title: "Swift Openssl中aes的使用"
date: 2023-09-25T18:04:01+08:00
lastmod: 2023-09-25T18:04:01+08:00
keywords: ["swift","iOS", "安全", "AES128","AES192", "AES256"]
tags: ["swift","iOS", "安全"]
categories: ["swift", "iOS", "安全"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## 一.openssl下aes算法及应用

### 1.AES加密模式

AES属于对称加密算法，加解密使用同一个秘钥。
对称加密算法，一般有至少4种模式，即CBC、ECB、CFB、OFB等。

### 2.AES块分组长度

AES 作为块密码算法，加解密的时候，需要将操作数据按固定长度的数据块进行分组后再进行处理。

对于AES算法，其分组长度都是固定16字节大小。

|  AES    | 密钥长度（字节) |分组长度（字节)|加密轮数
|:-------:|:--------:|:----:|:----:|
| AES-128 |   	16    |	16|	10
| AES-192 |   	24    |	16|	12
| AES-256 |   	32    |	16|	14

### 3.AES CBC模式

#### 加密
```swift
 func encryptedDataWithCBC(_ key: [UInt8], _ iv: [UInt8], _ text: String) -> Data? {
        
        guard let data = text.data(using: .utf8) else {
            return nil
        }
        
        var aesKey = AES_KEY()
        AES_set_encrypt_key(key, 256, &aesKey)
        
        let ivData = UnsafeMutablePointer<UInt8>.allocate(capacity: iv.count)
        ivData.initialize(from: iv, count: iv.count)
        
        defer {
            ivData.deallocate()
        }
        
        var copiedData = Data(data)
        let appendDataLen = AES_BLOCK_SIZE - (Int32(data.count) % AES_BLOCK_SIZE)
        
        if appendDataLen > 0 {
            let fillBytes = Data(repeating: UInt8(appendDataLen), count: Int(appendDataLen))
            copiedData.append(fillBytes)
        }
    
        var outData = Data(count: copiedData.count)
        
        copiedData.withUnsafeBytes { inBuf in
            
            outData.withUnsafeMutableBytes { outBuf in
                
                guard let inBufPtr = inBuf.baseAddress?.assumingMemoryBound(to: UInt8.self),
                      let outBufPtr = outBuf.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return
                }
                
                AES_cbc_encrypt(inBufPtr,
                                outBufPtr,
                                copiedData.count,
                                &aesKey,
                                ivData,
                                AES_ENCRYPT)
            }
        }
        
        return outData
    }
```

#### 解密
```swift
 func decryptedDataWithCBC(_ key: [UInt8], _ iv: [UInt8], _ data: Data) -> Data? {
        
        guard !data.isEmpty && Int32(data.count) % AES_BLOCK_SIZE == 0 else {
            return nil
        }
        
        var aesKey = AES_KEY()
        AES_set_decrypt_key(key, 256, &aesKey)
        
        let ivData = UnsafeMutablePointer<UInt8>.allocate(capacity: iv.count)
        ivData.initialize(from: iv, count: iv.count)
        
        defer {
            ivData.deallocate()
        }
        
        var outData = Data(count: data.count)
        data.withUnsafeBytes { inBuf in
            
            outData.withUnsafeMutableBytes { outBuf in
                
                guard let inBufPtr = inBuf.baseAddress?.assumingMemoryBound(to: UInt8.self),
                      let outBufPtr = outBuf.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return
                }
                
                AES_cbc_encrypt(inBufPtr,
                                outBufPtr,
                                data.count,
                                &aesKey,
                                ivData,
                                AES_DECRYPT)
            }
        }
        
        return removePKCS7Padding(outData, Int(AES_BLOCK_SIZE))
    }
```

#### 调用
```swift
    func testCBC() {
        print("---AES CBC---")
        
        let result = self.loadKeyAndIV()
        
//        let helloworld = "Hello world!12345678910111213141516"
        let helloworld = "Hello world!"
        print("---String:\(helloworld)---")
        let encryptedData = self.encryptedDataWithCBC(result.key, result.iv, helloworld)
        
        guard encryptedData != nil else {
            print("encryptedData fail")
            return
        }
        
        print("---encryptedData:\(encryptedData!)---")
        let decryptedData = self.decryptedDataWithCBC(result.key, result.iv, encryptedData!)
        
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
---AES CBC---
Generated Key: [181, 6, 58, 227, 195, 46, 0, 253, 51, 240, 74, 72, 53, 252, 140, 26, 253, 132, 65, 189, 105, 191, 127, 95, 89, 127, 133, 152, 119, 215, 117, 215],
 key len:32
IV: [115, 30, 152, 81, 198, 144, 196, 122, 248, 211, 105, 187, 153, 0, 239, 19]
---String:Hello world!---
---encryptedData:16 bytes---
---decryptedString:Optional("Hello world!")---

```

### 4.AES ECB模式

#### 加密
```swift
  func encryptedDataWithECB(_ key: [UInt8], _ text: String) -> Data? {
        
        guard let data = text.data(using: .utf8) else {
            return nil
        }
    
        var aesKey = AES_KEY()
        AES_set_encrypt_key(key, 256, &aesKey)
        
        var copiedData = Data(data)
        let appendDataLen = AES_BLOCK_SIZE - (Int32(data.count) % AES_BLOCK_SIZE)
        
        if appendDataLen > 0 {
            let fillBytes = Data(repeating: UInt8(appendDataLen), count: Int(appendDataLen))
            copiedData.append(fillBytes)
        }
 
        var outData = Data(count: copiedData.count)
        let loopNum = (Int32(copiedData.count)/AES_BLOCK_SIZE)
        
        copiedData.withUnsafeBytes { inBuf in
            
            outData.withUnsafeMutableBytes { outBuf in
                
                guard let inBufPtr = inBuf.baseAddress?.assumingMemoryBound(to: UInt8.self),
                      let outBufPtr = outBuf.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return
                }
                
                for i in 0..<loopNum {
                    let offset = Int32(i) * AES_BLOCK_SIZE
                    AES_ecb_encrypt(inBufPtr.advanced(by: Int(offset)), outBufPtr.advanced(by: Int(offset)), &aesKey, AES_ENCRYPT)
                }
                
            }
        }
        
        return outData
    }
```

#### 解密
```swift

    func decryptedDataWithECB(_ key: [UInt8], _ data: Data) -> Data? {
        
        guard !data.isEmpty && Int32(data.count) % AES_BLOCK_SIZE == 0 else {
            return nil
        }
        
        var aesKey = AES_KEY()
        AES_set_decrypt_key(key, 256, &aesKey)
        
        var outData = Data(count: data.count)
        let loopNum = (Int32(data.count)/AES_BLOCK_SIZE)
        
        data.withUnsafeBytes { inBuf in
            
            outData.withUnsafeMutableBytes { outBuf in
                
                guard let inBufPtr = inBuf.baseAddress?.assumingMemoryBound(to: UInt8.self),
                      let outBufPtr = outBuf.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return
                }
                
                for i in 0..<loopNum {
                    let offset = Int32(i) * AES_BLOCK_SIZE
                    AES_ecb_encrypt(inBufPtr.advanced(by: Int(offset)), outBufPtr.advanced(by: Int(offset)), &aesKey, AES_DECRYPT)
                }
                
            }
        }
        
        return removePKCS7Padding(outData, Int(AES_BLOCK_SIZE))
    }
```

#### 调用
```swift
  func testECB() {
        print("---AES testECB---")
        
        let result = self.loadKeyAndIV()
        
        let helloworld = "Hello world!12345678910111213141516"
        print("---String:\(helloworld)---")
        let encryptedData = self.encryptedDataWithECB(result.key, helloworld)
        
        guard encryptedData != nil else {
            print("encryptedData fail")
            return
        }
        
        print("---encryptedData:\(encryptedData!)---")
        let decryptedData = self.decryptedDataWithECB(result.key, encryptedData!)
        
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
---AES testECB---
Generated Key: [20, 22, 60, 126, 140, 150, 178, 146, 152, 105, 37, 154, 100, 22, 207, 213, 101, 236, 247, 34, 241, 33, 207, 19, 208, 227, 196, 183, 72, 162, 216, 27],
 key len:32
IV: [27, 81, 41, 109, 181, 65, 72, 235, 232, 153, 25, 196, 221, 141, 249, 32]
---String:Hello world!12345678910111213141516---
---encryptedData:48 bytes---
---decryptedString:Optional("Hello world!12345678910111213141516")---
```

### 5.AES CFB模式

#### 加密
```swift
 func encryptedDataWithCFB(_ key: [UInt8], _ iv: [UInt8], _ text: String) -> Data? {
        
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

                AES_cfb128_encrypt(inBufPtr, outBufPtr, data.count, &aesKey, ivData, &numBytesWritten, AES_ENCRYPT)
                print("AES_ENCRYPT outBufLen= \(numBytesWritten)")
                
            }
        }

        return outData
    }
```

#### 解密
```swift
     func decryptedDataWithCFB(_ key: [UInt8], _ iv: [UInt8], _ data: Data) -> Data? {
   
        guard !data.isEmpty else {
            return nil
        }

        var aesKey = AES_KEY()
        //特别注意：CFB模式加密和解密均使用加密key。
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
                
                AES_cfb128_encrypt(inBufPtr, outBufPtr, data.count, &aesKey, ivData, &numBytesWritten, AES_DECRYPT)
                print("AES_DECRYPT outBufLen= \(numBytesWritten)")
            }
        }

        return outData
    }
```

#### 调用
```swift
    func testCFB() {
        print("---AES testCFB---")
        
        let result = self.loadKeyAndIV16()
 
        let helloworld = "Hello world!012345678901011121314151617181920212223"
        print("---String:\(helloworld)---")
        let encryptedData = self.encryptedDataWithCFB(result.key, result.iv, helloworld)
        
        guard encryptedData != nil else {
            print("encryptedData fail")
            return
        }
        
        print("---encryptedData:---")
        encryptedData?.printBytes()
        
        let decryptedData = self.decryptedDataWithCFB(result.key, result.iv, encryptedData!)
        
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
执行情况
```terminal
---AES testCFB---
Generated Key: [212, 228, 96, 171, 216, 125, 199, 202, 77, 115, 113, 51, 105, 35, 87, 181],
 key len:16
IV: [61, 253, 30, 9, 157, 3, 137, 134, 243, 135, 132, 124, 211, 68, 63, 129] 
IV len: 16
---String:Hello world!012345678901011121314151617181920212223---
72 101 108 108 111 32 119 111 114 108 100 33 48 49 50 51 52 53 54 55 56 57 48 49 48 49 49 49 50 49 51 49 52 49 53 49 54 49 55 49 56 49 57 50 48 50 49 50 50 50 51 AES_ENCRYPT outBufLen= 3
---encryptedData:---
53 69 78 75 93 244 27 246 178 80 137 222 160 219 130 199 55 103 224 194 239 24 129 19 146 160 95 153 63 35 143 72 197 102 254 115 98 56 47 255 153 174 82 213 43 163 152 184 51 163 83 AES_DECRYPT outBufLen= 3
---decryptedData:---
72 101 108 108 111 32 119 111 114 108 100 33 48 49 50 51 52 53 54 55 56 57 48 49 48 49 49 49 50 49 51 49 52 49 53 49 54 49 55 49 56 49 57 50 48 50 49 50 50 50 51 ---decryptedString:Optional("Hello world!012345678901011121314151617181920212223")---

```

