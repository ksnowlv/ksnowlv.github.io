---
title: "Mac配置tomcat"
date: 2017-11-28
lastmod: 2017-11-28
categories:
  - "后台开发"
tags:
  - "java"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---



Mac下如何配置tomcat呢？

 <!--more-->

##tomcat目录结构简介

![image](/images/post/2017-11-28-macpei-zhi-tomcat/tomcat-dir-overview.png) 

* 1.bin:tomcat命令,像startup,shutdown

* 2.conf:存放tomcat配置信息,其中server.xml文件是核心的配置文件

* 3.lib:支持tomcat软件运行的jar包，技术支持包(如servlet和jsp)

* 4.logs:运行时的日志信息

* 5.temp:临时目录

* 6.webapps:共享资源文件和web应用目录

* 7.work:tomcat的运行目录.jsp运行时产生的临时文件就存放在这里





### 1.下载[Tomcat](https://tomcat.apache.org)

![image](/images/post/2017-11-28-macpei-zhi-tomcat/tomcat-download.png) 

### 2.安装tomcattomcat解压后放在，/Users/计算机名/Library/目录下

![image](/images/post/2017-11-28-macpei-zhi-tomcat/tomcat-dir.png)

### 3.启动tomcat
打开Terminal,进入ApacheTomcat所在目录的bin目录下.

```objective-c
./startup.sh
```
如果出现

```objective-c
-bash: ./startup.sh: Permission denied
```
使用**chmod u+x *.sh**修改下访问权限再重启tomcat即可。

![image](/images/post/2017-11-28-macpei-zhi-tomcat/tomcat-startup.png)

### 4.验证tomcat启动成功。在浏览器中输入[http://localhost:8080](http://localhost:8080)
成功启动后，如下：
![image](/images/post/2017-11-28-macpei-zhi-tomcat/tomcat-success.png)

### 5.关闭tomcat。
```objective-c
/shutdown.sh
```

### 6.密码设置
密码设置

在conf目录的tomcat-users.xml文件里</tomcat-users>上面加入以下代码:

```objective-c

<role rolename="manager-gui"/>
<user username="tomcat" password="s3cret" roles="manager-gui"/>

```

点击“manager app”,输入账号密码后，如下图

![image](/images/post/2017-11-28-macpei-zhi-tomcat/tomcat-manage-app.png)
