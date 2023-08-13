---
title: "Mac下搭建基于Apache的PHP开发环境"
date: 2014-08-17
lastmod: 2014-08-17
categories:
  - "后台开发"
tags:
  - "php"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

#### 一.开启Apache服务。<!--more-->
    #输入sudo apachectl start命令,再输入密码
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/PHP$sudo apachectl start
    Password:
    
    #查看Apache版本信息
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/PHP$sudo apachectl -v
    Password:
    Server version: Apache/2.2.26 (Unix)
    Server built:   Dec 10 2013 22:09:38
此时在浏览器上输入`http://localhost`,会出现`It works!`页面。

#### 二.启用PHP.
1.在`/etc/apache2/`目录下，打开`httpd.conf`，找到`LoadModule php5_module libexec/apache2/libphp5.so`,把`#`去掉，保存即可。

![image](/images/post/2014-08-17-mac-xia-da-jian-ji-yu-apachede-phpkai-fa-huan-jing/use_php.png)

2.复制`/Library/WebServer/Documents/index.html.en`文件到`/Library/WebServer/Documents/`目录下，重新命名为`index.php`
  打开`index.php`,在`It works`后面加上`<?php phpinfo(); ?>`
  
3.重启Apache服务。

    sudo apachectl restart
    
在浏览器中输入`http://localhost/index.php`，会出现一个显示php信息的页面.
 
 ![image](/images/post/2014-08-17-mac-xia-da-jian-ji-yu-apachede-phpkai-fa-huan-jing/php_page.png)

#### 三.配置MySql.
1.在[http://dev.mysql.com/downloads/mysql/](http://dev.mysql.com/downloads/mysql/)下载Mac版。选择`Mac OS X 10.8 (x86, 64-bit), DMG Archive`安装完即可。

2.在[http://www.phpmyadmin.net/home_page/downloads.php](http://www.phpmyadmin.net/home_page/downloads.php)下载`phpMyAdmin`,选择`phpMyAdmin-4.2.7-all-languages.7z`下载完成后，解压放进``/Library/WebServer/Documents/``，重命名为`phpmyadmin`

3.复制`/Library/WebServer/Documents/phpmyadmin/config.sample.inc.php`到`/Library/WebServer/Documents/phpmyadmin`目录下， 并命名为`config.inc.php`

4.编辑config.inc.php。

    $cfg['Servers']]$i]['host'] = 'localhost';
修改为:
   
    $cfg['Servers']]$i]['host'] = '127.0.0.1'; 
    
如果想要无密码登陆，则将其中的下面语句中的false改成true.
    $cfg['Servers'][$i]['AllowNoPassword'] = false
 
5、在浏览器中输入`http://localhost/phpmyadmin`
 输入用户名"root",按上一步的无密码操作即可直接登陆。
 
  ![image](/images/post/2014-08-17-mac-xia-da-jian-ji-yu-apachede-phpkai-fa-huan-jing/mysql_page.png)
 
#### 四.在Mac上使用`Sublime Text 2`开发PHP即可。