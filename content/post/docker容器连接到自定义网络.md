---
title: "docker容器连接到自定义网络"
date: 2023-12-12T19:47:52+08:00
lastmod: 2023-12-12T19:47:52+08:00
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

## docker容器连接到自定义网络


Docker中不同的容器如何通信呢？


#### 使用容器名称或主机名进行通信
Docker 默认会为容器分配一个唯一的名称，你可以使用这个名称来访问其他容器。例如，如果一个容器名为 "container1"，你可以在其他容器中使用 "container1" 作为主机名来访问它。

#### 使用容器 IP 地址进行通信
每个容器都有自己独立的 IP 地址。你可以使用容器的 IP 地址来访问其他容器。但是，容器的 IP 地址可能会发生变化，特别是在容器重新启动后。因此，这不是最推荐的方法。

#### 使用自定义网络
你可以创建一个自定义网络，并将多个容器连接到该网络中。这样，这些容器就可以通过容器名称（作为主机名）相互访问。这种方法更方便，因为容器名称不会发生变化，并且自定义网络提供了容器间的 DNS 解析。

#### 使用连接器（Linking）

尽管这种方法在 Docker 中已不推荐使用，但在早期版本中很常见。通过运行容器时的 --link 参数，你可以将一个容器连接到另一个容器，并允许容器之间进行通信。然而，现在使用自定义网络更加推荐，因为连接器已被弃用。


以FastAPI容器和mysql容器为例，FastAPI通过使用自定义网络访问mysql。

### 1.创建自定义网络

    docker network create mynet

### 2.MySQL容器连接到自定义网络,重启使网络生效

* MySQL容器连接到自定义网络

        docker network connect mynet mysql


* 重新启动mysql容器，以使其重新应用网络连接的更改
        
        docker restart mysql

```terminal
(base) lvwei@lvweideMacBook-Pro rustdemo % docker network connect mynet mysql
(base) lvwei@lvweideMacBook-Pro rustdemo % docker restart mysql
mysql
(base) lvwei@lvweideMacBook-Pro rustdemo % docker ps
CONTAINER ID   IMAGE          COMMAND                   CREATED          STATUS          PORTS                               NAMES
1178ee9492f1   mysql:latest   "docker-entrypoint.s…"   20 minutes ago   Up 20 minutes   3306/tcp, 33060/tcp                 mysql_1
f1a5aeb83045   mysql          "docker-entrypoint.s…"   4 days ago       Up 6 seconds    0.0.0.0:3306->3306/tcp, 33060/tcp   mysql

```

### 3.fastapi连接到自定义网络,重启fastapi服务

```terminal
(base) lvwei@lvweideMacBook-Pro rustdemo % docker network connect mynet newapp
(base) lvwei@lvweideMacBook-Pro rustdemo % docker restart newapp              
newapp
(base) lvwei@lvweideMacBook-Pro rustdemo % docker network inspect mynet       
[
    {
        "Name": "mynet",
        "Id": "297e608290472a23fec759a75e6b323771773d7bcfbaada11aa0c9fd285d8a76",
        "Created": "2023-12-08T05:42:23.346429009Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.20.0.0/16",
                    "Gateway": "172.20.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "1178ee9492f132618c7ee39892de10a22afa237d1e85583b9fe02302397eada0": {
                "Name": "mysql_1",
                "EndpointID": "8d8462243ff73c8529d6a7a63c18534a0a1d280a167a930328f58c522e8b6d83",
                "MacAddress": "02:42:ac:14:00:02",
                "IPv4Address": "172.20.0.2/16",
                "IPv6Address": ""
            },
            "2019aa4e114e42bbbf594341a5d8bcb95ec463150c738e467fab51e2f34181e7": {
                "Name": "newapp",
                "EndpointID": "1d3796871a9edd6a3c4d7b55fd4bb17b4e3b889dffcf1b4b84f18b209c87742e",
                "MacAddress": "02:42:ac:14:00:04",
                "IPv4Address": "172.20.0.4/16",
                "IPv6Address": ""
            },
            "f1a5aeb830455e93b4e31933f78c282a15ef13247dfcfbd7f98a9da825fe5d6e": {
                "Name": "mysql",
                "EndpointID": "110be5353f54e8cd2db9fdbbf904e0e027b963e4ca54486715a41355348de2d8",
                "MacAddress": "02:42:ac:14:00:03",
                "IPv4Address": "172.20.0.3/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```

连接到mynet的容器有mysql_1，newapp，mysql
