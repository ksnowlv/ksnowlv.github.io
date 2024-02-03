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

### 1.添加日志依赖

```toml
log = "0.4.0"
env_logger = "0.9.0"
chrono = "0.4.19"
```

### 2.日志中间件

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
//           //.wrap(auth_middleware::Auth)
            .wrap(logging_middleware::Logging)
           // .wrap(heartbeat_middleware::Heartbeat)
            .configure(user_routes).route("/{value}", web::get().to(index))
    });

    http_server.bind("127.0.0.1:8080")?
    .run()
    .await
}
```

### 4.效果

![image](/images/post/actix-web添加日志中间件/logger_res.png)
