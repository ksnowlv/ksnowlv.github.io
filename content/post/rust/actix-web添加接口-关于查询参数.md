---
title: "Actix Web添加接口-关于查询参数"
date: 2024-02-12T22:07:54+08:00
lastmod: 2024-02-12T22:07:54+08:00
keywords: ["actix web", "rust", "接口查询参数"]
tags: ["actix web", "rust"]
categories: ["actix web", "rust"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Actix Web添加接口-关于查询参数

### 1.路由中定义一个带有路径参数的处理函数

```rust

#[derive(Debug, Deserialize)]
pub struct TokenQuery {
	pub token: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct UserRegisterInfo {
	pub name: String,
	pub age: i32,
	pub phone: String,
	pub verification_code: String,
}

pub async fn update(query: Query<TokenQuery>, info: web::Json<UserRegisterInfo>) -> impl Responder {
	match get_user_by_token(&get_pool(), &query.token).await {
		Ok(Some(mut user)) => {
			match update_user(&get_pool(), &info, &user.userid).await {
				Ok(()) => api_response::ok_handler(Some(user), Some("更新成功".to_string())).await,
				Err(sqlx::Error::RowNotFound) => api_response::notfound_handler::<String>("未找到该用户，请检查更新的账号是否正确？").await,
				Err(_) => api_response::error_handler::<String>("未知错误".to_string().as_str()).await,
			}
		},
		Ok(None) => api_response::notfound_handler::<String>("未找到该用户，请检查更新的账号是否正确？").await,
		Err(e) => api_response::error_handler::<String>(e.to_string().as_str()).await,
	}
}

```

### 2.接口测试

#### 接口

https://127.0.0.1:8080/api/user/update?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI1NGRlNzI4ZC1mZjc2LTRiN2EtOWI4YS02OWE4MWJhOGMyMGYiLCJleHAiOjE3MDc2NTk3MDZ9.KkXOCt2DUROZcU3XaIDQwIgYbMcyxdea2l0-WYnQ1S4

#### 接口body
postman或apipost中选择raw中的json选项

```json
{
"name": "abc",
"phone": "xxx",
"verification_code": "123456",
"age": 20
}
```

### 3.小结

注意接口参数query: Query<TokenQuery>，不要选择query:String，不然会出现404.




