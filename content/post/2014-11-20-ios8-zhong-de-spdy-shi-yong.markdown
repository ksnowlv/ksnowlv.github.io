---
title: "iOS8中的spdy使用"
date: 2014-11-20
categories:
  - "iOS"
tags:
  - "网络"
---
<!--more-->

### spdy需要客户端和服务端同时支持。
<!--more-->

#### 1.spdy available on both OS X Yosemite and iOS 8 
SPDY/2, SPDY/3, and SPDY/3.1 are supported Supported transparently by NSURLSession No source changes needed—it just works

``` objective-c
 NSURL *url = [NSURL URLWithString:@"https://www.example.com/"];
  NSURLSessionDataTask *task = [[NSURLSession sharedSession]
        dataTaskWithURL:url
      completionHandler:^(NSData *data, NSURLResponse *response,
                          NSError *error) {
                          
   }];
  [task resume];

```

直接复用session,启用spdy.

#### 2.SPDY does require server-side support
* Client negotiates with server during TLS handshake
* Uses https:// URLs
* Existing web server software and many CDNs already support SPDY 
Will not interfere with your NSURLProtocol subclasses
* Apps might have their own implementation of SPDY or other protocols