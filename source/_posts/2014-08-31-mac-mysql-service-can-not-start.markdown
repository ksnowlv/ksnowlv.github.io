---
layout: post
title: "解决mac-mysql-service-can‘t-start的问题"
date: 2014-08-31 22:26
comments: true
categories: 数据库
---
`Mac`上安装[mysql-5.6.20-osx10.8-x86_64-3](http://dev.mysql.com/downloads/mysql/)完成。

<!--more-->

在**MySQL的控制面板**(系统偏好设置->MySQL)上，显示**mac mysql service can't start**。

**解决方案**：

编辑`/usr/local/mysql-5.6.20-osx10.8-x86_64/support-files/`目录下`mysql.server`文件,把

    basedir=
    datadir=
        
替换为

    basedir=/usr/local/mysql 
    datadir=/usr/local/mysql/data 
 
重启下`mysql service`，即可。

如果重启失败，重启下电脑吧。

`mysql service`启动成功后的界面。

![image](/images/post/2014-08-31-mac-mysql-service-can-not-start/mysql_service_ok.png)
