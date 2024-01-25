---
title: "Linux下加载动态库cannot Open Shared Object File No Such File or Directory"
date: 2024-01-13T17:21:05+08:00
lastmod: 2024-01-13T17:21:05+08:00
keywords: ["Linux", "C++", "clion"]
tags: ["Linux", "C++", "clion"]
categories: ["Linux", "C++", "clion"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 1.问题
clion 运行C++ CMakeList工程时，/tmp/linux-sdk/cmake-build-debug-main/MAIN: error while loading shared libraries: libPocoCrypto.so.100: cannot open shared object file: No such file or directory
如何解决？

### 2.原因
这个错误通常是由于系统无法找到名为 libPocoCrypto.so.100 的共享库文件引起的。

而CMakelists.txt文件中，已指定动态库的路径，并链接到目标，为什么还会出现这种错误呢？

### 3.解决方案

在 CLion 中执行可执行文件之前，尝试设置 LD_LIBRARY_PATH 环境变量来指定共享库的搜索路径。
CLion的Run/Debug Configurations配置中添加一个类似如下的环境变量：

LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

![image](/images/post/linux下加载动态库cannot-open-shared-object-file-No-such-file-or-directory/clion_setting.png)

![image](/images/post/linux下加载动态库cannot-open-shared-object-file-No-such-file-or-directory/ADD_LD_LIBRARY_PATH.png)



