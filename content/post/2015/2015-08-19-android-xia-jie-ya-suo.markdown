---
title: "Android下gzip数据流解压缩"
date: 2015-08-19
lastmod: 2015-08-19

keywords: ["Android", "解压缩"]
tags: ["Android"]
categories: ["Android"]

comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

在Android开发中，网络传输的数据如果采用压缩的方式，能大大减少网络流量，对文本的数据效果更明显。


### 一.gzip压缩

```java

 	public static byte[] gzipCompress(final byte[] data) {

        if (0 == data.length){
            return KEmptyByteArray;
        }


        byte[] pBuf = KEmptyByteArray;


        try {
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            GZIPOutputStream gzip = new GZIPOutputStream(byteArrayOutputStream);
            gzip.write(data);
            gzip.close();
            pBuf = byteArrayOutputStream.toByteArray();
            byteArrayOutputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return pBuf;
    }
    
```  


### 二. gzip解压

```java

    public static byte[] gzipUncompress(final byte[] data) {

        byte[] pBuf = KEmptyByteArray;
        if (data.length > 0) {
             ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(data);
            final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            GZIPInputStream gzipInputStream = null;
            try {

                gzipInputStream = new GZIPInputStream(byteArrayInputStream);

                int byteCount = 0;

                while (byteCount >= 0) {
                    byteCount = gzipInputStream.read(KGZipUncompressBuffer);
                    if(byteCount>0){
                        byteArrayOutputStream.write(KGZipUncompressBuffer, 0, byteCount);
                    }

                }

                pBuf = byteArrayOutputStream.toByteArray();

            }catch(IOException e){
                Log.w("gzip uncompressed fail", e.getMessage());
            }
            finally {

                try {
                    if (null !=byteArrayInputStream){
                        byteArrayInputStream.close();
                    }

                    if (null != byteArrayOutputStream){
                        byteArrayOutputStream.close();
                    }

                    if (null != gzipInputStream){
                        gzipInputStream.close();
                    }
                }
                catch (IOException e){
                    Log.w("gzip", e.getMessage());
                }
            }
        }

        return pBuf;
    }
    
``` 

### 三.gzip数据的判断
```java
    //判断一个数据流是否是GZip
    public static boolean isGZipData(final byte[] data){

        if (data.length > 2
                && data[0] == KYKGZipHeaderFirstByte
                && data[1] == KYKGZipHeaderSecondByte){
            return true;
        }

        return false;
    }

```  

### 四.说明

#### 1.KGZipUncompressBufferKGZipUncompressBuffer是一固定大小的内存缓冲区，减少内存的频繁创建与过大内存的分配。
#### 2.GZip数据流识别KYKGZipHeaderFirstByte|KYKGZipHeaderSecondByte：第一个字节0x1f(31),第二个字节为0x8b(139),标识为GZIP格式

    