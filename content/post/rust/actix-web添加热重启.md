---
title: "Actix Web添加热重启"
date: 2024-02-01T22:40:59+08:00
lastmod: 2024-02-01T22:40:59+08:00
keywords: ["rust", "Actix Web", "后端开发"]
tags: ["rust", "Actix Web", "后端开发"]
categories: ["rust", "Actix Web", "后端开发"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Actix Web添加热重启

### 1.添加cargo-watch依赖

```toml
cargo-watch = "8.5.2"
```

### 2.添加watch.sh脚本

```shell
#!/bin/bash
cargo watch -x 'run --bin actix-web-app'

```
注意actix-web-app是应用名称

### 3.clion中设置

可以配置脚本运行actix-web-app

![image](/images/post/actix-web添加热重启/cion_setting.png)