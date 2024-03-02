---
title: "Mac下解决obsidian国内无法访问第三方插件的问题"
date: 2024-01-25T19:13:51+08:00
lastmod: 2024-01-25T19:13:51+08:00
keywords: ["Mac", "obsidian", "第三方插件"]
tags: ["Mac"]
categories: ["Mac"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


### 1. 问题

Mac下，安装完obsidian后，发现无法访问第三方插件；

### 2. 解决方案

下载[obsidian-proxy-github插件](https://gitee.com/juqkai/obsidian-proxy-github/releases)，拷贝到obsidian工作目录.obsidian/plugins/目录下，重启obsidian,打开设置，在“第三方插件”的功能选项中，已经安装插件下，找到proxy-github启用即可。



![image](/images/post/Mac下解决obsidian国内无法访问第三方插件的问题/obsidian_dir.jpg)
### 3. 效果

![image](/images/post/Mac下解决obsidian国内无法访问第三方插件的问题/obsidian_plugins_setting.jpg)

