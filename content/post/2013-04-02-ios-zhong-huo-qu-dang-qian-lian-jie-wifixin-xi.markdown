---
title: "iOS中获取当前连接WIFI信息"
date: 2013-04-25
categories:
  - "iOS"
tags:
  - "网络"
---
<!--more-->

iOS系统中，通过公有API不能获取周围所有Wifi的信息，但是，可以获取设备当前连接WiFi的信息。

<!--more-->

### 1.引入头文件和库
    #import <SystemConfiguration/SystemConfiguration.h>
    #import <SystemConfiguration/CaptiveNetwork.h>
    和SystemConfiguration.framework
    
### 2.示例代码
``` objective-c

CFArrayRef arrayRef = CNCopySupportedInterfaces();
NSArray* netArray = (NSArray *)arrayRef;
NSLog(@"wifi num=%d", netArray.count);

for (NSString*  netName in netArray) {
CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((CFStringRef)netName);
if (dictRef != NULL) {
    NSDictionary *networkInfo = (NSDictionary *)dictRef;
    NSLog(@"network info = %@", networkInfo);
    CFStringRef ssid = CFDictionaryGetValue(dictRef, kCNNetworkInfoKeySSID);
    //mac address
    CFStringRef bssid = CFDictionaryGetValue(dictRef, kCNNetworkInfoKeyBSSID);
    CFStringRef ssidData = CFDictionaryGetValue(dictRef, kCNNetworkInfoKeySSIDData);
    
    NSLog(@"ssid = %@ bssid = %@,ssid data = %@",ssid,bssid,ssidData);
    CFRelease(dictRef);
   }
}

CFRelease(arrayRef);

```    

### 3.输出日志
``` objective-c

2013-04-26 11:17:09.501 dbTest_sqlite[1619:c303] wifi num=1
2013-04-26 11:17:09.502 dbTest_sqlite[1619:c303] network info = {
    BSSID = 0;
    SSID = "Tencent-FreeWiFi";
    SSIDDATA = <54656e63 656e742d 46726565 57694669>;
}
2013-04-26 11:17:09.503 dbTest_sqlite[1619:c303] ssid = Tencent-FreeWiFi bssid = 0,ssid data = <54656e63 656e742d 46726565 57694669>

``` 
