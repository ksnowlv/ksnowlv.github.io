---
title: "常见散列算法"
date: 2018-04-17
lastmod: 2018-04-17
categories:
  - "iOS"
tags:
  - "安全"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

## 散列算法

 常见的单向散列算法，可用于数字签名，单向的，不可逆向，**并非加密算法**。
 
 主要用途是为了校验数据在传输过程中是否被修改。

* 1.MD5(Message Digest algorithm 5，信息摘要算法)
* 2.SHA(Secure Hash Algorithm，安全散列算法)
* 3.HMAC(Hash Message Authentication Code，散列消息鉴别码)

其中sha1（安全性sha1 > md5）因为安全性问题，在iOS上推荐SHA224/SHA256/SHA384/SHA512.

这些散列算法，通常用来校验数据在传输过程中是否被修改。其中HMAC算法有一个密钥，增强了数据传输过程中的安全性，强化了算法外的不可控因素。 
 
### 1.iOS散列算法声明文件

```objective-c

typedef NS_ENUM(NSUInteger, YKSHAType) {
    YKSHATypeUnknown,
    YKSHATypeSha1,
    YKSHATypeSha224,
    YKSHATypeSha256,
    YKSHATypeSha384,
    YKSHATypeSha512,
};


/**
    如基本的单向散列算法
 **/
@interface YKEncryption : NSObject

/**
 MD5(Message Digest algorithm 5，信息摘要算法)
 **/

+ (NSString *)md5:(NSString *)source;

/**
SHA(Secure Hash Algorithm，安全散列算法)
 支持类型见YKSHAType定义
 **/
+ (NSString *)SHA:(NSString *)source shaType:(YKSHAType)shaType;

/**
HMAC(Hash Message Authentication Code，散列消息鉴别码)
 **/
+ (NSString *)hmac:(NSString *)source withKey:(NSString *)key;

@end
```


### 2.iOS散列算法实现文件

```objective-c
import "YKEncryption.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation YKEncryption

+ (NSString *)md5:(NSString *)source{
    
    if (0 == source.length) {
        return nil;
    }
    
    NSData *data = [source dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    memset(result, 0, CC_MD5_DIGEST_LENGTH * sizeof(unsigned char));
    
    CC_MD5(data.bytes, (unsigned int)data.length, result);
    
    NSMutableString *dest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];//
    
    for(NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [dest appendFormat:@"%02x",result[i]];
    }
    
    return [dest lowercaseString];
}



+ (NSString *)SHA:(NSString *)source shaType:(YKSHAType)shaType {
    if (0 == source.length || shaType < YKSHATypeSha1 || shaType > YKSHATypeSha512) {
        return nil;
    }
    
    NSData *data = [source dataUsingEncoding:NSUTF8StringEncoding];
    
    //CC_SHA512_DIGEST_LENGTH > CC_SHA384_DIGEST_LENGTH> CC_SHA256_DIGEST_LENGTH > CC_SHA224_DIGEST_LENGTH > CC_SHA1_DIGEST_LENGTH
    //resultData = calloc(length, sizeof(uint8_t)); need free(resultData) 使用定长数组，减少内存碎片。
    uint8_t resultData[CC_SHA512_DIGEST_LENGTH];
    memset(resultData, 0, CC_SHA512_DIGEST_LENGTH * sizeof(uint8_t));
    NSInteger resultDataLength = 0;
    
    switch (shaType) {
        case YKSHATypeSha1:{
            resultDataLength = CC_SHA1_DIGEST_LENGTH;
            CC_SHA1(data.bytes, (CC_LONG)data.length, resultData);
        }
            
            break;
            
        case YKSHATypeSha224:{
            resultDataLength = CC_SHA224_DIGEST_LENGTH;
            CC_SHA224(data.bytes, (CC_LONG)data.length, resultData);
        }
            
            break;
            
        case YKSHATypeSha256:{
            resultDataLength = CC_SHA256_DIGEST_LENGTH;
            CC_SHA256(data.bytes, (CC_LONG)data.length, resultData);
        }
            
            break;
            
        case YKSHATypeSha384:{
            resultDataLength = CC_SHA384_DIGEST_LENGTH;
            CC_SHA384(data.bytes, (CC_LONG)data.length, resultData);
        }
            break;
            
        case YKSHATypeSha512:{
            resultDataLength = CC_SHA512_DIGEST_LENGTH;
            CC_SHA512(data.bytes, (CC_LONG)data.length, resultData);
        }
            break;
        default:
            break;
    }
    
    NSMutableString* result = [NSMutableString stringWithCapacity:resultDataLength * 2];
    
    for(NSInteger i = 0; i < resultDataLength; i++) {
        [result appendFormat:@"%02x", resultData[i]];
    }
    
    return [result lowercaseString];
}

+ (NSString *)hmac:(NSString *)source withKey:(NSString *)key {
    
    if (0 == source.length ) {
        return nil;
    }
    
    NSData *sourceData = [source dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char hmac[CC_SHA256_DIGEST_LENGTH];
    memset(hmac, 0, CC_SHA256_DIGEST_LENGTH * sizeof(unsigned char));
    
    CCHmac(kCCHmacAlgSHA256, keyData.bytes, keyData.length, sourceData.bytes, sourceData.length, hmac);
    
    NSData *hmacData = [NSData dataWithBytes:hmac length:sizeof(hmac)];
    const unsigned char *buffer = (const unsigned char *)[hmacData bytes];
    
    NSMutableString *resHMAC = [NSMutableString stringWithCapacity:hmacData.length * 2];
    
    for (int i = 0; i < hmacData.length; ++i){
        [resHMAC appendFormat:@"%02x", buffer[i]];
    }
    
    return [resHMAC lowercaseString];
}

```

可以使用[http://www.atool.org/hash.php](http://www.atool.org/hash.php)对照散列后的值是否一致？

### 3.示例：

```objective-c
	NSString *source = @"hello world! 你是全世界!";
	NSString *resString = [YKEncryption md5:source];
	NSLog(@"md5 res = %@",resString);
	    
	    
	resString = [YKEncryption SHA:source shaType:YKSHATypeSha1];
	NSLog(@"sha1 res = %@",resString);
	    
	resString = [YKEncryption SHA:source shaType:YKSHATypeSha224];
	NSLog(@"sha224 res = %@",resString);
	resString = [YKEncryption SHA:source shaType:YKSHATypeSha256];
	NSLog(@"sha256 res = %@",resString);
	    
	resString = [YKEncryption SHA:source shaType:YKSHATypeSha384];
	NSLog(@"sha384 res = %@",resString);
	    
	resString = [YKEncryption SHA:source shaType:YKSHATypeSha512];
	NSLog(@"sha512 res = %@",resString);
	    
	resString = [YKEncryption hmac:source withKey:@"abc"];
    
NSLog(@"hmac res = %@",resString);
```

完整demo见[HashTest](git@github.com:ksnowlv/HashTest.git)