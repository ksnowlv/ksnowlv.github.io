---
title: "Actix Web添加日志中间件"
date: 2024-02-03T22:56:15+08:00
lastmod: 2024-02-03T22:56:15+08:00
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

## 日志中间件

日志中间件，用于在处理HTTP请求时记录请求和响应的相关信息。

### 1.添加日志依赖

```toml
log = "0.4.0"
env_logger = "0.9.0"
chrono = "0.4.19"
```

### 2.日志中间件

定义了一个名为Logging的日志中间件结构体，并实现了 Transform trait。这个结构体负责处理中间件的创建和初始化，以便于在应用中使用。

```toml

use std::future::{ready, Ready};
use std::io::Bytes;
use actix_http::body::{MessageBody, to_bytes};
use actix_http::{HttpMessage, StatusCode};
use actix_web::{dev::{forward_ready, Service, ServiceRequest, ServiceResponse, Transform}, Error, HttpResponse, web};
use futures_util::future::LocalBoxFuture;
use futures_util::{FutureExt, StreamExt};
use log::{info, warn, debug};


pub struct Logging;

// Middleware factory is `Transform` trait
// `S` - type of the next service
// `B` - type of response's body
impl<S, B> Transform<S, ServiceRequest> for Logging
	where
		S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
		S::Future: 'static,
		B: 'static,
{
	type Response = ServiceResponse<B>;
	type Error = Error;
	type InitError = ();
	type Transform = LoggingMiddleware<S>;
	type Future = Ready<Result<Self::Transform, Self::InitError>>;

	fn new_transform(&self, service: S) -> Self::Future {
		ready(Ok(LoggingMiddleware { service }))
	}
}

pub struct LoggingMiddleware<S> {
	service: S,
}

impl<S, B> Service<ServiceRequest> for LoggingMiddleware<S>
	where
		S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
		S::Future: 'static,
		B: 'static,
{
	type Response = ServiceResponse<B>;
	type Error = Error;
	type Future = LocalBoxFuture<'static, Result<Self::Response, Self::Error>>;

	forward_ready!(service);

	fn call(&self, req: ServiceRequest) -> Self::Future {
		let path = req.path().to_string();
		let headers = req.headers().to_owned();
		let query_params = req.query_string().to_string();
		debug!("request path: {}, \nheader:{:?}, \nquery_params:{} ",
			path, headers, query_params);

		let future = self.service.call(req);

		Box::pin(async move {

			let res: ServiceResponse<B> = future.await?;

			let status = res.status();
			let headers = res.headers().clone();
			debug!("Status Code: {}", status);
			debug!("Headers: {:?}", headers);
			Ok(res)
		})
	}
}

```

日志中间件的主要逻辑在 LoggingMiddleware 结构体的实现中。这个结构体实现了 Service trait，用于处理HTTP请求和响应，并记录相应的日志信息。

### 3.日志中间件使用

```toml
async fn main() -> std::io::Result<()> {
    init_logger();
    
    let http_server = HttpServer::new(|| {
        let spec = swagger_ui::swagger_spec_file!("actix_swagger/openapi.json");
        let config = swagger_ui::Config::default();

        App::new().service(scope("/api/v1/swagger")
                .configure(swagger(spec, config)))
            .wrap(middleware::Logger::default())
           //.wrap(auth_middleware::Auth)
            .wrap(logging_middleware::Logging)
            .configure(user_routes).route("/{value}", web::get().to(index))
    });

    http_server.bind("127.0.0.1:8080")?
    .run()
    .await
}
```
初始化了日志记录器，然后创建了一个HTTP服务器，默认的请求日志中间件和自定义的日志中间件,用于记录应用程序中处理的HTTP请求和响应的相关信息。在实际应用中，可以帮助开发人员更好地理解请求的处理过程和故障排查。


### 4.初始化日志记录器

```rust
use chrono::Local;
use env_logger::fmt::Color;
use env_logger::Env;
use log::{LevelFilter, info};
use std::io::Write;

pub fn init_logger() {
	let env = Env::default().filter_or("MY_LOG_LEVEL", "debug");
	// 设置日志打印格式
	env_logger::Builder::from_env(env).format(|buf, record| {
		Ok({
			let level_color = match record.level() {
				log::Level::Error => Color::Red,
				log::Level::Warn => Color::Yellow,
				log::Level::Info => Color::Green,
				log::Level::Debug | log::Level::Trace => Color::Cyan,
			};

			let mut level_style = buf.style();
			level_style.set_color(level_color).set_bold(true);

			let mut style = buf.style();
			style.set_color(Color::White).set_dimmed(true);

			write!(buf, "{} {} [ {} ] {}\n",
				   Local::now().format("%Y-%m-%d %H:%M:%S"),
				   level_style.value(record.level()),
				   style.value(record.module_path().unwrap_or("<unnamed>")),
				   record.args()).unwrap();
		})
	}).filter(None, LevelFilter::Debug).init();
	info!("env_logger initialized.");
}


```
初始化日志记录器的函数init_logger。使用 Env::default() 创建了一个默认的环境变量，并指定了过滤级别。在这里，它会读取名为 MY_LOG_LEVEL



### 5.效果

![image](/images/post/actix-web添加日志中间件/logger_res.png)
