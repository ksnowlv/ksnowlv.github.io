---
layout: post
title: "javaweb开发( 二)-Hello Java World"
date: 2017-11-28 17:24
comments: true
categories: java后台
---

####一.配置Tomcat服务器.
在系统偏好设置中*server*->*runtime-environment*->*add*

![image](/images/post/2017-11-28-javawebkai-fa-2/runtime-environment-config.png) 

#####1.选择我们先前配置的tomcat8.5

![image](/images/post/2017-11-28-javawebkai-fa-2/runtime-environment-config1.png) 
#####2.选择我们配置tomcat8.5所在目录。

![image](/images/post/2017-11-28-javawebkai-fa-2/runtime-environment-config2.png) 
点击完成即可。

**tomcat  name与安装目录下的tomcat版本保持一致**

#####3.查看Tomcat服务器配置如下。
![image](/images/post/2017-11-28-javawebkai-fa-2/runtime-environment-config3.png) 

####二.创建XServer工程并配置。

#####1.选择创建工程类型。
*File*->*New*->*Project*
![image](/images/post/2017-11-28-javawebkai-fa-2/new_project_type.png)

#####2.创建XServer工程
![image](/images/post/2017-11-28-javawebkai-fa-2/new_project_xserver.png)
其他的默认就可以,点击Finish即可。

#####3.配置index.jsp

![image](/images/post/2017-11-28-javawebkai-fa-2/new_project_index_jsp.png)

完整的工程包括XServer/Servers两个目录，运行项目，会报404。


因为web项目底下没有可访问的资源。在项目的**WebContent**目录下，创建一个jsp文件：index.jsp。

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

     <h1>Hello Java World!</h1>  
     <h2>Welcome to ksnowlv page!</h2>
</body>
</html>
```

#####4.运行服务显示index.jsp
运行工程，在浏览器中输入**http://localhost:8080/XServer/index.jsp**

![image](/images/post/2017-11-28-javawebkai-fa-2/new_project_xserver_result.png)

如果运行工程tomcat报错，可以把tomcat关闭重启。