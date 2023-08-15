---
title: "Mac下杀死占用某个端口的进程"
date: 2014-08-20
lastmod: 2014-08-20
categories:
  - "Mac"
tags:
  - "Mac"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

`Mac`下启动`nginx`服务时，经常会遇见到端口被占用的情况。

如何杀死占用相应端口的进程呢？


### 1.查看占用该端口的进程

格式:**lsof -i:port**   port:端口号

### 2.杀死进程
格式:**kill PID**   PID:进程的PID

### 3.示例
    ksnowlv@ksnowlvdeMacBook-Pro~$lsof -i:80
    COMMAND    PID    USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
    com.apple  640 ksnowlv   13u  IPv4 0x5c463434d35d8295      0t0  TCP 10.68.187.236:56236->117.79.146.98:http (ESTABLISHED)
    com.apple  640 ksnowlv   15u  IPv4 0x5c463434d3534295      0t0  TCP 10.68.187.236:56237->117.79.146.98:http (ESTABLISHED)
    com.apple  640 ksnowlv   16u  IPv4 0x5c463434d3534295      0t0  TCP 10.68.187.236:56237->117.79.146.98:http (ESTABLISHED)
    com.apple  640 ksnowlv   17u  IPv4 0x5c463434cb37aa7d      0t0  TCP 10.68.187.236:56239->117.79.146.98:http (ESTABLISHED)
    com.apple  640 ksnowlv   19u  IPv4 0x5c463434cb369a7d      0t0  TCP 10.68.187.236:56238->202.102.85.61:http (ESTABLISHED)
    com.apple  640 ksnowlv   20u  IPv4 0x5c463434d35d8295      0t0  TCP 10.68.187.236:56236->117.79.146.98:http (ESTABLISHED)
    com.apple  640 ksnowlv   22u  IPv4 0x5c463434cb37aa7d      0t0  TCP 10.68.187.236:56239->117.79.146.98:http (ESTABLISHED)
    com.apple  640 ksnowlv   24u  IPv4 0x5c463434cb369a7d      0t0  TCP 10.68.187.236:56238->202.102.85.61:http (ESTABLISHED)
    com.apple  640 ksnowlv   26u  IPv4 0x5c463434cb369295      0t0  TCP 10.68.187.236:56242->103.245.222.134:http (ESTABLISHED)
    com.apple  640 ksnowlv   28u  IPv4 0x5c463434d443b295      0t0  TCP 10.68.187.236:56241->117.79.146.98:http (ESTABLISHED)
    com.apple  640 ksnowlv   30u  IPv4 0x5c463434d443b295      0t0  TCP 10.68.187.236:56241->117.79.146.98:http (ESTABLISHED)
    com.apple  640 ksnowlv   31u  IPv4 0x5c463434cb369295      0t0  TCP 10.68.187.236:56242->103.245.222.134:http (ESTABLISHED)
    AliWangwa 2170 ksnowlv   13u  IPv4 0x5c463434d35faa7d      0t0  TCP 10.68.187.236:56234->203.208.49.174:http (ESTABLISHED)
    AliWangwa 2170 ksnowlv   15u  IPv4 0x5c463434d35faa7d      0t0  TCP 10.68.187.236:56234->203.208.49.174:http (ESTABLISHED)
    ksnowlv@ksnowlvdeMacBook-Pro~$kill 2170
    ksnowlv@ksnowlvdeMacBook-Pro~$kill 640
    ksnowlv@ksnowlvdeMacBook-Pro~$lsof -i:80
    ksnowlv@ksnowlvdeMacBook-Pro~$