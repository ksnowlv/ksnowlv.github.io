---
title: "Mac下搭建clion+docker容器中ubuntu安装ROS的环境"
date: 2024-03-16T13:40:23+08:00
lastmod: 2024-03-16T13:40:23+08:00
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

Mac上使用CLion和Ubuntu Docker容器进行ROS开发，如何配置环境呢？


### 1.构建ROS Docker镜像

按[Mac下通过docker中的linux配置和安装ROS2]()构建 ROS 镜像


### 2. 运行ROS Docker容器

运行一个ROS Docker容器，将其端口映射到你的Mac上，并设置环境变量，以便在容器内部使用X11（如果你打算运行图形界面的ROS应用程序）：
```shell
docker run -it --rm --name ros_container -p 8080:8080 -v /tmp/.X11-unix:/tmp/.X11-unix:rw ros2_sdk:1.0 bash
```


* -p 8080:8080 
  * 映射了用于clion Remote - Containers的端口
* -v /tmp/.X11-unix:/tmp/.X11-unix:rw 
  * 挂载了X11 socket目录，以便在容器内运行图形界面应用程序
  

### 3.ROS Docker容器安装ssh等服务

    apt update # 更新系统
    apt install openssl openssh-server -y # 安装 OpenSSL 和 OpenSSH 服务器
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
    service ssh restart #重启ssh服务
    passwd root		# 设置Docker容器的root密码，用于后续连接



```shell
root@acf5b27d6036:~/ros2_ws# apt update
Hit:1 http://mirrors.aliyun.com/ubuntu focal InRelease
Get:2 http://mirrors.aliyun.com/ubuntu focal-updates InRelease [114 kB]
Hit:3 http://mirrors.aliyun.com/ubuntu focal-backports InRelease
Hit:4 http://mirrors.aliyun.com/ubuntu focal-security InRelease
Get:5 http://mirrors.aliyun.com/ubuntu focal-updates/main amd64 Packages [3928 kB]
Get:6 http://mirrors.aliyun.com/ubuntu focal-updates/universe amd64 Packages [1487 kB]
Get:7 http://packages.ros.org/ros2/ubuntu focal InRelease [4685 B]           
Get:8 http://packages.ros.org/ros2/ubuntu focal/main amd64 Packages [1192 kB]
Fetched 6725 kB in 42s (161 kB/s)                                                                                                                                              
Reading package lists... Done
Building dependency tree       
Reading state information... Done
35 packages can be upgraded. Run 'apt list --upgradable' to see them.
root@acf5b27d6036:~/ros2_ws# apt install openssl openssh-server -y
Reading package lists... Done
Building dependency tree       
Reading state information... Done
openssl is already the newest version (1.1.1f-1ubuntu2.22).
openssl set to manually installed.
The following additional packages will be installed:
  ncurses-term openssh-sftp-server ssh-import-id wget
Suggested packages:
  molly-guard monkeysphere ssh-askpass ufw
The following NEW packages will be installed:
  ncurses-term openssh-server openssh-sftp-server ssh-import-id wget
0 upgraded, 5 newly installed, 0 to remove and 35 not upgraded.
Need to get 1037 kB of archives.
After this operation, 7030 kB of additional disk space will be used.
Get:1 http://mirrors.aliyun.com/ubuntu focal-updates/main amd64 wget amd64 1.20.3-1ubuntu2 [348 kB]
Get:2 http://mirrors.aliyun.com/ubuntu focal-updates/main amd64 ncurses-term all 6.2-0ubuntu2.1 [249 kB]
Get:3 http://mirrors.aliyun.com/ubuntu focal-updates/main amd64 openssh-sftp-server amd64 1:8.2p1-4ubuntu0.11 [51.7 kB]
Get:4 http://mirrors.aliyun.com/ubuntu focal-updates/main amd64 openssh-server amd64 1:8.2p1-4ubuntu0.11 [378 kB]
Get:5 http://mirrors.aliyun.com/ubuntu focal/main amd64 ssh-import-id all 5.10-0ubuntu1 [10.0 kB]
Fetched 1037 kB in 0s (2625 kB/s)     
debconf: delaying package configuration, since apt-utils is not installed
Selecting previously unselected package wget.
(Reading database ... 126979 files and directories currently installed.)
Preparing to unpack .../wget_1.20.3-1ubuntu2_amd64.deb ...
Unpacking wget (1.20.3-1ubuntu2) ...
Selecting previously unselected package ncurses-term.
Preparing to unpack .../ncurses-term_6.2-0ubuntu2.1_all.deb ...
Unpacking ncurses-term (6.2-0ubuntu2.1) ...
Selecting previously unselected package openssh-sftp-server.
Preparing to unpack .../openssh-sftp-server_1%3a8.2p1-4ubuntu0.11_amd64.deb ...
Unpacking openssh-sftp-server (1:8.2p1-4ubuntu0.11) ...
Selecting previously unselected package openssh-server.
Preparing to unpack .../openssh-server_1%3a8.2p1-4ubuntu0.11_amd64.deb ...
Unpacking openssh-server (1:8.2p1-4ubuntu0.11) ...
Selecting previously unselected package ssh-import-id.
Preparing to unpack .../ssh-import-id_5.10-0ubuntu1_all.deb ...
Unpacking ssh-import-id (5.10-0ubuntu1) ...
Setting up openssh-sftp-server (1:8.2p1-4ubuntu0.11) ...
Setting up wget (1.20.3-1ubuntu2) ...
Setting up openssh-server (1:8.2p1-4ubuntu0.11) ...

Creating config file /etc/ssh/sshd_config with new version
Creating SSH2 RSA key; this may take some time ...
3072 SHA256:ZEGpg23PUzyyySZQRZuFdu8oOr7ABocR0BMyUI8Ujis root@acf5b27d6036 (RSA)
Creating SSH2 ECDSA key; this may take some time ...
256 SHA256:i4qDGTsxK6BT3doCXskYvuvo3ZS0E4PGRnC+yDsay6o root@acf5b27d6036 (ECDSA)
Creating SSH2 ED25519 key; this may take some time ...
256 SHA256:RBMzf6xIFJgIhxki9jUTG0gHZiVHyP+Rn0ToOOV9T6w root@acf5b27d6036 (ED25519)
Created symlink /etc/systemd/system/sshd.service → /lib/systemd/system/ssh.service.
Created symlink /etc/systemd/system/multi-user.target.wants/ssh.service → /lib/systemd/system/ssh.service.
invoke-rc.d: could not determine current runlevel
invoke-rc.d: policy-rc.d denied execution of start.
Setting up ssh-import-id (5.10-0ubuntu1) ...
Attempting to convert /etc/ssh/ssh_import_id
Setting up ncurses-term (6.2-0ubuntu2.1) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for systemd (245.4-4ubuntu3.23) ...
root@acf5b27d6036:~/ros2_ws# echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
root@acf5b27d6036:~/ros2_ws# service ssh restart
 * Restarting OpenBSD Secure Shell server sshd                                                                                                                           [ OK ] 
root@acf5b27d6036:~/ros2_ws# passwd root
New password: 
Retype new password: 
passwd: password updated successfully
root@acf5b27d6036:~/ros2_ws# ps -ef | grep sshd
root       637     1  0 04:08 ?        00:00:00 sshd: /usr/sbin/sshd [listener] 0 of 10-100 startups
root       641     1  0 04:15 pts/0    00:00:00 grep --color=auto sshd
root@acf5b27d6036:~/ros2_ws# service ssh restart
 * Restarting OpenBSD Secure Shell server sshd                                                                                                                           [ OK ] 
root@acf5b27d6036:~/ros2_ws# service ssh restart
 * Restarting OpenBSD Secure Shell server sshd                                                                                                                           [ OK ] 
                                                                                                                          [ OK ] 

```

### 4.测试ssh连接

打开终端，在Docker外，用ssh测试连接：
```shell
ksnowlv@MacBook-Pro-3 ~ %  ssh root@localhost -p 8080
root@localhost's password: 
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 6.5.11-linuxkit x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

This system has been minimized by removing packages and content that are
not required on a system that users do not log into.

To restore this content, you can run the 'unminimize' command.
Last login: Sat Mar 16 04:37:39 2024 from 192.168.65.1
root@acf5b27d6036:~# 
```
容器可以正常访问。

#### 问题
如果出现
```shell
kex_exchange_identification: Connection closed by remote host
Connection closed by 127.0.0.1 port 8080
ksnowlv@MacBook-Pro-3 ~ % 
```

#### 原因

ROS Docker容器使用的是8080端口。

#### 解决方案
在 **/etc/ssh/sshd_config** 中添加**Port 8080**，确保SSH服务监听在8080端口； 然后，在ROS 容器内**service ssh restart**重启ssh服务。

### 5.打开远程开发

在**clion**下的**文件**菜单中，

![image](/images/ros/Mac下搭建clion+docker容器中ubuntu安装ROS的环境/clion_file_menu.jpg)

打开远程开发

![image](/images/ros/Mac下搭建clion+docker容器中ubuntu安装ROS的环境/clion_remote.png)

### 6.连接容器服务

![image](/images/ros/Mac下搭建clion+docker容器中ubuntu安装ROS的环境/clion_connect_ssh.png)

输入用户名：root，主机：localhost port:8080,点击检查连接并继续，输出密码，再点击身份验证。

### 7.下载clion

![image](/images/ros/Mac下搭建clion+docker容器中ubuntu安装ROS的环境/clion_download.png)

点击下载ide并连接

![image](/images/ros/Mac下搭建clion+docker容器中ubuntu安装ROS的环境/clion_password.png)

输入密码，开始下载IDE。


### 8.打开clion

下载完成后，按上述，5，6，7的操作，即可打开clion。

![image](/images/ros/Mac下搭建clion+docker容器中ubuntu安装ROS的环境/clion_open.png)

