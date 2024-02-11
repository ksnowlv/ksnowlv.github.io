---
title: "Actix Web关于token的生成和校验"
date: 2024-02-11T23:03:10+08:00
lastmod: 2024-02-11T23:03:10+08:00
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
## token的生成和校验

Actix-web中，生成token的常见技术方案包括JSON Web Token（JWT）和基于随机字符串的 token;

### 1.添加依赖

```toml
[dependencies]
jsonwebtoken = "9.2.0"
```


### 2.创建token生成器
添加文件token_generator.rs

```rust
use chrono::Utc;
use jsonwebtoken::Algorithm;
use serde_json::json;
use jsonwebtoken::{decode, encode, Header, Validation, EncodingKey, DecodingKey};
use rand::Rng;
use rand::thread_rng;
use std::time::Duration;
use jsonwebtoken::Algorithm::HS512;
use serde_derive::{Deserialize, Serialize};

pub const TOKEN_SECRET: &str = "123456helloworld*_++";

#[derive(Debug, Serialize, Deserialize)]
pub struct TokenClaims {
	userid: String,
	exp: usize,
}

// 生成一个随机的 jwt_secret 密钥
pub fn generate_jwt_secret() -> String {
	let rng = &mut thread_rng();
	let bytes = rng.gen::<[u8; 32]>();
	base64::encode(&bytes)
}

// 生成一个 JWT token
pub fn generate_jwt_token(user_id: &str, expiration_time: usize) -> Result<String, jsonwebtoken::errors::Error> {
	let claims = TokenClaims {
		userid:user_id.to_string(),
		exp: expiration_time,
	};

	let header = Header::new(Algorithm::HS256);
	encode(&header, &claims, &EncodingKey::from_secret(TOKEN_SECRET.as_ref()))
}

// 验证 JWT token
pub fn validate_jwt_token(token: &str) -> Result<TokenClaims, jsonwebtoken::errors::Error> {
	let decoding_key = DecodingKey::from_secret(TOKEN_SECRET.as_ref());
	let mut  validation= Validation::default();// Algorithm::HS256 指定算法，根据实际使用的算法进行调整
	validation.validate_exp = true;// 启用过期时间验证

	let result = decode::<TokenClaims>(token, &decoding_key, &validation)?;
	Ok(result.claims)
}

```

### 3.使用

```rust

let expiration_time = Utc::now().checked_add_signed(Duration::hours(1)).unwrap().timestamp() as usize;
let token = token_generator::generate_jwt_token( & user.userid, expiration_time).expect("Failed to generate JWT token");
println!("Generated JWT token: {}", token);

// 模拟验证JWT token的过程
match validate_jwt_token( & token) {
    Ok(claims) => {
        println ! ("Token valid. User ID: {}", claims.user_id);
    },
    Err(err) => {
        println ! ("Failed to validate token: {}", err);
    }
}

```
