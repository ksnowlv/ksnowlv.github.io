---
layout: post
title: "iOS有限后台任务"
date: 2015-08-19 20:37
comments: true
categories: iOS-基础
---
iOS下有限后台任务如何使用呢？

<!--more-->
iOS应用，在切换到后台时，可以开启有限后台任务。
见[苹果开发文档](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplication_Class/)，

####一.几个相关方法
* 1.beginBackgroundTaskWithExpirationHandler

* 2.beginBackgroundTaskWithName:expirationHandler
* 3.endBackgroundTask
* 4.setMinimumBackgroundFetchInterval


####二.切换到后台的处理
```objective-c

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    self.backgroundTaskIdentifier =
    [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:self.backgroundTaskIdentifier];
        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }];
    
	//添加自己的处理逻辑

}

```

####三.切换到前台的处理

```objective-c
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
   if (self.backgroundTaskIdentifier != UIBackgroundTaskInvalid){
         [application endBackgroundTask:self.backgroundTaskIdentifier];
         self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
   }
    
}

```