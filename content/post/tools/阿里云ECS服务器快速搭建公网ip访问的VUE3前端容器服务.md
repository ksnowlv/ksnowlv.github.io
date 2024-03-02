---
title: "阿里云ECS服务器快速搭建公网ip访问的VUE3前端容器服务"
date: 2024-02-26T19:10:09+08:00
lastmod: 2024-02-26T19:10:09+08:00
keywords: ["前端开发", "阿里云ECS", "docker", "vue3"]
tags: ["前端开发", "阿里云ECS", "docker", "vue3"]
categories: ["前端开发", "阿里云ECS", "docker", "vue3"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 1.阿里云ECS网络安全组设定规则

![image](/images/post/阿里云ECS服务器快速搭建公网ip访问的VUE3前端容器服务/ali_ecs_server_config_list.jpg)
选择网络与安全下的安全组，进入”管理规则“，配置入口规则；

添加规则如下

    开通端口8080（前端VUE3web服务使用）

![image](/images/post/阿里云ECS服务器快速搭建公网ip访问的VUE3前端容器服务/ali_ecs_server_config.png)

### 2.vue3前端容器服务。

#### 创建vue3项目,并生成用于生产环境的静态文件。

```shell
(base) lvwei@lvweideMacBook-Pro vue3_projects % npm init vite-app HelloVue
npx: 7 安装成功，用时 3.463 秒
Scaffolding project in /Users/lvwei/Documents/vue3_projects/HelloVue...

Done. Now run:

  cd HelloVue
  npm install (or `yarn`)
  npm run dev (or `yarn dev`)



   ╭────────────────────────────────────────────────────────────────╮
   │                                                                │
   │      New major version of npm available! 6.14.13 → 10.4.0      │
   │   Changelog: https://github.com/npm/cli/releases/tag/v10.4.0   │
   │               Run npm install -g npm to update!                │
   │                                                                │
   ╰────────────────────────────────────────────────────────────────╯

(base) lvwei@lvweideMacBook-Pro HelloVue % npm install   
npm WARN old lockfile 
npm WARN old lockfile The package-lock.json file was created with an old version of npm,
npm WARN old lockfile so supplemental metadata must be fetched from the registry.
npm WARN old lockfile 
npm WARN old lockfile This is a one-time fix-up, please be patient...
npm WARN old lockfile 

up to date in 6s
npm notice 
npm notice New major version of npm available! 9.6.4 -> 10.4.0
npm notice Changelog: https://github.com/npm/cli/releases/tag/v10.4.0
npm notice Run npm install -g npm@10.4.0 to update!
npm notice 
(base) lvwei@lvweideMacBook-Pro HelloVue % npm run dev

> HelloVue@0.0.0 dev
> vite

[vite] Optimizable dependencies detected:
vue

  Dev server running at:
  > Local:    http://localhost:3000/
  > Network:  http://172.28.38.85:3000/
(base) lvwei@lvweideMacBook-Pro HelloVue % npm run build 

> HelloVue@0.0.0 build
> vite build

[write] dist/index.html 0.38kb, brotli: 0.14kb
[write] dist/_assets/logo.3b714202.png 6.69kb
[write] dist/_assets/index.ea291e17.js 51.21kb, brotli: 18.34kb
[write] dist/_assets/style.0637ccc5.css 0.16kb, brotli: 0.10kb
Build completed in 1.71s.

(base) lvwei@lvweideMacBook-Pro HelloVue % 

```

#### VUE项目根目录创建nginx配置文件(default.conf)

```text
server {
    listen       80;
    server_name  ECS服务器公网IP; # 修改为docker服务宿主机的ip

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        try_files $uri $uri/ /index.html =404;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }
}

```

#### 创建Dockerfile

```dockerfile
# 使用官方的 Nginx 镜像作为基础镜像
FROM nginx

# 设置工作目录
WORKDIR /usr/share/nginx/html

# 删除默认的 Nginx 静态文件
RUN rm -rf ./*

# 将构建好的 Vue 应用程序文件复制到 Nginx 静态文件目录下
COPY dist/ .

# 配置 Nginx，将所有请求重定向到 index.html
COPY default.conf /etc/nginx/conf.d/default.conf

# 暴露80端口
EXPOSE 80

# 启动 Nginx 服务
CMD ["nginx", "-g", "daemon off;"]

```


登陆宝塔，在www目录下创建vuewebapp项目目录,上传dist目录,Dockerfile，default.conf三个文件。如图

![image](/images/post/阿里云ECS服务器快速搭建公网ip访问的VUE3前端容器服务/vue3_app_dir.jpg)

### 3.Docker生成镜像，并启动容器服务

```shell

# 生成镜像
[root@xxx vuewebapp]# docker build -t hellovueapp:1.2 . 
[+] Building 1.8s (10/10) FINISHED                                                                                                        docker:default
 => [internal] load build definition from Dockerfile                                                                                                0.0s
 => => transferring dockerfile: 705B                                                                                                                0.0s
 => [internal] load metadata for docker.io/library/nginx:latest                                                                                     1.6s
 => [internal] load .dockerignore                                                                                                                   0.0s
 => => transferring context: 2B                                                                                                                     0.0s
 => [1/5] FROM docker.io/library/nginx:latest@sha256:c26ae7472d624ba1fafd296e73cecc4f93f853088e6a9c13c0d52f6ca5865107                               0.0s
 => [internal] load build context                                                                                                                   0.0s
 => => transferring context: 667B                                                                                                                   0.0s
 => CACHED [2/5] WORKDIR /usr/share/nginx/html                                                                                                      0.0s
 => CACHED [3/5] RUN rm -rf ./*                                                                                                                     0.0s
 => CACHED [4/5] COPY dist/ .                                                                                                                       0.0s
 => [5/5] COPY default.conf /etc/nginx/conf.d/default.conf                                                                                          0.0s
 => exporting to image                                                                                                                              0.0s
 => => exporting layers                                                                                                                             0.0s
 => => writing image sha256:3c7507f227194fc56b41a64f4f228f8af710c6cb41826d1c285db841992c073c                                                        0.0s
 => => naming to docker.io/library/hellovueapp:1.2                                                                                                  0.0s
[root@xxx vuewebapp]# docker run -d --name hellovueapp  -p 8080:80 hellovueapp:1.2
9a16f28a88acfae7a7d457104637bc012655de8d53fd1111310732de1361d798
[root@xxx vuewebapp]# 
```

### 5.容器服务测试
在宝塔docker功能选项中查看hellovueapp服务
![image](/images/post/阿里云ECS服务器快速搭建公网ip访问的VUE3前端容器服务/vue3_app_docker_container.jpg)

可以通过curl http://172.17.0.3:80测试容器服务连通性。

```shell
[root@xxx vuewebapp]# curl http://172.17.0.3:80
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <link rel="icon" href="/favicon.ico" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Vite App</title>
<script type="module" src="/_assets/index.ea291e17.js"></script>
<link rel="stylesheet" href="/_assets/style.0637ccc5.css">
</head>
<body>
  <div id="app"></div>
  
</body>
</html>
[root@xxx vuewebapp]# 

```

前端容器服务正常

### 8.效果
浏览器中打开http:服务器公网ip:8080

![image](/images/post/阿里云ECS服务器快速搭建公网ip访问的VUE3前端容器服务/vue3_app_test_result.jpg)

