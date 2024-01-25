---
title: "Swift Data中withUnsafeBytes进行gzip压缩的陷阱"
date: 2023-08-16T15:25:01+08:00
lastmod: 2023-08-16T15:25:01+08:00
keywords: ["Swift", "解压缩", "Data"]
tags: ["Swift", "解压缩"]
categories: ["Swift", "解压缩"]

comment: true
toc: true
autoCollapseToc: true
reward: true

---

<!--more-->

## 问题

Swift Data gzip压缩时，通过withUnsafeBytes操作数据时，针对小数据量时，会出现压缩内容，不符合预期的情况。如何解决呢？

例如：

```swift
       var  stream = z_stream()

        (self as Data).withUnsafeBytes { (bytes:UnsafePointer<Bytef>) in
            stream.next_in = UnsafeMutablePointer<Bytef>(mutating:bytes)
            stream.avail_in = uInt((self as Data).count)
        }
```

## 解决方案

```swift
        let uncompressedDataPointer = UnsafeMutablePointer<Bytef>(mutating: self.bytes.bindMemory(to: Bytef.self, capacity: (self as Data).count))
        let uncompressedDataLength = uInt(self.count)

        var stream = z_stream()
        stream.total_out = 0
        stream.avail_in = uInt(uncompressedDataLength)
        stream.next_in = uncompressedDataPointer
```

## 效果验证

```swift
        let string = "Hello你好"
        let helloData =  string.data(using: .utf8)
        let compressData =   (helloData as? NSData)?.gzipCompressData()
        let uncompressData =  compressData?.gzipDataUncompress() as? Data
        let resString =  String(data: uncompressData ?? Data(), encoding: .utf8)
        print("resString:\(resString ?? "")")

```




