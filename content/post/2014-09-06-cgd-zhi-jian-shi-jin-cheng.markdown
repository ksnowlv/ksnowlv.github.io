---
title: "CGD之监视进程"
date: 2014-09-06
lastmod: 2014-09-06
categories:
  - "iOS"
tags:
  - "多线程"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

**GCD**可以检测进程的运行，退出状态，可以检测到进程间的信号。

    #define DISPATCH_PROC_EXIT		0x80000000
    #define DISPATCH_PROC_FORK		0x40000000
    #define DISPATCH_PROC_EXEC		0x20000000
    #define DISPATCH_PROC_SIGNAL	   0x08000000
可以使用`dispatch source`捕获相关信号。

* **DISPATCH_PROC_EXIT**在**Mac**上可以捕获，在**iOS**上是无法捕获的。
* **DISPATCH_PROC_SIGNAL**在**Mac**/**iOS**上均可捕获。

#### 1.Mac上示例:
```objective-c
// 可以通过注释掉的代码找关掉应用的BundleIdentifier
//    NSArray *runningAppList = [NSWorkspace sharedWorkspace].runningApplications;
//    
//    NSLog(@"runningAppList = %@",runningAppList.description);
    
    NSArray *appList = [NSRunningApplication
                                  runningApplicationsWithBundleIdentifier:@"com.google.Chrome"];
    
    if (appList.count == 0 ) {
        return;
    }
    
    NSRunningApplication *chromeApp = appList[0];

    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_PROC, chromeApp.processIdentifier,
                                         DISPATCH_PROC_EXIT, DISPATCH_TARGET_QUEUE_DEFAULT);
    dispatch_source_set_event_handler(self.source, ^(){
        NSLog(@"google Chrome exit");
    });
    dispatch_resume(self.source);
    
```

#### 执行上述代码前，确保`google Chrome浏览器`是打开的，然后，退出`google Chrome浏览器`。 

``` objective-c

2014-09-06 16:16:34.261 MacSignalTest[4070:1003] google Chrome exit
    
```

#### 2. iOS示例
``` objective-c

    pid_t pid = getpid();
    pid_t uid = getuid();
    const char* name =  getprogname();
    
    NSLog(@"pid = %d uid = %d, progname = %s",pid,uid,name);
    
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_PROC, pid,
                                         DISPATCH_PROC_SIGNAL, DISPATCH_TARGET_QUEUE_DEFAULT);
    dispatch_source_set_event_handler(self.source, ^(){
        NSLog(@"ios app exit for signal!");
    });
    dispatch_resume(self.source);
    
```

当**signal**信号发出时，会触发**signal**事件。

``` objective-c

    
```
