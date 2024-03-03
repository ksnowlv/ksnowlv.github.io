---
title: "Mac安装FastDFS"
date: 2023-11-25T18:49:46+08:00
lastmod: 2023-11-25T18:49:46+08:00
keywords: ["FastDFS", "存储", "后端开发", "Mac"]
tags: ["存储", "后端开发", "Mac"]
categories: ["存储", "后端开发", "Mac"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


## Mac 安装FastDFS


### 1.下载libfastcommon和fastdfs

[libfastcommon](https://github.com/happyfish100/libfastcommon)
[fastdfs](https://github.com/happyfish100/fastdfs)

### 2.libfastcommon安装

执行make.sh脚本，然后使用sudo ./make.sh install命令进行安装

```shell
(base) lvwei@lvweideMacBook-Pro fastdfs % cd libfastcommon-master/ 
(base) lvwei@lvweideMacBook-Pro libfastcommon-master % ls
HISTORY			LICENSE			debian			libfastcommon.spec	php-fastcommon
INSTALL			README			doc			make.sh			src
(base) lvwei@lvweideMacBook-Pro libfastcommon-master % ./make.sh 
gcc -Wall -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -g -O3 -DDARWIN -c -o hash.o hash.c  
gcc -Wall -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -g -O3 -DDARWIN -c -o chain.o chain.c  
gcc -Wall -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -g -O3 -DDARWIN -c -o shared_func.o shared_func.c  
gcc -Wall -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -g -O3 -DDARWIN -c -o ini_file_reader.o ini_file_reader.c  
gcc -Wall -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -g -O3 -DDARWIN -c -o logger.o logger.c  
gcc -Wall -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -g -O3 -DDARWIN -c -o sockopt.o sockopt.c  
gcc -Wall -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -g -O3 -DDARWIN -c -o base64.o base64.c  
gcc -Wall -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -g -O3 -DDARWIN -c -o sched_thread.o sched_thread.c  
gcc -Wall -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -g -O3 -DDARWIN -c -o http_func.o http_func.c  
gcc -Wall -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -g -O3 -DDARWIN -c -o md5.o md5.c  
gcc -Wall -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -g -O3 -DDARWIN -c -o pthread_func.o pthread_func.c  
gcc -Wall -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -g -O3 -DDARWIN -c -o local_ip_func.o local_ip_func.c  
...

(base) lvwei@lvweideMacBook-Pro libfastcommon-master % sudo ./make.sh install
Password:
mkdir -p /usr/local/lib
mkdir -p /usr/local/lib
mkdir -p /usr/local/include/fastcommon
install -m 755 libfastcommon.so /usr/local/lib
install -m 644 common_define.h hash.h chain.h logger.h base64.h shared_func.h pthread_func.h ini_file_reader.h _os_define.h sockopt.h sched_thread.h http_func.h md5.h local_ip_func.h avl_tree.h ioevent.h ioevent_loop.h fast_task_queue.h fast_timer.h locked_timer.h process_ctrl.h fast_mblock.h connection_pool.h fast_mpool.h fast_allocator.h fast_buffer.h skiplist.h multi_skiplist.h flat_skiplist.h skiplist_common.h system_info.h fast_blocked_queue.h php7_ext_wrapper.h id_generator.h char_converter.h char_convert_loader.h common_blocked_queue.h multi_socket_client.h skiplist_set.h uniq_skiplist.h fc_list.h locked_list.h json_parser.h buffered_file_writer.h server_id_func.h fc_queue.h sorted_queue.h fc_memory.h shared_buffer.h thread_pool.h fc_atomic.h array_allocator.h sorted_array.h /usr/local/include/fastcommon
(base) lvwei@lvweideMacBook-Pro libfastcommon-master % 

```

### 3.FastDFS安装

