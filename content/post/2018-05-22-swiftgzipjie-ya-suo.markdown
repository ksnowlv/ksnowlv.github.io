---
title: "swift之gzip解压缩(一)-Data"
date: 2018-05-22
lastmod: 2018-05-22
categories:
  - "swift"
tags:
  - "swift"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

解压缩使用swift需要引用libz库

## 一.声明Data类的扩展

```swift
/**解压缩流大小**/
private let GZIP_STREAM_SIZE: Int32 = Int32(MemoryLayout<z_stream>.size)
/**解压缩缓冲区大小**/
private let GZIP_BUF_LENGTH:Int = 512
/**默认空数据**/
private let GZIP_NULL_DATA = Data()

``` 

## 二.判断是否zip压缩后的数据。

```swift
   public var isGZipCompressed :Bool {
        return self.starts(with: [0x1f,0x8b])
    }
```


## 三.gzip压缩

```swift
public func gzipCompress() -> Data {
        
        guard self.count > 0 else {
            return self
        }
        
        var stream = z_stream()
        stream.avail_in = uInt(self.count)
        stream.total_out = 0
        
        self.withUnsafeBytes { (bytes:UnsafePointer<Bytef>) in
            stream.next_in = UnsafeMutablePointer<Bytef>(mutating:bytes)
        }

        var status = deflateInit2_(&stream,Z_DEFAULT_COMPRESSION, Z_DEFLATED, MAX_WBITS + 16, MAX_MEM_LEVEL, Z_DEFAULT_STRATEGY, ZLIB_VERSION, GZIP_STREAM_SIZE)
        
        if  status != Z_OK {
            return  GZIP_NULL_DATA
        }

        var compressedData = Data()
        
        while stream.avail_out == 0 {
            
            if Int(stream.total_out) >= compressedData.count {
                compressedData.count += GZIP_BUF_LENGTH
            }
            
            stream.avail_out = uInt(GZIP_BUF_LENGTH)
            
            compressedData.withUnsafeMutableBytes { (bytes:UnsafeMutablePointer<Bytef>) -> Void in
                stream.next_out = bytes.advanced(by: Int(stream.total_out))
            }
            
            status = deflate(&stream, Z_FINISH)
            
            if status != Z_OK && status != Z_STREAM_END {
                return GZIP_NULL_DATA
            }
        }
        
        guard deflateEnd(&stream) == Z_OK else {
            return GZIP_NULL_DATA
        }
        
        compressedData.count = Int(stream.total_out)
        return compressedData
    }
```

## 四.gzip解压

```swift
    public func gzipUncompress() ->Data {
        guard self.count > 0  else {
            return GZIP_NULL_DATA
        }
        
        guard self.isGZipCompressed else {
            return self
        }
        
        var  stream = z_stream()
      
        self.withUnsafeBytes { (bytes:UnsafePointer<Bytef>) in
            stream.next_in =  UnsafeMutablePointer<Bytef>(mutating: bytes)
        }
        
        stream.avail_in = uInt(self.count)
        stream.total_out = 0
      
        
        var status: Int32 = inflateInit2_(&stream, MAX_WBITS + 16, ZLIB_VERSION,GZIP_STREAM_SIZE)
        
        guard status == Z_OK else {
            return GZIP_NULL_DATA
        }
        
        var decompressed = Data(capacity: self.count * 2)
        while stream.avail_out == 0 {

            stream.avail_out = uInt(GZIP_BUF_LENGTH)
            decompressed.count += GZIP_BUF_LENGTH

            decompressed.withUnsafeMutableBytes { (bytes:UnsafeMutablePointer<Bytef>)in
                 stream.next_out = bytes.advanced(by: Int(stream.total_out))
            }

            status = inflate(&stream, Z_SYNC_FLUSH)

            if status != Z_OK && status != Z_STREAM_END {
                break
            }
        }
        
        if inflateEnd(&stream) != Z_OK {
            return GZIP_NULL_DATA
        }
        
        decompressed.count = Int(stream.total_out)
        return decompressed
    }

```

## 五.示例

``` swift
        let string = "Hello world!"
        let helloData =  string.data(using: .utf8)
        let compressData =   helloData?.gzipCompress()
        let uncompressData =  compressData?.gzipUncompress()
        let resString =  String(data: uncompressData!, encoding: String.Encoding.utf8)
        print(resString)
        
```