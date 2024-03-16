---
title: "Mac下通过docker中的linux配置和安装ROS2"
date: 2024-03-15T11:48:05+08:00
lastmod: 2024-03-15T11:48:05+08:00
keywords: ["Mac", "ROS2", "C++", "Linux"]
tags: ["Mac", "ROS2", "C++", "Linux"]
categories: ["Mac", "ROS2", "C++", "Linux"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


### 1.Dockerfile

```dockerfile
FROM ubuntu:20.04


# 设置时区及非交互式模式
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/Asia/Beijing /etc/localtime && DEBIAN_FRONTEND=noninteractive 


# 解决ubuntu官方apt源无法访问的问题，注意选用合适的架构
COPY sources.list /etc/apt/

# 安装基本依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    valgrind \
    libssl-dev \
    iputils-ping \
    curl \
    gnupg2 \
    lsb-release
# 更新apt并安装必要的工具:curl， gnupg2，lsb-release    

# 安装 libcurl 和 rapidjson
RUN apt-get install -y \
    libcurl4-gnutls-dev \
    rapidjson-dev


# 下载并编译安装 cJSON 库
RUN cd /tmp \
    #&& git clone https://github.com/DaveGamble/cJSON.git \
    && git clone https://gitee.com/mirrors/cJSON.git \
    && cd cJSON \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install \
    && rm -rf /tmp/cJSON   
    


# 添加ROS2软件源
RUN curl -sSL https://gitee.com/ohhuo/rosdistro/raw/master/ros.key | apt-key add -
RUN sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'


# 更新apt，并安装ROS2
RUN apt-get update && apt-get install -y \
    ros-foxy-desktop

# 安装一些常用工具
RUN apt-get install -y \
    python3-pip

# 设置环境变量
ENV ROS_DISTRO foxy

# 设置工作目录
WORKDIR /root/ros2_ws

# 安装软件包
RUN apt update && apt install -y \
    python3-pip \
    python3-vcstool

# 安装colcon
RUN python3 -m pip install -U colcon-common-extensions

# 设置ROS环境
RUN echo "source /opt/ros/foxy/setup.bash" >> /root/.bashrc

# 初始化ROS 2工作空间并构建
RUN /bin/bash -c "source /opt/ros/foxy/setup.bash; cd /root/ros2_ws; colcon build"

# 验证ROS 2是否安装成功
CMD ["bash"]


```

### 2.sources.list

```text

deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse

```

### 3.制作镜像

```shell
ksnowlv@MacBook-Pro-3 RosProjects % docker build -t ros2_sdk:1.0 .
[+] Building 897.6s (20/20) FINISHED                                                                                                                       docker:desktop-linux
 => [internal] load .dockerignore                                                                                                                                          0.0s
 => => transferring context: 2B                                                                                                                                            0.0s
 => [internal] load build definition from Dockerfile                                                                                                                       0.0s
 => => transferring dockerfile: 2.59kB                                                                                                                                     0.0s
 => [internal] load metadata for docker.io/library/ubuntu:20.04                                                                                                           15.4s
 => CACHED [ 1/15] FROM docker.io/library/ubuntu:20.04@sha256:626ffe58f6e7566e00254b638eb7e0f3b11d4da9675088f4781a50ae288f3322                                             0.0s
 => [internal] load build context                                                                                                                                          0.0s
 => => transferring context: 481B                                                                                                                                          0.0s
 => [ 2/15] RUN ln -fs /usr/share/zoneinfo/Asia/Beijing /etc/localtime && DEBIAN_FRONTEND=noninteractive                                                                   0.3s
 => [ 3/15] COPY sources.list /etc/apt/                                                                                                                                    0.0s
 => [ 4/15] RUN apt-get update && apt-get install -y     build-essential     cmake     git     valgrind     libssl-dev     iputils-ping     curl     gnupg2     lsb-rel  142.3s
 => [ 5/15] RUN apt-get install -y     libcurl4-gnutls-dev     rapidjson-dev                                                                                               2.8s 
 => [ 6/15] RUN cd /tmp     && git clone https://gitee.com/mirrors/cJSON.git     && cd cJSON     && mkdir build     && cd build     && cmake ..     && make     && make   10.0s 
 => [ 7/15] RUN curl -sSL https://gitee.com/ohhuo/rosdistro/raw/master/ros.key | apt-key add -                                                                             0.7s 
 => [ 8/15] RUN sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.l  0.4s 
 => [ 9/15] RUN apt-get update && apt-get install -y     ros-foxy-desktop                                                                                                559.1s 
 => [10/15] RUN apt-get install -y     python3-pip                                                                                                                         4.8s 
 => [11/15] WORKDIR /root/ros2_ws                                                                                                                                          0.0s 
 => [12/15] RUN apt update && apt install -y     python3-pip     python3-vcstool                                                                                           6.9s 
 => [13/15] RUN python3 -m pip install -U colcon-common-extensions                                                                                                       124.5s 
 => [14/15] RUN echo "source /opt/ros/foxy/setup.bash" >> /root/.bashrc                                                                                                    0.8s 
 => [15/15] RUN /bin/bash -c "source /opt/ros/foxy/setup.bash; cd /root/ros2_ws; colcon build"                                                                             1.1s 
 => exporting to image                                                                                                                                                    28.2s 
 => => exporting layers                                                                                                                                                   28.1s 
 => => writing image sha256:38d6552607833a391dadf67ae55fac8a412e76452b6c532b545591126a8b9073                                                                               0.0s 
 => => naming to docker.io/library/ros2_sdk:1.0                                                                                                                            0.0s 

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/s1hii2q5h6m5pfjvp5o6f1wqp

What's Next?
  View a summary of image vulnerabilities and recommendations → docker scout quickview
ksnowlv@MacBook-Pro-3 RosProjects % 

```

### 4.启动容器并开启ROS2 Python listener

```shell
ksnowlv@MacBook-Pro-3 RosProjects %  docker run -it --name ros2  ros2_sdk:1.0 /bin/bash
root@3111abffabb0:~/ros2_ws# ros2 run demo_nodes_py listener
```

### 5.进入容器并开启ROS2 C++ talker
打开另外一个终端，通过**docker exec -it ros2 /bin/bash**进入容器内部，启动 C++ talker
```shell
ksnowlv@MacBook-Pro-3 ~ % docker exec -it ros2 /bin/bash
root@3111abffabb0:~/ros2_ws# ros2 run demo_nodes_cpp talker
[INFO] [1710476040.280881406] [talker]: Publishing: 'Hello World: 1'
[INFO] [1710476041.280782859] [talker]: Publishing: 'Hello World: 2'
[INFO] [1710476042.280745710] [talker]: Publishing: 'Hello World: 3'
[INFO] [1710476043.280830397] [talker]: Publishing: 'Hello World: 4'
[INFO] [1710476044.281149678] [talker]: Publishing: 'Hello World: 5'
[INFO] [1710476045.280676070] [talker]: Publishing: 'Hello World: 6'
[INFO] [1710476046.281002897] [talker]: Publishing: 'Hello World: 7'
[INFO] [1710476047.280855025] [talker]: Publishing: 'Hello World: 8'
[INFO] [1710476048.281101670] [talker]: Publishing: 'Hello World: 9'
[INFO] [1710476049.281158616] [talker]: Publishing: 'Hello World: 10'

```

### 6.效果

![image](/images/ros/Mac下通过docker中的linux配置和安装ROS2/result.png)