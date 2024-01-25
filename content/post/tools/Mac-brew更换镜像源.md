---
title: "Mac Brew更换镜像源"
date: 2023-08-30T10:34:38+08:00
lastmod: 2023-08-30T10:34:38+08:00
keywords: ["Mac", "brew", "镜像源"]
tags: ["Mac"]
categories: ["Mac"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## brew更换镜像源

Homebrew官方源下载包会很慢,所以通常我们都是用国内的镜像源来代替，这样会提高我们的效率。

#### Homebrew主要有四个部分组成
* brew
* homebrew-core 
* homebrew-bottles
* homebrew-cask

### 1.查看 brew.git 当前源

```shell
lvwei@lvweideMacBook-Pro homebrew % cd "$(brew --repo homebrew/core)" && git remote -v
origin	git@github.com:Homebrew/homebrew-core (fetch)
origin	git@github.com:Homebrew/homebrew-core (push)
```

### 2.查看 homebrew-core.git 当前源

```shell
lvwei@lvweideMacBook-Pro homebrew % cd "$(brew --repo homebrew/core)" && git remote -v
origin	git@github.com:Homebrew/homebrew-core (fetch)
origin	git@github.com:Homebrew/homebrew-core (push)
```

### 3. Homebrew 镜像源切换为中科大镜像源

```shell
lvwei@lvweideMacBook-Pro homebrew-core % cd "$(brew --repo)" && git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
lvwei@lvweideMacBook-Pro homebrew % cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core" && git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git                                                          
lvwei@lvweideMacBook-Pro homebrew-core % cd "$(brew --repo)/Library/Taps/homebrew/homebrew-cask" && git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git  
```

### 4.替换homebrew-bottles镜像

在.bash_profile文件中添加
```shell
HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
export HOMEBREW_BOTTLE_DOMAIN
```

命令行

```shell
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.bash_profile
```

### 5.刷新brew源

```shell
lvwei@lvweideMacBook-Pro homebrew-core % brew update
Installing from the API is now the default behaviour!
You can save space and time by running:
  brew untap homebrew/core
  brew untap homebrew/cask
Updated 2 taps (homebrew/core and homebrew/cask).
==> New Formulae
apify-cli                                                                   vunnel
==> New Casks
hypercal                                                                    simple-web-server
==> Outdated Formulae
coreutils          libgpg-error       libksba            make               python-tk@3.9      python@3.9         sqlite             zlib
==> Outdated Casks
perforce

You have 8 outdated formulae and 1 outdated cask installed.
You can upgrade them with brew upgrade
or list them with brew outdated.
```

### 6.执行情况

```shell
lvwei@lvweideMacBook-Pro ~ % cd "$(brew --repo)" && git remote -v
origin	git@github.com:Homebrew/brew.git (fetch)
origin	git@github.com:Homebrew/brew.git (push)
lvwei@lvweideMacBook-Pro homebrew % cd "$(brew --repo homebrew/core)" && git remote -v
origin	git@github.com:Homebrew/homebrew-core (fetch)
origin	git@github.com:Homebrew/homebrew-core (push)
lvwei@lvweideMacBook-Pro homebrew-core % cd "$(brew --repo)" && git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
lvwei@lvweideMacBook-Pro homebrew % cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core" && git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git                                                          
lvwei@lvweideMacBook-Pro homebrew-core % cd "$(brew --repo)/Library/Taps/homebrew/homebrew-cask" && git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git                                                     
lvwei@lvweideMacBook-Pro homebrew-cask % cd "$(brew --repo)" && git remote -v                                   
origin	https://mirrors.ustc.edu.cn/brew.git (fetch)
origin	https://mirrors.ustc.edu.cn/brew.git (push)
lvwei@lvweideMacBook-Pro homebrew % cd "$(brew --repo homebrew/core)" && git remote -v                                   
origin	https://mirrors.ustc.edu.cn/homebrew-core.git (fetch)
origin	https://mirrors.ustc.edu.cn/homebrew-core.git (push)
lvwei@lvweideMacBook-Pro homebrew-core % brew update
Installing from the API is now the default behaviour!
You can save space and time by running:
  brew untap homebrew/core
  brew untap homebrew/cask
Updated 2 taps (homebrew/core and homebrew/cask).
==> New Formulae
apify-cli                                                                   vunnel
==> New Casks
hypercal                                                                    simple-web-server
==> Outdated Formulae
coreutils          libgpg-error       libksba            make               python-tk@3.9      python@3.9         sqlite             zlib
==> Outdated Casks
perforce

You have 8 outdated formulae and 1 outdated cask installed.
You can upgrade them with brew upgrade
or list them with brew outdated.

```
