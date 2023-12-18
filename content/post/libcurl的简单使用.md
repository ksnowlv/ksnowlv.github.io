---
title: "Libcurl的简单使用"
date: 2023-12-14T19:25:36+08:00
lastmod: 2023-12-14T19:25:36+08:00
keywords: ["Mac", "C++", "网络"]
tags: ["Mac", "C++", "网络"]
categories: ["Mac", "C++", "网络"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## C++libcurl库的使用

Mac上配置libcurl库的环境变量，并在C++项目中通过CMakeLists.txt 文件引用

### 1.libcurl安装

    brew install curl #如果是x86的cpu架构
    arch -arm64 brew install curl #如果是arm的cpu架构

### 2.环境变量配置

.bash_profile或者.zshrc添加配置

    # liburl
    export CURL_HOME=/usr/local/opt/curl
    export C_INCLUDE_PATH=$CURL_HOME/include
    export CPLUS_INCLUDE_PATH=$CURL_HOME/include
    export LIBRARY_PATH=$CURL_HOME/lib
    export DYLD_LIBRARY_PATH=$CURL_HOME/lib

### 3.CMakeLists.txt引用libcurl库

    find_path(CURL_INCLUDE_DIR curl/curl.h)
    find_library(CURL_LIBRARY NAMES curl)
    include_directories(${CURL_INCLUDE_DIR})

    add_executable(my_program main.cpp)
    target_link_libraries(my_program ${CURL_LIBRARY})
