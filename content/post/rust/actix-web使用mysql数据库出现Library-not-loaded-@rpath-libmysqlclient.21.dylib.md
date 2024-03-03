---
title: "Actix Web使用mysql数据库出现Library Not Loaded @Rpath Libmysqlclient.21.dylib"
date: 2024-03-02T20:02:54+08:00
lastmod: 2024-03-02T20:02:54+08:00
keywords: ["rust", "Actix Web", "后端开发", "数据库"]
tags: ["rust", "Actix Web", "后端开发", "数据库"]
categories: ["rust", "Actix Web", "后端开发", "数据库"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 1.问题

rust工程安装diesel时，出现Library not loaded: @rpath/libmysqlclient.21.dylib，如何解决呢？

```shell
ksnowlv@MacBook-Pro-3 actix-web-app % diesel setup
dyld[6955]: Library not loaded: @rpath/libmysqlclient.21.dylib
  Referenced from: <5665A7B3-A57B-3E52-8721-800489186218> /Users/ksnowlv/.cargo/bin/diesel
  Reason: no LC_RPATH's found
zsh: abort      diesel setup
ksnowlv@MacBook-Pro-3 actix-web-app % cargo install diesel_cli
 
```
 
### 2.解决方案



安装数据库后端所需的客户端库，或者可以使用 --no-default-features 标志来排除不需要的默认库。

默认情况下，diesel CLI 依赖于以下客户端库：

* libpq 用于 PostgreSQL 后端
* libmysqlclient 用于 Mysql 后端
* libsqlite3 用于 SQLite 后端

所以安装libmysqlclient客户端库即解决问题

```shell

ksnowlv@MacBook-Pro-3 actix-web-app % cargo install diesel_cli --no-default-features --features mysql   
    Updating `rsproxy` index
  Installing diesel_cli v2.1.1
   Compiling proc-macro2 v1.0.78
   Compiling unicode-ident v1.0.12
   Compiling serde v1.0.197
   Compiling tinyvec_macros v0.1.1
   Compiling hashbrown v0.14.3
   Compiling equivalent v1.0.1
   Compiling pkg-config v0.3.30
   Compiling winnow v0.5.40
   Compiling utf8parse v0.2.1
   Compiling tinyvec v1.6.0
   Compiling colorchoice v1.0.0
   Compiling percent-encoding v2.3.1
   Compiling anstyle-parse v0.2.3
   Compiling anstyle-query v1.0.2
   Compiling memchr v2.7.1
   Compiling unicode-bidi v0.3.15
   Compiling anstyle v1.0.6
   Compiling autocfg v1.1.0
   Compiling anstream v0.6.13
   Compiling mysqlclient-sys v0.2.5
   Compiling num-traits v0.2.18
   Compiling indexmap v2.2.5
   Compiling unicode-normalization v0.1.23
   Compiling aho-corasick v1.1.2
   Compiling form_urlencoded v1.2.1
   Compiling idna v0.5.0
   Compiling clap_lex v0.7.0
   Compiling regex-syntax v0.8.2
   Compiling strsim v0.11.0
   Compiling overload v0.1.1
   Compiling byteorder v1.5.0
   Compiling bitflags v2.4.2
   Compiling clap_builder v4.5.1
   Compiling url v2.5.0
   Compiling core-foundation-sys v0.8.6
   Compiling nu-ansi-term v0.46.0
   Compiling iana-time-zone v0.1.60
   Compiling diffy v0.3.0
   Compiling heck v0.4.1
   Compiling quote v1.0.35
   Compiling syn v2.0.52
   Compiling dotenvy v0.15.7
   Compiling chrono v0.4.34
   Compiling regex-automata v0.4.5
   Compiling clap v4.5.1
   Compiling clap_complete v4.5.1
   Compiling diesel_table_macro_syntax v0.1.0
   Compiling regex v1.10.3
   Compiling serde_derive v1.0.197
   Compiling diesel_derives v2.1.2
   Compiling diesel v2.1.4
   Compiling serde_spanned v0.6.5
   Compiling toml_datetime v0.6.5
   Compiling serde_regex v1.1.0
   Compiling toml_edit v0.19.15
   Compiling toml v0.7.8
   Compiling migrations_internals v2.1.0
   Compiling migrations_macros v2.1.0
   Compiling diesel_migrations v2.1.0
   Compiling diesel_cli v2.1.1
    Finished release [optimized] target(s) in 1m 06s
   Replacing /Users/ksnowlv/.cargo/bin/diesel
    Replaced package `diesel_cli v2.1.1` with `diesel_cli v2.1.1` (executable `diesel`)
ksnowlv@MacBook-Pro-3 actix-web-app % diesel setup --database-url=mysql://root:12345678@localhost/actix-web-app
Creating database: actix-web-app
Failed to run migrations: Using unsupported buffer type: 253  (parameter: 1)

```

可参考[官方文档](http://diesel.rs/guides/getting-started.html)



