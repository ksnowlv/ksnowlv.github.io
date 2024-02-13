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

#### MyData数据定义
```rust
#[derive(Debug, Serialize, Deserialize)]
struct MyData {
  code: i32,
  message: String,
}

``` 

#### 接口引用MyData

```rust

#[post("/from_json")]
async fn from_json(my_data: web::Json<MyData>) -> impl Responder {
  println!("Received mydata from JSON: {:?}", my_data);
  HttpResponse::Ok().json(my_data)
}

#[post("/to_json")]
async fn to_json() -> impl Responder {
  let my_data = MyData { code: 1, message: "OK".to_string() };
  let json_data = serde_json::to_string(&my_data).unwrap();
  HttpResponse::Ok().body(json_data)
}

```
