---
title: "CMake拷贝文件到指定目录"
date: 2024-01-24T15:14:58+08:00
lastmod: 2024-01-24T15:14:58+08:00
keywords: ["CMake"]
tags: ["CMake"]
categories: ["CMake"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## CMake拷贝多级目录下的文件

### 1.背景

C++应用需要测试一批视频文件，视频文件目录如下

---video \
------a \
---------a_1.mp4 \
---------a_2.mp4 \
------b \
---------b_1.mp4 \
---------b_2.mp4 \
------ \
------x \
---------x_1.mp4 \
---------x_2.mp4 

### 2.解决方案


CMakeLists通过add_custom_command自定义命令，在构建过程中添加一些定制化的操作。例如复制文件、执行脚本、进行文件处理等

```CMake
# 拷贝视频文件
file(GLOB_RECURSE VIDEO_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "video/*/*.mp4")

# 创建目标路径
set(TARGET_VIDEO_DIR ${CMAKE_CURRENT_BINARY_DIR}/video)
file(MAKE_DIRECTORY ${TARGET_VIDEO_DIR})

# 复制视频文件到构建目录
foreach(VIDEO_FILE ${VIDEO_FILES})
	add_custom_command(
			OUTPUT ${TARGET_VIDEO_DIR}/${VIDEO_FILE}
			COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/${VIDEO_FILE} ${TARGET_VIDEO_DIR}/${VIDEO_FILE}
			DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${VIDEO_FILE}
			COMMENT "Copying video file ${VIDEO_FILE}"
	)
endforeach()

# 声明一个自定义目标，将视频文件添加到依赖中
add_custom_target(copy_videos DEPENDS ${TARGET_VIDEO_DIR}/${VIDEO_FILES})

# 将 copy_videos 目标添加到构建目标的依赖中
add_dependencies(${PROJECT_NAME} copy_videos)

```

### 3.关于自定义命令
一般情况下，add_custom_command通常与add_custom_target结合使用，用来创建自定义的构建规则。

* add_custom_command命令

```CMake
add_custom_command(
    OUTPUT output_file
    COMMAND command1
    COMMAND command2
    DEPENDS input_file
)
```

* 参数
  * OUTPUT 指定了这个自定义命令的输出文件
  * COMMAND 指定了要执行的命令或脚本
  * DEPENDS 指定了这个自定义命令所依赖的输入文件
  
### 4.示例
构建时复制一个文件并生成一个输出文件，你可以使用add_custom_command和add_custom_target来实现这个功能。

```CMake
add_custom_command(
    OUTPUT file.txt
    COMMAND ${CMAKE_COMMAND} -E copy file.txt file.txt
    DEPENDS file.txt
)

add_custom_target(${PROJECT_NAME} DEPENDS file.txt)

```

