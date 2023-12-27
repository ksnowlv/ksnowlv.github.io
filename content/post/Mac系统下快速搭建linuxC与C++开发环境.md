---
title: "Mac系统下快速搭建linuxC与C++开发环境"
date: 2023-12-27T21:53:53+08:00
lastmod: 2023-12-27T21:53:53+08:00
keywords: ["Mac", "Linux", "C++", "docker"]
tags: ["Mac", "Linux", "C++", "docker"]
categories: ["Mac", "Linux", "C++", "docker"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


## Mac搭建linuxC/C++开发环境

解决方案：Mac使用CLion作为IDE + Docker Desktop创建Linux镜像中的C/C++开发环境。

### 1.docker安装

从[docker官网](https://www.docker.com/get-started/)下载Mac版本，并完成安装

### 2.docker创建linux镜像

#### dockerfile
目前Ubuntu最新版本为22.04，选择其作为基础镜像。
以下是搭建一个最基本的C/C++环境的dockerfile。

```dockerfile
FROM ubuntu:22.04
MAINTAINER wuweijie@apache.org
RUN apt update && apt install -y cmake g++ gdb

```

#### docker构建Image

启动docker，打开终端后，切换到dockerfile所在的目录，制作镜像。

```terminal
ksnowlv@MacBook-Pro-3 docker % docker build -t linux/cmake:1.0 .
[+] Building 100.9s (6/6) FINISHED                                                                                            docker:desktop-linux
 => [internal] load .dockerignore                                                                                                             0.0s
 => => transferring context: 2B                                                                                                               0.0s
 => [internal] load build definition from Dockerfile                                                                                          0.0s
 => => transferring dockerfile: 225B                                                                                                          0.0s
 => [internal] load metadata for docker.io/library/ubuntu:22.04                                                                              16.3s
 => [1/2] FROM docker.io/library/ubuntu:22.04@sha256:f154feaf13b51d16e2b4b5575d69abc808da40c4b80e3a5055aaa4bcc5099d5b                        40.1s
 => => resolve docker.io/library/ubuntu:22.04@sha256:f154feaf13b51d16e2b4b5575d69abc808da40c4b80e3a5055aaa4bcc5099d5b                         0.0s
 => => sha256:f154feaf13b51d16e2b4b5575d69abc808da40c4b80e3a5055aaa4bcc5099d5b 1.42kB / 1.42kB                                                0.0s
 => => sha256:3c3de9608507804525ff4303874525760ea36d62606e8105f515adaa761b80cb 529B / 529B                                                    0.0s
 => => sha256:9d28ccdc1fc782ec635c98e55ff68b05e6de1df2c7fcbbb4385f023368eec716 1.46kB / 1.46kB                                                0.0s
 => => sha256:aee1767db0dd7da5c30ffaef2282976fe8730cdb0a7b1ecda17cd3c85374fa57 29.89MB / 29.89MB                                             37.7s
 => => extracting sha256:aee1767db0dd7da5c30ffaef2282976fe8730cdb0a7b1ecda17cd3c85374fa57                                                     2.2s
 => [2/2] RUN apt update && apt install -y cmake g++ gdb                                                                                     41.7s
 => exporting to image                                                                                                                        2.7s 
 => => exporting layers                                                                                                                       2.7s 
 => => writing image sha256:a873ce46cea1140c549e340660c61150a913ef4c5952ca7f00085db03a043b47                                                  0.0s 
 => => naming to docker.io/linux/cmake:1.0                                                                                                    0.0s 
                                                                                                                                                   
View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/7edfqlawkbvj9g06y3bxg6wa7                                         

What's Next?
  View a summary of image vulnerabilities and recommendations → docker scout quickview
ksnowlv@MacBook-Pro-3 docker % docker images
REPOSITORY    TAG       IMAGE ID       CREATED          SIZE
linux/cmake   1.0       a873ce46cea1   15 minutes ago   503MB
mysql         latest    3218b38490ce   2 years ago      516MB
ubuntu        latest    ba6acccedd29   2 years ago      72.8MB

```
linux镜像制作成功。

![image](/images/post/Mac系统下快速搭建linuxC与C++开发环境/docker_image.jpg)

### 3.clion环境设置

打开setting设置工具链

![image](/images/post/Mac系统下快速搭建linuxC与C++开发环境/clion_toolchains.jpg)


选择CMake选项，设置CMake工具

![image](/images/post/Mac系统下快速搭建linuxC与C++开发环境/clion_cmake.jpg)

### 4.Hello示例工程效果
![image](/images/post/Mac系统下快速搭建linuxC与C++开发环境/clion_hello.jpg)




