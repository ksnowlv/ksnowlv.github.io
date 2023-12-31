---
title: "Linux Ubuntu官方源无法访问问题"
date: 2023-12-31T19:14:39+08:00
lastmod: 2023-12-31T19:14:39+08:00
keywords: ["Linux", "Docker"]
tags: ["Linux", "Docker"]
categories: ["Linux", "Docker"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Ubuntu官方apt源无法访问

### 1.问题

```terminal
lvwei@lvweideMacBook-Pro clion_cpp_demo % docker build -t helloworld .
[+] Building 64.9s (5/10)                                                                                     docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                          0.0s
 => => transferring dockerfile: 1.32kB                                                                                        0.0s
 => [internal] load .dockerignore                                                                                             0.0s
[+] Building 94.0s (6/10)                                                                                     docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                          0.0s
 => => transferring dockerfile: 1.32kB                                                                                        0.0s
 => [internal] load .dockerignore                                                                                             0.0s
 => => transferring context: 2B                                                                                               0.0s
 => [internal] load metadata for docker.io/library/ubuntu:20.04                                                               2.2s
 => CACHED [1/6] FROM docker.io/library/ubuntu:20.04@sha256:f2034e7195f61334e6caff6ecf2e965f92d11e888309065da85ff50c617732b8  0.0s
 => [internal] load build context                                                                                             0.0s
 => => transferring context: 16.25kB                                                                                          0.0s
 => ERROR [2/6] RUN apt-get update && apt-get install -y     build-essential     cmake     git     valgrind                  91.8s
------                                                                                                                             
 > [2/6] RUN apt-get update && apt-get install -y     build-essential     cmake     git     valgrind:                              
61.14 Err:1 http://ports.ubuntu.com/ubuntu-ports focal InRelease                                                                   
61.14   Connection failed [IP: 185.125.190.36 80]                                                                                  
91.69 Err:2 http://ports.ubuntu.com/ubuntu-ports focal-updates InRelease                                                           
91.69   Could not connect to ports.ubuntu.com:80 (185.125.190.39), connection timed out Could not connect to ports.ubuntu.com:80 (185.125.190.36), connection timed out [IP: 185.125.190.36 80]
91.69 Err:3 http://ports.ubuntu.com/ubuntu-ports focal-backports InRelease
91.69   Unable to connect to ports.ubuntu.com:http: [IP: 185.125.190.36 80]
91.69 Err:4 http://ports.ubuntu.com/ubuntu-ports focal-security InRelease
91.69   Unable to connect to ports.ubuntu.com:http: [IP: 185.125.190.36 80]
91.70 Reading package lists...
91.73 W: Failed to fetch http://ports.ubuntu.com/ubuntu-ports/dists/focal/InRelease  Connection failed [IP: 185.125.190.36 80]
91.73 W: Failed to fetch http://ports.ubuntu.com/ubuntu-ports/dists/focal-updates/InRelease  Could not connect to ports.ubuntu.com:80 (185.125.190.39), connection timed out Could not connect to ports.ubuntu.com:80 (185.125.190.36), connection timed out [IP: 185.125.190.36 80]
91.73 W: Failed to fetch http://ports.ubuntu.com/ubuntu-ports/dists/focal-backports/InRelease  Unable to connect to ports.ubuntu.com:http: [IP: 185.125.190.36 80]
91.73 W: Failed to fetch http://ports.ubuntu.com/ubuntu-ports/dists/focal-security/InRelease  Unable to connect to ports.ubuntu.com:http: [IP: 185.125.190.36 80]
91.73 W: Some index files failed to download. They have been ignored, or old ones used instead.
91.74 Reading package lists...
91.75 Building dependency tree...
91.75 Reading state information...
91.75 E: Unable to locate package build-essential
91.75 E: Unable to locate package cmake
91.75 E: Unable to locate package git
91.75 E: Unable to locate package valgrind
------
Dockerfile:9
--------------------
   8 |     # 安装基本依赖
   9 | >>> RUN apt-get update && apt-get install -y \
  10 | >>>     build-essential \
  11 | >>>     cmake \
  12 | >>>     git \
  13 | >>>     valgrind 
  14 |     
--------------------
ERROR: failed to solve: process "/bin/sh -c apt-get update && apt-get install -y     build-essential     cmake     git     valgrind" did not complete successfully: exit code: 100
```
这个错误表示你无法连接到Ubuntu的存储库来获取更新或所需的软件包，Ubuntu官方apt源无法访问。

### 2.解决方案
此时建议使用国内apt源。

在Dockerfile文件中
```Dockerfile
RUN apt-get update && apt-get install -y \
build-essential \
cmake \
git \
valgrind
```
之前添加
```Docker
# 注意sources.list与Dockerfile同目录
COPY sources.list /etc/apt/
```

### 3.sources.list

#### 3.1.x86/64架构的环境使用以下sources.list
```text
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse

```

#### 3.2.arm架构的环境使用以下sources.list
```text
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy-updates main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy-updates main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy-backports main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy-backports main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy-security main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy-security main restricted universe multiverse
```

重新构建Image镜像即可



