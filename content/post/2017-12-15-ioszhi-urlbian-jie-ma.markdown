---
title: "iOS之url编解码"
date: 2017-12-15
categories:
  - "iOS-基础"
tags:
  - "iOS-基础"
---
<!--more-->


iOS 开发中，经常需要对url编码与解码。

<!--more-->

### iOS9之前#### 1.url编码```objective-c

+ (NSString*)encodeUrl:(NSString *)urlString {
    if (0 == urlString.length) {
        return KBlankString;
    }
    
    return (__bridge_transfer NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)urlString,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8);
}
```

#### 2.url解码
```objective-c
+ (NSString *)decodeUrl:(NSString *)urlString {
    
    if (0 == urlString.length) {
        return KBlankString;
    }
    
    return (__bridge_transfer NSString*) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                 (__bridge CFStringRef)urlString,
                                                                                                 CFSTR(""),kCFStringEncodingUTF8);
    
}

```

### iOS7之后。
#### 1.url编码```objective-c
+ (NSString *)URLEncode:(NSString *)urlString {
    if (0 == urlString.length) {
        return KBlankString;
    }
    return [urlString stringByAddingPercentEncodingWithAllowedCharacters:[self URLEncodeCharSet]];
}

static NSCharacterSet *_sharedCharacterSet = nil;

+ (NSCharacterSet *)URLEncodeCharSet {
    
    if (nil == _sharedCharacterSet) {
        _sharedCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"] invertedSet];
    }
    
    return _sharedCharacterSet;
}

```

#### 2.url解码
```objective-c
+ (NSString *)URLDecode:(NSString *)urlString {
    if (0 == urlString.length) {
        return KBlankString;
    }
    
    return [urlString stringByRemovingPercentEncoding];
}

```
