---
title: "Mac下国内如何加快brew访问速度"
date: 2024-03-14T14:51:50+08:00
lastmod: 2024-03-14T14:51:50+08:00
keywords: ["Mac", "brew"]
tags: ["Mac"]
categories: ["Mac"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 1.问题

Mac安装软件时，国内如何加快brew访问速度？

### 2.解决方案

更换Homebrew镜像源

#### 1.更换到清华大学镜像源

```shell
cd "$(brew --repo)"
git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git

cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
```

#### 2.更换到淘宝镜像源

```shell
cd "$(brew --repo)"
git remote set-url origin https://mirrors.aliyun.com/homebrew/brew.git

cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.aliyun.com/homebrew/homebrew-core.git
```