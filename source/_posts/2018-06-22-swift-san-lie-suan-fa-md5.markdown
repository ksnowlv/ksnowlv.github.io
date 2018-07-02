---
layout: post
title: "swift-散列算法md5"
date: 2018-06-22 18:02
comments: true
categories: swift-基础框架
---

swift中散列算法md5很常用。

```objective-c

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

###记得在bridging-header中导入头文件
 * CommonCrypto/CommonDigest.h