---
title: "Docker中linux环境搭建"
date: 2024-03-01T21:18:44+08:00
lastmod: 2024-03-01T21:18:44+08:00
keywords: ["Mac", "Docker", "linux"]
tags: ["Mac", "Docker", "linux"]
categories: ["Mac", "Docker", "linux"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


### 1.搭建linux环境的Dockerfile

```dockerfile
FROM ubuntu:20.04


# 设置非交互式模式
ARG DEBIAN_FRONTEND=noninteractive


# 解决ubuntu官方apt源无法访问的问题，注意选用合适的架构
COPY sources.list /etc/apt/

# 安装基本依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    valgrind \
    libssl-dev \
    iputils-ping

# 安装 libcurl 和 rapidjson
RUN apt-get install -y \
    libcurl4-gnutls-dev \
    rapidjson-dev

# 下载并编译安装 zip 库
RUN cd /tmp \
    && git clone https://github.com/kuba--/zip.git \
    && cd zip \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install \
    && rm -rf /tmp/zip

# 下载并编译安装 cJSON 库
RUN cd /tmp \
    && git clone https://github.com/DaveGamble/cJSON.git \
    && cd cJSON \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install \
    && rm -rf /tmp/cJSON   
    
# 下载并编译安装 tencentcloud-iot-explorer-sdk-embedded-c 库
#RUN cd /tmp \
#    && git clone https://github.com/TencentCloud/tencentcloud-iot-explorer-sdk-embedded-c.git \
#    && cd tencentcloud-iot-explorer-sdk-embedded-c \
#    && mkdir build \
#    && cd build \
#    && cmake .. \
#    && make \
#    && make install \
#    && rm -rf /tmp/tencentcloud-iot-explorer-sdk-embedded-c     


# 下载并编译安装 Poco 库
#RUN cd /tmp \
#    && git clone https://gitee.com/vintonliu/poco.git\
#    && cd poco \
#    && mkdir build2 \
#    && cd build2 \
#    && cmake .. \
#    && make \
#    && make install \
#    && rm -rf /tmp/poco  




#RUN cd /tmp \
#    && git clone https://github.com/tencentyun/cos-cpp-sdk-v5.git\
#    && cd cos-cpp-sdk-v5 \
#    && cp -r third_party/include/Poco /usr/local/include/Poco \
#    && cp -r third_party/lib/linux/poco/* /usr/local/lib/



# https://github.com/pocoproject/poco.git git clone https://gitee.com/mirrors/poco-cpp-libraries.git
# git clone -b release/1.12.5p2 --single-branch https://gitee.com/mirrors/POCO.git poco
RUN cd /tmp \
    && git clone https://gitee.com/mirrors/POCO.git poco \
    && cd poco \
    && mkdir cmake-build \
    && cd cmake-build \
    && cmake .. \
    && make \
    && make install \
    && rm -rf /tmp/poco  

# 将你的程序复制到镜像应用目录中
#COPY HelloWorld/cmake-build-debug-docker/HELLOWORLD /app/HelloWorld

# 设置工作目录
WORKDIR /app

# 设置容器的启动命令
CMD ["sh", "-c", "echo Hello, World!"]


```


### 2.创建镜像

```shell
ksnowlv@MacBook-Pro-3 clion_cpp_demo % docker build -t linux_sdk:1.0 .
[+] Building 1057.3s (13/13) FINISHED                                                                                                               docker:desktop-linux
 => [internal] load .dockerignore                                                                                                                                   0.0s
 => => transferring context: 2B                                                                                                                                     0.0s
 => [internal] load build definition from Dockerfile                                                                                                                0.0s
 => => transferring dockerfile: 3.15kB                                                                                                                              0.0s
 => [internal] load metadata for docker.io/library/ubuntu:20.04                                                                                                    15.4s
 => [internal] load build context                                                                                                                                   0.0s
 => => transferring context: 465B                                                                                                                                   0.0s
 => [1/8] FROM docker.io/library/ubuntu:20.04@sha256:626ffe58f6e7566e00254b638eb7e0f3b11d4da9675088f4781a50ae288f3322                                               0.0s
 => CACHED [2/8] COPY sources.list /etc/apt/                                                                                                                        0.0s
 => CACHED [3/8] RUN apt-get update && apt-get install -y     build-essential     cmake     git     valgrind     libssl-dev     iputils-ping                        0.0s
 => CACHED [4/8] RUN apt-get install -y     libcurl4-gnutls-dev     rapidjson-dev                                                                                   0.0s
 => [5/8] RUN cd /tmp     && git clone https://github.com/kuba--/zip.git     && cd zip     && mkdir build     && cd build     && cmake ..     && make     && make   5.8s
 => [6/8] RUN cd /tmp     && git clone https://github.com/DaveGamble/cJSON.git     && cd cJSON     && mkdir build     && cd build     && cmake ..     && make      13.0s
 => [7/8] RUN cd /tmp     && git clone https://gitee.com/mirrors/POCO.git poco     && cd poco     && mkdir cmake-build     && cd cmake-build     && cmake ..     1017.8s 
 => [8/8] WORKDIR /app                                                                                                                                              0.1s 
 => exporting to image                                                                                                                                              5.0s 
 => => exporting layers                                                                                                                                             5.0s 
 => => writing image sha256:d2e4e131b5beb3a4bbbd50644f395869fa80bc0c24d4c8d8a0206e44be9b7291                                                                        0.0s 
 => => naming to docker.io/library/linux_sdk:1.0                                                                                                                    0.0s 
                                                                                                                                                                         
View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/lc091ka39t7dsw9pgryxph3zr

What's Next?
  View a summary of image vulnerabilities and recommendations → docker scout quickview

```

### 3.启动容器服务

```shell
ksnowlv@MacBook-Pro-3 clion_cpp_demo % docker run -it --name linux_sdk  linux_sdk:1.0
Hello, World!
```

容器服务启动成功