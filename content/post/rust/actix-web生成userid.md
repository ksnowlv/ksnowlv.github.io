---
title: "Actix Web生成userid"
date: 2024-02-10T21:47:41+08:00
lastmod: 2024-02-10T21:47:41+08:00
keywords: ["rust","Actix Web", "后端开发"]
tags: ["rust","Actix Web", "后端开发"]
categories: ["rust", "Actix Web", "后端开发"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Actix-Web生成userid

通常涉及几种策略，如 UUID、递增ID、数据库自增字段等。

我们采用uuid方案， 唯一性高，不依赖数据库，可以在任何地方生成；

### 1.添加依赖

```rust
[dependencies]
uuid = "1.7"
```

### 2.创建uuid生成器
添加文件userid_generator.rs

```rust
use uuid::Uuid;

pub async fn generate_user_id() -> String {
	return  Uuid::new_v4().to_string();
}

```

### 3.使用

```rust
use crate::models::userid_generator::{generate_user_id};
let user_id = generate_user_id().await;
```
