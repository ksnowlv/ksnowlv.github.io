---
title: "Mac下支持多个ssh-key"
date: 2017-11-29
categories:
  - "git"
tags:
  - "git"
---
<!--more-->

Mac下如何支持多个ssh-key呢？

<!--more-->

   通过ssh-config文件配置各个ssh-key,避免在mac重启后，每次手动添加ssh-key。

配置文件`config`如下：

```objective-c

Host    		gitee.com
HostName  		gitee.com
User            ksnowlv@163.com
PreferredAuthentications publickey
IdentityFile    ~/.ssh/ksnowlv163


Host    		10.103.40.101
HostName  		10.103.40.101
User            git
PreferredAuthentications publickey
IdentityFile    ~/.ssh/id_rsa

```
