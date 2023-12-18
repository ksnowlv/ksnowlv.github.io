---
title: "Docker常用命令"
date: 2023-12-13T09:26:10+08:00
lastmod: 2023-12-13T09:26:10+08:00
keywords: ["docker", "后端开发"]
tags: ["docker", "后端开发"]
categories: ["docker", "后端开发"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## 一.Docker常用命令

### 1.docker的版本信息
命令：docker version

```terminal
(base) lvwei@lvweideMacBook-Pro rustdemo % docker version
Client:
 Cloud integration: v1.0.35+desktop.5
 Version:           24.0.6
 API version:       1.43
 Go version:        go1.20.7
 Git commit:        ed223bc
 Built:             Mon Sep  4 12:28:49 2023
 OS/Arch:           darwin/arm64
 Context:           desktop-linux

Server: Docker Desktop 4.24.2 (124339)
 Engine:
  Version:          24.0.6
  API version:      1.43 (minimum version 1.12)
  Go version:       go1.20.7
  Git commit:       1a79695
  Built:            Mon Sep  4 12:31:36 2023
  OS/Arch:          linux/arm64
  Experimental:     false
 containerd:
  Version:          1.6.22
  GitCommit:        8165feabfdfe38c65b599c4993d227328c231fca
 runc:
  Version:          1.1.8
  GitCommit:        v1.1.8-0-g82f18fe
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```

### 2.docker的系统信息
命令：docker info

```terminal
(base) lvwei@lvweideMacBook-Pro rustdemo % docker info
Client:
 Version:    24.0.6
 Context:    desktop-linux
 Debug Mode: false
 Plugins:
  buildx: Docker Buildx (Docker Inc.)
    Version:  v0.11.2-desktop.5
    Path:     /Users/lvwei/.docker/cli-plugins/docker-buildx
  compose: Docker Compose (Docker Inc.)
    Version:  v2.22.0-desktop.2
    Path:     /Users/lvwei/.docker/cli-plugins/docker-compose
  dev: Docker Dev Environments (Docker Inc.)
    Version:  v0.1.0
    Path:     /Users/lvwei/.docker/cli-plugins/docker-dev
  extension: Manages Docker extensions (Docker Inc.)
    Version:  v0.2.20
    Path:     /Users/lvwei/.docker/cli-plugins/docker-extension
  init: Creates Docker-related starter files for your project (Docker Inc.)
    Version:  v0.1.0-beta.8
    Path:     /Users/lvwei/.docker/cli-plugins/docker-init
  sbom: View the packaged-based Software Bill Of Materials (SBOM) for an image (Anchore Inc.)
    Version:  0.6.0
    Path:     /Users/lvwei/.docker/cli-plugins/docker-sbom
  scan: Docker Scan (Docker Inc.)
    Version:  v0.26.0
    Path:     /Users/lvwei/.docker/cli-plugins/docker-scan
  scout: Docker Scout (Docker Inc.)
    Version:  v1.0.7
    Path:     /Users/lvwei/.docker/cli-plugins/docker-scout

Server:
 Containers: 8
  Running: 4
  Paused: 0
  Stopped: 4
 Images: 6
 Server Version: 24.0.6
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Using metacopy: false
  Native Overlay Diff: true
  userxattr: false
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Cgroup Version: 2
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 8165feabfdfe38c65b599c4993d227328c231fca
 runc version: v1.1.8-0-g82f18fe
 init version: de40ad0
 Security Options:
  seccomp
   Profile: unconfined
  cgroupns
 Kernel Version: 6.4.16-linuxkit
 Operating System: Docker Desktop
 OSType: linux
 Architecture: aarch64
 CPUs: 8
 Total Memory: 7.667GiB
 Name: docker-desktop
 ID: 93024967-feb6-48e3-a684-37f47fa4e37c
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 HTTP Proxy: http.docker.internal:3128
 HTTPS Proxy: http.docker.internal:3128
 No Proxy: hubproxy.docker.internal
 Experimental: false
 Insecure Registries:
  hubproxy.docker.internal:5555
  127.0.0.0/8
 Live Restore Enabled: false
```
#### 说明
* Client（客户端）：显示 Docker 客户端的版本和配置上下文。

* Plugins（插件）：显示已安装的 Docker 插件及其版本。这些插件可以提供更多的功能和工具，如构建镜像、运行容器等。

* Server（服务器）：显示 Docker 服务器的运行状态。它列出当前服务器上正在运行的容器和镜像数量，以及服务器的版本和运行配置。

* Storage Driver（存储驱动）：显示 Docker 使用的存储驱动类型和配置。

* Logging Driver（日志驱动）：显示 Docker 使用的日志驱动类型和配置。

* Cgroup Driver（Cgroup 驱动）：显示 Docker 使用的 Cgroup 驱动类型和配置。

* Swarm（容器编排）：显示 Docker Swarm 是否被激活及配置信息。

* Runtimes（容器运行时）：显示 Docker 使用的容器运行时类型和版本。

* Security Options（安全选项）：显示 Docker 使用的安全选项配置。

* Kernel Version（内核版本）：显示 Docker 运行的宿主机的内核版本。

* Operating System（操作系统）：显示 Docker 运行的操作系统。

* Architecture（架构）：显示 Docker 运行的宿主机的架构。

* CPUs（CPU 核数）：显示 Docker 运行的宿主机的 CPU 核数。

* Total Memory（总内存）：显示 Docker 运行的宿主机的总内存大小。

* Docker Root Dir（Docker 根目录）：显示 Docker 存储镜像和容器数据的根目录。

* HTTP Proxy（HTTP 代理）：显示 Docker 客户端使用的 HTTP 代理配置。

* HTTPS Proxy（HTTPS 代理）：显示 Docker 客户端使用的 HTTPS 代理配置。

* No Proxy（无代理）：显示 Docker 客户端的无代理配置。

* Experimental（实验性功能）：显示 Docker 是否启用了实验性功能。

* Insecure Registries（不安全的镜像仓库）：显示 Docker 客户端信任的不安全的镜像仓库地址。

* Live Restore Enabled（启用实时恢复）：显示 Docker 是否启用了实时容器恢复功能。


### 3.docker进入容器内部/退出容器
进入命令：docker exec -it containerId或containerName /bin/bash
进入命令：exit

### 4.doccker查看容器信息

命令：docker inspect containerId或containerName

```terminal
(base) lvwei@lvweideMacBook-Pro rustdemo % docker inspect newapp
[
    {
        "Id": "2019aa4e114e42bbbf594341a5d8bcb95ec463150c738e467fab51e2f34181e7",
        "Created": "2023-12-12T11:37:11.463873337Z",
        "Path": "uvicorn",
        "Args": [
            "main:app",
            "--host",
            "0.0.0.0",
            "--port",
            "8081"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 9047,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2023-12-12T11:44:39.745304169Z",
            "FinishedAt": "2023-12-12T11:37:12.429198629Z"
        },
        "Image": "sha256:38660250eb0c6c115399fe0e62c098520ea9de2dbe611f7b6bf40af4530c7c05",
        "ResolvConfPath": "/var/lib/docker/containers/2019aa4e114e42bbbf594341a5d8bcb95ec463150c738e467fab51e2f34181e7/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/2019aa4e114e42bbbf594341a5d8bcb95ec463150c738e467fab51e2f34181e7/hostname",
        "HostsPath": "/var/lib/docker/containers/2019aa4e114e42bbbf594341a5d8bcb95ec463150c738e467fab51e2f34181e7/hosts",
        "LogPath": "/var/lib/docker/containers/2019aa4e114e42bbbf594341a5d8bcb95ec463150c738e467fab51e2f34181e7/2019aa4e114e42bbbf594341a5d8bcb95ec463150c738e467fab51e2f34181e7-json.log",
        "Name": "/newapp",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "mynet",
            "PortBindings": {
                "8081/tcp": [
                    {
                        "HostIp": "",
                        "HostPort": "8081"
                    }
                ]
            },
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "ConsoleSize": [
                51,
                150
            ],
            "CapAdd": null,
            "CapDrop": null,
            "CgroupnsMode": "private",
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "private",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": [],
            "BlkioDeviceWriteBps": [],
            "BlkioDeviceReadIOps": [],
            "BlkioDeviceWriteIOps": [],
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": null,
            "PidsLimit": null,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/1b53991296a8020405671bd618030eca6762195bb6851d5e76abbd8a2a975417-init/diff:/var/lib/docker/overlay2/s5grffub34pe4tdhzrn8ipwe1/diff:/var/lib/docker/overlay2/qtouc6gwy18tovvarspfqj89q/diff:/var/lib/docker/overlay2/vx2hut6b70e6lg3hdofxxyaao/diff:/var/lib/docker/overlay2/da6c621bd9476179634ca091f6d02e4b787b85412e9cd9a411bece8bacc23f55/diff:/var/lib/docker/overlay2/323d410ff341a42beedfc01fa2016a775971b7af5b265126ad875f0f79f2ba76/diff:/var/lib/docker/overlay2/8003b2acc85c05a1073502bc23ad83146b820078b3dc2c919cadd6689a4d90ac/diff:/var/lib/docker/overlay2/328c2bfe008330f8ab8c331998d4ee0603c3a7996ad30c9a0edf56e5ccfa5d4c/diff:/var/lib/docker/overlay2/380910e8138794172d7cc511e6ddac062eafbf6fadb20fe8029fa326e4f18f89/diff:/var/lib/docker/overlay2/f2396e67fbb3189c34a80056ea42ca3d2b04d79dcd908a79f3da3cf50c882f23/diff:/var/lib/docker/overlay2/8b296a7e7422b29b2466da53afbb5e2e1b241ca186c42b01fb9f2d6255680ff2/diff:/var/lib/docker/overlay2/152d4b6b45dfdd9f776756214e9e8a7c6df28440af814ca76f22552d0a093701/diff",
                "MergedDir": "/var/lib/docker/overlay2/1b53991296a8020405671bd618030eca6762195bb6851d5e76abbd8a2a975417/merged",
                "UpperDir": "/var/lib/docker/overlay2/1b53991296a8020405671bd618030eca6762195bb6851d5e76abbd8a2a975417/diff",
                "WorkDir": "/var/lib/docker/overlay2/1b53991296a8020405671bd618030eca6762195bb6851d5e76abbd8a2a975417/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "2019aa4e114e",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "8081/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "LANG=C.UTF-8",
                "GPG_KEY=A035C8C19219BA821ECEA86B64E628F8D684696D",
                "PYTHON_VERSION=3.11.7",
                "PYTHON_PIP_VERSION=23.2.1",
                "PYTHON_SETUPTOOLS_VERSION=65.5.1",
                "PYTHON_GET_PIP_URL=https://github.com/pypa/get-pip/raw/4cfa4081d27285bda1220a62a5ebf5b4bd749cdb/public/get-pip.py",
                "PYTHON_GET_PIP_SHA256=9cc01665956d22b3bf057ae8287b035827bfd895da235bcea200ab3b811790b6"
            ],
            "Cmd": [
                "uvicorn",
                "main:app",
                "--host",
                "0.0.0.0",
                "--port",
                "8081"
            ],
            "Image": "fastapitest-app",
            "Volumes": null,
            "WorkingDir": "/app",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": {}
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "55d0f6c28c5689051f3c8c958f2c23ffeee2325b57e1f61151a9661330d15552",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {
                "8081/tcp": [
                    {
                        "HostIp": "0.0.0.0",
                        "HostPort": "8081"
                    }
                ]
            },
            "SandboxKey": "/var/run/docker/netns/55d0f6c28c56",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "",
            "Gateway": "",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "",
            "IPPrefixLen": 0,
            "IPv6Gateway": "",
            "MacAddress": "",
            "Networks": {
                "mynet": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": [
                        "2019aa4e114e"
                    ],
                    "NetworkID": "297e608290472a23fec759a75e6b323771773d7bcfbaada11aa0c9fd285d8a76",
                    "EndpointID": "1d3796871a9edd6a3c4d7b55fd4bb17b4e3b889dffcf1b4b84f18b209c87742e",
                    "Gateway": "172.20.0.1",
                    "IPAddress": "172.20.0.4",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:14:00:04",
                    "DriverOpts": null
                }
            }
        }
    }
]
(base) lvwei@lvweideMacBook-Pro rustdemo % 

```

### 5.docker查看容器日志

命令：docker logs containerId或containerName


### 6.docker查看容器中进程信息

命令：docker top containerId或containerName

```terminal
(base) lvwei@lvweideMacBook-Pro rustdemo % docker top newapp
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
root                9047                9021                0                   Dec12               ?                   00:00:31            /usr/local/bin/python /usr/local/bin/uvicorn main:app --host 0.0.0.0 --port 8081

```

### 7.docker查看容器内存CPU占用情况

命令：docker stats

```terminal
CONTAINER ID   NAME      CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O        PIDS
2019aa4e114e   newapp    0.70%     77.42MiB / 7.667GiB   0.99%     7.66kB / 6.08kB   46MB / 43.5MB    8
1178ee9492f1   mysql_1   0.95%     406.1MiB / 7.667GiB   5.17%     3.01kB / 0B       29.8MB / 270MB   39
f1a5aeb83045   mysql     0.93%     356.4MiB / 7.667GiB   4.54%     3.94kB / 3.34kB   28.2MB / 17MB    38

CONTAINER ID   NAME      CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O        PIDS
2019aa4e114e   newapp    0.29%     77.42MiB / 7.667GiB   0.99%     7.66kB / 6.08kB   46MB / 43.5MB    8
1178ee9492f1   mysql_1   1.05%     406.1MiB / 7.667GiB   5.17%     3.01kB / 0B       29.8MB / 270MB   39
f1a5aeb83045   mysql     0.92%     356.4MiB / 7.667GiB   4.54%     3.94kB / 3.34kB   28.2MB / 17MB    38

CONTAINER ID   NAME      CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O        PIDS
2019aa4e114e   newapp    0.29%     77.42MiB / 7.667GiB   0.99%     7.66kB / 6.08kB   46MB / 43.5MB    8
1178ee9492f1   mysql_1   1.05%     406.1MiB / 7.667GiB   5.17%     3.01kB / 0B       29.8MB / 270MB   39
f1a5aeb83045   mysql     0.92%     356.4MiB / 7.667GiB   4.54%     3.94kB / 3.34kB   28.2MB / 17MB    38

CONTAINER ID   NAME      CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O        PIDS
2019aa4e114e   newapp    0.37%     77.42MiB / 7.667GiB   0.99%     7.66kB / 6.08kB   46MB / 43.5MB    8
1178ee9492f1   mysql_1   0.87%     406.1MiB / 7.667GiB   5.17%     3.01kB / 0B       29.8MB / 270MB   39
f1a5aeb83045   mysql     0.94%     356.4MiB / 7.667GiB   4.54%     3.94kB / 3.34kB   28.2MB / 17MB    38

```

### 8.docker显示所有运行容器

命令：docker ps
```terminal
(base) lvwei@lvweideMacBook-Pro rustdemo % docker ps   
CONTAINER ID   IMAGE             COMMAND                   CREATED        STATUS        PORTS                               NAMES
2019aa4e114e   fastapitest-app   "uvicorn main:app --…"   16 hours ago   Up 16 hours   0.0.0.0:8081->8081/tcp              newapp
1178ee9492f1   mysql:latest      "docker-entrypoint.s…"   16 hours ago   Up 16 hours   3306/tcp, 33060/tcp                 mysql_1
f1a5aeb83045   mysql             "docker-entrypoint.s…"   4 days ago     Up 16 hours   0.0.0.0:3306->3306/tcp, 33060/tcp   mysql

```

### 9.docker显示所有容器,包括非运行中的容器

命令：docker ps -a
```terminal
(base) lvwei@lvweideMacBook-Pro rustdemo % docker ps -a
CONTAINER ID   IMAGE                    COMMAND                   CREATED        STATUS                      PORTS                               NAMES
2019aa4e114e   fastapitest-app          "uvicorn main:app --…"   16 hours ago   Up 16 hours                 0.0.0.0:8081->8081/tcp              newapp
1178ee9492f1   mysql:latest             "docker-entrypoint.s…"   16 hours ago   Up 16 hours                 3306/tcp, 33060/tcp                 mysql_1
38d83edd33d3   ubuntu:20.04             "/bin/bash"               17 hours ago   Exited (0) 17 hours ago                                         vigilant_euclid
7148e674b2ed   ubuntu:20.04             "/bin/bash"               17 hours ago   Exited (0) 17 hours ago                                         elegant_burnell
74423150804c   ubuntu:20.04             "/bin/bash"               24 hours ago   Exited (255) 17 hours ago                                       charming_bouman
f1a5aeb83045   mysql                    "docker-entrypoint.s…"   4 days ago     Up 16 hours                 0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
929b04ca4b68   watch-fastapi-frontend   "nginx -g 'daemon of…"   7 weeks ago    Exited (255) 2 weeks ago    0.0.0.0:2153->80/tcp                WatchWeb
9dd1c7f8b9cd   watch-fastapi-backend    "uvicorn main:app --…"   7 weeks ago    Exited (255) 2 weeks ago    0.0.0.0:1339->80/tcp                WatchFastAPI
(base) lvwei@lvweideMacBook-Pro rustdemo % 

```

### 10.docker镜像命令

命令：

    docker images                   			        #查看所有镜像
    docker images -a                  			        #查看所有镜像，包括中间层镜像
    docker images -aq                                   #查看所有镜像，包括中间层镜像ID
    docker images imageName                 	        #查看具体镜像
    docker rmi imageid或者imageName                      #删除指定的镜像
    docker rmi imageidA imageidB imageidC               #删除指定多个镜像
    docker rmi -f imageid或者imageName                   #强制删除指定的镜像
    docker rmi -f $(docker images -aq)                  #删除全部的镜像
    docker image inspect imageName                      #查看具体镜像详情
    docker history imageName                            #查看镜像的创建历史
    docker build -f dockerfilepath -t imageName:[tag] . #构建镜像
    docker save imageName[:tag] -o 文件                  #导出镜像到文件
    docker load -i 文件  
    docker image inspect imageName                      #查看镜像详情

```terminal
(base) lvwei@lvweideMacBook-Pro rustdemo % docker images
REPOSITORY               TAG       IMAGE ID       CREATED        SIZE
fastapi-admin            latest    d1cc409585b7   46 hours ago   339MB
fastapitest-app          latest    38660250eb0c   4 days ago     1.45GB
ubuntu                   20.04     51abb690a343   2 weeks ago    65.7MB
mysql                    latest    9c61872d4987   7 weeks ago    628MB
watch-fastapi-frontend   latest    c498806e80e2   7 weeks ago    16.3MB
watch-fastapi-backend    latest    17194408bc6a   7 weeks ago    1.03GB
(base) lvwei@lvweideMacBook-Pro rustdemo % docker images -a
REPOSITORY               TAG       IMAGE ID       CREATED        SIZE
fastapi-admin            latest    d1cc409585b7   46 hours ago   339MB
fastapitest-app          latest    38660250eb0c   4 days ago     1.45GB
ubuntu                   20.04     51abb690a343   2 weeks ago    65.7MB
mysql                    latest    9c61872d4987   7 weeks ago    628MB
watch-fastapi-frontend   latest    c498806e80e2   7 weeks ago    16.3MB
watch-fastapi-backend    latest    17194408bc6a   7 weeks ago    1.03GB
(base) lvwei@lvweideMacBook-Pro rustdemo % docker images -aq
d1cc409585b7
38660250eb0c
51abb690a343
9c61872d4987
c498806e80e2
17194408bc6a
(base) lvwei@lvweideMacBook-Pro rustdemo % docker images mysql       
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
mysql        latest    9c61872d4987   7 weeks ago   628MB
# 当前容器镜像列表
(base) lvwei@lvweideMacBook-Pro rustdemo % docker ps -a
CONTAINER ID   IMAGE                    COMMAND                   CREATED        STATUS                      PORTS                               NAMES
2019aa4e114e   fastapitest-app          "uvicorn main:app --…"   18 hours ago   Up 18 hours                 0.0.0.0:8081->8081/tcp              newapp
1178ee9492f1   mysql:latest             "docker-entrypoint.s…"   18 hours ago   Up 18 hours                 3306/tcp, 33060/tcp                 mysql_1
38d83edd33d3   ubuntu:20.04             "/bin/bash"               19 hours ago   Exited (0) 19 hours ago                                         vigilant_euclid
7148e674b2ed   ubuntu:20.04             "/bin/bash"               19 hours ago   Exited (0) 19 hours ago                                         elegant_burnell
74423150804c   ubuntu:20.04             "/bin/bash"               26 hours ago   Exited (255) 19 hours ago                                       charming_bouman
f1a5aeb83045   mysql                    "docker-entrypoint.s…"   4 days ago     Up 18 hours                 0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
929b04ca4b68   watch-fastapi-frontend   "nginx -g 'daemon of…"   7 weeks ago    Exited (255) 2 weeks ago    0.0.0.0:2153->80/tcp                WatchWeb
9dd1c7f8b9cd   watch-fastapi-backend    "uvicorn main:app --…"   7 weeks ago    Exited (255) 2 weeks ago    0.0.0.0:1339->80/tcp                WatchFastAPI
# 当前容器正在运行的镜像列表
(base) lvwei@lvweideMacBook-Pro rustdemo %  docker ps
CONTAINER ID   IMAGE             COMMAND                   CREATED        STATUS        PORTS                               NAMES
2019aa4e114e   fastapitest-app   "uvicorn main:app --…"   18 hours ago   Up 18 hours   0.0.0.0:8081->8081/tcp              newapp
1178ee9492f1   mysql:latest      "docker-entrypoint.s…"   18 hours ago   Up 18 hours   3306/tcp, 33060/tcp                 mysql_1
f1a5aeb83045   mysql             "docker-entrypoint.s…"   5 days ago     Up 18 hours   0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
(base) lvwei@lvweideMacBook-Pro rustdemo % docker image inspect mysql
[
    {
        "Id": "sha256:9c61872d4987a19e0bc9028731b0e94954ffe9c7fafb49f3b41784615da9cd2c",
        "RepoTags": [
            "mysql:latest"
        ],
        "RepoDigests": [
            "mysql@sha256:6057dec95d87a0d7880d9cfc9b3d9292f9c11473a5104b906402a2b73396e377"
        ],
        "Parent": "",
        "Comment": "buildkit.dockerfile.v0",
        "Created": "2023-10-24T16:24:49Z",
        "Container": "",
        "ContainerConfig": {
            "Hostname": "",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": null,
            "Cmd": null,
            "Image": "",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": null
        },
        "DockerVersion": "",
        "Author": "",
        "Config": {
            "Hostname": "",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "3306/tcp": {},
                "33060/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "GOSU_VERSION=1.16",
                "MYSQL_MAJOR=innovation",
                "MYSQL_VERSION=8.2.0-1.el8",
                "MYSQL_SHELL_VERSION=8.0.35-1.el8"
            ],
            "Cmd": [
                "mysqld"
            ],
            "ArgsEscaped": true,
            "Image": "",
            "Volumes": {
                "/var/lib/mysql": {}
            },
            "WorkingDir": "",
            "Entrypoint": [
                "docker-entrypoint.sh"
            ],
            "OnBuild": null,
            "Labels": null
        },
        "Architecture": "arm64",
        "Os": "linux",
        "Size": 627965221,
        "VirtualSize": 627965221,
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/4fba45e34e4248be3c525b4c8a5c073dfefc288b6cc08b1b226984e4d5a8d279/diff:/var/lib/docker/overlay2/71a5c1d217c5da325c94d8f01632033cce52c54e68245ce93d74209b6ea2f9fb/diff:/var/lib/docker/overlay2/6f4ca247e1e8772f2a152fa31ec005dc808b4f8c4f889e84d4c9f7a956ec202e/diff:/var/lib/docker/overlay2/b7a0d9223aafbc5f176e4e77156d69a3f1e83e6471b312ae202411b4e31e25a7/diff:/var/lib/docker/overlay2/7f4eca4a5973cf32f04988aec2ed80ec0378935d5fdaccaad398acea1ef30b84/diff:/var/lib/docker/overlay2/9612c4e5bec47df2202f5ee585ed12da6e0b17bb83dfa05a2a441db8ee74c0be/diff:/var/lib/docker/overlay2/bbdd3abc20bc7ead974f26b24585b05680620e3cb78a24714fa0e62cb45da52f/diff:/var/lib/docker/overlay2/427e54d37d6490d62007906128e98d863d5a36e82bc289f396c873cf09319537/diff:/var/lib/docker/overlay2/91514ee79b196473eb3c6582455ef3ef3f2745529a55ccbdf4e3d0b077327611/diff",
                "MergedDir": "/var/lib/docker/overlay2/69324e474955614322988c6fb2db9c4dbeee4c5f829f709b218da6c513a731a6/merged",
                "UpperDir": "/var/lib/docker/overlay2/69324e474955614322988c6fb2db9c4dbeee4c5f829f709b218da6c513a731a6/diff",
                "WorkDir": "/var/lib/docker/overlay2/69324e474955614322988c6fb2db9c4dbeee4c5f829f709b218da6c513a731a6/work"
            },
            "Name": "overlay2"
        },
        "RootFS": {
            "Type": "layers",
            "Layers": [
                "sha256:1f031b71c95636034780ae0fbb7c1a43c0e038cc1263a0fa0323ee0c32eac95a",
                "sha256:1442201c1ce7c97abc20aee2839c72187c50f2fc9f2ecaeab47168460c246ff0",
                "sha256:c90bc0aec28ce5ecadc57e6a6503cf41ac3318686d1d04a881881ea22153e657",
                "sha256:1382f2eca5973555c7745317ed22c288fa8b755a6f0c2cf44f4f4714fcddd832",
                "sha256:19160d7b55ac54b57e4a91f41bc9955569a38452a084a490d6eefa924eb62805",
                "sha256:3d9c228a8836644503fbc623fa6b8d63a12b9ed96ea06e6212d404e7796a034b",
                "sha256:7ca9c182461617fdb20a4b50cfc76f076820001b06d580eaa46096f8ce48f993",
                "sha256:1010443133268a199076a271ed3149cdeef0b31aad0f986100bdc89ec6c24ac2",
                "sha256:73a1a8ae11f638b960a5dab90891cbe46d757dc368dffe043463392db58f4b90",
                "sha256:4ce33419470e97d6ad8e9dba6daf201b76c6ad4402010952ef1686cb8009e0f5"
            ]
        },
        "Metadata": {
            "LastTagTime": "0001-01-01T00:00:00Z"
        }
    }
]
(base) lvwei@lvweideMacBook-Pro rustdemo % 


```

### 11.docker 查看镜像的创建历史

命令：docker history imagename

```terminal
(base) lvwei@lvweideMacBook-Pro rustdemo % docker history mysql
IMAGE          CREATED       CREATED BY                                       SIZE      COMMENT
9c61872d4987   7 weeks ago   CMD ["mysqld"]                                   0B        buildkit.dockerfile.v0
<missing>      7 weeks ago   EXPOSE map[3306/tcp:{} 33060/tcp:{}]             0B        buildkit.dockerfile.v0
<missing>      7 weeks ago   ENTRYPOINT ["docker-entrypoint.sh"]              0B        buildkit.dockerfile.v0
<missing>      7 weeks ago   COPY docker-entrypoint.sh /usr/local/bin/ # …   14.2kB    buildkit.dockerfile.v0
<missing>      7 weeks ago   VOLUME [/var/lib/mysql]                          0B        buildkit.dockerfile.v0
<missing>      7 weeks ago   RUN /bin/sh -c set -eux;  microdnf install -…   290MB     buildkit.dockerfile.v0
<missing>      7 weeks ago   ENV MYSQL_SHELL_VERSION=8.0.35-1.el8             0B        buildkit.dockerfile.v0
<missing>      7 weeks ago   RUN /bin/sh -c set -eu;  . /etc/os-release; …   215B      buildkit.dockerfile.v0
<missing>      7 weeks ago   RUN /bin/sh -c set -eux;  microdnf install -…   197MB     buildkit.dockerfile.v0
<missing>      7 weeks ago   RUN /bin/sh -c set -eu;  . /etc/os-release; …   246B      buildkit.dockerfile.v0
<missing>      7 weeks ago   ENV MYSQL_VERSION=8.2.0-1.el8                    0B        buildkit.dockerfile.v0
<missing>      7 weeks ago   ENV MYSQL_MAJOR=innovation                       0B        buildkit.dockerfile.v0
<missing>      7 weeks ago   RUN /bin/sh -c set -eux;  key='859BE8D7C586F…   3.17kB    buildkit.dockerfile.v0
<missing>      7 weeks ago   RUN /bin/sh -c set -eux;  microdnf install -…   14MB      buildkit.dockerfile.v0
<missing>      7 weeks ago   RUN /bin/sh -c set -eux;  arch="$(uname -m)"…   2.4MB     buildkit.dockerfile.v0
<missing>      7 weeks ago   ENV GOSU_VERSION=1.16                            0B        buildkit.dockerfile.v0
<missing>      7 weeks ago   RUN /bin/sh -c set -eux;  groupadd --system …   2.77kB    buildkit.dockerfile.v0
<missing>      7 weeks ago   /bin/sh -c #(nop)  CMD ["/bin/bash"]             0B        
<missing>      7 weeks ago   /bin/sh -c #(nop) ADD file:f5ee75151bd25b33e…   125MB     
(base) lvwei@lvweideMacBook-Pro rustdemo % 

```

### 12.docker构建镜像

命令：

    # 构建镜像命令，文件在当前目录下且文件名是Dockerfile可以不写-f指定
    # 最后的 . 代表本次执行的上下文路径是当前路径，是指 docker 在构建镜像，有时候想要使用到本机的文件（比如复制），docker build 命令得知这个路径后，会将路径下的所有内容打包。
    # 上下文路径下不要放无用的文件，因为会一起打包发送给 docker 引擎，如果文件过多会造成过程缓慢。
    docker build -f dockerfile文件路径 -t 镜像名:[tag] .

### 13.docker导出镜像

命令：

    docker save [OPTIONS] IMAGE [IMAGE...]

```terminal
(base) lvwei@lvweideMacBook-Pro rustdemo %  docker save mysql -o mysql/mysql.tar
(base) lvwei@lvweideMacBook-Pro rustdemo % ls
HelloWorld	hello		mysql		mysql.tar	nginx.tar
(base) lvwei@lvweideMacBook-Pro rustdemo % cd mysql
(base) lvwei@lvweideMacBook-Pro mysql % ls
mysql.tar
```

### 14.docker

命令：

    docker pull [OPTIONS] NAME[:TAG|@DIGEST]

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
root@74
```

## 二.docker网络

### 1.docker网络简介

Docker网络的实现主要是依赖Linux网络有关的技术，这些技术有网络命名空间（Network Namespace）、Veth设备对、网桥、ipatables和路由。

（1）网络命名空间，实现网络隔离。

（2）Veth设备对，实现不同网络命名空间之间的通信。

（3）网桥，实现不同网络之间通信。

（4）ipatables，实现对数据包进行过滤和转发。

（5）路由，决定数据包到底发送到哪里。

### 2.网络模式

运行容器时，你可以使用该-–net标志来指定容器应连接到哪些网络

#### host模式
    使用 --net=host 指定,容器和宿主机共用一个Network Namespace。容器将使用宿主机的网络。

#### none模式
    使用 --net=none指定,没有网络的意思。

#### container模式

    使用 --net=container:容器名称或者ID 指定。
    container模式，当前容器和指定容器共用一个Network Namespace。当前容器将使用指定容器的网络。

#### bridge模式
    使用 --net=bridge 指定，默认设置。
    bridge模式，桥接模式，默认的模式。

```terminal

(base) lvwei@lvweideMacBook-Pro mysql % docker network ls
NETWORK ID     NAME                    DRIVER    SCOPE
b711222d5d67   bridge                  bridge    local
a84d064e7e5c   fastapitest_default     bridge    local
2cb92de19cfb   host                    host      local
297e60829047   mynet                   bridge    local
5fe1043d059a   none                    null      local
92c6bf939fc1   watch-fastapi_default   bridge    local
(base) lvwei@lvweideMacBook-Pro mysql % 

```
