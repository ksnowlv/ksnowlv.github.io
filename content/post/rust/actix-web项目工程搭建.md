---
title: "Actix Web项目工程搭建"
date: 2024-01-31T18:45:30+08:00
lastmod: 2024-01-31T18:45:30+08:00
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

## Actix-web项目

使用Actix-web创建actix-web-app工程
### 1.目录结构划分

actix-web-app \
---src \
------cache \
---------mod.rs \
------config \
---------mod.rs \
------db \
---------mod.rs \
------handlers \
---------mod.rs \
------middleware \
---------mod.rs \
------models \
---------mod.rs \
------main.rs \
---Cargo.toml \
---Cargo.lock 

### 2.目录说明
* cache:缓存相关
* config:项目配置
* db:数据库交互
* handlers:请求的处理器
* middleware:中间件相关
* models:数据模型

### 3.添加路由

以user用例

* 1.添加user_handles.rs(handlers目录下)

```rust
use actix_web::{web, HttpResponse, Responder };

pub fn user_routes(cfg: &mut web::ServiceConfig) {
    cfg.service(web::scope("/user")
            .route("/login", web::get().to(login))
            .route("/regist", web::get().to(regist))
            .route("/get_sms_code", web::get().to(get_sms_code))
            .route("/update", web::get().to(update))
            .route("/delete", web::get().to(delete))
            );
}

pub  async fn  get_user() -> impl Responder{
    let user = User{id:1, user_id: "abc".to_string(), phone: "15210".to_string(), age: 10, name:"ksnowlv".to_string(), token:"aaaa".to_string(), sms_code:"123456".to_string()};
    HttpResponse::Ok().json(user)
}

pub async fn regist() -> impl Responder {
    HttpResponse::Ok().body("regist successfully")
}

pub async fn login() -> impl Responder {
    HttpResponse::Ok().body("login successfully")
}

pub async fn get_sms_code() -> impl Responder {
    HttpResponse::Ok().body("get_sms_code successfully")
}

pub async fn update() -> impl Responder {
    HttpResponse::Ok().body("user updated successfully")
}

pub async fn delete() -> impl Responder {
    HttpResponse::Ok().body("delete user successfully")
}
```

* 2.mod.rs(handlers目录下)

添加user_handler模块外部可见

```rust
pub mod user_handler;
```

### 4.app使用路由

```rust
use actix_web::{web, App, HttpServer, Responder, HttpResponse};
use crate::handlers::user_handler::user_routes;

mod handlers;
mod models;
mod db;
mod cache;
mod config;
mod middleware;


async fn index() -> impl Responder {
    HttpResponse::Ok().body("Hello, Actix-web!")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .configure(user_routes)

    })
        .bind("127.0.0.1:8080")?
        .run()
        .await
}
```


### 5.接口测试
注意接口路径，5个接口测试通过

* 1.http://127.0.0.1:8080/user/login
* 2.http://127.0.0.1:8080/user/regist
* 3.http://127.0.0.1:8080/user/get_sms_code
* 4.http://127.0.0.1:8080/user/update
* 5.http://127.0.0.1:8080/user/delete


