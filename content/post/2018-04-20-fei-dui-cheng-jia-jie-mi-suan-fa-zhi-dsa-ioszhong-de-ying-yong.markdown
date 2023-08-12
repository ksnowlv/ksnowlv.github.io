---
title: "非对称加解密算法之DSA-iOS中的应用"
date: 2018-04-20
categories:
  - "安全"
tags:
  - "安全"
---
<!--more-->


#### 1.引用openssl库。[https://github.com/x2on/OpenSSL-for-iPhone](https://github.com/x2on/OpenSSL-for-iPhone)
<!--more-->

#### 2.对数据进行签名。
```objective-c

/*对数据进行签名
 @param data 要签名的数据
 @return 签名后数据
 */
- (NSData *)sign:(NSData *)data {
    
    int dsaSize = DSA_size(_privateDSAKey);
    
    unsigned char *signBuf = (unsigned char *)calloc(dsaSize, 1);
    memset(signBuf, 0, dsaSize *sizeof(unsigned char));
    unsigned int signBufLength = 0;
    
    int res = DSA_sign(0, (const unsigned char *) data.bytes, (int)data.length, signBuf, &signBufLength, _privateDSAKey);
    
    if ( 1 == res ) {
        return [NSData dataWithBytesNoCopy:signBuf length:signBufLength];
    }
    
    free(signBuf);
    return nil;
}

```

#### 3.对数据进行验签。
```objective-c

/*进行数据的DSA验签
 @param data      原数据
 @param signData 签名后的数据
 @return 是否成功
 */
 
- (BOOL)verify:(NSData *)data withSignData:(NSData *)signData {
    return  DSA_verify(0, (const unsigned char *)[data bytes], (int)data.length,  (const unsigned char *)[signData bytes], (int)signData.length, _publicDSAKey) == 1;
}

```

#### 4.在加签和验签前加载公钥与私钥。
```objective-c

/*使用dsa公钥与私钥
 @param privateKey 私钥
 @param publicKey 公钥
 */
- (void)setUpPrivateKey:(NSString *)privateKey withPublicKey:(NSString *)publicKey {
    
    BIO *bio = BIO_new_mem_buf((void *)[privateKey cStringUsingEncoding:NSUTF8StringEncoding], -1);
    _privateDSAKey = PEM_read_bio_DSAPrivateKey(bio, NULL, NULL, NULL);
    
    BIO_free(bio);
    
    bio = BIO_new_mem_buf((void *)[publicKey cStringUsingEncoding:NSUTF8StringEncoding], -1);
    _publicDSAKey = PEM_read_bio_DSA_PUBKEY(bio, NULL, NULL, NULL);
    BIO_free(bio);
}
```

#### 5.测试。```objective-c
 KDSASign *sign = [KDSASign new];
    [sign setUpPrivateKey:priKey withPublicKey:pubKey];
    
    NSData *resData =  [sign sign:[orginalString dataUsingEncoding:NSUTF8StringEncoding]];
    BOOL isVerify =  [sign verify:[orginalString dataUsingEncoding:NSUTF8StringEncoding] withSignData:resData];
    
    if (isVerify) {
        NSLog(@"验签通过");
    }else{
        NSLog(@"验签失败");
    }

```

#### 6.其它* 1.接口为什么设计成这样？加载公钥与私钥和加签，验签接口合并？
* 2.为什么没有采用单例？
* 3.为什么接口没有使用类方法？