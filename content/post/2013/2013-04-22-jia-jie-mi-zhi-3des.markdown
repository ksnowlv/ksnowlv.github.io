---
title: "加解密之3DES"
date: 2013-04-22
lastmod: 2013-04-22
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

## iPhone 3DES

iPhone开发过程中，可能会用到加解密之类的，这里使用iPhone SDK自带的加密接口。主要是针对3DES方式下的加解密。

### 1. 示例代码
* 加密
* 解密

```objective-c
//
//  ViewController.m
//  3DESTest
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
    
    NSData* encryptData = [self AESEncrypt:[content dataUsingEncoding:NSUTF8StringEncoding] withKey:key];
    printf("encryptData = %s\n",[encryptData description].UTF8String);
    
    NSData* decryptData = [self AESDecrypt:encryptData withKey:key];
    NSString* utf8String = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    NSLog(@"decryptData = %@",utf8String);
    [utf8String release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSData *) AESEncrypt:(NSData *)srcData withKey:(NSString*)key{
    
    char keyPtr[kCCKeySize3DES+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [srcData length];
    
    size_t buffer_size           = dataLength + kCCBlockSize3DES;
    void* buffer                 = malloc(buffer_size);
    size_t num_bytes_encrypted   = 0;

    CCCryptorStatus crypt_status = CCCrypt(kCCEncrypt, kCCAlgorithm3DES, kCCOptionPKCS7Padding,
                                           keyPtr, kCCKeySize3DES,
                                           NULL,
                                           [srcData bytes], dataLength,
                                           buffer, buffer_size,
                                           &num_bytes_encrypted);
    
    if (crypt_status == kCCSuccess){
        NSLog(@"~~ encrypt data successfully...");
        return [NSData dataWithBytesNoCopy:buffer length:num_bytes_encrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
    
}

- (NSData *) AESDecrypt:(NSData *)srcData withKey:(NSString*)key{
    char keyPtr[kCCKeySize3DES+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger data_length= [srcData length];
    
    size_t buffer_size           = data_length + kCCBlockSize3DES;
    void* buffer                 = malloc(buffer_size);
    size_t num_bytes_decrypted   = 0;
    
    
    CCCryptorStatus crypt_status = CCCrypt(kCCDecrypt, kCCAlgorithm3DES, kCCOptionPKCS7Padding,
                                           keyPtr, kCCKeySize3DES,
                                           NULL /* initialization vector (optional) */,
                                           [srcData bytes], data_length, /* input */
                                           buffer, buffer_size, /* output */
                                           &num_bytes_decrypted);
    
    if (crypt_status == kCCSuccess){
        NSLog(@"decrypt data successfully...");
        return [NSData dataWithBytesNoCopy:buffer length:num_bytes_decrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

@end

```

### 2.执行情况

```terminal
	2013-04-22 15:47:15.207 3DESTest[11832:11303] ~~ encrypt data successfully...
	encryptData = <685d98c2 68e6ea39 f238964b f78b3a46 27a7909f 546da9e3 56c7f844 d2353a51 fdeb2e7c 749dcb17 3c7dc951 0883fe5c cf46974e db2d10a9>
	2013-04-22 15:47:15.209 3DESTest[11832:11303] decrypt data successfully...
	2013-04-22 15:47:15.209 3DESTest[11832:11303] decryptData = 五一回家休息几天啊，好好出去转转玩玩!
```
