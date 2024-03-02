---
title: "iOS push机制"
date: 2014-10-21
lastmod: 2014-10-21
categories:
  - "iOS"
tags:
  - "iOS"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---


### 一. push原理
iOS push工作机制可以使用下图概括：
![image](/images/post/2014-10-21-ios-push-ji-zhi/apple_push_overview.png)

* Provider:应用自己的服务器；
* APNS:Apple Push Notification Service的简称，苹果Push服务器.

可以简化为：
![image](/images/post/2014-10-21-ios-push-ji-zhi/apple_push_flow_diagram.jpg)


### 二. push执行时序可由下图示意：

![image](/images/post/2014-10-21-ios-push-ji-zhi/apple_push_timing_diagram.jpg)


### 三. push for iOS客户端-deviceToken
![image](/images/post/2014-10-21-ios-push-ji-zhi/apple_push_flow_diagram_for_client.jpg)


#### .关于客户端获取deviceToken
   服务端要发送push消息给某一设备还必须知道该设备的deviceToken。应用运行后获取到deviceToken，然后上传给服务器.
   下面介绍如何获取deviceToken?

* 1. 应用必须先注册使用push功能。

``` objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    
  }

``` 

* 2.在AppDelegate中添加下面方法来获取deviceToken：

``` objective-c
// Delegation methods
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    const void *devTokenBytes = [devToken bytes];
    self.registered = YES;
    [self sendProviderDeviceToken:devTokenBytes]; // custom method
}
 
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

```

应用获取到deviceToken后，上传给Provider，Provider就可以用这个deviceToken给这个设备push消息了。

    通常情况下，deviceToken是不会改变的；有时同一台设备可能有不同的deviceToken。关于该主题可以搜索相关内容
    所以，当deviceToken改变时一定要通知服务器更新。
    
### 四.push for provider
服务器配置好证书并拿到deviceToken后就可以向APNS发送消息了. 发送消息的格式有两种：

* 1.简单消息格式

![image](/images/post/2014-10-21-ios-push-ji-zhi/apple_push_payload_simple.png)

``` objective-c

static bool sendPayload(SSL *sslPtr, char *deviceTokenBinary, char *payloadBuff, size_t payloadLength)
{
    bool rtn = false;
    if (sslPtr && deviceTokenBinary && payloadBuff && payloadLength)
    {
        uint8_t command = 0; /* command number */
        char binaryMessageBuff[sizeof(uint8_t) + sizeof(uint16_t) +
            DEVICE_BINARY_SIZE + sizeof(uint16_t) + MAXPAYLOAD_SIZE];
        /* message format is, |COMMAND|TOKENLEN|TOKEN|PAYLOADLEN|PAYLOAD| */
        char *binaryMessagePt = binaryMessageBuff;
        uint16_t networkOrderTokenLength = htons(DEVICE_BINARY_SIZE);
        uint16_t networkOrderPayloadLength = htons(payloadLength);
 
        /* command */
        *binaryMessagePt++ = command;
 
       /* token length network order */
        memcpy(binaryMessagePt, &networkOrderTokenLength, sizeof(uint16_t));
        binaryMessagePt += sizeof(uint16_t);
 
        /* device token */
        memcpy(binaryMessagePt, deviceTokenBinary, DEVICE_BINARY_SIZE);
        binaryMessagePt += DEVICE_BINARY_SIZE;
 
        /* payload length network order */
        memcpy(binaryMessagePt, &networkOrderPayloadLength, sizeof(uint16_t));
        binaryMessagePt += sizeof(uint16_t);
 
        /* payload */
        memcpy(binaryMessagePt, payloadBuff, payloadLength);
        binaryMessagePt += payloadLength;
        if (SSL_write(sslPtr, binaryMessageBuff, (binaryMessagePt - binaryMessageBuff)) > 0)
            rtn = true;
    }
    return rtn;
}

```


* 2.增强型消息格式
![image](/images/post/2014-10-21-ios-push-ji-zhi/apple_push_payload_Enhanced.png)

``` objective-c

static bool sendPayload(SSL *sslPtr, char *deviceTokenBinary, char *payloadBuff, size_t payloadLength)
{
  bool rtn = false;
  if (sslPtr && deviceTokenBinary && payloadBuff && payloadLength)
  {
      uint8_t command = 1; /* command number */
      char binaryMessageBuff[sizeof(uint8_t) + sizeof(uint32_t) + sizeof(uint32_t) + sizeof(uint16_t) +
          DEVICE_BINARY_SIZE + sizeof(uint16_t) + MAXPAYLOAD_SIZE];
      /* message format is, |COMMAND|ID|EXPIRY|TOKENLEN|TOKEN|PAYLOADLEN|PAYLOAD| */
      char *binaryMessagePt = binaryMessageBuff;
      uint32_t whicheverOrderIWantToGetBackInAErrorResponse_ID = 1234;
      uint32_t networkOrderExpiryEpochUTC = htonl(time(NULL)+86400); // expire message if not delivered in 1 day
      uint16_t networkOrderTokenLength = htons(DEVICE_BINARY_SIZE);
      uint16_t networkOrderPayloadLength = htons(payloadLength);
 
      /* command */
      *binaryMessagePt++ = command;
 
     /* provider preference ordered ID */
     memcpy(binaryMessagePt, &whicheverOrderIWantToGetBackInAErrorResponse_ID, sizeof(uint32_t));
     binaryMessagePt += sizeof(uint32_t);
 
     /* expiry date network order */
     memcpy(binaryMessagePt, &networkOrderExpiryEpochUTC, sizeof(uint32_t));
     binaryMessagePt += sizeof(uint32_t);
 
     /* token length network order */
      memcpy(binaryMessagePt, &networkOrderTokenLength, sizeof(uint16_t));
      binaryMessagePt += sizeof(uint16_t);
 
      /* device token */
      memcpy(binaryMessagePt, deviceTokenBinary, DEVICE_BINARY_SIZE);
      binaryMessagePt += DEVICE_BINARY_SIZE;
 
      /* payload length network order */
      memcpy(binaryMessagePt, &networkOrderPayloadLength, sizeof(uint16_t));
      binaryMessagePt += sizeof(uint16_t);
 
      /* payload */
      memcpy(binaryMessagePt, payloadBuff, payloadLength);
      binaryMessagePt += payloadLength;
      if (SSL_write(sslPtr, binaryMessageBuff, (binaryMessagePt - binaryMessageBuff)) > 0)
          rtn = true;
  }
  return rtn;
}

```


### 五. push for iOS客户端-处理push消息
iOS系统收到push消息后，如果用户点击查看,

* 1.如果应用已经启动，将调用application:didReceiveRemoteNotification的方法：

``` objective-c
 - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
      // userInfo 就是push消息Payload
  }
  

```
  
* 2.如果应用还没有启动，通过push冷启动后，仍然能在启动后获取Payload：

``` objective-c

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
      NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
  }
  
```
 
### 六.关于消息控制方面  
  可以在application:didReceiveRemoteNotification控制消息的显示，消失。

例如：

``` objective-c
[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0]; 

```

详情可参考苹果开发文档[Apple Push Notification Service](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/ApplePushService.html#//apple_ref/doc/uid/TP40008194-CH100-SW5)

  
  







