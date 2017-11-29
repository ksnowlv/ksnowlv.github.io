---
layout: post
title: "ZLib与GZip解压缩对比"
date: 2014-12-02 20:51
comments: true
categories: iOS-解压缩
---

###1.ZLib与GZip解压缩
    ZLib库默认解压缩方法，并非GZip解压缩，而是ZLib的。
    zlib(RFC1950):一种格式，是对deflate进行了简单的封装； 
    gzip(RFC1952):一种格式，也是对deflate进行的封装.
    gzip与GZip是一种数据压缩格式，可以大体分为头部，数据部和尾部三个部分
    gzip数据头比zlib数据头要大，因为它保存了文件名和其他文件系统信息，事实上这是广泛使用的gzip文件的数据头格式。
    而zlib和gzip格式的区别仅仅是头部和尾部不一样，而实际的内容都是deflate编码的，即： gzip = gzip头(10字节) + deflate编码的实际内容 + gzip尾(8字节)

<!--more-->

###ZLib头部
0x78,0x9c 是zlib数据头(非固定，参考RFC 1951)。或者0x0,0x0,0xFF,0xFF也可以实现正常解压缩，而00 00 FF FF是zlib容错方式的数据块头

####GZip头部：
第一个字节0x1f(31),第二个字节为0x8b(139),标识为GZIP格式。第三个字节为0x08(8)，指示DEFLATE方法.目前只有一种，CM=8;
    
####GZip尾部：
CRC32：4字节。原始(未压缩)数据的32位校验和。
ISIZE：4字节。原始(未压缩)数据的长度的低32位。
GZIP中字节排列顺序是LSB方式，即Little-Endian，与ZLIB中的相反

        

###2.objective-c版本的ZLib与GZip解压缩
####ZLib压缩
```objective-c

+ (NSData *)zlibCompressData:(NSData *)sourceData {

  NSUInteger sourceDataLength = [sourceData length];

  if (sourceDataLength == 0) {
    return sourceData;
  }

  z_stream stream;
  memset(&stream, 0, sizeof(z_stream));

  stream.next_in = (Bytef *)[sourceData bytes];
  stream.avail_in = (uInt)sourceDataLength;
  stream.total_out = 0;
  stream.zalloc = Z_NULL;
  stream.zfree = Z_NULL;

  if (deflateInit(&stream, Z_DEFAULT_COMPRESSION) != Z_OK) {
    return nil;
  }

  const int KBufLen = 1024;
  Byte buf[KBufLen];
  memset(buf, 0, KBufLen * sizeof(Byte));

  BOOL isCompressOK = NO;

  NSMutableData *compressedData =
      [NSMutableData dataWithLength:sourceDataLength];
  [compressedData setData:nil]; //必须得加

  int res = 0;

  while (stream.avail_out == 0) {

    memset(buf, 0, KBufLen * sizeof(Byte));
    stream.avail_out = KBufLen;
    stream.next_out = buf;

    res = deflate(&stream, Z_FINISH);
    ;

    switch (res) {
    case Z_NEED_DICT:
    case Z_DATA_ERROR:
    case Z_MEM_ERROR:
    case Z_STREAM_ERROR:
    case Z_BUF_ERROR: {
      isCompressOK = NO;
      break;
    }

    default: {
      if (res == Z_OK || res == Z_STREAM_END) {
        const int dataLen = KBufLen - stream.avail_out;
        isCompressOK = YES;

        if (dataLen > 0) {
          [compressedData appendBytes:buf length:dataLen];
        }
      }

      break;
    }
    }

    if (!isCompressOK) {
      break;
    }
  }

  res = deflateEnd(&stream);
  if (res != Z_OK) {
    return nil;
  }

  if (isCompressOK) {
    return compressedData;
  } else {
    return nil;
  }
}

```

####ZLib解压
```objective-c
+ (NSData *)zlibUncompressData:(NSData *)sourceData {

  NSUInteger sourceDataLength = [sourceData length];

  if (sourceDataLength == 0) {
    return sourceData;
  }

  z_stream stream;
  memset(&stream, 0, sizeof(z_stream));

  stream.next_in = (Bytef *)[sourceData bytes];
  stream.avail_in = (uInt)sourceDataLength;
  stream.total_out = 0;
  stream.zalloc = Z_NULL;
  stream.zfree = Z_NULL;

  int res = inflateInit(&stream);
  // inflateInit2(&strm, (15+32))

  if (res != Z_OK) {
    return nil;
  }

  const int KBufLen = 1024;
  Byte buf[KBufLen];
  memset(buf, 0, KBufLen * sizeof(Byte));

  BOOL isUncompressOK = NO;

  NSMutableData *decompressed = [NSMutableData dataWithLength:sourceDataLength];
  [decompressed setData:nil]; //必须得加

  while (stream.avail_out == 0) {

    memset(buf, 0, KBufLen * sizeof(Byte));
    stream.avail_out = KBufLen;
    stream.next_out = buf;

    res = inflate(&stream, Z_NO_FLUSH);

    switch (res) {
    case Z_NEED_DICT:
    case Z_DATA_ERROR:
    case Z_MEM_ERROR:
    case Z_STREAM_ERROR:
    case Z_BUF_ERROR: {
      isUncompressOK = NO;
      break;
    }

    default: {
      if (res == Z_OK || res == Z_STREAM_END) {
        const int dataLen = KBufLen - stream.avail_out;
        isUncompressOK = YES;

        if (dataLen > 0) {
          [decompressed appendBytes:buf length:dataLen];
        }
      }

      break;
    }
    }

    if (!isUncompressOK) {
      break;
    }
  }

  if (inflateEnd(&stream) != Z_OK) {
    return nil;
  }

  if (isUncompressOK) {
    return decompressed;
  } else {
    return nil;
  }
}

```


####GZip压缩
```objective-c
+ (NSData *)gzipCompress:(NSData *)sourceData {

  NSUInteger sourceDataLength = [sourceData length];

  if (sourceDataLength == 0) {
    return sourceData;
  }

  z_stream stream;
  memset(&stream, 0, sizeof(z_stream));

  stream.next_in = (Bytef *)[sourceData bytes];
  stream.avail_in = (uInt)sourceDataLength;
  stream.total_out = 0;
  stream.zalloc = Z_NULL;
  stream.zfree = Z_NULL;

  //只有设置为MAX_WBITS + 16才能在在压缩文本中带header和trailer
  if (deflateInit2(&stream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, MAX_WBITS + 16,
                   8, Z_DEFAULT_STRATEGY) != Z_OK) {
    return nil;
  }

  const int KBufLen = 1024;
  Byte buf[KBufLen];
  memset(buf, 0, KBufLen * sizeof(Byte));

  BOOL isCompressOK = NO;

  NSMutableData *compressedData =
      [NSMutableData dataWithLength:sourceDataLength];
  [compressedData setData:nil]; //必须得加

  int res = 0;

  while (stream.avail_out == 0) {

    memset(buf, 0, KBufLen * sizeof(Byte));
    stream.avail_out = KBufLen;
    stream.next_out = buf;

    res = deflate(&stream, Z_FINISH);
    ;

    switch (res) {
    case Z_NEED_DICT:
    case Z_DATA_ERROR:
    case Z_MEM_ERROR:
    case Z_STREAM_ERROR:
    case Z_BUF_ERROR: {
      isCompressOK = NO;
      break;
    }

    default: {
      if (res == Z_OK || res == Z_STREAM_END) {
        const int dataLen = KBufLen - stream.avail_out;
        isCompressOK = YES;

        if (dataLen > 0) {
          [compressedData appendBytes:buf length:dataLen];
        }
      }

      break;
    }
    }

    if (!isCompressOK) {
      break;
    }
  }

  res = deflateEnd(&stream);
  if (res != Z_OK) {
    return nil;
  }

  if (isCompressOK) {
    return compressedData;
  } else {
    return nil;
  }
}

```


####GZip解压
```objective-c
+ (NSData *)gzipUncompress:(NSData *)sourceData {

  NSUInteger sourceDataLength = [sourceData length];

  if (sourceDataLength == 0) {
    return sourceData;
  }

  z_stream stream;
  memset(&stream, 0, sizeof(z_stream));

  stream.next_in = (Bytef *)[sourceData bytes];
  stream.avail_in = (uInt)sourceDataLength;
  stream.total_out = 0;
  stream.zalloc = Z_NULL;
  stream.zfree = Z_NULL;

  int res = inflateInit2(&stream, MAX_WBITS + 16);
  // inflateInit2(&strm, (15+32))
  //只有设置为MAX_WBITS + 16才能在解压带header和trailer的文本

  if (res != Z_OK) {
    return nil;
  }

  const int KBufLen = 1024;
  Byte buf[KBufLen];
  memset(buf, 0, KBufLen * sizeof(Byte));

  BOOL isUncompressOK = NO;

  NSMutableData *decompressed = [NSMutableData dataWithLength:sourceDataLength];
  [decompressed setData:nil]; //必须得加

  while (stream.avail_out == 0) {

    memset(buf, 0, KBufLen * sizeof(Byte));
    stream.avail_out = KBufLen;
    stream.next_out = buf;

    res = inflate(&stream, Z_SYNC_FLUSH);

    switch (res) {
    case Z_NEED_DICT:
    case Z_DATA_ERROR:
    case Z_MEM_ERROR:
    case Z_STREAM_ERROR:
    case Z_BUF_ERROR: {
      isUncompressOK = NO;
      break;
    }

    default: {
      if (res == Z_OK || res == Z_STREAM_END) {
        const int dataLen = KBufLen - stream.avail_out;
        isUncompressOK = YES;

        if (dataLen > 0) {
          [decompressed appendBytes:buf length:dataLen];
        }
      }

      break;
    }
    }

    if (!isUncompressOK) {
      break;
    }
  }

  if (inflateEnd(&stream) != Z_OK) {
    return nil;
  }

  if (isUncompressOK) {
    return decompressed;
  } else {
    return nil;
  }
}

```

###3.代码示例

```objective-c
NSString* hello = @"helloabc123";
    NSData *helloData = [NSData dataWithBytes:hello.UTF8String length:[hello lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    
NSData *compressData = [CommonFuctions zlibCompressData:helloData];
    
NSData *unCompressData = [CommonFuctions zlibUncompressData:compressData];
    
NSString* string = [[NSString alloc] initWithData:unCompressData encoding:NSUTF8StringEncoding];
    
NSLog(@"Zlib compressData Length = %lu compressData = %@", (unsigned long)compressData.length,[compressData description]);

NSData *compressDataGZip = [CommonFuctions gzipCompress:helloData];
    
NSData *uncompressDataGZip = [CommonFuctions gzipUncompress:compressDataGZip];
    
NSString* stringRes = [[NSString alloc] initWithData:uncompressDataGZip encoding:NSUTF8StringEncoding];;
    
NSLog(@"GZip compressData Length = %lu compressData = %@", (unsigned long)compressDataGZip.length,[compressDataGZip description]);
    
```

###4.日志输出：

```objective-c
2014-12-02 21:14:20.946 ZlibGZipTest[14417:4245959] Zlib compressData Length = 19 compressData = <789ccb48 cdc9c94f 4c4a3634 32060019 9003d1>
2014-12-02 21:14:24.142 ZlibGZipTest[14417:4245959] GZip compressData Length = 31 compressData = <1f8b0800 00000000 0003cb48 cdc9c94f 4c4a3634 32060012 e873880b 000000>
(lldb) 
```
###5.结论
####1.zlib默认压缩后比gzip小一点。
####2.zlib与gzip头尾对比。

* **zlib头**：789ccb48  **zlib尾**：32060019 9003d1
* **gzip头**：1f8b0800 00000000 0003cb48 **gzip尾**：32060012 e873880b 000000

两者相比差12个字节。

