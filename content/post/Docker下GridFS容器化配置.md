---
title: "Docker下GridFS容器化配置"
date: 2023-12-18T14:51:39+08:00
lastmod: 2023-12-18T14:51:39+08:00
keywords: ["Mac", "Docker", "GridFS"]
tags: ["Mac", "Docker", "GridFS"]
categories: ["Mac", "Docker", "GridFS"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Mac Docker下GridFS容器化配置

### 1.启动Docker,拉取MongoDB镜像
终端下使用**docker pull mongo**命令摘取MongoDB镜像

```terminal
(base) lvwei@lvweideMacBook-Pro mysql % docker pull mongo
Using default tag: latest
latest: Pulling from library/mongo
005e2837585d: Pull complete 
e60b3ed21100: Pull complete 
81fcf60fea85: Pull complete 
ea5bd96d017e: Pull complete 
b08ff5e0599a: Pull complete 
f069ac5b7852: Pull complete 
acd1af47c587: Pull complete 
0bbdd9420f1d: Pull complete 
33f87a23bbf7: Pull complete 
Digest: sha256:5aa96e3cd219086c540c95ccc4554ff8aa86861628dc565d0ef4b32573e5c7b9
Status: Downloaded newer image for mongo:latest
docker.io/library/mongo:latest

What's Next?
  View a summary of image vulnerabilities and recommendations → docker scout quickview mongo
(base) lvwei@lvweideMacBook-Pro fastapitest % docker ps -a     
CONTAINER ID   IMAGE                    COMMAND                   CREATED          STATUS                     PORTS                               NAMES
e7f94f8f7c10   mongo                    "docker-entrypoint.s…"   56 minutes ago   Up 53 minutes              0.0.0.0:27017->27017/tcp            mongodb
2019aa4e114e   38660250eb0c             "uvicorn main:app --…"   5 days ago       Exited (0) 3 minutes ago                                       newapp
1178ee9492f1   mysql:latest             "docker-entrypoint.s…"   5 days ago       Up 5 days                  3306/tcp, 33060/tcp                 mysql_1
38d83edd33d3   ubuntu:20.04             "/bin/bash"               5 days ago       Exited (0) 5 days ago                                          vigilant_euclid
7148e674b2ed   ubuntu:20.04             "/bin/bash"               5 days ago       Exited (0) 5 days ago                                          elegant_burnell
74423150804c   ubuntu:20.04             "/bin/bash"               6 days ago       Exited (255) 5 days ago                                        charming_bouman
f1a5aeb83045   mysql                    "docker-entrypoint.s…"   10 days ago      Up 5 days                  0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
929b04ca4b68   watch-fastapi-frontend   "nginx -g 'daemon of…"   8 weeks ago      Exited (255) 3 weeks ago   0.0.0.0:2153->80/tcp                WatchWeb
9dd1c7f8b9cd   watch-fastapi-backend    "uvicorn main:app --…"   8 weeks ago      Exited (255) 3 weeks ago   0.0.0.0:1339->80/tcp                WatchFastAPI

```

mongodb的镜像已生成

### 2.启动mongodb

终端运行以下命令来创建并启动MongoDB容器

    docker run -d -p 27017:27017 --name mongodb -v /path/to/gridfs/data:/data/db mongo
/path/to/gridfs/data替换为你想要将GridFS数据文件存储在本地的目录路径。这将会在本地创建一个目录，在其中存储GridFS的数据文件。

#### 关于GridFS数据文件的本地目录路径

 确定要存储GridFS数据文件的本地目录路径。例如，假设你想将GridFS数据文件存储在/Users/yourusername/gridfsdata目录
 命令行中使用以下命令来启动MongoDB容器并挂载GridFS数据目录

    docker run -d -p 27017:27017 --name mongodb -v /Users/lvwei/gridfsdata:/data/db mongo

启动后，设置mongodb容器连接mynet的网络

    docker network connect mynet mongodb
    docker restart  mongodb


```terminal
(base) lvwei@lvweideMacBook-Pro mysql % docker run -d -p 27017:27017 --name mongodb -v /Users/lvwei/gridfsdata:/data/db mongo
e7f94f8f7c1055e5e09fd453e63c08837125cc3168b1f8698077af3c52f02b76
(base) lvwei@lvweideMacBook-Pro mysql % docker ps                                                                            
CONTAINER ID   IMAGE             COMMAND                   CREATED              STATUS              PORTS                               NAMES
e7f94f8f7c10   mongo             "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:27017->27017/tcp            mongodb
2019aa4e114e   fastapitest-app   "uvicorn main:app --…"   5 days ago           Up 5 days           0.0.0.0:8081->8081/tcp              newapp
1178ee9492f1   mysql:latest      "docker-entrypoint.s…"   5 days ago           Up 5 days           3306/tcp, 33060/tcp                 mysql_1
f1a5aeb83045   mysql             "docker-entrypoint.s…"   10 days ago          Up 5 days           0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
(base) lvwei@lvweideMacBook-Pro mysql % docker network connect mynet mongodb
(base) lvwei@lvweideMacBook-Pro mysql % docker restart  mongodb             
mongodb
(base) lvwei@lvweideMacBook-Pro fastapitest % docker inspect mongodb
[
    {
        "Id": "e7f94f8f7c1055e5e09fd453e63c08837125cc3168b1f8698077af3c52f02b76",
        "Created": "2023-12-18T05:48:40.451509003Z",
        "Path": "docker-entrypoint.sh",
        "Args": [
            "mongod"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 59164,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2023-12-18T05:51:34.713422542Z",
            "FinishedAt": "2023-12-18T05:51:34.346934167Z"
        },
        "Image": "sha256:9c24e0cf03484386bb145f1f7b272a56d183c88aa9202060834d674628bf70e8",
        "ResolvConfPath": "/var/lib/docker/containers/e7f94f8f7c1055e5e09fd453e63c08837125cc3168b1f8698077af3c52f02b76/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/e7f94f8f7c1055e5e09fd453e63c08837125cc3168b1f8698077af3c52f02b76/hostname",
        "HostsPath": "/var/lib/docker/containers/e7f94f8f7c1055e5e09fd453e63c08837125cc3168b1f8698077af3c52f02b76/hosts",
        "LogPath": "/var/lib/docker/containers/e7f94f8f7c1055e5e09fd453e63c08837125cc3168b1f8698077af3c52f02b76/e7f94f8f7c1055e5e09fd453e63c08837125cc3168b1f8698077af3c52f02b76-json.log",
        "Name": "/mongodb",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": [
                "/Users/lvwei/gridfsdata:/data/db"
            ],
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {
                "27017/tcp": [
                    {
                        "HostIp": "",
                        "HostPort": "27017"
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
                39,
                145
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
                "LowerDir": "/var/lib/docker/overlay2/4294d9987f2300e5c5d1ec6bcc0e9d2b2cf5c32bfe383d9b82f1f47683eb9fab-init/diff:/var/lib/docker/overlay2/a63471060024bcc9afc7545943b6db3d01ae3f0eeeb3b2b9dd8ee502a2156438/diff:/var/lib/docker/overlay2/ad1c3f38c568d7a69bc03b266b72642882715d46530932b4b18b1d3954db7166/diff:/var/lib/docker/overlay2/4ab00fc440a3d8b6ce3617082696ece4773d1e77a67b54273dcfdc0d024e0322/diff:/var/lib/docker/overlay2/f1ed5ede51937490225bb270e9d7b14a4f6ff31b2e9fc2e93dd05bdaf2f332cf/diff:/var/lib/docker/overlay2/b4bb71741a4d2aef75c352b601b88211fb58c61b394022f5dbae9afd17f57812/diff:/var/lib/docker/overlay2/d430ee9134e6d6c7b704667696c2d4312c224f41a5bdedf89a31882ce8adfc5c/diff:/var/lib/docker/overlay2/41760377a9777186983edd798b5d2c8794f6b2e77412af7c7fb1a5eaadc14a0f/diff:/var/lib/docker/overlay2/04c40361418677abff0275a2b2bcab6e4ccd4f02baa5df233dc63bbe5cfe75c1/diff:/var/lib/docker/overlay2/3e0ffb0628079671a40d3050aa85bf541b61aac8a4fe45a06bbf8c11dde938b4/diff",
                "MergedDir": "/var/lib/docker/overlay2/4294d9987f2300e5c5d1ec6bcc0e9d2b2cf5c32bfe383d9b82f1f47683eb9fab/merged",
                "UpperDir": "/var/lib/docker/overlay2/4294d9987f2300e5c5d1ec6bcc0e9d2b2cf5c32bfe383d9b82f1f47683eb9fab/diff",
                "WorkDir": "/var/lib/docker/overlay2/4294d9987f2300e5c5d1ec6bcc0e9d2b2cf5c32bfe383d9b82f1f47683eb9fab/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [
            {
                "Type": "bind",
                "Source": "/Users/lvwei/gridfsdata",
                "Destination": "/data/db",
                "Mode": "",
                "RW": true,
                "Propagation": "rprivate"
            },
            {
                "Type": "volume",
                "Name": "8487ef9fa577527ccc8b6e5c62378b56ba5cc3da91c1f69410d44e1693f6635e",
                "Source": "/var/lib/docker/volumes/8487ef9fa577527ccc8b6e5c62378b56ba5cc3da91c1f69410d44e1693f6635e/_data",
                "Destination": "/data/configdb",
                "Driver": "local",
                "Mode": "",
                "RW": true,
                "Propagation": ""
            }
        ],
        "Config": {
            "Hostname": "e7f94f8f7c10",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "27017/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "GOSU_VERSION=1.16",
                "JSYAML_VERSION=3.13.1",
                "MONGO_PACKAGE=mongodb-org",
                "MONGO_REPO=repo.mongodb.org",
                "MONGO_MAJOR=7.0",
                "MONGO_VERSION=7.0.4",
                "HOME=/data/db"
            ],
            "Cmd": [
                "mongod"
            ],
            "Image": "mongo",
            "Volumes": {
                "/data/configdb": {},
                "/data/db": {}
            },
            "WorkingDir": "",
            "Entrypoint": [
                "docker-entrypoint.sh"
            ],
            "OnBuild": null,
            "Labels": {
                "org.opencontainers.image.ref.name": "ubuntu",
                "org.opencontainers.image.version": "22.04"
            }
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "248979e4050804aaa00fdddd72085b6b855a0488ce4c86ab4a5e8c0f5f42bae5",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {
                "27017/tcp": [
                    {
                        "HostIp": "0.0.0.0",
                        "HostPort": "27017"
                    }
                ]
            },
            "SandboxKey": "/var/run/docker/netns/248979e40508",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "c28b4ec4c4211303dd29ca2a8c6f93e8729fe94d6c95c6d8a044f3e4a8f7f5af",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.2",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "02:42:ac:11:00:02",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "b711222d5d67c7959ea55f9224a8246f92de2123e006b88f52792a67a4fa857a",
                    "EndpointID": "c28b4ec4c4211303dd29ca2a8c6f93e8729fe94d6c95c6d8a044f3e4a8f7f5af",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null
                },
                "mynet": {
                    "IPAMConfig": {},
                    "Links": null,
                    "Aliases": [
                        "e7f94f8f7c10"
                    ],
                    "NetworkID": "297e608290472a23fec759a75e6b323771773d7bcfbaada11aa0c9fd285d8a76",
                    "EndpointID": "ed9f3f283d2364c13c9c67ee1a2487febac2a3ddf7331268ea46394f0b79af90",
                    "Gateway": "172.20.0.1",
                    "IPAddress": "172.20.0.5",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:14:00:05",
                    "DriverOpts": {}
                }
            }
        }
    }
]
(base) lvwei@lvweideMacBook-Pro fastapitest % 

```

### 3.工程更改GridFS的配置

Docker容器之间的连接，通常应该使用Docker的服务名称而不是localhost来指定主机名。在这里，应该将MongoDB服务器地址设为Docker容器的名称，即mongodb，而不是localhost。

由 client = MongoClient('mongodb://localhost:27017/')更换为client = MongoClient('mongodb://mongodb:27017/')

### 4.fastapi工程重新打包镜像,并启动容器

在工程目录下，使用docker build打包，然后停止并删除fastapi容器，然后重新启动fastapi容器。

```terminal
(base) lvwei@lvweideMacBook-Pro fastapitest %  docker build -t fastapitest-app .


[+] Building 79.3s (9/9) FINISHED                                                                                           docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                                        0.0s
 => => transferring dockerfile: 404B                                                                                                        0.0s
 => [internal] load .dockerignore                                                                                                           0.0s
 => => transferring context: 2B                                                                                                             0.0s
 => [internal] load metadata for docker.io/library/python:3.11                                                                              5.9s
 => [1/4] FROM docker.io/library/python:3.11@sha256:c0c5e12cd9fe77a556dea3bc71a71e16bb2fcb35974ce82215095d4cd279fb93                        0.0s
 => => resolve docker.io/library/python:3.11@sha256:c0c5e12cd9fe77a556dea3bc71a71e16bb2fcb35974ce82215095d4cd279fb93                        0.0s
 => [internal] load build context                                                                                                           0.5s
 => => transferring context: 699.68kB                                                                                                       0.5s
 => CACHED [2/4] WORKDIR /app                                                                                                               0.0s
 => [3/4] COPY . /app                                                                                                                       3.1s
 => [4/4] RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/                                  68.8s
 => exporting to image                                                                                                                      0.9s 
 => => exporting layers                                                                                                                     0.9s 
 => => writing image sha256:8f1064fd222b6fdfe457c7e03abf07f4183840dfc707aeb8a826ac170f9c9397                                                0.0s 
 => => naming to docker.io/library/fastapitest-app                                                                                          0.0s 
                                                                                                                                                 
What's Next?                                                                                                                                     
  View a summary of image vulnerabilities and recommendations → docker scout quickview
(base) lvwei@lvweideMacBook-Pro fastapitest % docker stop newapp                                                       
newapp
(base) lvwei@lvweideMacBook-Pro fastapitest % docker rm newapp  
newapp
(base) lvwei@lvweideMacBook-Pro fastapitest % docker run -d --name fastapp --network mynet -p 8081:8081 fastapitest-app
a85c06841de1ea712d972c6095936209955c38ee73efd959665eb9c58a8aad00
(base) lvwei@lvweideMacBook-Pro fastapitest % docker ps   
CONTAINER ID   IMAGE             COMMAND                   CREATED             STATUS          PORTS                               NAMES
a85c06841de1   fastapitest-app   "uvicorn main:app --…"   11 seconds ago      Up 10 seconds   0.0.0.0:8081->8081/tcp              fastapp
e7f94f8f7c10   mongo             "docker-entrypoint.s…"   About an hour ago   Up 58 minutes   0.0.0.0:27017->27017/tcp            mongodb
1178ee9492f1   mysql:latest      "docker-entrypoint.s…"   5 days ago          Up 5 days       3306/tcp, 33060/tcp                 mysql_1
f1a5aeb83045   mysql             "docker-entrypoint.s…"   10 days ago         Up 5 days       0.0.0.0:3306->3306/tcp, 33060/tcp   mysql

```

### 5.执行效果

在http://127.0.0.1:8081/docs#打开后，在网页上选择文件，并上传

![image](/images/post/docker下GridFS容器化配置/fastapi_gridfs_upload_file.png)

### 6.其它问题

如果使用mongodb://localhost:27017/连接gridFS，则会出现以下异常

    raise ServerSelectionTimeoutError(
    pymongo.errors.ServerSelectionTimeoutError: localhost:27017: [Errno 111] Connection refused (configured timeouts: socketTimeoutMS: 20000.0ms, connectTimeoutMS: 20000.0ms), Timeout: 30s, Topology Description: ]>


原因：

    FastAPI容器连接到MongoDB GridFS容器时，是Docker容器之间的连接，通常应该使用Docker的服务名称而不是localhost来指定主机名。在这里，应该将MongoDB服务器地址设为Docker容器的名称，即mongodb，而不是localhost。
