---
title: "Mac搭建vscode+linux容器中的flutter开发环境1"
date: 2024-03-25T19:32:40+08:00
lastmod: 2024-03-25T19:32:40+08:00
keywords: ["Flutter", "Linux"]
tags: ["Flutter", "Linux"]
categories: ["Flutter", "Linux"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Mac搭建vscode+linux容器中的flutter开发环境

### 1. Mac本机创建flutter工程hello_world。

### 2.制作镜像的Dockerfile

```dockerfile
# 使用官方的Ubuntu 20.04镜像作为基础镜像
FROM ubuntu:20.04

# 设置环境变量，防止在安装过程中出现交互式提示
ENV DEBIAN_FRONTEND=noninteractive

# 更新软件包列表并安装基本依赖
RUN apt-get update && apt-get install -y \
  git \
  unzip \
  curl \
  build-essential \
  cmake \
  ninja-build \
  clang \
  lldb \
  lld \
  gdb\
  pkg-config\
  libgtk-3-dev

# 从指定的git仓库下载Flutter
WORKDIR /app
RUN git clone https://github.com/flutter/flutter.git

# 配置Flutter的环境变量
ENV PATH="/app/flutter/bin:${PATH}"

# 安装Flutter插件
RUN /app/flutter/bin/flutter config --no-analytics && \
    /app/flutter/bin/flutter doctor -v

RUN mkdir -p /app/FlutterProjects/hello_world
# 复制上一级目录的同级目录到/app/FlutterProjects
COPY hello_world /app/FlutterProjects/hello_world

# 暴露端口
EXPOSE 8080

# 设置默认的工作目录
WORKDIR /app

```

```shell
ksnowlv@MacBook-Pro-3 LinuxFlutter %  docker build -t flutter_nogl .
[+] Building 880.8s (13/13) FINISHED                                                                                                                          docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                                                                          0.0s
 => => transferring dockerfile: 1.71kB                                                                                                                                        0.0s
 => [internal] load .dockerignore                                                                                                                                             0.0s
 => => transferring context: 2B                                                                                                                                               0.0s
 => [internal] load metadata for docker.io/library/ubuntu:20.04                                                                                                              15.5s
 => CACHED [1/8] FROM docker.io/library/ubuntu:20.04@sha256:626ffe58f6e7566e00254b638eb7e0f3b11d4da9675088f4781a50ae288f3322                                                  0.0s
 => [internal] load build context                                                                                                                                             0.3s
 => => transferring context: 126.43kB                                                                                                                                         0.3s
 => [2/8] RUN apt-get update && apt-get install -y   git   unzip   curl   build-essential   cmake   ninja-build   clang   lldb   lld   gdb  pkg-config  libgtk-3-dev        601.9s
 => [3/8] WORKDIR /app                                                                                                                                                        0.1s 
 => [4/8] RUN git clone https://github.com/flutter/flutter.git                                                                                                              117.2s 
 => [5/8] RUN /app/flutter/bin/flutter config --no-analytics &&     /app/flutter/bin/flutter doctor -v                                                                      119.2s 
 => [6/8] WORKDIR /app                                                                                                                                                        0.0s 
 => [7/8] RUN mkdir -p /app/FlutterProjects/hello_world                                                                                                                       0.5s 
 => [8/8] COPY hello_world /app/FlutterProjects/hello_world                                                                                                                   6.8s 
 => exporting to image                                                                                                                                                       19.4s 
 => => exporting layers                                                                                                                                                      19.3s 
 => => writing image sha256:bebf15e8f29786f1d161a2ef3044abe8e3911538a4ecea32fee99d53f8c418a4                                                                                  0.0s 
 => => naming to docker.io/library/flutter_nogl                                                                                                                               0.0s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/k3fjcrbid51xixzgndv76iszi

What's Next?
  View a summary of image vulnerabilities and recommendations → docker scout quickview
ksnowlv@MacBook-Pro-3 LinuxFlutter %  
```

### 3.启动容器

```shell
ksnowlv@MacBook-Pro-3 LinuxFlutter %  docker run -it  -e DISPLAY=host.docker.internal:0  -v /tmp/.X11-unix:/tmp/.X11-unix  --name flutter_nogl  flutter_nogl /bin/bash
```
上述命令启动了一个名为flutter_nogl的容器，并将其设置为交互式容器（-it 选项）。

docker run: 运行一个新的容器
* -it: 指定交互式执行，通常用于需要交互的命令行应用程序
* -e DISPLAY=host.docker.internal:0: 设置名为 DISPLAY 的环境变量，用于指定容器内的图形界面显示到宿主机的X服务器。host.docker.internal 是Docker针对宿主机的主机名，0 则表示 X 服务器的显示编号。
* -v /tmp/.X11-unix:/tmp/.X11-unix: 将宿主机的 X11 UNIX 域套接字（指向 X 服务器的通信管道）映射到容器内的相同位置。这允许容器内的应用程序连接到宿主机的 X 服务器以显示图形界面。
* --name flutter_nogl: 为容器指定一个名称，即 flutter_nogl
flutter_nogl: 要使用的镜像名称，也即您要从其中启动容器的镜像名称
* /bin/bash: 在容器内启动的命令，这里是启动一个 bash shell
综合起来，这个命令的目的是创建一个带有图形界面的容器，允许在其中执行需要图形界面的命令或应用程序。通常情况下，这样的容器会用于运行需要图形界面的应用程序或者开发环境，比如在容器内运行带有图形界面的Flutter开发环境

### 4.Mac安装XQuartz，并完成允许从网络客户端连接设置
从[https://www.xquartz.org](https://www.xquartz.org)下载**XQuartz**，并完成安装。

在Mac应用程序中，找到实用工具中的**XQuartz**，并打开。

在**XQuartz**的偏好设置中，选择安全性选项卡，然后，勾选“鉴定连接”和“允许从网络客户端连接”，确保这两项选中。然后，重启**XQuartz**，使设置生效。

![image](/images/flutter/Mac搭建vscode+linux容器中的flutter开发环境1/x11_setting.jpg)

```shell
ksnowlv@MacBook-Pro-3 base_demo % xhost +
access control disabled, clients can connect from any host
ksnowlv@MacBook-Pro-3 base_demo % xeyes
```
**XQuartz**返回上述信息就代表，已完成设置；输入**xeyes**你将看到鼠标的眼睛。


### 5. VSCode打开容器中的hello_world工程

VSCode 安装docker插件，安装完成后， **control+option+p** ，选择Docker： 焦点在 Containers 视图上
Docker: Focus on Containers View，并打开。
![image](/images/flutter/Mac搭建vscode+linux容器中的flutter开发环境1/vscode_container.jpg)

### 6.效果

右击运行的容器，并打开**附加 Visual Studio Code**；
![image](/images/flutter/Mac搭建vscode+linux容器中的flutter开发环境1/vscode_start.png)
启动vscode后，运行linux应用

![image](/images/flutter/Mac搭建vscode+linux容器中的flutter开发环境1/result.png)


能跑起来，报错libGL error: No matching fbConfigs or visuals found
libGL error: failed to load driver: swrast知道是OPENGL出错了，试了许多办法，无效果。

有知道的，还请指点。


```shell
Launching lib/main.dart on Linux in debug mode...
✓ Built build/linux/x64/debug/bundle/hello_world
libGL error: No matching fbConfigs or visuals found
libGL error: failed to load driver: swrast

(hello_world:51854): Gdk-CRITICAL **: 15:22:14.928: gdk_gl_context_make_current: assertion 'GDK_IS_GL_CONTEXT (context)' failed

** (hello_world:51854): WARNING **: 15:22:14.928: Failed to initialize GLArea: Unable to create a GL context

** (hello_world:51854): CRITICAL **: 15:22:15.146: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.154: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.163: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.171: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.179: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.187: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.195: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.203: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.211: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.219: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.227: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.235: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.243: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.251: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.259: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.268: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.275: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.284: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.291: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.302: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:15.992: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.002: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.008: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.019: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.026: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.034: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.041: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.050: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.057: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.066: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.073: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.084: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.089: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.102: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.105: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.113: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.121: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.129: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.137: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.145: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.333: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.339: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.347: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.355: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.364: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.372: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.380: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.388: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.395: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.403: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.411: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.420: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.427: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.437: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.444: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.452: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.460: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.469: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.477: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.484: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.492: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.501: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.508: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.518: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.524: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.533: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.540: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.549: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.567: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.597: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.621: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.629: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.637: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.653: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.661: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.670: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.678: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.686: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.694: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.711: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.728: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.736: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.742: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed

** (hello_world:51854): CRITICAL **: 15:22:16.751: void fl_keyboard_manager_sync_modifier_if_needed(FlKeyboardManager *, guint, double): assertion 'FL_IS_KEYBOARD_MANAGER(self)' failed



```


