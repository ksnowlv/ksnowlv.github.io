---
layout: post
title: "python-WSGI搭建web-server"
date: 2014-08-10 16:43
comments: true
categories: python
---
    
####python提供了WSGI:Web Server Gateway Interface 只要求Web开发者实现一个函数即可响应HTTP请求。

<!--more-->

####application()函数必须由WSGI服务器来调用
####先定义hello.py文件。

``` python

#hello.py
def application(environ, start_response):

start_response('200 OK', [('Content-Type', 'text/html')])

  return '<h1>Hello, %s!</h1>' % (environ['PATH_INFO'][1:] or 'web')

```


####可以从`environ`里读取`PATH_INFO`，默认为web.

####你可以在地址栏输入文本作为URL的一部分，将返回Hello, [输入文本]!


####定义python_http_server.py文件，代码如下:


``` python

# python_http_server.py
# 从wsgiref模块导入:
from wsgiref.simple_server import make_server
# 导入我们自己编写的application函数:
from hello import application

# 创建一个服务器，IP地址为空，端口是8000，处理函数是application:
httpd = make_server('', 8000, application)
print "Serving HTTP on port 8000..."
# 开始监听HTTP请求:
httpd.serve_forever()


```

####运行python_http_server.py

    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/python server$python python_http_server.py 
    Serving HTTP on port 8000...
    127.0.0.1 - - [10/Aug/2014 16:32:03] "GET / HTTP/1.1" 200 20
    127.0.0.1 - - [10/Aug/2014 16:33:00] "GET /ksnowlv HTTP/1.1" 200 24
    127.0.0.1 - - [10/Aug/2014 17:02:40] "GET /kair HTTP/1.1" 200 21
  
####注意：如果8000端口已被其他程序占用，启动将失败，请修改成其他端口。

启动python server成功后，打开浏览器，输入`http://localhost:8000/`,输入ksnowlv,kair可以看到相关变化.

![image](/images/post/2014-08-10-python-wsgi-da-jian-web-server/web_server_result.png)

    hello.py和python_http_server.py放到同一个目录
