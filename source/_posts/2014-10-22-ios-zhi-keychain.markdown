---
layout: post
title: "iOS之Keychain"
date: 2014-10-22 17:51
comments: true
categories: iOS-存储
---


iOS之Keychain用途:提供了一种安全的保存私密信息的方式，每个ios程序都有一个独立的keychain存储,它保存的信息不会因App被删除而丢失，也可用于跨App共享keychain信息。见苹果开发文档[Keychain Services Programming Guide](https://developer.apple.com/library/ios/documentation/Security/Conceptual/keychainServConcepts/02concepts/concepts.html#//apple_ref/doc/uid/TP30000897-CH204-TP9)

Keychain Services Reference关键的方法如下

* SecItemCopyMatching
* SecItemAdd
* SecItemUpdate
* SecItemDelete

苹果官方提供了的demo程序[GenericKeychain](https://developer.apple.com/library/ios/samplecode/GenericKeychain/Introduction/Intro.html)，使用苹果封装的`KeychainItemWrapper.h`和`KeychainItemWrapper.m`提供的接口即可。

代码示例如下：

``` objective-c

    KeychainItemWrapper *uuid = [[KeychainItemWrapper alloc]
                                         initWithIdentifier:@"UUID"
                                         accessGroup:@"com.taobao.userinfo"];
    NSString *strUUID = [uuid objectForKey:(__bridge id)kSecValueData];
    
    if (strUUID.length == 0 )
    {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        strUUID =  CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        [uuid setObject:strUUID forKey:(__bridge id)kSecValueData];
        
        NSLog(@"create uuid");
        CFRelease(uuidRef);
    }
    
    NSLog(@"uuid = %@",strUUID);
    
```

可参考[源代码](https://github.com/ksnowlv/KeyChainTest.git)，该工程中的`KeychainItemWrapper.h`和`KeychainItemWrapper.m`是支持**ARC**的。

