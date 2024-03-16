---
title: "Mac下搭建VSCode+docker容器中ubuntu安装ROS的环境"
date: 2024-03-16T19:27:39+08:00
lastmod: 2024-03-16T19:27:39+08:00
keywords: ["Mac", "ROS2", "C++", "Linux"]
tags: ["Mac", "ROS2", "C++", "Linux"]
categories: ["Mac", "ROS2", "C++", "Linux"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 1.安装VSCode

### 2.VSCode中安装docker插件
在**VSCode**扩展中找到**docker**插件，并安装重启。

### 3.启动ROS2容器服务

在前文中[ROS2容器服务](https://ksnowlv.github.io/post/ros/mac下通过docker中的linux配置和安装ros2/)启动容器服务

### 4.VSCode打开容器服务

Command+Shift+P（或者Ctrl+Shift+P）打开命令面板，选择 "Dokcer",

![image](../../images/ros/Mac下搭建VSCode+docker容器中ubuntu安装ROS的环境/docker_open.png)

![image](../../images/ros/Mac下搭建VSCode+docker容器中ubuntu安装ROS的环境/docker_overview.png)
然后选择ros2_sdk:1.0容器，附加到Visual Studio Code 打开容器。

### 5.测试ros2容器服务

打开终端，

```shell
root@acf5b27d6036:~/ros2_ws# ros2 run demo_nodes_py listener
[INFO] [1710589373.953308780] [listener]: I heard: [Hello World: 1]
[INFO] [1710589374.931733296] [listener]: I heard: [Hello World: 2]
[INFO] [1710589375.931589398] [listener]: I heard: [Hello World: 3]
[INFO] [1710589376.931793177] [listener]: I heard: [Hello World: 4]
[INFO] [1710589377.934030979] [listener]: I heard: [Hello World: 5]
[INFO] [1710589378.931360876] [listener]: I heard: [Hello World: 6]
[INFO] [1710589379.931520993] [listener]: I heard: [Hello World: 7]
```

打开另一终端

```shell

```

![image](../../images/ros/Mac下搭建VSCode+docker容器中ubuntu安装ROS的环境/result.png)

