---
title: "Actix Web开启http2"
date: 2024-02-09T22:35:06+08:00
lastmod: 2024-02-09T22:35:06+08:00
keywords: ["rust", "Actix Web", "后端开发", "http2"]
tags: ["rust", "Actix Web", "后端开发"]
categories: ["rust", "Actix Web", "后端开发"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Actix Web开启http2

actix-web支持http2，可以将http连接升级到HTTP/2。

### 1.添加依赖

```toml
actix-web = { version = "4.4", features = ["openssl"] }
openssl = { version = "0.10", features = ["v110"] }
```

### 2.生成https自签名证书

使用openssl genrsa -out key.pem 2048和openssl req -new -x509 -key key.pem -out cert.pem -days 365在项目根目录生成证书

```shell
(base) lvwei@bogon actix-web-app % openssl genrsa -out key.pem 2048
(base) lvwei@bogon actix-web-app % openssl req -new -x509 -key key.pem -out cert.pem -days 365
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:CN  
State or Province Name (full name) [Some-State]:BEIJING
Locality Name (eg, city) []:BEIJING
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Personal
Organizational Unit Name (eg, section) []:Personal
Common Name (e.g. server FQDN or YOUR name) []:actix-web
Email Address []:ksnowlv@163.com
```

### 3.http server开启http2

```rust
use openssl::ssl::{SslAcceptor, SslFiletype, SslMethod};

let http_server = HttpServer::new(|| {
let spec = swagger_ui::swagger_spec_file!("actix_swagger/openapi.json");
let config = swagger_ui::Config::default();

App::new().service(scope("/api/v1/swagger")
.configure(swagger(spec, config)))
.wrap(middleware::Logger::default())
.wrap(logging_middleware::Logging)
.wrap(Compress::default())
.configure(user_routes).route("/{value}", web::get().to(index))
});

// 创建 SSL 加密器
let mut builder = SslAcceptor::mozilla_intermediate(SslMethod::tls()).unwrap();
builder.set_private_key_file("key.pem", SslFiletype::PEM).unwrap();
builder.set_certificate_chain_file("cert.pem").unwrap();

http_server//.bind("127.0.0.1:8080")?
.bind_openssl("127.0.0.1:8080", builder)?
.run()
.await

```

### 4.效果

重启actix-web服务，打开[https://127.0.0.1:8080/123](https://127.0.0.1:8080/123)验证。

![image](/images/rust/actix-web开启http2/http2_result.jpg)

