---
title: "Fastapi项目docker部署"
date: 2023-12-08T15:42:41+08:00
lastmod: 2023-12-08T15:42:41+08:00
keywords: ["Fastapi", "docker", "后端开发"]
tags: ["Fastapi", "docker", "后端开发"]
categories: ["Fastapi", "docker", "后端开发"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Fastapi项目docker部署

### 1.requirements.txt生成
Fastapi项目根目录（与main.py同级目录），使用pip3 freeze生成requirements.txt文件
```terminal
pip3 freeze > requirements.txt
```

requirements.txt文件内容如下
```python
aioredis==2.0.1
annotated-types==0.6.0
anyio==3.7.1
async-timeout==4.0.3
certifi==2023.11.17
cffi==1.16.0
charset-normalizer==3.3.2
click==8.1.7
confluent-kafka==2.3.0
cryptography==41.0.5
dnspython==2.4.2
docopt==0.6.2
ecdsa==0.18.0
fastapi==0.103.2
fastdfs-client-py3==1.0.0
h11==0.14.0
h2==4.1.0
hdfs==2.7.3
hpack==4.0.0
httptools==0.6.1
Hypercorn==0.15.0
hyperframe==6.0.1
idna==3.4
jwt==1.3.1
loguru==0.7.2
priority==2.0.0
pyasn1==0.5.0
pycparser==2.21
pydantic==2.4.2
pydantic-settings==2.0.3
pydantic_core==2.10.1
pymongo==4.6.0
PyMySQL==1.1.0
python-dotenv==1.0.0
python-jose==3.3.0
python-multipart==0.0.6
pywebhdfs==0.4.1
PyYAML==6.0.1
redis==5.0.1
requests==2.31.0
rsa==4.9
six==1.16.0
sniffio==1.3.0
SQLAlchemy==2.0.22
starlette==0.27.0
typing_extensions==4.8.0
ujson==5.8.0
urllib3==2.1.0
uvicorn==0.23.2
uvloop==0.18.0
watchfiles==0.21.0
websockets==11.0.3
wsproto==1.2.0
```

### 2.Dockerfile配置

```python
# 设置基本镜像
FROM python:3.11

# 设置工作目录
WORKDIR /app

# 拷贝项目文件到工作目录
COPY . /app

# 安装项目依赖
RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/

# 暴露端口
EXPOSE 8081

# 运行 FastAPI 应用程序
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8081"]
```

注意main:app与项目工程对应

![image](/images/post/fastapi项目docker部署/dockerfile.jpg)

### 3.构建镜像文件

构建镜像文件命令如下
    
    docker build -t 项目名称 .
注意：项目名称后的小点“.” 别忘记了！！！

命令行进入到Dockerfile配置文件所在目录，执行如下：

```terminal
(base) lvwei@lvweideMacBook-Pro fastapitest % docker build -t fastapitest-app .                     
[+] Building 84.5s (9/9) FINISHED                                                                                                docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                                             0.0s
 => => transferring dockerfile: 404B                                                                                                             0.0s
 => [internal] load .dockerignore                                                                                                                0.0s
 => => transferring context: 2B                                                                                                                  0.0s
 => [internal] load metadata for docker.io/library/python:3.11                                                                                   4.1s
 => [1/4] FROM docker.io/library/python:3.11@sha256:0698431f4610b4cad4ccea2b3e2754dfbb61ac4c553bbd2b044d716a917f2cdc                             0.0s
 => [internal] load build context                                                                                                                0.3s
 => => transferring context: 692.19kB                                                                                                            0.3s
 => CACHED [2/4] WORKDIR /app                                                                                                                    0.0s
 => [3/4] COPY . /app                                                                                                                            3.5s
 => [4/4] RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/                                       75.6s
 => exporting to image                                                                                                                           0.9s
 => => exporting layers                                                                                                                          0.9s
 => => writing image sha256:38660250eb0c6c115399fe0e62c098520ea9de2dbe611f7b6bf40af4530c7c05                                                     0.0s 
 => => naming to docker.io/library/fastapitest-app                                                                                               0.0s 
                                                                                                                                                      
What's Next?                                                                                                                                          
  View a summary of image vulnerabilities and recommendations → docker scout quickview
```

### 4.运行容器

运行容器文件命令如下
    
    docker run -d --name 新取的容器名称 -p 8000:80 刚刚构建的镜像名称

上面构建镜像为fastapitest-app，操作情况如下：

```terminal
(base) lvwei@lvweideMacBook-Pro fastapitest % docker run -d --name newapp --network mynet -p 8081:8081 fastapitest-app
a46d63fd7bbf0140db8f873bad3950831ec47a86c36b65f0b1605597f214a585
(base) lvwei@lvweideMacBook-Pro fastapitest % docker ps -a                                                           
CONTAINER ID   IMAGE                    COMMAND                   CREATED          STATUS                     PORTS                               NAMES
a46d63fd7bbf   fastapitest-app          "uvicorn main:app --…"   7 seconds ago    Up 6 seconds               0.0.0.0:8081->8081/tcp              newapp
b51576373e98   fastapi-app              "uvicorn main:app --…"   6 minutes ago    Exited (3) 5 minutes ago                                       myapp
f1a5aeb83045   mysql                    "docker-entrypoint.s…"   41 minutes ago   Up 41 minutes              0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
df43976c22e7   fastapitest:latest       "uvicorn main:app --…"   4 hours ago      Exited (1) 4 hours ago                                         frosty_newton
929b04ca4b68   watch-fastapi-frontend   "nginx -g 'daemon of…"   6 weeks ago      Exited (255) 12 days ago   0.0.0.0:2153->80/tcp                WatchWeb
9dd1c7f8b9cd   watch-fastapi-backend    "uvicorn main:app --…"   6 weeks ago      Exited (255) 12 days ago   0.0.0.0:1339->80/tcp                WatchFastAPI
(base) lvwei@lvweideMacBook-Pro fastapitest % docker ps                                             
CONTAINER ID   IMAGE             COMMAND                   CREATED          STATUS          PORTS                               NAMES
a46d63fd7bbf   fastapitest-app   "uvicorn main:app --…"   29 seconds ago   Up 29 seconds   0.0.0.0:8081->8081/tcp              newapp
f1a5aeb83045   mysql             "docker-entrypoint.s…"   41 minutes ago   Up 41 minutes   0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
```

### 5.FastAPI容器和mysql容器使用相同网络


为什么FastAPI容器和mysql容器使用相同网络，要指定--network mynet呢？

原因： docker部署启动fastapi报错sqlalchemy.exc.OperationalError: (pymysql.err.OperationalError) (2003, "Can't connect to MySQL server on '127.0.0.1' ([Errno 111] Connection refused)")
FastAPI无法连接到MySQL服务器。

在Docker部署中，不能使用127.0.0.1作为MySQL服务器的地址，因为在Docker容器中，127.0.0.1指向的是容器内部，而不是宿主机。

要解决这个问题，你需要确保FastAPI容器与MySQL容器在同一个Docker网络中，并且使用MySQL容器的名称或服务名称来作为连接地址。


创建一个Docker网络，这将使得FastAPI容器和MySQL容器能够相互访问。

#### 创建网络：
    docker network create mynetwork
#### 运行MySQL容器时，指定--network选项将其连接到刚刚创建的网络：

    docker run --name mysql-container --network=mynetwork -e MYSQL_ROOT_PASSWORD=your_password -d mysql:latest
确保将your_password替换为你自己的MySQL根密码。

#### 修改mysql连接配置

 在FastAPI容器中，将连接地址设置为MySQL容器的名称或服务名称，并且将127.0.0.1更改为Docker网络的名称：

    DATABASE_URL = "mysql+pymysql://root:your_password@mysql-container:3306/your_database"

将your_password替换为你在步骤2中设置的MySQL根密码，并将your_database替换为你自己的数据库名称。

例如：
    
    SQLALCHEMY_DATABASE_URL = "mysql+pymysql://root:111111@mysql:3306/mydatabase?charset=utf8mb4"


详细操作步骤参考

```terminal
(base) lvwei@lvweideMacBook-Pro fastapitest % docker network create mynet    
297e608290472a23fec759a75e6b323771773d7bcfbaada11aa0c9fd285d8a76
(base) lvwei@lvweideMacBook-Pro fastapitest % docker ps                  
CONTAINER ID   IMAGE     COMMAND                   CREATED       STATUS       PORTS                               NAMES
3936a8093161   mysql     "docker-entrypoint.s…"   5 hours ago   Up 5 hours   33060/tcp, 0.0.0.0:3307->3306/tcp   mysql
(base) lvwei@lvweideMacBook-Pro fastapitest % docker ps -a          
CONTAINER ID   IMAGE                    COMMAND                   CREATED       STATUS                     PORTS                  NAMES
df43976c22e7   fastapitest:latest       "uvicorn main:app --…"   2 hours ago   Exited (1) 2 hours ago                            frosty_newton
3936a8093161   mysql                    "docker-entrypoint.s…"   5 hours ago   Exited (0) 9 minutes ago                          mysql
929b04ca4b68   watch-fastapi-frontend   "nginx -g 'daemon of…"   6 weeks ago   Exited (255) 12 days ago   0.0.0.0:2153->80/tcp   WatchWeb
9dd1c7f8b9cd   watch-fastapi-backend    "uvicorn main:app --…"   6 weeks ago   Exited (255) 12 days ago   0.0.0.0:1339->80/tcp   WatchFastAPI
(base) lvwei@lvweideMacBook-Pro fastapitest % docker run --name mysql --network mynet -p 3306:3306 -e MYSQL_ROOT_PASSWORD=111111 -d mysql
docker: Error response from daemon: Conflict. The container name "/mysql" is already in use by container "3936a8093161e17f3ccae316d9984fd84f077408af93c39876f791da5ce1aec9". You have to remove (or rename) that container to be able to reuse that name.
See 'docker run --help'.
(base) lvwei@lvweideMacBook-Pro fastapitest % docker stop 3936a8093161e17f3ccae316d9984fd84f077408af93c39876f791da5ce1aec9
3936a8093161e17f3ccae316d9984fd84f077408af93c39876f791da5ce1aec9
(base) lvwei@lvweideMacBook-Pro fastapitest % docker rm 3936a8093161e17f3ccae316d9984fd84f077408af93c39876f791da5ce1aec9
3936a8093161e17f3ccae316d9984fd84f077408af93c39876f791da5ce1aec9
(base) lvwei@lvweideMacBook-Pro fastapitest % sudo lsof -i :3306
Password:
COMMAND PID   USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
mysqld  411 _mysql   20u  IPv6 0x70f53d14a8c97b0b      0t0  TCP *:mysql (LISTEN)
(base) lvwei@lvweideMacBook-Pro fastapitest % sudo kill 411
(base) lvwei@lvweideMacBook-Pro fastapitest % sudo lsof -i :3306
(base) lvwei@lvweideMacBook-Pro fastapitest % docker ps -a                                                                               
CONTAINER ID   IMAGE                    COMMAND                   CREATED         STATUS                     PORTS                               NAMES
f1a5aeb83045   mysql                    "docker-entrypoint.s…"   8 seconds ago   Up 6 seconds               0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
df43976c22e7   fastapitest:latest       "uvicorn main:app --…"   3 hours ago     Exited (1) 3 hours ago                                         frosty_newton
929b04ca4b68   watch-fastapi-frontend   "nginx -g 'daemon of…"   6 weeks ago     Exited (255) 12 days ago   0.0.0.0:2153->80/tcp                WatchWeb
9dd1c7f8b9cd   watch-fastapi-backend    "uvicorn main:app --…"   6 weeks ago     Exited (255) 12 days ago   0.0.0.0:1339->80/tcp                WatchFastAPI
(base) lvwei@lvweideMacBook-Pro fastapitest % docker build -t fastapi-app . 
[+] Building 88.3s (9/9) FINISHED                                                                                                docker:desktop-linux
 => [internal] load .dockerignore                                                                                                                0.0s
 => => transferring context: 2B                                                                                                                  0.0s
 => [internal] load build definition from Dockerfile                                                                                             0.0s
 => => transferring dockerfile: 404B                                                                                                             0.0s
 => [internal] load metadata for docker.io/library/python:3.11                                                                                   5.1s
 => [1/4] FROM docker.io/library/python:3.11@sha256:0698431f4610b4cad4ccea2b3e2754dfbb61ac4c553bbd2b044d716a917f2cdc                             0.0s
 => [internal] load build context                                                                                                                0.5s
 => => transferring context: 698.71kB                                                                                                            0.4s
 => CACHED [2/4] WORKDIR /app                                                                                                                    0.0s
 => [3/4] COPY . /app                                                                                                                            4.6s
 => [4/4] RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/                                       77.2s
 => exporting to image                                                                                                                           0.8s
 => => exporting layers                                                                                                                          0.8s
 => => writing image sha256:ed85de08365ed66171ef256b3cb64b58c202474cb49574f36cd16474a5cbfe96                                                     0.0s 
 => => naming to docker.io/library/fastapi-app                                                                                                   0.0s 
                                                                                                                                                      
What's Next?                                                                                                                                          
  View a summary of image vulnerabilities and recommendations → docker scout quickview
(base) lvwei@lvweideMacBook-Pro fastapitest % docker run -d -p 8081:8081 fastapi-app 
24f2e1350437f41ce2a05521d74e197bb13c9c442f19e033ab81b2ea73ab5a9c
(base) lvwei@lvweideMacBook-Pro fastapitest % docker ps -a                          
CONTAINER ID   IMAGE                    COMMAND                   CREATED         STATUS                     PORTS                               NAMES
24f2e1350437   fastapi-app              "uvicorn main:app --…"   4 seconds ago   Exited (1) 3 seconds ago                                       compassionate_rubin
f1a5aeb83045   mysql                    "docker-entrypoint.s…"   8 minutes ago   Up 8 minutes               0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
df43976c22e7   fastapitest:latest       "uvicorn main:app --…"   3 hours ago     Exited (1) 3 hours ago                                         frosty_newton
929b04ca4b68   watch-fastapi-frontend   "nginx -g 'daemon of…"   6 weeks ago     Exited (255) 12 days ago   0.0.0.0:2153->80/tcp                WatchWeb
9dd1c7f8b9cd   watch-fastapi-backend    "uvicorn main:app --…"   6 weeks ago     Exited (255) 12 days ago   0.0.0.0:1339->80/tcp                WatchFastAPI
(base) lvwei@lvweideMacBook-Pro fastapitest % docker ps
CONTAINER ID   IMAGE     COMMAND                   CREATED          STATUS          PORTS                               NAMES
f1a5aeb83045   mysql     "docker-entrypoint.s…"   12 minutes ago   Up 12 minutes   0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
(base) lvwei@lvweideMacBook-Pro fastapitest % docker exec -it mysql bash
bash-4.4# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.2.0 MySQL Community Server - GPL

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.10 sec)

mysql> create database mydatabase;
Query OK, 1 row affected (0.02 sec)

mysql> use mydatabase
Database changed
mysql>  show tables;
Empty set (0.00 sec)
mysql> CREATE TABLE users (
    ->      id INT auto_increment,
    ->     userid VARCHAR(64) primary key,
    ->     name VARCHAR(50),
    ->     age INT,
    ->     phone VARCHAR(20),
    ->     verification_code VARCHAR(6),
    ->     token VARCHAR(256),
    ->     index idx_id (id),
    ->     index idx_phone (phone),
    ->     index idx_token (token)
    ->     );
Query OK, 0 rows affected (0.08 sec)

mysql> DESCRIBE users;
+-------------------+--------------+------+-----+---------+----------------+
| Field             | Type         | Null | Key | Default | Extra          |
+-------------------+--------------+------+-----+---------+----------------+
| id                | int          | NO   | MUL | NULL    | auto_increment |
| userid            | varchar(64)  | NO   | PRI | NULL    |                |
| name              | varchar(50)  | YES  |     | NULL    |                |
| age               | int          | YES  |     | NULL    |                |
| phone             | varchar(20)  | YES  | MUL | NULL    |                |
| verification_code | varchar(6)   | YES  |     | NULL    |                |
| token             | varchar(256) | YES  | MUL | NULL    |                |
+-------------------+--------------+------+-----+---------+----------------+
7 rows in set (0.03 sec)

mysql> exit
Bye
bash-4.4# exit
exit
(base) lvwei@lvweideMacBook-Pro fastapitest % docker ps                 
CONTAINER ID   IMAGE     COMMAND                   CREATED          STATUS          PORTS                               NAMES
f1a5aeb83045   mysql     "docker-entrypoint.s…"   16 minutes ago   Up 16 minutes   0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
(base) lvwei@lvweideMacBook-Pro fastapitest % docker ps -a                                                                                            
CONTAINER ID   IMAGE                    COMMAND                   CREATED          STATUS                     PORTS                               NAMES
24f2e1350437   fastapi-app              "uvicorn main:app --…"   18 minutes ago   Exited (1) 6 minutes ago                                       compassionate_rubin
f1a5aeb83045   mysql                    "docker-entrypoint.s…"   27 minutes ago   Up 27 minutes              0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
df43976c22e7   fastapitest:latest       "uvicorn main:app --…"   3 hours ago      Exited (1) 3 hours ago                                         frosty_newton
929b04ca4b68   watch-fastapi-frontend   "nginx -g 'daemon of…"   6 weeks ago      Exited (255) 12 days ago   0.0.0.0:2153->80/tcp                WatchWeb
9dd1c7f8b9cd   watch-fastapi-backend    "uvicorn main:app --…"   6 weeks ago      Exited (255) 12 days ago   0.0.0.0:1339->80/tcp                WatchFastAPI
(base) lvwei@lvweideMacBook-Pro fastapitest % docker run fastapi-app --network mynet -d -p 8081:8081 
docker: Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: exec: "--network": executable file not found in $PATH: unknown.
(base) lvwei@lvweideMacBook-Pro fastapitest % docker run -d --name myapp --network mynet -p 8081:8081 fastapi-app
b51576373e9838d0e1de9208772ac40c57e2c9f9d4a83bce87068f2971c0284d
(base) lvwei@lvweideMacBook-Pro fastapitest % docker ps -a
CONTAINER ID   IMAGE                    COMMAND                   CREATED              STATUS                      PORTS                               NAMES
b51576373e98   fastapi-app              "uvicorn main:app --…"   13 seconds ago       Exited (3) 10 seconds ago                                       myapp
6f08868300dc   fastapi-app              "--network mynet -d …"   About a minute ago   Created                     8081/tcp                            ecstatic_tu
6c876e8bd8fd   fastapi-app              "--network mynet"         7 minutes ago        Created                     0.0.0.0:8081->8081/tcp              compassionate_fermi
24f2e1350437   fastapi-app              "uvicorn main:app --…"   27 minutes ago       Exited (1) 15 minutes ago                                       compassionate_rubin
f1a5aeb83045   mysql                    "docker-entrypoint.s…"   35 minutes ago       Up 35 minutes               0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
df43976c22e7   fastapitest:latest       "uvicorn main:app --…"   4 hours ago          Exited (1) 4 hours ago                                          frosty_newton
929b04ca4b68   watch-fastapi-frontend   "nginx -g 'daemon of…"   6 weeks ago          Exited (255) 12 days ago    0.0.0.0:2153->80/tcp                WatchWeb
9dd1c7f8b9cd   watch-fastapi-backend    "uvicorn main:app --…"   6 weeks ago          Exited (255) 12 days ago    0.0.0.0:1339->80/tcp                WatchFastAPI
(base) lvwei@lvweideMacBook-Pro fastapitest % docker build -t fastapitest-app .                     
[+] Building 84.5s (9/9) FINISHED                                                                                                docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                                             0.0s
 => => transferring dockerfile: 404B                                                                                                             0.0s
 => [internal] load .dockerignore                                                                                                                0.0s
 => => transferring context: 2B                                                                                                                  0.0s
 => [internal] load metadata for docker.io/library/python:3.11                                                                                   4.1s
 => [1/4] FROM docker.io/library/python:3.11@sha256:0698431f4610b4cad4ccea2b3e2754dfbb61ac4c553bbd2b044d716a917f2cdc                             0.0s
 => [internal] load build context                                                                                                                0.3s
 => => transferring context: 692.19kB                                                                                                            0.3s
 => CACHED [2/4] WORKDIR /app                                                                                                                    0.0s
 => [3/4] COPY . /app                                                                                                                            3.5s
 => [4/4] RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/                                       75.6s
 => exporting to image                                                                                                                           0.9s
 => => exporting layers                                                                                                                          0.9s
 => => writing image sha256:38660250eb0c6c115399fe0e62c098520ea9de2dbe611f7b6bf40af4530c7c05                                                     0.0s 
 => => naming to docker.io/library/fastapitest-app                                                                                               0.0s 
                                                                                                                                                      
What's Next?                                                                                                                                          
  View a summary of image vulnerabilities and recommendations → docker scout quickview
(base) lvwei@lvweideMacBook-Pro fastapitest % docker run -d --name myapp --network mynet -p 8081:8081 fastapitest-app
docker: Error response from daemon: Conflict. The container name "/myapp" is already in use by container "b51576373e9838d0e1de9208772ac40c57e2c9f9d4a83bce87068f2971c0284d". You have to remove (or rename) that container to be able to reuse that name.
See 'docker run --help'.
(base) lvwei@lvweideMacBook-Pro fastapitest % docker run -d --name newapp --network mynet -p 8081:8081 fastapitest-app
a46d63fd7bbf0140db8f873bad3950831ec47a86c36b65f0b1605597f214a585
(base) lvwei@lvweideMacBook-Pro fastapitest % docker ps -a                                                           
CONTAINER ID   IMAGE                    COMMAND                   CREATED          STATUS                     PORTS                               NAMES
a46d63fd7bbf   fastapitest-app          "uvicorn main:app --…"   7 seconds ago    Up 6 seconds               0.0.0.0:8081->8081/tcp              newapp
b51576373e98   fastapi-app              "uvicorn main:app --…"   6 minutes ago    Exited (3) 5 minutes ago                                       myapp
f1a5aeb83045   mysql                    "docker-entrypoint.s…"   41 minutes ago   Up 41 minutes              0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
df43976c22e7   fastapitest:latest       "uvicorn main:app --…"   4 hours ago      Exited (1) 4 hours ago                                         frosty_newton
929b04ca4b68   watch-fastapi-frontend   "nginx -g 'daemon of…"   6 weeks ago      Exited (255) 12 days ago   0.0.0.0:2153->80/tcp                WatchWeb
9dd1c7f8b9cd   watch-fastapi-backend    "uvicorn main:app --…"   6 weeks ago      Exited (255) 12 days ago   0.0.0.0:1339->80/tcp                WatchFastAPI
(base) lvwei@lvweideMacBook-Pro fastapitest % docker ps                                             
CONTAINER ID   IMAGE             COMMAND                   CREATED          STATUS          PORTS                               NAMES
a46d63fd7bbf   fastapitest-app   "uvicorn main:app --…"   29 seconds ago   Up 29 seconds   0.0.0.0:8081->8081/tcp              newapp
f1a5aeb83045   mysql             "docker-entrypoint.s…"   41 minutes ago   Up 41 minutes   0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
(base) lvwei@lvweideMacBook-Pro fastapitest % docker network ls
NETWORK ID     NAME                    DRIVER    SCOPE
a0e17f6bc61f   bridge                  bridge    local
a84d064e7e5c   fastapitest_default     bridge    local
2cb92de19cfb   host                    host      local
297e60829047   mynet                   bridge    local
5fe1043d059a   none                    null      local
92c6bf939fc1   watch-fastapi_default   bridge    local
(base) lvwei@lvweideMacBook-Pro fastapitest % 

```

