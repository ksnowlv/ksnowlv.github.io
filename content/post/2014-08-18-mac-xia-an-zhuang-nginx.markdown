---
title: "Mac下安装nginx"
date: 2014-08-18
lastmod: 2014-08-18
categories:
  - "后台开发"
tags:
  - "nginx"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---


Mac下安装nginx,我使用的是Homebrew,Homebrew安装好的情况下。

#### 1.先安装pcre.
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/PHP$brew install pcre
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/PHP$brew install pcre
    ==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/pcre-8.35.mavericks.bottle.tar.gz
    Already downloaded: /Library/Caches/Homebrew/pcre-8.35.mavericks.bottle.tar.gz
    ==> Pouring pcre-8.35.mavericks.bottle.tar.gz
    #忽略该错误是要付出代价的，请看后面!!!!!
    Error: The `brew link` step did not complete successfully
    The formula built, but is not symlinked into /usr/local
    Could not symlink share/man/man1/pcre-config.1
    Target /usr/local/share/man/man1/pcre-config.1
    already exists. You may want to remove it:
      rm /usr/local/share/man/man1/pcre-config.1
    #解决方法之一，注意!!!
    To force the link and overwrite all conflicting files:
      brew link --overwrite pcre

    To list all files that would be deleted:
      brew link --overwrite --dry-run pcre

    Possible conflicting files are:

静待pcre安装完即可。

#### 2.安装nginx.    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/PHP$brew install nginx
    ==> Downloading https://downloads.sf.net/project/machomebrew/    Bottles/nginx-1.6.1.mavericks.bottle.tar.gz
 静待nginx安装完成即可。
    
#### 如果安装出错，例如出现     
     Error: You must `brew link pcre' before nginx can be installed   
 参考链接:[http://ksnowlv.gitcafe.com/blog/2014/08/18/you-must-brew-link-pcre-before-nginx-can-be-installed/](http://ksnowlv.gitcafe.com/blog/2014/08/18/you-must-brew-link-pcre-before-nginx-can-be-installed/) 解决办法。
 
#### 如果解决上述错误会怎么样呢？nginx环境安装不成功呗。  在启动nginx时，`http://localhost:8080/`，页面一直显示`404`。
  

#### 3.启动nginx。    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/PHP$sudo nginx
    Password:
 
输入正确密码后,在浏览器中打开`http://localhost:8080/`,即可看到`nginx欢迎页面`

![image](/images/post/2014-08-18-mac-xia-an-zhuang-nginx/welcome_nginx.png)


可以使用`sudo nginx -s stop`关闭`nginx`服务。

    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/PHP$sudo nginx -s stop


#### 4.查看nginx版本信息和help
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/PHP$nginx -v
    nginx version: nginx/1.6.1

    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/PHP$nginx -h
    nginx version: nginx/1.6.1
    Usage: nginx [-?hvVtq] [-s signal] [-c filename] [-p prefix] [-g directives]

    Options:
      -?,-h         : this help
      -v            : show version and exit
      -V            : show version and configure options then exit
      -t            : test configuration and exit
      -q            : suppress non-error messages during configuration testing
      -s signal     : send signal to a master process: stop, quit, reopen, reload
      -p prefix     : set prefix path (default: /usr/local/Cellar/nginx/1.6.1/)
      -c filename   : set configuration file (default: /usr/local/etc/nginx/nginx.conf)
      -g directives : set global directives out of configuration file

        
总结:今天尝试把pcre,nginx在Mac上卸载一遍,重新安装时,才发现当时忽略

    Error: You must `brew link pcre' before nginx can be installed
    
  是多大的灾难,一直是以为配置不对,前前后后检查配置文件...
 
    
 
    