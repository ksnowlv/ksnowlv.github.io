---
title: "Mac下使用Clion如何使用valgrind"
date: 2023-12-31T19:30:54+08:00
lastmod: 2023-12-31T19:30:54+08:00
keywords: ["Mac", "Clion", "linux", "valgrind"]
tags: ["Mac", "Clion", "linux", "valgrind"]
categories: ["Mac", "Clion", "linux", "valgrind"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Mac下使用Valgrind

### 1.Mac下Valgrind使用问题

Valgrind是一款用于内存调试、内存泄漏检测以及性能分析的软件开发工具。在linux系统上，如ubuntu，CentOS，Fedora都适用。但是在Mac上，并不兼容。在Windows上不可用，可以通过虚拟机，双系统等方式在linux下使用。那Mac下，如何使用该工具呢

### 2.解决方案

* 2.1 Docker通过Dockerfile制作包含Valgrind工具的linux镜像文件；
* 2.2 把测试的linux应用拷贝到linux镜像应用目录中；
* 2.3 通过docker启动容器使用Valgrind来检查应用的内存问题。

详细的dockerfile如下

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
    valgrind 

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

# 将你的程序复制到镜像应用目录中
COPY HelloWorld/cmake-build-debug-docker/HELLOWORLD /app/HelloWorld

# 设置工作目录
WORKDIR /app

# 设置容器的启动命令
CMD ["sh", "-c", "echo Hello, World!"]


```

关于sources.list可参考(https://ksnowlv.github.io/post/linux-ubuntu官方源无法访问问题)[https://ksnowlv.github.io/post/linux-ubuntu官方源无法访问问题]

### 4.镜像制作

使用

    docker build -t helloworld .
制作helloworld镜像，注意Dockerfile与sources.list在同一目录下。


```shell
lvwei@lvweideMacBook-Pro clion_cpp_demo % docker build -t helloworld .
[+] Building 4.4s (12/12) FINISHED                                                                            docker:desktop-linux
=> [internal] load .dockerignore                                                                                             0.0s
=> => transferring context: 2B                                                                                               0.0s
=> [internal] load build definition from Dockerfile                                                                          0.0s
=> => transferring dockerfile: 1.43kB                                                                                        0.0s
=> [internal] load metadata for docker.io/library/ubuntu:20.04                                                               4.3s
=> [1/7] FROM docker.io/library/ubuntu:20.04@sha256:f2034e7195f61334e6caff6ecf2e965f92d11e888309065da85ff50c617732b8         0.0s
=> [internal] load build context                                                                                             0.0s
=> => transferring context: 300B                                                                                             0.0s
=> CACHED [2/7] COPY sources.list /etc/apt/                                                                                  0.0s
=> CACHED [3/7] RUN apt-get update && apt-get install -y     build-essential     cmake     git     valgrind                  0.0s
=> CACHED [4/7] RUN apt-get install -y     libcurl4-gnutls-dev     rapidjson-dev                                             0.0s
=> CACHED [5/7] RUN cd /tmp     && git clone https://github.com/kuba--/zip.git     && cd zip     && mkdir build     && cd b  0.0s
=> [6/7] COPY HelloWorld/cmake-build-debug-docker/HELLOWORLD /app/HelloWorld                                                 0.0s
=> [7/7] WORKDIR /app                                                                                                        0.0s
=> exporting to image                                                                                                        0.0s
=> => exporting layers                                                                                                       0.0s
=> => writing image sha256:3e32e9c81893b4626a2525af368f863a95aab79f8595b95dd52898c97d610791                                  0.0s
=> => naming to docker.io/library/helloworld                                                                                 0.0s

What's Next?
View a summary of image vulnerabilities and recommendations → docker scout quickview
```

### 4.valgrind内存检查

使用命令

    docker run -it --rm helloworld valgrind --leak-check=full --show-leak-kinds=all /app/HelloWorld

检查/app/HelloWorld应用程序内存情况

其中参数说明如下

* --leak-check=yes 
  * 会告诉 Valgrind 进行内存泄漏检测，但它只会提供每个泄漏点的总体信息，例如泄漏的总字节数和泄漏的块数。
* --leak-check=full 
  * 则会提供更详细的信息。除了泄漏点的总体信息，它还会显示每个单独的泄漏块的信息，包括它的大小和分配它的函数的堆栈跟踪。这可以帮助你更准确地定位内存泄漏的位置。
* --show-leak-kinds=all 
  * 显示所有类型的内存泄漏，包括 "definitely lost"、"indirectly lost"、"possibly lost" 和 "still reachable"。
--num-callers=n 
  * 增加调用堆栈的深度。


```shell
lvwei@lvweideMacBook-Pro clion_cpp_demo % docker run -it --rm helloworld valgrind --leak-check=full --show-leak-kinds=all /app/HelloWorld
==1== Memcheck, a memory error detector
==1== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
==1== Using Valgrind-3.18.1 and LibVEX; rerun with -h for copyright info
==1== Command: /app/HelloWorld
==1== 
Hello world!
---Test
name:ksnowlv,age:20
unique_ptr age:1,name:ksnow:0
unique_ptr age:2,name:ksnow:1
unique_ptr age:3,name:ksnow:2
unique_ptr age:4,name:ksnow:3
unique_ptr age:5,name:ksnow:4
unique_ptr age:6,name:ksnow:5
unique_ptr age:7,name:ksnow:6
unique_ptr age:8,name:ksnow:7
unique_ptr age:9,name:ksnow:8
unique_ptr age:10,name:ksnow:9
sharedPersons age:1,name:ksnow:0
sharedPersons age:2,name:ksnow:1
sharedPersons age:3,name:ksnow:2
sharedPersons age:4,name:ksnow:3
sharedPersons age:5,name:ksnow:4
sharedPersons age:6,name:ksnow:5
sharedPersons age:7,name:ksnow:6
sharedPersons age:8,name:ksnow:7
sharedPersons age:9,name:ksnow:8
sharedPersons age:10,name:ksnow:9
1 p1 use_count:1,age:10
2 p1 use_count:2
3 p1 use_count:3
4 p1 use_count:2
thread name:t1,g_total=50005000
thread name:t3,g_total=100010000
thread name:t2,g_total=150015000
g_total=150015000
SetAtomicFlag
SetAtomicFlag
SetAtomicFlag
SetAtomicFlag
SetAtomicFlag
SetAtomicFlag
SetAtomicFlag
SetAtomicFlag
SetAtomicFlag
SetAtomicFlag
SetAtomicFlag
func1 do somethings!
clearAtomicFlag 
SharedMemoryTest
----pid:12
parent process pid:1,key=10879429,shmid:0
read buf:
child process pid:12,parent process pid:1,key=10879429,shmid:0
write buf:Hello world!
------Test------
顺序遍历
0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,
反序遍历
19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,
删除3 或 5之间
0,
1,
2,
4,
6,
7,
8,
9,
10,
11,
12,
13,
14,
15,
16,
17,
18,
19,

删除5或 11位置之间
0,
1,
2,
4,
6,
13,
14,
15,
16,
17,
18,
19,

-----TestAsync---
-----ShowMyInfomationmessage:1+2:
---ProcessBigDataTest threadID:102195456
数据处理超时，继续处理中thread_id:67316064
数据处理超时，继续处理中thread_id:67316064
数据处理超时，继续处理中thread_id:67316064
数据处理超时，继续处理中thread_id:67316064
数据处理完成thread_id:67316064
3
-----TestPackagedTask---
-----ShowMyInfomationmessage:
---ProcessBigDataTest threadID:67316064
task result:3
task result:---ProcessBigDataTest threadID:102195456
5
newTask result:9
-----TestPromise---
set my value:ksnow!!!
threadid:2,count:1
threadid:2,count:2
threadid:2,count:3
threadid:2,count:4
threadid:2,count:5
threadid:1,count:6
threadid:1,count:7
threadid:1,count:8
threadid:1,count:9
threadid:1,count:10
TestRecursiveMutex:1
TestRecursiveMutex:1,2
threadid:2,lock success
threadid:3,lock fail
threadid:3,lock success
threadid:1,lock fail
threadid:2,lock fail
threadid:1,lock success
threadid:2,lock fail
threadid:3,lock success
threadid:1,lock success
threadid:2,lock fail
threadid:3,lock success
threadid:1,lock fail
threadid:2,lock success
threadid:3,lock success
threadid:1,lock fail
lock success
TestLockGuard:锁被占用!!!
mutex超过作用域名后
TestLockGuard:锁成功!!!
Parent process: wrote data to shared_data =1234
Child process: shared_data =1234Child process: shared_data2 =5678*****
~AtomicTest
*****
*****
*****
*****
*****
*****
==21== 
==21== HEAP SUMMARY:
==21==     in use at exit: 0 bytes in 0 blocks
==21==   total heap usage: 52 allocs, 52 frees, 77,722 bytes allocated
==21== 
==21== All heap blocks were freed -- no leaks are possible
==21== 
==21== For lists of detected and suppressed errors, rerun with: -s
==21== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
Parent process: 21
*****
~AtomicTest
*****
*****
*****
*****
*****
*****
# 内存检查结果
==12== 
==12== HEAP SUMMARY:
==12==     in use at exit: 0 bytes in 0 blocks
==12==   total heap usage: 52 allocs, 52 frees, 77,722 bytes allocated
==12== 
==12== All heap blocks were freed -- no leaks are possible
==12== 
==12== For lists of detected and suppressed errors, rerun with: -s
==12== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
lvwei@lvweideMacBook-Pro clion_cpp_demo %
```

检查程序并无泄漏，内存越界，异常等，那制造点内存问题

如main.cpp中添加13，15行两行代码
```c++
using namespace std;

int main(int argc, char *argv[])
{
    std::cout << "Hello world!" << std::endl;
    unique_ptr<TestCase> tc(make_unique<TestCase>());
    tc->TestMyCase();

    int * p = new int[100];//13行

    p[100] = 3;////15行
}
```

重新打包并使用valgrind进行内存检查

```shell

lvwei@lvweideMacBook-Pro clion_cpp_demo % docker run -it --rm helloworld valgrind --leak-check=full --show-leak-kinds=all /app/HelloWorld
==1== Memcheck, a memory error detector
==1== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
==1== Using Valgrind-3.18.1 and LibVEX; rerun with -h for copyright info
==1== Command: /app/HelloWorld
==1== 
Hello world!
---Test
name:ksnowlv,age:20
unique_ptr age:1,name:ksnow:0
unique_ptr age:2,name:ksnow:1
unique_ptr age:3,name:ksnow:2
unique_ptr age:4,name:ksnow:3
unique_ptr age:5,name:ksnow:4
unique_ptr age:6,name:ksnow:5
unique_ptr age:7,name:ksnow:6
unique_ptr age:8,name:ksnow:7
unique_ptr age:9,name:ksnow:8
unique_ptr age:10,name:ksnow:9
sharedPersons age:1,name:ksnow:0
sharedPersons age:2,name:ksnow:1
sharedPersons age:3,name:ksnow:2
sharedPersons age:4,name:ksnow:3
sharedPersons age:5,name:ksnow:4
sharedPersons age:6,name:ksnow:5
sharedPersons age:7,name:ksnow:6
sharedPersons age:8,name:ksnow:7
sharedPersons age:9,name:ksnow:8
sharedPersons age:10,name:ksnow:9
1 p1 use_count:1,age:10
2 p1 use_count:2
3 p1 use_count:3
4 p1 use_count:2
thread name:t1,g_total=50005000
thread name:t3,g_total=100010000
thread name:t2,g_total=150015000
g_total=150015000
SetAtomicFlag
func1 do somethings!
clearAtomicFlag 
SharedMemoryTest
----pid:12
parent process pid:1,key=5046755,shmid:0
read buf:
child process pid:12,parent process pid:1,key=5046755,shmid:0
write buf:Hello world!
------Test------
顺序遍历
0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,
反序遍历
19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,
删除3 或 5之间
0,
1,
2,
4,
6,
7,
8,
9,
10,
11,
12,
13,
14,
15,
16,
17,
18,
19,

删除5或 11位置之间
0,
1,
2,
4,
6,
13,
14,
15,
16,
17,
18,
19,

-----TestAsync---
-----ShowMyInfomationmessage:1+2:
---ProcessBigDataTest threadID:102195456
数据处理超时，继续处理中thread_id:67316064
数据处理超时，继续处理中thread_id:67316064
数据处理超时，继续处理中thread_id:67316064
数据处理超时，继续处理中thread_id:67316064
数据处理完成thread_id:67316064
3
-----TestPackagedTask---
-----ShowMyInfomationmessage:
---ProcessBigDataTest threadID:67316064
task result:3
task result:---ProcessBigDataTest threadID:102195456
5
newTask result:9
-----TestPromise---
set my value:ksnow!!!
threadid:1,count:1
threadid:1,count:2
threadid:1,count:3
threadid:1,count:4
threadid:1,count:5
threadid:2,count:6
threadid:2,count:7
threadid:2,count:8
threadid:2,count:9
threadid:2,count:10
TestRecursiveMutex:1
TestRecursiveMutex:1,2
threadid:2,lock success
threadid:3,lock fail
threadid:1,lock fail
threadid:1,lock success
threadid:3,lock fail
threadid:2,lock fail
threadid:3,lock success
threadid:1,lock fail
threadid:2,lock fail
threadid:1,lock success
threadid:2,lock fail
threadid:3,lock fail
threadid:2,lock success
threadid:1,lock success
threadid:3,lock fail
lock success
TestLockGuard:锁被占用!!!
mutex超过作用域名后
TestLockGuard:锁成功!!!
Parent process: wrote data to shared_data =1234
Child process: shared_data =1234
Child process: shared_data2 =5678
==21== Invalid write of size 4
==21==    at 0x15648C: main (main.cpp:15)
==21==  Address 0x4d6af20 is 0 bytes after a block of size 400 alloc'd
==21==    at 0x4866AE8: operator new[](unsigned long) (in /usr/libexec/valgrind/vgpreload_memcheck-arm64-linux.so)
==21==    by 0x15647B: main (main.cpp:13)
==21== 
*****
~AtomicTest
*****
*****
*****
*****
*****
*****
==21== 
==21== HEAP SUMMARY:
==21==     in use at exit: 400 bytes in 1 blocks
==21==   total heap usage: 53 allocs, 52 frees, 78,122 bytes allocated
==21== 
==21== 400 bytes in 1 blocks are definitely lost in loss record 1 of 1
==21==    at 0x4866AE8: operator new[](unsigned long) (in /usr/libexec/valgrind/vgpreload_memcheck-arm64-linux.so)
==21==    by 0x15647B: main (main.cpp:13)
==21== 
==21== LEAK SUMMARY:
==21==    definitely lost: 400 bytes in 1 blocks
==21==    indirectly lost: 0 bytes in 0 blocks
==21==      possibly lost: 0 bytes in 0 blocks
==21==    still reachable: 0 bytes in 0 blocks
==21==         suppressed: 0 bytes in 0 blocks
==21== 
==21== For lists of detected and suppressed errors, rerun with: -s
==21== ERROR SUMMARY: 2 errors from 2 contexts (suppressed: 0 from 0)
Parent process: 21
==12== Invalid write of size 4
==12==    at 0x15648C: main (main.cpp:15)
==12==  Address 0x4d6af20 is 0 bytes after a block of size 400 alloc'd
==12==    at 0x4866AE8: operator new[](unsigned long) (in /usr/libexec/valgrind/vgpreload_memcheck-arm64-linux.so)
==12==    by 0x15647B: main (main.cpp:13)
==12== 
*****
~AtomicTest
*****
*****
*****
*****
*****
*****
==12== 
==12== HEAP SUMMARY:
==12==     in use at exit: 400 bytes in 1 blocks
==12==   total heap usage: 53 allocs, 52 frees, 78,122 bytes allocated
==12== 
==12== 400 bytes in 1 blocks are definitely lost in loss record 1 of 1
==12==    at 0x4866AE8: operator new[](unsigned long) (in /usr/libexec/valgrind/vgpreload_memcheck-arm64-linux.so)
==12==    by 0x15647B: main (main.cpp:13)
==12== 
==12== LEAK SUMMARY:
==12==    definitely lost: 400 bytes in 1 blocks
==12==    indirectly lost: 0 bytes in 0 blocks
==12==      possibly lost: 0 bytes in 0 blocks
==12==    still reachable: 0 bytes in 0 blocks
==12==         suppressed: 0 bytes in 0 blocks
==12== 
==12== For lists of detected and suppressed errors, rerun with: -s
==12== ERROR SUMMARY: 2 errors from 2 contexts (suppressed: 0 from 0)
12
------Test------
顺序遍历
0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,
反序遍历
19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,
删除3 或 5之间
0,
1,
2,
4,
6,
7,
8,
9,
10,
11,
12,
13,
14,
15,
16,
17,
18,
19,

删除5或 11位置之间
0,
1,
2,
4,
6,
13,
14,
15,
16,
17,
18,
19,

-----TestAsync---
-----ShowMyInfomationmessage:1+2:
---ProcessBigDataTest threadID:102195456
数据处理超时，继续处理中thread_id:67316064
数据处理超时，继续处理中thread_id:67316064
数据处理超时，继续处理中thread_id:67316064
数据处理超时，继续处理中thread_id:67316064
数据处理完成thread_id:67316064
3
-----TestPackagedTask---
-----ShowMyInfomationmessage:
---ProcessBigDataTest threadID:67316064
task result:3
task result:---ProcessBigDataTest threadID:102195456
5
newTask result:9
-----TestPromise---
set my value:ksnow!!!
threadid:2,count:1
threadid:2,count:2
threadid:2,count:3
threadid:2,count:4
threadid:2,count:5
threadid:1,count:6
threadid:1,count:7
threadid:1,count:8
threadid:1,count:9
threadid:1,count:10
TestRecursiveMutex:1
TestRecursiveMutex:1,2
threadid:1,lock success
threadid:2,lock fail
threadid:2,lock success
threadid:3,lock fail
threadid:1,lock fail
threadid:3,lock success
threadid:1,lock success
threadid:2,lock fail
threadid:3,lock fail
threadid:2,lock success
threadid:1,lock success
threadid:3,lock fail
threadid:2,lock success
threadid:3,lock fail
threadid:1,lock fail
lock success
TestLockGuard:锁被占用!!!
mutex超过作用域名后
TestLockGuard:锁成功!!!
Parent process: wrote data to shared_data =1234
Child process: shared_data =1234
Child process: shared_data2 =5678
==30== Invalid write of size 4
==30==    at 0x15648C: main (main.cpp:15)
==30==  Address 0x4d6af20 is 0 bytes after a block of size 400 alloc'd
==30==    at 0x4866AE8: operator new[](unsigned long) (in /usr/libexec/valgrind/vgpreload_memcheck-arm64-linux.so)
==30==    by 0x15647B: main (main.cpp:13)
==30== 
*****
~AtomicTest
*****
*****
*****
*****
*****
*****
==30== 
==30== HEAP SUMMARY:
==30==     in use at exit: 400 bytes in 1 blocks
==30==   total heap usage: 53 allocs, 52 frees, 78,122 bytes allocated
==30== 
==30== 400 bytes in 1 blocks are definitely lost in loss record 1 of 1
==30==    at 0x4866AE8: operator new[](unsigned long) (in /usr/libexec/valgrind/vgpreload_memcheck-arm64-linux.so)
==30==    by 0x15647B: main (main.cpp:13)
==30== 
==30== LEAK SUMMARY:
==30==    definitely lost: 400 bytes in 1 blocks
==30==    indirectly lost: 0 bytes in 0 blocks
==30==      possibly lost: 0 bytes in 0 blocks
==30==    still reachable: 0 bytes in 0 blocks
==30==         suppressed: 0 bytes in 0 blocks
==30== 
==30== For lists of detected and suppressed errors, rerun with: -s
==30== ERROR SUMMARY: 2 errors from 2 contexts (suppressed: 0 from 0)
Parent process: 30
==1== Invalid write of size 4
==1==    at 0x15648C: main (main.cpp:15)
==1==  Address 0x4d6af20 is 0 bytes after a block of size 400 alloc'd
==1==    at 0x4866AE8: operator new[](unsigned long) (in /usr/libexec/valgrind/vgpreload_memcheck-arm64-linux.so)
==1==    by 0x15647B: main (main.cpp:13)
==1== 
*****
~AtomicTest
*****
*****
*****
*****
*****
*****
==1== 
==1== HEAP SUMMARY:
==1==     in use at exit: 400 bytes in 1 blocks
==1==   total heap usage: 53 allocs, 52 frees, 78,122 bytes allocated
==1== 
==1== 400 bytes in 1 blocks are definitely lost in loss record 1 of 1
==1==    at 0x4866AE8: operator new[](unsigned long) (in /usr/libexec/valgrind/vgpreload_memcheck-arm64-linux.so)
==1==    by 0x15647B: main (main.cpp:13)
==1== 
==1== LEAK SUMMARY:
==1==    definitely lost: 400 bytes in 1 blocks
==1==    indirectly lost: 0 bytes in 0 blocks
==1==      possibly lost: 0 bytes in 0 blocks
==1==    still reachable: 0 bytes in 0 blocks
==1==         suppressed: 0 bytes in 0 blocks
==1== 
==1== For lists of detected and suppressed errors, rerun with: -s
==1== ERROR SUMMARY: 2 errors from 2 contexts (suppressed: 0 from 0)
lvwei@lvweideMacBook-Pro clion_cpp_demo % 


```
上述检查结果直接显示

```shell

==30== Invalid write of size 4
==30==    at 0x15648C: main (main.cpp:15)
==30==  Address 0x4d6af20 is 0 bytes after a block of size 400 alloc'd
==30==    at 0x4866AE8: operator new[](unsigned long) (in /usr/libexec/valgrind/vgpreload_memcheck-arm64-linux.so)
==30==    by 0x15647B: main (main.cpp:13)
```

* Invalid write of size 4，内存越界，在main.cpp:15
* Address 0x4d6af20 is 0 bytes after a block of size 400 alloc'd，内存泄漏，在main.cpp:13

### 5. Callgrind 性能分析

虽然 Callgrind 主要用于性能分析，但它也可以显示每个函数的内存使用情况。你可以使用 Callgrind 来看哪个函数分配了最多的内存

valgrind --tool=callgrind your_program [your_program_arguments]


* --dump-instr=yes：这个选项让 Callgrind 收集每个指令的信息，而不仅仅是每个函数的信息。这可以让你更详细地了解你的程序的行为，但也会使 Callgrind 运行得更慢，并生成更大的输出文件。
* --collect-jumps=yes：这个选项让 Callgrind 收集程序中的跳转信息。这可以帮助你了解你的程序的控制流，但也会使 Callgrind 运行得更慢，并生成更大的输出文件。
* --branch-sim=yes：这个选项让 Callgrind 模拟程序的分支预测。这可以帮助你了解你的程序的分支预测效率，但也会使 Callgrind 运行得更慢


```shell
lvwei@lvweideMacBook-Pro clion_cpp_demo % docker start mytest                                            
mytest
lvwei@lvweideMacBook-Pro clion_cpp_demo % docker exec -it mytest valgrind --tool=callgrind /app/HelloWorld
==14== Callgrind, a call-graph generating cache profiler
==14== Copyright (C) 2002-2017, and GNU GPL'd, by Josef Weidendorfer et al.
==14== Using Valgrind-3.18.1 and LibVEX; rerun with -h for copyright info
==14== Command: /app/HelloWorld
==14== 
==14== For interactive control, run 'callgrind_control -h'.
Hello world!
---Test
name:ksnowlv,age:20
unique_ptr age:1,name:ksnow:0
unique_ptr age:2,name:ksnow:1
unique_ptr age:3,name:ksnow:2
unique_ptr age:4,name:ksnow:3
unique_ptr age:5,name:ksnow:4
unique_ptr age:6,name:ksnow:5

```

在容器/app/目录下（与HelloWorld同目录），生成callgrind.out文件。

![image](/images/post/Mac下使用Clion如何使用valgrind/callgrind.out.png)


### 6.callgrind.out文件查看器kcachegrind和qcachegrind

kcachegrind和qcachegrind 是两个用于可视化性能分析数据的工具，它们可以读取由Valgrind的Callgrind工具生成的输出，并生成详细的调用图。

KCacheGrind为Linux平台设计的，MacOS下，QCacheGrind是KCacheGrind的MacOS 版本，可以直接在MacOS上运行并分析Callgrind数据

使用

    arch -arm64 brew install qcachegrind

安装qcachegrind

```shell
lvwei@lvweideMacBook-Pro clion_cpp_demo % arch -arm64 brew install qcachegrind
Running `brew update --auto-update`...
Error: Failed to download https://formulae.brew.sh/api/formula.jws.json!
Failed to download https://formulae.brew.sh/api/formula_tap_migrations.jws.json!
==> Downloading https://formulae.brew.sh/api/formula.jws.json
############################################################################################################################ 100.0%
==> Auto-updated Homebrew!
Updated 2 taps (homebrew/core and homebrew/cask).
==> New Formulae
cargo-llvm-cov                   hopscotch-map                    pivit                            wasmedge
halp                             netsurf-buildsystem              sugarjar
==> New Casks
lightburn                                   opencat                                     openthesaurus-deutsch

You have 40 outdated formulae and 1 outdated cask installed.

==> Downloading https://formulae.brew.sh/api/cask.jws.json
############################################################################################################################ 100.0%
Warning: You are using macOS 14.
We do not provide support for this pre-release version.
It is expected behaviour that some formulae will fail to build in this pre-release version.
It is expected behaviour that Homebrew will be buggy and slow.
Do not create any issues about this on Homebrew's GitHub repositories.
Do not create any issues even if you think this message is unrelated.
Any opened issues will be immediately closed without response.
Do not ask for help from Homebrew or its maintainers on social media.
You may ask for help in Homebrew's discussions but are unlikely to receive a response.
Try to figure out the problem yourself and submit a fix as a pull request.
We will review it but may or may not accept it.

==> Fetching dependencies for qcachegrind: qt@5, fontconfig, jpeg-xl, aom, libavif, gd, jasper, netpbm, gts, gdk-pixbuf, librsvg and graphviz
==> Fetching qt@5
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/qt%405-5.15.11.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching fontconfig
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/fontconfig-2.15.0.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching jpeg-xl
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/jpeg-xl-0.9.0.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching aom
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/aom-3.8.0_1.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching libavif
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/libavif-1.0.3.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching gd
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/gd-2.3.3_6.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching jasper
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/jasper-4.1.1.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching netpbm
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/netpbm-11.02.07.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching gts
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/gts-0.7.6_3.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching gdk-pixbuf
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/gdk-pixbuf-2.42.10_1.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching librsvg
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/librsvg-2.57.1.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching graphviz
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/graphviz-9.0.0.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching qcachegrind
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/qcachegrind-23.08.4.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Installing dependencies for qcachegrind: qt@5, fontconfig, jpeg-xl, aom, libavif, gd, jasper, netpbm, gts, gdk-pixbuf, librsvg and graphviz
==> Installing qcachegrind dependency: qt@5
==> Pouring qt@5-5.15.11.arm64_sonoma.bottle.tar.gz
🍺  /opt/homebrew/Cellar/qt@5/5.15.11: 10,848 files, 341.8MB
==> Installing qcachegrind dependency: fontconfig
==> Pouring fontconfig-2.15.0.arm64_sonoma.bottle.tar.gz
==> Regenerating font cache, this may take a while
==> /opt/homebrew/Cellar/fontconfig/2.15.0/bin/fc-cache -frv
🍺  /opt/homebrew/Cellar/fontconfig/2.15.0: 90 files, 2.4MB
==> Installing qcachegrind dependency: jpeg-xl
==> Pouring jpeg-xl-0.9.0.arm64_sonoma.bottle.tar.gz
🍺  /opt/homebrew/Cellar/jpeg-xl/0.9.0: 45 files, 5.1MB
==> Installing qcachegrind dependency: aom
==> Pouring aom-3.8.0_1.arm64_sonoma.bottle.tar.gz
🍺  /opt/homebrew/Cellar/aom/3.8.0_1: 23 files, 9.9MB
==> Installing qcachegrind dependency: libavif
==> Pouring libavif-1.0.3.arm64_sonoma.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libavif/1.0.3: 19 files, 536.6KB
==> Installing qcachegrind dependency: gd
==> Pouring gd-2.3.3_6.arm64_sonoma.bottle.tar.gz
🍺  /opt/homebrew/Cellar/gd/2.3.3_6: 33 files, 1.5MB
==> Installing qcachegrind dependency: jasper
==> Pouring jasper-4.1.1.arm64_sonoma.bottle.tar.gz
🍺  /opt/homebrew/Cellar/jasper/4.1.1: 44 files, 1.6MB
==> Installing qcachegrind dependency: netpbm
==> Pouring netpbm-11.02.07.arm64_sonoma.bottle.tar.gz
🍺  /opt/homebrew/Cellar/netpbm/11.02.07: 416 files, 18.7MB
==> Installing qcachegrind dependency: gts
==> Pouring gts-0.7.6_3.arm64_sonoma.bottle.tar.gz
🍺  /opt/homebrew/Cellar/gts/0.7.6_3: 26 files, 1.6MB
==> Installing qcachegrind dependency: gdk-pixbuf
==> Pouring gdk-pixbuf-2.42.10_1.arm64_sonoma.bottle.tar.gz
==> /opt/homebrew/Cellar/gdk-pixbuf/2.42.10_1/bin/gdk-pixbuf-query-loaders --update-cache
🍺  /opt/homebrew/Cellar/gdk-pixbuf/2.42.10_1: 150 files, 4MB
==> Installing qcachegrind dependency: librsvg
==> Pouring librsvg-2.57.1.arm64_sonoma.bottle.tar.gz
==> /opt/homebrew/opt/gdk-pixbuf/bin/gdk-pixbuf-query-loaders --update-cache
🍺  /opt/homebrew/Cellar/librsvg/2.57.1: 22 files, 44MB
==> Installing qcachegrind dependency: graphviz
==> Pouring graphviz-9.0.0.arm64_sonoma.bottle.tar.gz
🍺  /opt/homebrew/Cellar/graphviz/9.0.0: 287 files, 7.1MB
==> Installing qcachegrind
==> Pouring qcachegrind-23.08.4.arm64_sonoma.bottle.tar.gz
🍺  /opt/homebrew/Cellar/qcachegrind/23.08.4: 13 files, 1.5MB
==> Running `brew cleanup qcachegrind`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
==> Upgrading 1 dependent of upgraded formulae:
Disable this behaviour by setting HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
ffmpeg 6.0_1 -> 6.1.1
==> Fetching dependencies for ffmpeg: dav1d, frei0r, ca-certificates, cjson, libmicrohttpd, mbedtls, librist, libvpx, mpg123, sdl2, srt, svt-av1, leptonica, x264, libsodium and zeromq
==> Fetching dav1d
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/dav1d-1.3.0.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching frei0r
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/frei0r-2.3.2.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching ca-certificates
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/ca-certificates-2023-12-12.all.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching cjson
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/cjson-1.7.17.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching libmicrohttpd
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/libmicrohttpd-0.9.77.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching mbedtls
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/mbedtls-3.5.1.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching librist
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/librist-0.2.10.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching libvpx
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/libvpx-1.13.1.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching mpg123
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/mpg123-1.32.3.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching sdl2
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/sdl2-2.28.5.arm64_sonoma.bottle.1.tar.gz
############################################################################################################################ 100.0%
==> Fetching srt
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/srt-1.5.3.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching svt-av1
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/svt-av1-1.8.0.arm64_sonoma.bottle.1.tar.gz
############################################################################################################################ 100.0%
==> Fetching leptonica
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/leptonica-1.84.0.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching x264
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/x264-r3108.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching libsodium
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/libsodium-1.0.19.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching zeromq
==> Downloading https://mirrors.ustc.edu.cn/homebrew-bottles/zeromq-4.3.5_1.arm64_sonoma.bottle.tar.gz
############################################################################################################################ 100.0%
==> Fetching ffmpeg
Warning: Bottle missing, falling back to the default domain...
==> Downloading https://ghcr.io/v2/homebrew/core/ffmpeg/manifests/6.1.1
############################################################################################################################ 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/ffmpeg/blobs/sha256:b5153b06d18a6748e2333b0a1446704d31be752450f4d9ffbab41e880ff8df
##########################################################################################                                    73.2%curl: (92) HTTP/2 stream 1 was not closed cleanly: PROTOCOL_ERROR (err 1)

Error: ffmpeg: Failed to download resource "ffmpeg"
Download failed: https://ghcr.io/v2/homebrew/core/ffmpeg/blobs/sha256:b5153b06d18a6748e2333b0a1446704d31be752450f4d9ffbab41e880ff8df02
==> Checking for dependents of upgraded formulae...
==> No broken dependents to reinstall!
==> `brew cleanup` has not been run in the last 30 days, running now...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
Removing: /opt/homebrew/Cellar/aom/3.7.1... (23 files, 9.0MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/aom--3.7.1.arm64_sonoma.bottle.tar.gz... (3.6MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/aribb24--1.0.4... (71.0KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/c-ares--1.22.1.arm64_sonoma.bottle.tar.gz... (203.7KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/ca-certificates--2023-08-22... (125.2KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/chruby--0.3.9... (18.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/cjson--1.7.16... (56KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/dav1d--1.2.1... (353.1KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/ffmpeg--6.0_1... (19MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/flac--1.4.3... (1.1MB)
Removing: /opt/homebrew/Cellar/fontconfig/2.14.2... (88 files, 2.4MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/fontconfig--2.14.2... (627.6KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/freetype--2.13.2... (929.3KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/frei0r--2.3.1... (632.2KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/fribidi--1.0.13... (139.7KB)
Removing: /opt/homebrew/Cellar/gettext/0.22.3... (2,040 files, 22.0MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/gettext--0.22.3.arm64_sonoma.bottle.tar.gz... (9.1MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/giflib--5.2.1... (147.8KB)
Removing: /opt/homebrew/Cellar/gmp/6.2.1_1... (21 files, 3.2MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/graphite2--1.3.14... (89.6KB)
Removing: /opt/homebrew/Cellar/harfbuzz/8.2.1... (76 files, 9.2MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/icu4c--73.2... (29.3MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/imath--3.1.9... (183.7KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/jpeg-turbo--3.0.0... (1.1MB)
Removing: /opt/homebrew/Cellar/jpeg-xl/0.8.2_1... (43 files, 10.8MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/jpeg-xl--0.8.2... (4.2MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/jpeg-xl--0.8.2_1.arm64_ventura.bottle.1.tar.gz... (4.2MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/lame--3.100... (780.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/leptonica--1.83.1... (2.5MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libass--0.17.1... (212.6KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libb2--0.98.1... (30.3KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libbluray--1.3.4... (357.3KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libevent--2.1.12_1... (701.8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libidn2--2.3.4_1... (324.2KB)
Removing: /opt/homebrew/Cellar/libnghttp2/1.55.1... (13 files, 728.3KB)
Removing: /opt/homebrew/Cellar/libnghttp2/1.56.0... (13 files, 734.0KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libogg--1.3.5... (228.2KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libpng--1.6.40... (447.9KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/librist--0.2.7_3... (203.4KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libsamplerate--0.2.2... (2.6MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libsndfile--1.2.2... (348.8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libsoxr--0.1.3... (89.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libtasn1--4.19.0... (168KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libunibreak--5.1... (61.8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libunistring--1.1... (1.6MB)
Removing: /opt/homebrew/Cellar/libuv/1.46.0... (47 files, 3MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libvidstab--1.1.1... (46.0KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libvmaf--2.3.1... (1MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libvorbis--1.3.7... (576.8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libxau--1.0.11... (30KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libxdmcp--1.1.4... (34.9KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libxext--1.3.5... (104.4KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libxrender--0.9.11... (51.8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libyaml--0.2.5... (107.8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/little-cms2--2.15... (412KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/lz4--1.9.4... (251.0KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/lzo--2.10... (145.2KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/minio--RELEASE.2023-11-20T22-40-07Z.2023-11-20T22-40-07Z... (97.4MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/mongodb-database-tools--100.9.1.zip... (58.4MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/mongosh--2.0.2.arm64_sonoma.bottle.tar.gz... (11.2MB)
Removing: /opt/homebrew/Cellar/mujs/1.3.3... (11 files, 1.2MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/mujs--1.3.3.arm64_sonoma.bottle.1.tar.gz... (435.9KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/mysql--8.1.0.arm64_sonoma.bottle.tar.gz... (81.5MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/nettle--3.9.1... (957.9KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/node--21.2.0.arm64_sonoma.bottle.tar.gz... (15.3MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/opencore-amr--0.1.6... (296.7KB)
Removing: /opt/homebrew/Cellar/openexr/3.1.11... (194 files, 7.7MB)
Removing: /opt/homebrew/Cellar/openexr/3.2.0... (204 files, 7.8MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/openjpeg--2.5.0_1... (2MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/openldap--2.6.6.arm64_sonoma.bottle.tar.gz... (2.5MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/opus--1.4... (446.5KB)
Removing: /opt/homebrew/Cellar/p11-kit/0.25.0... (67 files, 4.8MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/pango--1.50.14... (802.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/pcre2--10.42... (2.0MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/pixman--0.42.2... (368.6KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/protobuf@21--21.12.arm64_sonoma.bottle.1.tar.gz... (5.2MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/python-tk@3.9--3.9.18.arm64_ventura.bottle.tar.gz... (33.2KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/python@3.9--3.9.18.arm64_ventura.bottle.tar.gz... (14MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/rav1e--0.6.6... (45.3MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/rbenv--1.2.0.arm64_ventura.bottle.tar.gz... (20.8KB)
Removing: /opt/homebrew/Cellar/readline/8.2.1... (50 files, 1.7MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/readline--8.2.1.arm64_ventura.bottle.tar.gz... (573.8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/rubberband--3.3.0... (559KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/ruby--3.2.2_1... (12.9MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/ruby-install--0.9.2.all.bottle.tar.gz... (25.4KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/snappy--1.1.10... (42.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/speex--1.2.1... (537.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/sqlite--3.44.0.arm64_sonoma.bottle.tar.gz... (2.2MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/svt-av1--1.7.0... (1.4MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/tcl-tk--8.6.13_4.arm64_ventura.bottle.tar.gz... (8.4MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/theora--1.1.1... (682.3KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/x265--3.5... (2.6MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/xorgproto--2023.2... (696KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/xvid--1.3.7... (445.2KB)
Removing: /opt/homebrew/Cellar/xz/5.4.4... (163 files, 2.6MB)
Removing: /Users/lvwei/Library/Caches/Homebrew/zimg--3.0.5... (338.7KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/zstd--1.5.5... (742.6KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/ruby_bottle_manifest--3.2.2_1... (13.6KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/cairo_bottle_manifest--1.16.0_5... (27.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/cjson_bottle_manifest--1.7.16-1... (9KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/mpg123_bottle_manifest--1.31.3... (7.6KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/lz4_bottle_manifest--1.9.4... (8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/brotli_bottle_manifest--1.0.9... (10.4KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/aribb24_bottle_manifest--1.0.4... (8.8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/graphite2_bottle_manifest--1.3.14... (9.1KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/gettext_bottle_manifest--0.21.1... (10.8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libtiff_bottle_manifest--4.5.1... (9.8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/openjpeg_bottle_manifest--2.5.0_1... (11.6KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libx11_bottle_manifest--1.8.6... (13.9KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/icu4c_bottle_manifest--73.2... (8.4KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/speex_bottle_manifest--1.2.1... (8.6KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libbluray_bottle_manifest--1.3.4... (10.7KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libarchive_bottle_manifest--3.7.1... (9.7KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/ca-certificates_bottle_manifest--2023-08-22... (7.3KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/x264_bottle_manifest--r3095-1... (8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libtasn1_bottle_manifest--4.19.0... (8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/dav1d_bottle_manifest--1.2.1... (7.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/hugo_bottle_manifest--0.117.0... (7.3KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/openssl@3_bottle_manifest--3.1.2-1... (8.8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/lame_bottle_manifest--3.100... (10.6KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libxext_bottle_manifest--1.3.5... (12.4KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libogg_bottle_manifest--1.3.5-2... (7.4KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/sdl2_bottle_manifest--2.28.2... (11.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/imath_bottle_manifest--3.1.9... (7.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/rav1e_bottle_manifest--0.6.6... (7.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/snappy_bottle_manifest--1.1.10... (7KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/pcre2_bottle_manifest--10.42... (8.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/nginx_bottle_manifest--1.25.2... (9.6KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/x265_bottle_manifest--3.5-1... (8.9KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libxau_bottle_manifest--1.0.11... (7.7KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/librist_bottle_manifest--0.2.7_3... (8.2KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libxcb_bottle_manifest--1.15_1... (14.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/ffmpeg_bottle_manifest--6.0_1... (58.8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/aom_bottle_manifest--3.6.1... (14.3KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/unbound_bottle_manifest--1.17.1_1... (12.2KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libb2_bottle_manifest--0.98.1... (10.0KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libvmaf_bottle_manifest--2.3.1-1... (7.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libyaml_bottle_manifest--0.2.5... (9.2KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/xvid_bottle_manifest--1.3.7... (9.0KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/flac_bottle_manifest--1.4.3... (8.3KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/giflib_bottle_manifest--5.2.1... (8.9KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/srt_bottle_manifest--1.5.2... (8.8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/zimg_bottle_manifest--3.0.5... (7.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libass_bottle_manifest--0.17.1... (19.9KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/rubberband_bottle_manifest--3.3.0... (13.4KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libxrender_bottle_manifest--0.9.11... (11.0KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/ruby-install_bottle_manifest--0.9.1... (2KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libsamplerate_bottle_manifest--0.2.2... (7.3KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/xorgproto_bottle_manifest--2023.2... (14.2KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/pixman_bottle_manifest--0.42.2-1... (7.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/tesseract_bottle_manifest--5.3.2_1... (26.6KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/webp_bottle_manifest--1.3.1... (12.2KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/harfbuzz_bottle_manifest--8.1.1... (19.9KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libxdmcp_bottle_manifest--1.1.4... (7.7KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/chruby_bottle_manifest--0.3.9-1... (1.7KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libsoxr_bottle_manifest--0.1.3-1... (9.8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libvidstab_bottle_manifest--1.1.1... (7.2KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/little-cms2_bottle_manifest--2.15... (10.1KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libvpx_bottle_manifest--1.13.0... (7KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/opus_bottle_manifest--1.4... (7.3KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/fontconfig_bottle_manifest--2.14.2... (9KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libidn2_bottle_manifest--2.3.4_1-1... (8.3KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/p11-kit_bottle_manifest--0.25.0... (9KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/zstd_bottle_manifest--1.5.5-1... (8.6KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/lzo_bottle_manifest--2.10... (11.4KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/jpeg-xl_bottle_manifest--0.8.2... (14.6KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libunibreak_bottle_manifest--5.1... (7.2KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/jpeg-turbo_bottle_manifest--3.0.0... (11.8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/svt-av1_bottle_manifest--1.7.0... (7.7KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/opencore-amr_bottle_manifest--0.1.6... (8.4KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/freetype_bottle_manifest--2.13.2... (8.3KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/openexr_bottle_manifest--3.1.11... (8KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libsodium_bottle_manifest--1.0.18_1... (9.2KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/mbedtls_bottle_manifest--3.4.1... (7.3KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libevent_bottle_manifest--2.1.12_1... (9.6KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/gnutls_bottle_manifest--3.8.1... (14.4KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/highway_bottle_manifest--1.0.6... (7.7KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libsndfile_bottle_manifest--1.2.2... (10.6KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/glib_bottle_manifest--2.76.4... (13.3KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/ca-certificates_bottle_manifest--2023-05-30... (7.3KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/zeromq_bottle_manifest--4.3.4... (9.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/fribidi_bottle_manifest--1.0.13... (7.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libnghttp2_bottle_manifest--1.55.1... (7.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/frei0r_bottle_manifest--2.3.1... (7.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/pango_bottle_manifest--1.50.14... (20.1KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/leptonica_bottle_manifest--1.83.1... (13.0KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/theora_bottle_manifest--1.1.1-4... (10.5KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libvorbis_bottle_manifest--1.3.7-1... (8.1KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/nettle_bottle_manifest--3.9.1... (8.2KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libpng_bottle_manifest--1.6.40... (7.9KB)
Removing: /Users/lvwei/Library/Caches/Homebrew/libunistring_bottle_manifest--1.1... (7KB)
Removing: /Users/lvwei/Library/Logs/Homebrew/mongodb-community... (126B)
Removing: /Users/lvwei/Library/Logs/Homebrew/mongodb-database-tools... (131B)
Removing: /Users/lvwei/Library/Logs/Homebrew/glib... (64B)
Removing: /Users/lvwei/Library/Logs/Homebrew/minio... (114B)
Removing: /Users/lvwei/Library/Logs/Homebrew/zookeeper... (64B)
Removing: /Users/lvwei/Library/Logs/Homebrew/openssl@3... (64B)
Removing: /Users/lvwei/Library/Logs/Homebrew/mysql... (1.3KB)
Removing: /Users/lvwei/Library/Logs/Homebrew/node... (64B)
Removing: /Users/lvwei/Library/Logs/Homebrew/unbound... (64B)
Removing: /Users/lvwei/Library/Logs/Homebrew/python@3.11... (2 files, 2.5KB)
Removing: /Users/lvwei/Library/Logs/Homebrew/python@3.9... (2 files, 2.5KB)
Removing: /Users/lvwei/Library/Logs/Homebrew/gnutls... (64B)
Pruned 0 symbolic links and 4 directories from /opt/homebrew
```

安装后，使用QCacheGrind启动QCacheGrind应用，打开上一步的callgrind.out文件进行分析程序调用情况

![image](/images/post/Mac下使用Clion如何使用valgrind/qcachegrind_overview.png)

选择HelloWorld应用程序，效果如下

![image](/images/post/Mac下使用Clion如何使用valgrind/qcachegrind_helloworld.png)




