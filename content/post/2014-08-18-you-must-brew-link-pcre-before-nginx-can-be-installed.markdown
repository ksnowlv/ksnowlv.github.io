---
title: You must `brew link pcre' before nginx can be installed
date: 2014-08-18
lastmod: 2014-08-18
categories:
  - "后台开发"
tags:
  - "nginx"
comment: true
toc: false
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

在使用Homebrew安装nginx时,会遇见如下错误:

    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/PHP$brew install nginx
    Error: You must `brew link pcre' before nginx can be installed
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/PHP$
 
 可使用命令`brew link --overwrite pcre`，强制链接并覆盖冲突的文件即可。
  
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/PHP$brew link --overwrite pcre
    Linking /usr/local/Cellar/pcre/8.35... 133 symlinks created
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/PHP$brew install nginx
    
如果使用上述命令出错，则找到`/usr/local/Cellar/pcre`和`/usr/local/opt/pcre`的`pcre`目录干掉，重新安装pcre,再强制链接。