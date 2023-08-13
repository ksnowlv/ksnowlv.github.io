---
title: "swift-散列算法md5"
date: 2018-06-22
lastmod: 2018-06-22
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

## md5算法


swift中散列算法md5很常用。

```swift

    func md5() -> NSString {
        
        guard self.length > 0 else {
            return self
        }
        
        let utf8Buf = self.cString(using: String.Encoding.utf8.rawValue)
        let length = self.lengthOfBytes(using: String.Encoding.utf8.rawValue)
        
        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
        buffer.initialize(to: 0)
        CC_MD5(utf8Buf,CC_LONG(length), buffer)
        
        let md5String = NSMutableString()
        
        for i in 0 ..< CC_MD5_DIGEST_LENGTH {
            md5String.appendFormat("%02x", buffer[Int(i)])
        }
        
        buffer.deallocate()
        
        return md5String.uppercased as NSString
    }
```

## 注意事项
 记得在**bridging-header**中导入头文件 **CommonCrypto/CommonDigest.h**