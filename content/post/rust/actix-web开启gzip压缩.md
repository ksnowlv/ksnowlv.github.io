---
title: "Actix Web开启gzip压缩"
date: 2024-02-09T21:40:13+08:00
lastmod: 2024-02-09T21:40:13+08:00
keywords: ["rust", "Actix Web", "后端开发", "gzip"]
tags: ["rust", "Actix Web", "后端开发"]
categories: ["rust", "Actix Web", "后端开发"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 

### 1.添加gzip引用

```rust
use actix_web::middleware::Compress;
```

### 2.接口开启gzip压缩

```rust
       App::new().service(scope("/api/v1/swagger")
            .wrap(middleware::Logger::default())
            .wrap(logging_middleware::Logging)
            .wrap(Compress::default())
            .configure(user_routes).route("/{value}", web::get().to(index))
    });

```

### 3.gzip压缩验证

![image](/images/rust/actix-web开启gzip压缩/http_gzip.jpg)
