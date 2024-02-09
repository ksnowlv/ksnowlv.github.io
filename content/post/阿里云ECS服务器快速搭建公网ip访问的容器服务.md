---
title: "阿里云ECS服务器快速搭建公网ip访问的容器服务"
date: 2024-02-06T17:01:28+08:00
lastmod: 2024-02-06T17:01:28+08:00
keywords: ["后端开发", "阿里云ECS", "docker", "fastapi"]
tags: ["后端开发", "阿里云ECS", "docker", "fastapi"]
categories: ["后端开发", "阿里云ECS", "docker", "fastapi"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## 阿里云ECS服务器快速搭建公网ip访问的容器服务


### 1.购买阿里云ECS服务
* 1.开通阿里云账号后，选择CentOS系统，购买阿里云ECS服务器；
* 2.设定阿里云相关密码
  * 实例镜像中选择远程连接，设定相关密码；
  * 进入linux系统后，yum update更新系统；
  * 安装linux宝塔面板，并注册开通宝塔账号；
  


![image](/images/post/阿里云ECS服务器快速搭建公网ip访问的容器服务/ali_ecs_server.jpg)


### 2.阿里云ECS网络安全组设定规则

![image](/images/post/阿里云ECS服务器快速搭建公网ip访问的容器服务/ali_ecs_server_config_list.jpg)
选择网络与安全下的安全组，进入”管理规则“，配置入口规则；

添加规则如下

    开通端口10277（宝塔运维使用）和8001（测试服务使用）

![image](/images/post/阿里云ECS服务器快速搭建公网ip访问的容器服务/ali_ecs_server_config.jpg)

### 3.fastapi容器服务。

#### 创建fastapi项目
登陆宝塔，在www目录下创建myfastapiapp项目,上传main.py,requirements.txt,Docker三个文件。如图

![image](/images/post/阿里云ECS服务器快速搭建公网ip访问的容器服务/fastapiapp_docker_service.jpg)

* main.py

```python

# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.


from typing import Union
from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.get("/")
async def read_root():
    return {"Hello": "World"}

@app.get("/items/{item_id}")
async def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


if __name__ == '__main__':
    uvicorn.run(app="main:app", host="127.0.0.1", port=8001, log_level="debug", reload=True)


```

* requirements.txt

```text
annotated-types==0.6.0
anyio==4.2.0
click==8.1.7
fastapi==0.109.2
h11==0.14.0
httptools==0.6.1
idna==3.6
pydantic==2.6.0
pydantic_core==2.16.1
python-dotenv==1.0.1
PyYAML==6.0.1
sniffio==1.3.0
starlette==0.36.3
typing_extensions==4.9.0
uvicorn==0.27.0.post1
uvloop==0.19.0
watchfiles==0.21.0
websockets==12.0

```

* Docker

```dockerfile
# 设置基本镜像
FROM python:3.11

# 设置工作目录
WORKDIR /app

# 拷贝项目文件到工作目录
COPY . /app

# 安装项目依赖
RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/

# 暴露端口
EXPOSE 8001

# 运行 FastAPI 应用程序
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8001"]

```

### 4.Docker生成镜像，并启动容器服务

```shell

# 生成镜像
 docker build -t myfastapp:1.5 . 
 
 # 以8001端口启动容器服务
 docker run -d --name myfastapp  -p 8001:8001 myfastapp:1.5
 
```

### 5.容器服务测试
在宝塔docker功能选项中查看myfastapi服务
![image](/images/post/阿里云ECS服务器快速搭建公网ip访问的容器服务/fastapi_docker_service_test.jpg)

可以通过curl http://172.17.0.2:8001测试容器服务连通性。

```shell
[root@xxx ~]# curl http://172.17.0.2:8001
{"Hello":"World"}[root@xxx ~]#

```

容器服务正常

### 6.nginx配置

![image](/images/post/阿里云ECS服务器快速搭建公网ip访问的容器服务/fastapi_nginx.jpg)
按上述配置nginx，并重启。
```shell
# nginx重启
sudo systemctl restart nginx
```

### 7.Docker服务配置ip数据转发。

开启docker容器ip数据转发，并重启myfastapp容器服务

```shell
echo "net.ipv4.ip_forward = 1" 

[root@xx ~]# docker ps
CONTAINER ID   IMAGE           COMMAND                  CREATED       STATUS       PORTS                                       NAMES
bc1823be09e3   myfastapp:1.5   "uvicorn main:app --…"   6 hours ago   Up 6 hours   0.0.0.0:8001->8001/tcp, :::8001->8001/tcp   myfastapp
[root@xx ~]# docker restart myfastapp 
myfastapp
[root@xx ~]# 



```



### 8.效果
浏览器中打开http:服务器公网ip:8001/docs可进入swagger
![image](/images/post/阿里云ECS服务器快速搭建公网ip访问的容器服务/fastapi_test_result.jpg)

