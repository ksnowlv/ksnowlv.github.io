---
title: "Mac下找回sql密码"
date: 2017-11-28
categories:
  - "数据库"
tags:
  - "数据库"
---
<!--more-->


安装好MySQL，系统给了个默认的的密码。然而，很不幸，忘记了默认的密码。如何找回呢？

 <!--more-->
#### 1.设置中把MySQL关闭。
![image](/images/post/2017-11-28-macxia-zhao-hui-sqlmi-ma/sql-control.png) 

#### 2.切换到MySQL目录下。MySQL目录：usr/local/mysql-5.7.20-macos10.12-x86_64/bin

```objective-c
sudo ./mysqld_safe --skip-grant-table
```
![image](/images/post/2017-11-28-macxia-zhao-hui-sqlmi-ma/sql_mysqld_safe.png) 

#### 3.设置新密码
* 另开个终端，配置短命令：alias mysql=/usr/local/mysql/bin/mysql

* 置root用户的密码为；123 

```objective-c
mysql> update mysql.user set password=‘123' whereUser='root'
mysql> flush privileges; 
mysql> quit
```

![image](/images/post/2017-11-28-macxia-zhao-hui-sqlmi-ma/sql_reset_passoword.png) 

再重启MySQL即可，MySQL Workbench也可以正常使用啦!!!


