---
title: "Actix Web添加JSON负载及出错处理配置"
date: 2024-02-13T08:44:47+08:00
lastmod: 2024-02-13T08:44:47+08:00
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

## JSON负载及出错处理配置

Actix Web 可以针对JSON负载大小对所有的接口进行配置；

### 1.app_data来配置全局的JSON负载大小及出错处理

App::new()中使用app_data来配置全局的JSON负载大小及出错处理

```rust
    let http_server = HttpServer::new(|| {
        let spec = swagger_ui::swagger_spec_file!("actix_swagger/openapi.json");
        let config = swagger_ui::Config::default();

        App::new().service(scope("/api/v1/swagger")
                .configure(swagger(spec, config)))
            .wrap(middleware::Logger::default())
            .wrap(logging_middleware::Logging)
            .wrap(Compress::default())
            .app_data(web::Data::new(get_pool()))
            //全局JSON负载的最大大小为2MB,并配置自定义错误处理函数
            .app_data(web::JsonConfig::default().limit(1024 * 1024 * 3).error_handler(handle_json_payload_error))
            .configure(user_routes).route("/{value}", web::get().to(index))
    });
```

### 2.出错处理

```rust
// 自定义错误处理程序函数
fn handle_json_payload_error(err: actix_web::error::JsonPayloadError, _req: &HttpRequest) -> Error {
    // 在这里处理 JSON payload 错误，例如返回适当的错误响应或记录错误日志
    println!("handle_json_payload_error:{:?}", err);
    err.into()
}

```
