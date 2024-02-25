---
title: "Npm淘宝镜像报错"
date: 2024-02-21T09:49:48+08:00
lastmod: 2024-02-21T09:49:48+08:00
keywords: ["npm","前端","淘宝镜像"]
tags: ["npm","前端"]
categories: ["npm","前端"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 问题

npm报错：request to https://registry.npm.taobao.org failed, reason certificate has expired

### 解决方案

```shell
Last login: Tue Feb 20 18:28:43 on ttys000
(base) lvwei@lvweideMacBook-Pro ~ % npm config list
; cli configs
metrics-registry = "https://registry.npm.taobao.org/"
scope = ""
user-agent = "npm/6.14.13 node/v14.17.3 darwin x64"

; userconfig /Users/lvwei/.npmrc
electron_mirror = "https://npm.taobao.org/mirrors/electron/"
registry = "https://registry.npm.taobao.org/"

; node bin location = /Users/lvwei/.nvm/versions/node/v14.17.3/bin/node
; cwd = /Users/lvwei
; HOME = /Users/lvwei
; "npm config ls -l" to show all defaults.

(base) lvwei@lvweideMacBook-Pro ~ % npm cache clean --force
npm WARN using --force I sure hope you know what you are doing.
(base) lvwei@lvweideMacBook-Pro ~ % npm config set registry https://registry.npmmirror.com
(base) lvwei@lvweideMacBook-Pro ~ % npm config list                                       
; cli configs
metrics-registry = "https://registry.npmmirror.com/"
scope = ""
user-agent = "npm/6.14.13 node/v14.17.3 darwin x64"

; userconfig /Users/lvwei/.npmrc
electron_mirror = "https://npm.taobao.org/mirrors/electron/"
registry = "https://registry.npmmirror.com/"

; node bin location = /Users/lvwei/.nvm/versions/node/v14.17.3/bin/node
; cwd = /Users/lvwei
; HOME = /Users/lvwei
; "npm config ls -l" to show all defaults.



   ╭────────────────────────────────────────────────────────────────╮
   │                                                                │
   │      New major version of npm available! 6.14.13 → 10.4.0      │
   │   Changelog: https://github.com/npm/cli/releases/tag/v10.4.0   │
   │               Run npm install -g npm to update!                │
   │                                                                │
   ╰────────────────────────────────────────────────────────────────╯

(base) lvwei@lvweideMacBook-Pro ~ % 


```
