---
title: "加解密之RC4"
date: 2013-04-22
lastmod: 2013-04-22
categories:
  - "iOS"
tags:
  - "安全"
comment: true
toc: false
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

IPHONE开发过程中，可能会用到加解密之类的，这里使用IPHONE SDK自带的加密接口。主要是针对RC4方式下的加解密。

```objective-c
//
//  ViewController.m
//  RC4Test
//
//  Created by lv wei on 13-4-22.
//  Copyright (c) 2013年 lv wei. All rights reserved.
//

#import "ViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString* key = @"my little pang bao!";
    NSString* content = @"五一回家休息几天啊，好好出去转转玩玩!";
    NSData* initData = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData* encryptData = [self RC4Encrypt:initData withKey:key];
    printf("encryptData = %s\n",[encryptData description].UTF8String);
    
    NSData* decryptData = [self RC4Decrypt:encryptData withKey:key];
    NSString* utf8String = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    NSLog(@"decryptData = %@",utf8String);
    [utf8String release];
}

- (NSData *)RC4Encrypt:(NSData*)srcData withKey:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeMaxRC4+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [srcData length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCKeySizeMaxRC4;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmRC4, kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr, kCCKeySizeMaxRC4,
                                          NULL /* initialization vector (optional) */,
                                          [srcData bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSData *)RC4Decrypt:(NSData*)srcData withKey:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeMaxRC4+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [srcData length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmRC4, kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr, kCCKeySizeMaxRC4,
                                          NULL /* initialization vector (optional) */,
                                          [srcData bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

@end

```

运行结果如下：

	encryptData = <dc3fcda3 7fcdb553 772337cc eba99575 39a071e7 bdf85b49 c8538ffb 66a0c6f1 d79e1773 51967eae f7da1aac 5574edc4 59595855 8413bf>
	2013-04-22 17:34:16.297 RC4Test[12957:11303] decryptData = 五一回家休息几天啊，好好出去转转玩玩!
