---
layout: post
title: "iOS设备获取DNS-IP"
date: 2014-11-11 17:56
comments: true
categories: iOS-网络
---

iOS设备如何获取DNS-IP呢？
示例如下：

``` objective-c

#include <arpa/inet.h>
#include <ifaddrs.h>
#include <resolv.h>
#include <dns.h>

- (void)outPutDNSServers
{
    res_state res = malloc(sizeof(struct __res_state));
    
    int result = res_ninit(res);
    
    if ( result == 0 )
    {
        for ( int i = 0; i < res->nscount; i++ )
        {
            NSString *s = [NSString stringWithUTF8String :  inet_ntoa(res->nsaddr_list[i].sin_addr)];
            
            NSLog(@"%@",s);
        }
    }
    else
         NSLog(@"%@",@" res_init result != 0");
    
    res_nclose(res);
    
 
}

``` 

另外添加**libresolv.dylib**

日志输出：


``` objective-c
2014-11-11 17:52:03.111 NetWorkInfoTest[1870:2041786] 10.32.255.10
2014-11-11 17:52:03.112 NetWorkInfoTest[1870:2041786] 10.32.222.10

```