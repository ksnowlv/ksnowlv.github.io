---
title: "Mac Wireshark截包https"
date: 2023-09-13T17:08:32+08:00
lastmod: 2023-09-13T17:08:32+08:00
keywords: ["Mac","Wireshark", "https"]
tags: ["Mac", "网络"]
categories: ["Mac","网络"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Mac Wireshark截取https
注：本人安装的Wireshark版本为Version 4.0.8 (v4.0.8-0-g81696bb74857)，以下操作基于该版本

Wireshark默认进行http，TCP，DNS等数据截包，如何进行https截包呢？

### 1.启动Wireshark

```terminal
(base) lvwei@lvweideMacBook-Pro wireshark_log % sudo wireshark
Password:
 ** (wireshark:10663) 16:23:45.621380 [GUI WARNING] -- Populating font family aliases took 219 ms. Replace uses of missing font family "SF Mono" with one that exists to avoid this cost. 
 ** (wireshark:10663) 16:23:51.397797 [Capture MESSAGE] -- Capture Start ...
 ** (wireshark:10663) 16:23:51.434589 [Capture MESSAGE] -- Capture started
 ** (wireshark:10663) 16:23:51.434615 [Capture MESSAGE] -- File: "/var/tmp/wireshark_Wi-Fi0A9FB2.pcapng"
2023-09-13 16:24:22.948 wireshark[10663:83770] TSM AdjustCapsLockLEDForKeyTransitionHandling - _ISSetPhysicalKeyboardCapsLockLED Inhibit

```

### 2.配置wireshark支持https
在偏好设置中打开protocols->TLS选项，并指定log file文件。

![image](/images/post/Mac-wireshark截包https/tls_setting1.jpg)
![image](/images/post/Mac-wireshark截包https/tls_setting2.jpg)

### 3.启动chorme

使用**sudo**命令启动Chrome，并指定--ssl-key-log-file路径，此处为/Users/lvwei/Documents/wireshark_log/log.log
其中**log.log**用纯文本空文件创建即可

示例如下

```terminal
sudo /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --ssl-key-log-file=/Users/lvwei/Documents/wireshark_log/log.log
```

详细情况
```terminal
(base) lvwei@lvweideMacBook-Pro wireshark % sudo /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --ssl-key-log-file=/Users/lvwei/Documents/wireshark_log/log.log

Password:
[11366:259:0913/163039.128144:ERROR:chrome_browser_main.cc(1059)] The use of Rosetta to run the x64 version of Chromium on Arm is neither tested nor maintained, and unexpected behavior will likely result. Please check that all tools that spawn Chromium are Arm-native.
[11366:61955:0913/163212.371104:ERROR:login_database_async_helper.cc(97)] Encryption is not available.
[11366:47363:0913/163212.371217:ERROR:login_database_async_helper.cc(97)] Encryption is not available.
2023-09-13 16:32:12.419 Google Chrome[11366:90616] KSPaths accessing user domain product actives store as root. [com.google.Keystone.SharedErrorDomain:1001 - 'KSPaths.m:402']
2023-09-13 16:32:12.421 Google Chrome[11366:90616] Error while attempting to write actives: (<KSError:0x13400fd36c0
	domain="com.google.Keystone.SharedErrorDomain"
	code=1001
	userInfo={
		NSLocalizedDescription = "KSPaths accessing user domain product actives store as root.";
		line = 402;
		filename = "KSPaths.m";
		function = "+[KSPaths userKeystoneSubDirectoryWithName:error:]";
		date = 2023-09-13 08:32:12 +0000;
	}
>)
[11366:259:0913/163212.428422:ERROR:dock.mm(165)] dock_plist is not an NSDictionary
[11366:259:0913/163212.815803:ERROR:dock.mm(165)] dock_plist is not an NSDictionary
2023-09-13 16:32:13.132 Google Chrome[11366:90616] KSPaths accessing user domain Keystone directory as root. [com.google.Keystone.SharedErrorDomain:1001 - 'KSPaths.m:331']
2023-09-13 16:32:13.132 Google Chrome[11366:90616] KSBundle could not obtain user bundle path. [com.google.Keystone.SharedErrorDomain:1201 - 'KSBundle.m:44'] (KSPaths accessing user domain Keystone directory as root. [com.google.Keystone.SharedErrorDomain:1001])

```

### 4.wireshark截包
#### 1.过滤掉非http请求
可以查看http/https请求/响应情况
![image](/images/post/Mac-wireshark截包https/main.jpg)

#### 2.跟踪HTTP流、TCP流行等
![image](/images/post/Mac-wireshark截包https/main1.jpg)
选中跟踪HTTP流示例
![image](/images/post/Mac-wireshark截包https/main2.jpg)
