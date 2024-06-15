---
title: "Mac安装mongodb并启动"
date: 2024-06-15T20:43:42+08:00
lastmod: 2024-06-15T20:43:42+08:00
keywords: ["fastapi","数据库","mongodb"]
tags: ["fastapi","数据库"]
categories: ["fastapi","数据库"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


### 1.mongo server 源码安装

从官网：`https://www.mongodb.com/try/download/community`
直接下载，如果是苹果ARM架构，下载ARM架构的压缩包即可。我的是X84架构的，直接下载X84架构的即可。
然后解压文件

为什么要使用源码方式安装呢？

使用
```shell
$ brew install mongodb-atlas
$ atlas setup
```
多次下载失败，实在无奈。


### 2.mongodb配置

上述解压后的`mongodb-macos-x86_64-7.0.11`文件夹拷贝到`usr/local`目录下,然后配置环境变量

在`.bash_profile`文件中

```shell
# mongodb
export MONGODB_HOME=/usr/local/mongodb-macos-x86_64-7.0.11
export PATH=$PATH:$MONGODB_HOME/bin
```
添加`mongodb`环境变量


### 3.查看mongodb版本

```shell
ksnowlv@MacBook-Pro-3 bin % mongod -version
db version v7.0.11
Build Info: {
    "version": "7.0.11",
    "gitVersion": "f451220f0df2b9dfe073f1521837f8ec5c208a8c",
    "modules": [],
    "allocator": "system",
    "environment": {
        "distarch": "x86_64",
        "target_arch": "x86_64"
    }
}
ksnowlv@MacBook-Pro-3 bin % 
```
表明已经安装成功

### 4.mongodb文件介绍

mongodb 子目录 bin 下包含三个二进制文件


* install_compass 用来安装 MongoDB 的图形化操作界面
* mongod 为 MongoDB 服务的 daemon 进程

* 对于分片集群，mongos 实例提供客户端应用程序和分片集群之间的接口

### 5. 命令行启动 MongoDB 服务


创建`MongoDB`服务的日志目录：`/usr/local/var/log/mongodb`

![image](/images/fastapi/Mac安装mongodb并启动/result1.png)

创建`MongoDB`服务的数据目录：`/usr/local/var/mongodb`

![image](/images/fastapi/Mac安装mongodb并启动/result2.png)

并修改文件权限，支持读写。

`mongod`命令说明

    `mongod --dbpath /usr/local/var/mongodb --logpath /usr/local/var/log/mongodb/mongo.log --logappend --fork`


* --dbpath 指定数据存放路径
* --logpath 指定日志存放路径
* --logappend 指定日志以追加的形式写入文件，之前的日志不会被覆盖
* --fork 指定进程在后台运行


使用`mongod`启动`mongod服务`
使用`ps aux | grep -v grep | grep mongod`查看`mongod服务`

```shell
ksnowlv@MacBook-Pro-3 mongodb-macos-x86_64-7.0.11 % mongod --dbpath /usr/local/var/mongodb --logpath /usr/local/var/log/mongodb/mongo.log --fork
about to fork child process, waiting until server is ready for connections.
forked process: 11314
child process started successfully, parent exiting
ksnowlv@MacBook-Pro-3 mongodb-macos-x86_64-7.0.11 % ps aux | grep -v grep | grep mongod
ksnowlv          11314   0.3  0.2 36592448  37472   ??  S     9:35下午   0:00.97 mongod --dbpath /usr/local/var/mongodb --logpath /usr/local/var/log/mongodb/mongo.log --fork

```


### 6.查看端口为27017的服务

```shell
ksnowlv@MacBook-Pro-3 ~ % lsof -i :27017
COMMAND   PID    USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
mongod  11314 ksnowlv   11u  IPv4 0x19e46bc920f60509      0t0  TCP localhost:27017 (LISTEN)
ksnowlv@MacBook-Pro-3 ~ %
```
可以看出来`mongod服务`启动成功了






