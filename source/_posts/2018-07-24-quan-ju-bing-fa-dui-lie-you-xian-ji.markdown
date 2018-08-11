---
layout: post
title: "全局并发队列优先级"
date: 2018-07-24 14:23
comments: true
categories: swift
---

全局并发队（Global Queue）

* 老版gcd有四种：`high`，`default`，`low`，`background`，
	
	优先级为：high>default>low>background
	
* 新版gcd有六种：`background`，`utility`，`default`，`userInitiated`，`userInteractive`，`unspecified`

    优先级为：userInteractive>default>unspecified>userInitiated>utility>background
    
    测试代码如下：
    
    ```objective-c
     for i in 1...3 {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                NSLog("DispatchQoS.QoSClass.default, %d", i)
            }
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                NSLog("DispatchQoS.QoSClass.background, %d", i)
            }
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.unspecified).async {
                NSLog("DispatchQoS.QoSClass.unspecified, %d", i)
            }
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                NSLog("DispatchQoS.QoSClass.userInitiated, %d", i)
            }
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
                NSLog("DispatchQoS.QoSClass.userInteractive, %d", i)
            }
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
                NSLog("DispatchQoS.QoSClass.utility, %d", i)
            }
        }

    ```
    
    输出日志：
    
```objective-c
2018-07-24 15:04:12.619688+0800 YKBaseSwiftFramework[8252:505814] DispatchQoS.QoSClass.userInteractive, 3
2018-07-24 15:04:12.619688+0800 YKBaseSwiftFramework[8252:505813] DispatchQoS.QoSClass.userInteractive, 2
2018-07-24 15:04:12.619688+0800 YKBaseSwiftFramework[8252:505825] DispatchQoS.QoSClass.userInteractive, 1
2018-07-24 15:04:12.619716+0800 YKBaseSwiftFramework[8252:505820] DispatchQoS.QoSClass.default, 1
2018-07-24 15:04:12.619735+0800 YKBaseSwiftFramework[8252:505815] DispatchQoS.QoSClass.unspecified, 1
2018-07-24 15:04:12.619741+0800 YKBaseSwiftFramework[8252:505828] DispatchQoS.QoSClass.userInitiated, 1
2018-07-24 15:04:12.620001+0800 YKBaseSwiftFramework[8252:505830] DispatchQoS.QoSClass.default, 2
2018-07-24 15:04:12.620003+0800 YKBaseSwiftFramework[8252:505814] DispatchQoS.QoSClass.unspecified, 2
2018-07-24 15:04:12.620065+0800 YKBaseSwiftFramework[8252:505831] DispatchQoS.QoSClass.userInitiated, 2
2018-07-24 15:04:12.620101+0800 YKBaseSwiftFramework[8252:505832] DispatchQoS.QoSClass.default, 3
2018-07-24 15:04:12.620122+0800 YKBaseSwiftFramework[8252:505834] DispatchQoS.QoSClass.userInitiated, 3
2018-07-24 15:04:12.620133+0800 YKBaseSwiftFramework[8252:505833] DispatchQoS.QoSClass.unspecified, 3
2018-07-24 15:04:12.620143+0800 YKBaseSwiftFramework[8252:505827] DispatchQoS.QoSClass.utility, 1
2018-07-24 15:04:12.620286+0800 YKBaseSwiftFramework[8252:505829] DispatchQoS.QoSClass.utility, 2
2018-07-24 15:04:12.620343+0800 YKBaseSwiftFramework[8252:505835] DispatchQoS.QoSClass.utility, 3
2018-07-24 15:04:12.622419+0800 YKBaseSwiftFramework[8252:505824] DispatchQoS.QoSClass.background, 1
2018-07-24 15:04:12.622904+0800 YKBaseSwiftFramework[8252:505832] DispatchQoS.QoSClass.background, 2
2018-07-24 15:04:12.622998+0800 YKBaseSwiftFramework[8252:505831] DispatchQoS.QoSClass.background, 3

   ```