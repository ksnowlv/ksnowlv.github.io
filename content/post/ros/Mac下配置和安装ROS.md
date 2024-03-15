---
title: "Mac下配置和安装ROS"
date: 2024-03-14T13:01:57+08:00
lastmod: 2024-03-14T13:01:57+08:00
keywords: ["Mac", "ROS", "C++"]
tags: ["Mac", "ROS", "C++"]
categories: ["Mac", "ROS", "C++"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 1.安装Homebrew
Homebrew是Mac上常用的包管理工具。在终端中执行以下命令进行安装：

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

### 2.添加ROS repository

终端执行以下命令，将ROS repository添加到Homebrew中。

* brew tap ros/deps
* brew tap osrf/simulation
* brew tap homebrew/core

执行上述命令前，先执行export HOMEBREW_NO_INSTALL_FROM_API=1；告诉Homebrew不要从API安装软件包。

```shell
ksnowlv@MacBook-Pro-3 RosProjects % export HOMEBREW_NO_INSTALL_FROM_API=1
ksnowlv@MacBook-Pro-3 RosProjects % brew tap ros/deps                    
==> Tapping ros/deps
Cloning into '/usr/local/Homebrew/Library/Taps/ros/homebrew-deps'...
remote: Enumerating objects: 104, done.
remote: Total 104 (delta 0), reused 0 (delta 0), pack-reused 104
Receiving objects: 100% (104/104), 27.19 KiB | 41.00 KiB/s, done.
Resolving deltas: 100% (47/47), done.
Tapped 6 formulae (21 files, 54.6KB).
ksnowlv@MacBook-Pro-3 RosProjects % brew tap osrf/simulation
==> Tapping osrf/simulation
Cloning into '/usr/local/Homebrew/Library/Taps/osrf/homebrew-simulation'...
remote: Enumerating objects: 13824, done.
remote: Counting objects: 100% (2996/2996), done.
remote: Compressing objects: 100% (605/605), done.
remote: Total 13824 (delta 2642), reused 2683 (delta 2380), pack-reused 10828
Receiving objects: 100% (13824/13824), 3.31 MiB | 22.00 KiB/s, done.
Resolving deltas: 100% (10599/10599), done.
Tapped 105 formulae (220 files, 4.1MB).
ksnowlv@MacBook-Pro-3 RosProjects % brew tap homebrew/core
ksnowlv@MacBook-Pro-3 RosProjects % brew install --only-dependencies ros/texlive
==> Tapping homebrew/cask
Cloning into '/usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask'...
remote: Enumerating objects: 905485, done.
remote: Counting objects: 100% (764/764), done.
remote: Compressing objects: 100% (344/344), done.
Receiving objects:   6% (57724/905485), 31.66 MiB | 28.00 KiB/s 

```

### 3.安装ROS工具

安装ROS的核心工具和库文件：

* brew install --only-dependencies ros/texlive
* brew install ros-melodic-desktop

### 4.配置ROS环境变量
在bash配置文件（如~/.bash_profile或~/.bashrc）中添加ROS环境变量，执行以下命令进行配置：

echo "source /usr/local/opt/ros-melodic/setup.bash" >> ~/.bash_profile
source ~/.bash_profile

### 5.初始化ROS工作区

创建一个新的ROS工作区（workspace）并初始化，执行以下命令：

mkdir -p ~/ros_catkin_ws/src
cd ~/ros_catkin_ws
catkin_make

### 6.验证安装

执行以下命令验证ROS安装是否成功：

roscore
以上步骤完成后，ROS应该已经成功安装到您的Mac电脑上。您可以尝试运行一些ROS命令来验证安装结果。请注意，以上步骤是针对ROS Melodic版本的安装说明，如果您需要安装其他版本，可以替换相应的版本号（如ros-melodic-desktop）。

