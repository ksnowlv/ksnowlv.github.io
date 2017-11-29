---
layout: post
title: "Mac下配置nginx-mysql-php"
date: 2014-08-19 10:10
comments: true
categories: nginx
---

Mac上配置nginx,mysql,php开发环境

<!--more-->

####一.安装nginx.

 1.安装pcre.
 
    brew install pcre
 
 2.安装nginx.   
 
     brew install nginx
     
 如遇见问题，可参考链接:[Mac下安装nginx](http://ksnowlv.gitcafe.com/blog/2014/08/18/mac-xia-an-zhuang-nginx/)
 
####二.安装mysql.

从[mysql官网](http://dev.mysql.com/downloads/mysql/)下载Mac版本安装即可。

####三.安装配置php.

`Mac`内置有`php`,但是我们选择装新版本的`php55`.

    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/PHP$brew install php55
    ==> Installing dependencies for php55: libpng, freetype, gettext, jpeg, unixodbc, homebrew/dupes/zlib, libtool
    ==> Installing php55 dependency: libpng
    ....

`php55`安装完成后,修改`nginx`配置文件。

在`/usr/local/etc/nginx`目录中,打开`nginx.conf`,添加对php的支持。

![image](/images/post/2014-08-19-macxia-an-zhuang-nginx-mysql-php/nginx_php_config.png)

####四.测试php页面。

1.在`/usr/local/Cellar/nginx/1.6.1/html`目录下创建页面`index.php`.
内容为：

    <?php phpinfo();?>

2.在终端启动`PHP`和`nginx`服务

    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/PHP$SystemStarter php55-fpm restart
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/PHP$sudo nginx -s reload
    Password:
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/PHP$

3.在浏览器打开`http://localhost:8080/index.php`，就可以看到`php页面`。

![image](/images/post/2014-08-19-macxia-an-zhuang-nginx-mysql-php/php_main_page.png)
        