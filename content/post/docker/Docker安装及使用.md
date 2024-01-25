---
title: "Mac Docker安装及使用"
date: 2023-10-20T23:04:08+08:00
lastmod: 2023-10-20T23:04:08+08:00
keywords: ["后端开发", "Docker"]
tags: ["后端开发", "Docker"]
categories: ["后端开发", "Docker"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## 一.Mac上Docker安装

### 1.安装Docker
Docker官方网站:[https://www.docker.com/get-started](https://www.docker.com/get-started)下载Mac版本的Docker安装

安装完成后，打开终端（Terminal）Docker是否已经正确安装
```shell
(base) lvwei@lvweideMacBook-Pro watch-fastapi % docker --version
Docker version 24.0.6, build ed223bc
```
表明Docker已成功安装

### 2.安装docker-compose

Docker24.0.6已包含docker-compose，故不需要直接安装，直接查看docker-compose版本即可
  
```shell                                                                             
(base) lvwei@lvweideMacBook-Pro watch-fastapi % docker-compose --version
Docker Compose version v2.22.0-desktop.2
```

通过docker-compose编排一系列环境进行一键快速部署运行
docker-compose用来实现Docker容器快速编排,可参考
[https://gitee.com/zhengqingya/docker-compose?_from=gitee_search#/zhengqingya/docker-compose/blob/master/windows使用docker-compose安装开发环境系列.md](https://gitee.com/zhengqingya/docker-compose?_from=gitee_search#/zhengqingya/docker-compose/blob/master/windows使用docker-compose安装开发环境系列.md)


#### Docker-Compose 的编排结构
Docker-Compose 将所管理的容器分为三层

* 工程（project）：一个工程包含多个服务
* 服务（service）：一个服务当中可包括多个容器实例
* 容器（container）
Docker-Compose 运行目录下的所有文件（docker-compose.yml、extends文件 或 环境变量文件等）组成一个工程，若无特殊指定 工程名即为当前目录名。
Docker Compose 的核心就是其配置文件，采用 YAML 格式，默认为 docker-compose.yml 。
