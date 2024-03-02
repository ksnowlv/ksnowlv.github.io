---
title: "swift之gzip解压缩(二)-NSData"
date: 2018-06-22
lastmod: 2018-06-22
categories:
  - "swift"
tags:
  - "swift"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---


工程目前以objective-c为主，采用的是swift与objective-c混编方式，因此对NSData作了扩展。


### 1.gzip压缩

```swift
 /// gzip数据压缩
    ///
    /// - Returns: Data
    public func gzipCompress() -> NSData? {
        
        guard self.length > 0 else {
            return self
        }
        
        var stream = z_stream()
        stream.avail_in = uInt(self.length)
        stream.total_out = 0
        
        (self as Data).withUnsafeBytes { (bytes:UnsafePointer<Bytef>) in
            stream.next_in = UnsafeMutablePointer<Bytef>(mutating:bytes)
        }

        var status = deflateInit2_(&stream,Z_DEFAULT_COMPRESSION, Z_DEFLATED, MAX_WBITS + 16, MAX_MEM_LEVEL, Z_DEFAULT_STRATEGY, ZLIB_VERSION, GZIP_STREAM_SIZE)
        
        if  status != Z_OK {
            return  nil
        }

        let compressedData = NSMutableData()
        
        while stream.avail_out == 0 {
            
            stream.avail_out = uInt(GZIP_BUF_LENGTH)
            stream.next_out = GZipBuf
            
            status = deflate(&stream, Z_FINISH)
            
            if status != Z_OK && status != Z_STREAM_END {
                return nil
            }else {
                let dataLength = GZIP_BUF_LENGTH - Int(stream.avail_out)
                
                if dataLength > 0 {
                    compressedData.append(GZipBuf, length: dataLength)
                }
                
            }
        }
        
        guard deflateEnd(&stream) == Z_OK else {
            return nil
        }
    
        return compressedData
    }

```

### 2.gzip解压

```swift

    /// gzip数据解压
    ///
    /// - Returns: NSData
    public func gzipUncompress() -> NSData? {
        guard self.length > 0 else {
            return nil
        }
        
        guard self.isGZipCompressed else {
            return self
        }
        
        var  stream = z_stream()
        
        (self as Data).withUnsafeBytes { (bytes:UnsafePointer<Bytef>) in
            stream.next_in = UnsafeMutablePointer<Bytef>(mutating:bytes)
        }

        stream.avail_in = uInt(self.length)
        stream.total_out = 0
      

        var status: Int32 = inflateInit2_(&stream, MAX_WBITS + 16, ZLIB_VERSION,GZIP_STREAM_SIZE)
        
        guard status == Z_OK else {
            return nil
        }

        let decompressed = NSMutableData(capacity: self.length * 2)
     
        while stream.avail_out == 0 {

            stream.avail_out = uInt(GZIP_BUF_LENGTH)
            stream.next_out = GZipBuf
            status = inflate(&stream, Z_SYNC_FLUSH)

            if status != Z_OK && status != Z_STREAM_END {
                break
            }else {
                
                let dataLen :Int = GZIP_BUF_LENGTH - Int(stream.avail_out);
                
                if dataLen > 0 {
                    decompressed?.append(GZipBuf, length: dataLen)
                }
            }
        }
        
        if inflateEnd(&stream) != Z_OK {
            return nil
        }
        
        return decompressed!
    }
  
```

