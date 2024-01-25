---
title: "Docker部署redis"
date: 2024-01-13T23:12:36+08:00
lastmod: 2024-01-13T23:12:36+08:00
keywords: ["Docker", "redis", "后端开发"]
tags: ["Docker", "redis", "后端开发"]
categories: ["Docker", "redis", "后端开发"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

##

### 1.创建my-redis-container文件夹

* 1.docker-compose.yml
```dockerfile
version: '3'
services:
  redis:
    image: redis
    container_name: redis_container
    command: redis-server --requirepass 123456
    ports:
      - "6379:6379"
    volumes:
      - ./redis_data:/data
    restart: always

```

* 2.redis_data文件夹


### 2.启动redis容器服务

通过docker-compose up -d下载并启动redis容器服务
通过docker exec -it redis_container redis-cli -a 123456进入redis服务中

```shell
lvwei@lvweideMacBook-Pro my-redis-container % docker-compose up -d
[+] Running 9/9
 ✔ redis 8 layers [⣿⣿⣿⣿⣿⣿⣿⣿]      0B/0B      Pulled                                                                         390.3s 
   ✔ a5573528b1f0 Pull complete                                                                                             333.3s 
   ✔ 5510d86d1248 Pull complete                                                                                               2.7s 
   ✔ da38f099d0c0 Pull complete                                                                                               2.2s 
   ✔ 1c7eb85776c1 Pull complete                                                                                               8.6s 
   ✔ b01ad51b2004 Pull complete                                                                                             383.7s 
   ✔ ced83491d1f3 Pull complete                                                                                              10.8s 
   ✔ 4f4fb700ef54 Pull complete                                                                                              12.3s 
   ✔ 4ee968e6f056 Pull complete                                                                                              15.0s 
[+] Building 0.0s (0/0)                                                                                       docker:desktop-linux
[+] Running 2/2
 ✔ Network my-redis-container_default  Created                                                                                0.0s 
 ✔ Container redis_container           Started                                                                                0.2s 
lvwei@lvweideMacBook-Pro my-redis-container % docker exec -it redis_container redis-cli -a 123456
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
127.0.0.1:6379> KEYS *
(empty array)
127.0.0.1:6379> SET name "ksnowlv" 
OK
127.0.0.1:6379> KEYS *
1) "name"
127.0.0.1:6379> GET name
"ksnowlv"
127.0.0.1:6379> set age  40
OK
127.0.0.1:6379> get age
"40"
127.0.0.1:6379> set address "beijinghaidian"
OK
127.0.0.1:6379> keys *
1) "address"
2) "age"
3) "name"
127.0.0.1:6379> values
(error) ERR unknown command 'values', with args beginning with: 
127.0.0.1:6379> values *
(error) ERR unknown command 'values', with args beginning with: '*' 
127.0.0.1:6379> exit
lvwei@lvweideMacBook-Pro my-redis-container % pwd
/Users/lvwei/Documents/python_projects/fastapitest/files/my-redis-container
lvwei@lvweideMacBook-Pro my-redis-container % 

```
