---
title: "如何把githubblog源代码同步到github上"
date: 2014-07-25
lastmod: 2014-07-25
categories:
  - "github-博客"
tags:
  - "github-博客"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

使用github和octopress搭建好github博客后，如何把本地源代码上传到服务器上呢？


### 1.博客目录初始化

在octopress下或博客目录(***有_config.yml文件的目录***)下，使用git初始化命令，如下所示：

```
git init
```

### 2.添加远程代码库
```
git remote add origin 远程代码库地址url
```
### 3.创建一源代码分支

名称例如为source,使用git创建分支的命令，如下所示：
```
git checkout -b source
```
然后回车后，会看到控制台输出如下所示：

```
Switched to a new branch 'source'
```

### 4.添加并提交文件
```
git add --all
git commit -a -m "source files"
```

### 5.把源文件push到source分支
```
git push origin source
```