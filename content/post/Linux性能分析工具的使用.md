---
title: "Linux性能分析工具的使用"
date: 2023-12-12T14:17:57+08:00
lastmod: 2023-12-12T14:17:57+08:00
keywords: ["linux", "性能分析"]
tags: ["linux", "性能分析"]
categories: ["linux", "性能分析"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## linux系统性能分析工具

### 1.vmstat（虚拟内存统计）

 * vmstat（VirtualMeomoryStatistics，虚拟内存统计）
   * Linux 中监控内存的常用工具,可对操作系统的虚拟内存、进程、CPU 等的整体情况进行监视。
 * vmstat 的常规用法
   * vmstat interval times 即每隔 interval 秒采样一次，共采样 times 次，如果省略 times，则一直采集数据，直到用户手动停止为止。

本文linux环境：MacOS上使用docker安装ubuntu:20.04版本

 ```terminal
 (base) lvwei@lvweideMacBook-Pro rustdemo % docker pull ubuntu:20.04
20.04: Pulling from library/ubuntu
dae58cbd668a: Pull complete 
Digest: sha256:f5c3e53367f142fab0b49908550bdcdc4fb619d2f61ec1dfa60d26e0d59ac9e7
Status: Downloaded newer image for ubuntu:20.04
docker.io/library/ubuntu:20.04

What's Next?
  View a summary of image vulnerabilities and recommendations → docker scout quickview ubuntu:20.04
(base) lvwei@lvweideMacBook-Pro rustdemo % docker run -it ubuntu:20.04 /bin/bash
root@74423150804c:/# 

root@74423150804c:/# vmstat 3
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 0  0  49184 463400 191548 6259620    0    0     4    37   34   34  0  0 99  0  0
 0  0  49184 463400 191548 6259616    0    0     0     0  473  774  0  0 99  0  0
 0  0  49184 463148 191556 6259616    0    0     0     4  669  947  0  0 99  0  0
 0  0  49184 463148 191556 6259616    0    0     0     0  407  699  0  0 100  0  0
 0  0  49184 463148 191564 6259616    0    0     0     4  628  988  0  0 99  0  0
 0  0  49184 462644 191564 6259616    0    0     0     0  614  867  0  0 99  0  0
 0  0  49184 462644 191572 6259608    0    0     0     4  419  695  0  0 100  0  0
 0  0  49184 462644 191572 6259616    0    0     0     0  500  840  0  0 99  0  0
 0  0  49184 462392 191580 6259616    0    0     0     4 1282 1999  1  0 99  0  0
 0  0  49184 461888 191580 6259636    0    0     0     0  714 1024  0  0 99  0  0
 0  0  49184 461888 191588 6259632    0    0     0     4  457  758  0  0 100  0  0
 0  0  49184 463964 191588 6259644    0    0     0     3  477  782  0  0 100  0  0

 ```

#### 说明
* procs：r 这一列显示了多少进程在等待cpu，b列显示多少进程正在不可中断的休眠（等待IO）。
* memory：swapd 列显示了多少块被换出了磁盘（页面交换），剩下的列显示了多少块是空闲的（未被使用），多少块正在被用作缓冲区，以及多少正在被用作操作系统的缓存。
* swap：显示交换活动：每秒有多少块正在被换入（从磁盘）和换出（到磁盘）。
* io：显示了多少块从块设备读取（bi）和写出（bo）,通常反映了硬盘I/O。
* system：显示每秒中断(in)和上下文切换（cs）的数量。
*  cpu：显示所有的cpu时间花费在各类操作的百分比，包括执行用户代码（非内核），执行系统代码（内核），空闲以及等待IO。

#### 内存不足的表现


    回收 buffer 和 cache，free memory 仍急剧减少，大量使用交换分区（swpd）,页面交换（swap）频繁，读写磁盘数量（io）增多，缺页中断（in）增多，上下文切换（cs）次数增多，等待IO的进程数（b）增多，大量CPU时间用于等待IO（wa）

### 2.iostat(中央处理器统计信息)

安装sysstat包，
```terminal
root@74423150804c:/# apt install sysstat
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  cron libsensors-config libsensors5 ucf xz-utils
Suggested packages:
...

root@74423150804c:/# iostat -dx 3
Linux 6.4.16-linuxkit (74423150804c) 	12/12/23 	_aarch64_	(8 CPU)

Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz  aqu-sz  %util
loop0            0.04      2.97     0.00   0.00    1.16    69.03    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00   0.00
vda              0.84     30.97     0.06   6.84    0.21    37.08    0.94    292.78     3.08  76.71   16.00   312.61    0.06    716.09     0.00   0.00    1.37 11839.52    0.02   0.10


Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz  aqu-sz  %util
loop0            0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00   0.00
vda              0.00      0.00     0.00   0.00    0.00     0.00    0.67      8.00     1.33  66.67    1.50    12.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00   0.13


Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz  aqu-sz  %util
loop0            0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00   0.00
vda              0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00   0.00


Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz  aqu-sz  %util
loop0            0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00   0.00
vda              0.00      0.00     0.00   0.00    0.00     0.00    1.67      8.00     0.33  16.67    2.20     4.80    0.00      0.00     0.00   0.00    0.00     0.00    0.00   0.27

```

#### 说明
* Device: 设备名称，表示统计数据所对应的设备。
* r/s: 代表每秒钟从设备读取的次数 (reads per second)。
* rkB/s: 每秒钟从设备读取的数据量，以千字节 (KB) 为单位 (kilobytes per second)。
* rrqm/s: 每秒钟合并读请求的次数 (合并的读请求是通过读请求合并成更大的操作以提高效率的)。
* %rrqm: 合并读请求所占的百分比，即合并请求在总读请求中的占比。
* r_await: 读请求的平均等待时间，以毫秒为单位。
* rareq-sz: 每个读请求的平均大小，以扇区为单位。
* w/s: 代表每秒钟向设备写入的次数 (writes per second)。
* wkB/s: 每秒钟向设备写入的数据量，以千字节 (KB) 为单位 (kilobytes per second)。
* wrqm/s: 每秒钟合并写请求的次数。
* %wrqm: 合并写请求所占的百分比，即合并请求在总写请求中的占比。
* w_await: 写请求的平均等待时间，以毫秒为单位。
* wareq-sz: 每个写请求的平均大小，以扇区为单位。
* d/s: 代表每秒钟发生的被删除的块的次数。
* dkB/s: 每秒钟被删除块的数据量，以千字节 (KB) 为单位。
* drqm/s: 每秒钟合并删除请求的次数。
* %drqm: 合并删除请求所占的百分比，即合并请求在总删除请求中的占比。
* d_await: 删除请求的平均等待时间，以毫秒为单位。
* dareq-sz: 每个删除请求的平均大小，以扇区为单位。
* aqu-sz: 平均请求队列的长度 (Average queue length).
* %util: 设备的利用率，即设备处于忙碌状态的百分比。


这些数据对于分析系统磁盘 I/O 情况非常有用。您可以通过这些数据了解设备的读写负载情况、请求合并情况、请求等待时间以及设备利用率等信息。

### 3.dstat（系统监控工具）

dstat是一个功能强大的综合性能监控工具，可以显示有关系统资源使用情况的实时统计信息。下面是一些常用的dstat用法列举：

* 显示 CPU 使用情况:
dstat -c
* 显示内存使用情况:
dstat -m
* 显示磁盘 I/O 情况:
dstat -d

* 显示网络使用情况:
dstat -n

* 显示系统负载情况:
dstat -l
* 显示进程相关信息：
dstat -p
* 指定特定统计间隔和持续时间：
dstat -t -s 5 10 在此示例中，-t 参数用于显示时间戳，-s 参数指定统计间隔为 5 秒，持续时间为 10 秒。

* 导出数据到 CSV 文件:
dstat -cdlmn --output data.csv 在此示例中，-cdlmn 参数用于指定需要统计的内容，--output 参数指定输出到 CSV 文件 data.csv。


```terminal

root@74423150804c:/# apt install dstat
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  file libexpat1 libmagic-mgc libmagic1 libmpdec2 libpython3-stdlib libpython3.8-minimal libpython3.8-stdlib libreadline8 libsqlite3-0 libssl1.1
  mime-support python3 python3-minimal python3-six python3.8 python3.8-minimal readline-common
Suggested packages:
  python3-doc python3-tk python3-venv python3.8-venv python3.8-doc binutils binfmt-support readline-doc
The following NEW packages will be installed:
...

root@74423150804c:/# dstat         
You did not select any stats, using -cdngy by default.
--total-cpu-usage-- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai stl| read  writ| recv  send|  in   out | int   csw 
  0   0  99   0   0|  34k  291k|   0     0 |   1B  429B| 657  1038 
  0   0 100   0   0|   0     0 |   0     0 |   0     0 | 640  1084 
  1   0  99   0   0|   0     0 |   0     0 |   0     0 | 562   823 
  1   0  99   0   0|   0     0 |   0     0 |   0     0 | 515   798 
  0   0  99   0   0|   0     0 |   0     0 |   0     0 | 468   748 
  1   0  99   0   0|   0     0 |   0     0 |   0     0 |1515  2542 
  1   1  98   0   0|   0    12k|   0     0 |   0     0 |1810  2260 
  0   0  99   0   0|   0     0 |   0     0 |   0     0 | 579   952 
  0   0  99   0   0|   0     0 |   0     0 |   0     0 | 480   794 
  0   0 100   0   0|   0     0 |   0     0 |   0     0 | 451   734 
  0   0  99   0   0|   0     0 |   0     0 |   0     0 | 428   685 
  0   0  99   0   0|   0     0 |   0     0 |   0     0 | 682  1144 
  1   0  99   0   0|   0    12k|   0     0 |   0     0 | 884  1347 
  0   0  99   0   0|   0     0 |   0     0 |   0     0 | 468   736 
  0   0 100   0   0|   0     0 |   0     0 |   0     0 | 413   691 
  0   0  99   0   0|   0     0 |   0     0 |   0     0 |1447  2387 
  1   1  98   0   0|   0     0 |   0     0 |   0     0 |1676  2184 
  0   0  99   0   0|   0     0 |   0     0 |   0     0 |1134  1674 
  0   0 100

```

#### 说明

* Total CPU Usage: 显示了 CPU 的使用情况，包括用户态 (usr)、系统态 (sys)、空闲态 (idl)、等待态 (wai) 和虚拟机态 (stl) 的百分比。

* Disk I/O (-dsk/total-): 显示了磁盘的读取和写入量，使用的单位是 kB/s。在这个例子中，读取量 (read) 为 34k，写入量 (writ) 为 291k。

* Network (-net/total-): 显示了网络传输的接收和发送量，使用的单位是字节数。在这个例子中，接收量 (recv) 和发送量 (send) 都为 0 字节。

* Paging: 显示了系统的分页（磁盘交换）情况，单位是字节数。在这个例子中，入页数 (in) 为 1 字节，出页数 (out) 为 429 字节。

* System: 显示了系统的中断 (int) 和上下文切换 (csw) 次数。

根据这些数据，您可以了解到系统的 CPU 使用情况、磁盘和网络的读写量、分页和系统处理的中断和上下文切换次数。这些统计数据可以帮助您分析系统的性能瓶颈和负载情况。请注意，输出中的数据是实时更新的，每行代表一个间隔时间的统计。


```terminal

# 显示系统负载情况
root@74423150804c:/# dstat -l
---load-avg---
 1m   5m  15m 
   0 0.02 0.03
   0 0.02 0.03
   0 0.02 0.03
   0 0.02 0.03
   0 0.02 0.03
   0 0.02 0.03
   0 0.02 0.03
   0 0.02 0.03
   0 0.02 0.03
   0 0.02 0.03
   0 0.02 0.03
   0 0.02 0.03
   0 0.02 0.03
   0 0.02 0.03
   0 0.02 0.03
   0 0.02 0.03
   0 0.02 0.03^C
 # 显示进程相关信息  
root@74423150804c:/# dstat -p
---procs---
run blk new
  0   0 1.8
  0   0 7.0
  0   0   0
  0   0   0
  0   0   0^C
root@74423150804c:/# 

```

### 4.pidstat（监控系统资源）
主要用于监控全部或指定进程占用系统资源的情况,如 CPU,内存、设备 IO、任务切换、线程等。

* 显示所有进程的CPU统计信息：
pidstat -u
* 显示指定进程的CPU统计信息（以进程ID为例，您需要将<pid>替换为实际的进程ID）：
pidstat -p <pid> -u

* 显示所有进程的内存统计信息：
pidstat -r

* 显示指定进程的内存统计信息（以进程ID为例，您需要将<pid>替换为实际的进程ID）：
pidstat -p <pid> -r

* 显示所有进程的磁盘I/O统计信息：
pidstat -d

* 显示指定进程的磁盘I/O统计信息（以进程ID为例，您需要将<pid>替换为实际的进程ID）：
pidstat -p <pid> -d

* 显示所有进程的网络统计信息：
pidstat -n

* 显示指定进程的网络统计信息（以进程ID为例，您需要将<pid>替换为实际的进程ID）：
pidstat -p <pid> -n

```terminal

root@74423150804c:/# pidstat
Linux 6.4.16-linuxkit (74423150804c) 	12/12/23 	_aarch64_	(8 CPU)

07:34:48      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command
07:34:48        0         1    0.00    0.00    0.00    0.00    0.00     2  bash
root@74423150804c:/# 
root@74423150804c:/# pidstat -u 3
Linux 6.4.16-linuxkit (74423150804c) 	12/12/23 	_aarch64_	(8 CPU)

07:32:48      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command

07:32:51      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command
07:32:54        0       897    0.00    0.33    0.00    0.00    0.33     4  pidstat

07:32:54      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command

07:32:57      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command

07:33:00      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command

07:33:03      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command

07:33:06      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command

07:33:09      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command

07:33:12      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command
07:33:15        0       897    0.00    0.33    0.00    0.00    0.33     4  pidstat

07:33:15      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command

07:33:18      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command
^C

Average:      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command
Average:        0       897    0.00    0.06    0.00    0.00    0.06     -  pidstat

root@74423150804c:/# pidstat -r 3
Linux 6.4.16-linuxkit (74423150804c) 	12/12/23 	_aarch64_	(8 CPU)

07:35:47      UID       PID  minflt/s  majflt/s     VSZ     RSS   %MEM  Command
07:35:50        0       901    140.20      0.00    4552    2432   0.03  pidstat

07:35:50      UID       PID  minflt/s  majflt/s     VSZ     RSS   %MEM  Command
07:35:53        0       901     34.00      0.00    4552    2816   0.04  pidstat

07:35:53      UID       PID  minflt/s  majflt/s     VSZ     RSS   %MEM  Command

07:35:56      UID       PID  minflt/s  majflt/s     VSZ     RSS   %MEM  Command

07:35:59      UID       PID  minflt/s  majflt/s     VSZ     RSS   %MEM  Command

07:36:02      UID       PID  minflt/s  majflt/s     VSZ     RSS   %MEM  Command

07:36:05      UID       PID  minflt/s  majflt/s     VSZ     RSS   %MEM  Command

07:36:08      UID       PID  minflt/s  majflt/s     VSZ     RSS   %MEM  Command

07:36:11      UID       PID  minflt/s  majflt/s     VSZ     RSS   %MEM  Command

07:36:14      UID       PID  minflt/s  majflt/s     VSZ     RSS   %MEM  Command


```


#### pidstat -u 3命令显示了每3秒钟的CPU统计信息。

* 07:32:48：统计的时间戳。
* UID：进程所有者的用户标识号。
* PID：进程ID。
* %usr：用户态CPU占用百分比，表示进程在用户态执行代码的时间百分比。
* %system：系统态CPU占用百分比，表示进程在内核态执行代码的时间百分比。
* %guest：与虚拟化相关的CPU占用百分比。
* %wait：进程等待CPU的百分比。
* %CPU：进程的总CPU占用百分比，包括用户态和系统态。
* CPU：所在的CPU核心编号。
* Command：进程的命令名称。


#### pidstat -r 3命令显示了每3秒钟的内存统计信息。

* 07:35:47：统计的时间戳。
* UID：进程所有者的用户标识号。
* PID：进程ID。
* minflt/s：每秒钟的次缺页异常的次数，表示需要从磁盘加载数据到内存。
* majflt/s：每秒钟的主缺页异常次数，表示需要从磁盘加载整个内存页面。
* VSZ：虚拟内存大小。
* RSS：常驻内存集大小，表示当前正在使用的实际物理内存大小。
* %MEM：进程占用物理内存的百分比。
* Command：进程的命令名称。

### 5.top（显示系统性能信息）


```terminal

root@74423150804c:/# top

top - 07:40:28 up 1 day,  8:29,  0 users,  load average: 0.00, 0.06, 0.09
Tasks:   2 total,   1 running,   1 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.3 us,  0.3 sy,  0.0 ni, 99.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :   7851.5 total,    422.5 free,   1125.2 used,   6303.7 buff/cache
MiB Swap:   1024.0 total,    976.0 free,     48.0 used.   6318.8 avail Mem 

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                                         
    1 root      20   0    3884   2816   2560 S   0.0   0.0   0:00.37 bash                                                                            
  902 root      20   0    5748   2560   2176 R   0.0   0.0   0:00.01 top                                                                             


```
#### 说明
* 07:40:28：当前时间。
* up 1 day, 8:29：系统已经运行1天8小时29分钟。
* 0 users：当前登录用户数为0。
* load average: 0.00, 0.06, 0.09：最近1分钟、5分钟和15分钟的平均负载值。
* Tasks: 2 total, 1 running, 1 sleeping, 0 stopped, 0 zombie：系统中总共有2个任务，其中1个正在运行，1个正在休眠。
* %Cpu(s): 0.3 us, 0.3 sy, 0.0 ni, 99.3 id, 0.0 wa, 0.0 hi, 0.0 si, 0.0 st：CPU使用情况统计信息。
* MiB Mem 和 MiB Swap：内存和交换空间的使用情况统计信息。
* PID：进程ID。
* USER：进程所有者。
* PR：进程的调度优先级。
* NI：进程的静态优先级。
* VIRT：进程使用的虚拟内存大小。
* RES：进程使用的常驻内存集大小。
* SHR：进程使用的共享内存大小。
* S：进程状态（运行中、休眠等）。
* %CPU 和 %MEM：进程的CPU占用百分比和内存占用百分比。
* TIME+：进程运行的累计CPU时间。
* COMMAND：进程的命令名称。

### 6.mpstat（CPU的一些统计信息）


```terminal

root@74423150804c:/# mpstat
Linux 6.4.16-linuxkit (74423150804c) 	12/12/23 	_aarch64_	(8 CPU)

07:56:30     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
07:56:30     all    0.34    0.00    0.25    0.01    0.00    0.01    0.00    0.00    0.00   99.39

```

#### 说明

* %usr: Percentage of CPU utilization that occurred while executing at the user level
* %nice: Percentage of CPU utilization that occurred while executing at the user level with nice priority
* %sys: Percentage of CPU utilization that occurred while executing at the system level (kernel)
* %iowait: Percentage of time that the CPU or CPUs were idle during which the system had an outstanding disk I/O request
* %irq: Percentage of time spent by the CPU or CPUs to service hardware interrupts
* %soft: Percentage of time spent by the CPU or CPUs to service software interrupts
* %steal: The percentage of time spent in involuntary wait by the virtual CPU or CPUs while the hypervisor was servicing another virtual processor
* %guest: The percentage of time spent by the CPU or CPUs to run a virtual processor
* %gnice: Percentage of time spent by the CPU or CPUs to execute at the user level with "nice" priority on a guest environment
* %idle: Percentage of time that the CPU or CPUs were idle and the system did not have an outstanding disk I/O request


### 7.netstat(显示与 IP、TCP、UDP和 ICMP 协议相关的统计数据)

```terminal
root@74423150804c:/# sudo apt install net-tools
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following NEW packages will be installed:
  net-tools
0 upgraded, 1 newly installed, 0 to remove and 2 not upgraded.
Need to get 194 kB of archives.
After this operation, 827 kB of additional disk space will be used.
Get:1 http://ports.ubuntu.com/ubuntu-ports focal/main arm64 net-tools arm64 1.60+git20180626.aebd88e-1ubuntu1 [194 kB]
Fetched 194 kB in 4s (44.7 kB/s)    
debconf: delaying package configuration, since apt-utils is not installed
Selecting previously unselected package net-tools.
(Reading database ... 13757 files and directories currently installed.)
Preparing to unpack .../net-tools_1.60+git20180626.aebd88e-1ubuntu1_arm64.deb ...
Unpacking net-tools (1.60+git20180626.aebd88e-1ubuntu1) ...
Setting up net-tools (1.60+git20180626.aebd88e-1ubuntu1) ...
root@74423150804c:/# netstat
Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 74423150804c:49256      185.125.190.39:http     TIME_WAIT  
Active UNIX domain sockets (w/o servers)
Proto RefCnt Flags       Type       State         I-Node   Path
root@74423150804c:/# 

```

#### 说明

* Proto: The protocol used for the connection (TCP in this case).
* Recv-Q and Send-Q: The number of bytes in the receive and send queues respectively.
* Local Address: The local IP address and port associated with the connection.
* Foreign Address: The remote IP address and port connected to the local address.
* State: The state of the TCP connection.

