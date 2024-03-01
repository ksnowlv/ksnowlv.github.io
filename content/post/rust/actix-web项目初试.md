---
title: "Actix Web项目初试"
date: 2024-01-30T19:04:11+08:00
lastmod: 2024-01-30T19:04:11+08:00
keywords: ["rust", "Actix Web"]
tags: ["rust", "Actix Web"]
categories: ["rust", "Actix Web"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## actix_web初试

### 1.创建actix_web_app工程

Cargo.toml 添加actix-web依赖
```toml
[dependencies]
actix-web = "3.3.2"

```

### 2.main.rs示例代码

```rust
use actix_web::{web, App, HttpServer, Responder, HttpResponse};

async fn index() -> impl Responder {
	HttpResponse::Ok().body("Hello, Actix-web!")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
	HttpServer::new(|| {
		App::new()
			.route("/", web::get().to(index))
	})
		.bind("127.0.0.1:8080")?
		.run()
		.await
}

```

### 3.效果

打开127.0.0.1:8080，效果如下

![image](/images/post/actix-web项目初试/rust_web_app.png)
