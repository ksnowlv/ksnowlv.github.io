---
title: "Actix Web添加json支持"
date: 2024-01-31T19:35:34+08:00
lastmod: 2024-01-31T19:35:34+08:00
keywords: ["rust", "Actix Web", "后端开发", "serde"]
tags: ["rust", "Actix Web", "后端开发"]
categories: ["rust", "Actix Web", "后端开发"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### Actix Web添加Json支持

### 1.rust json库

* serde_json
  * Rust中最流行的JSON库之一，可以用于序列化和反序列化JSON数据。它与serde库集成，Rust数据结构和JSON可以互转。

* json-rust
  * 轻量级JSON库，在处理小型JSON数据的时候非常方便，而且易于使用。

* rustc-serialize
  * Rust标准库中的JSON库，提供了对JSON数据的序列化和反序列化支持，但已经被推荐使用serde_json来替代。

* json5-rust
  * 用于解析和序列化JSON5格式数据的Rust库。JSON5是对JSON语法的扩展，可以更加灵活地表示JSON数据。用于配置文件，来解析配置文件。或数据交换，或写作工具中的编辑器

因此，我们选择serde_json。


### 2.Cargo.toml配置

```toml
[dependencies]
serde = "1.0"
serde_derive = "1.0"
```
### 3.代码示例

#### User数据定义
```rust
use serde::{Serialize, Deserialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct User {
    pub id: u32,
    pub user_id: String,
    pub phone: String,
    pub age: u32,
    pub name: String,
    pub token: String,
    pub sms_code: String,
}

``` 

#### 接口引用User

```rust
pub  async fn  get_user() -> impl Responder{
    let user = User{id:1, user_id: "abc".to_string(), phone: "15210".to_string(), age: 10, name:"ksnowlv".to_string(), token:"aaaa".to_string(), sms_code:"123456".to_string()};
    HttpResponse::Ok().json(user)
}
```
