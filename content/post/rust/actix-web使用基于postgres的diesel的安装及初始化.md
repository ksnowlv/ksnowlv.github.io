---
title: "Actix Web使用基于postgres的diesel的安装及初始化"
date: 2024-03-03T10:14:47+08:00
lastmod: 2024-03-03T10:14:47+08:00
keywords: ["Actix Web", "diesel", "postgres", "数据库"]
tags: ["Actix Web", "后端开发", "数据库"]
categories: ["Actix Web", "后端开发", "数据库"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


### 1.基于postgres的diesel的安装及数据库表初始化

```shell
#安装diesel_cli
ksnowlv@MacBook-Pro-3 diesel_demo_postgres % cargo install diesel_cli
    Updating `rsproxy` index
     Ignored package `diesel_cli v2.1.1` is already installed, use --force to override
#.env设置数据库的环境变量     
ksnowlv@MacBook-Pro-3 diesel_demo_postgres % echo DATABASE_URL=postgres://postgres:12345678@localhost/diesel_demo > .env 
#创建数据库
ksnowlv@MacBook-Pro-3 diesel_demo_postgres % diesel setup
Creating migrations directory at: /Users/ksnowlv/Documents/code_space/rust_projects/diesel_demo_postgres/migrations
thread 'main' panicked at /Users/ksnowlv/.cargo/registry/src/rsproxy.cn-8f6827c7555bfaf8/diesel_cli-2.1.1/src/database.rs:41:21:
Database url `postgres://postgres:12345678@localhost/diesel_demo` requires the `postgres` feature but it's not enabled.
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
ksnowlv@MacBook-Pro-3 diesel_demo_postgres % RUST_BACKTRACE=1
#安装PostgreSQL
ksnowlv@MacBook-Pro-3 diesel_demo_postgres % cargo install diesel_cli --no-default-features --features postgres
    Updating `rsproxy` index
  Installing diesel_cli v2.1.1
   Compiling proc-macro2 v1.0.78
   Compiling unicode-ident v1.0.12
   Compiling serde v1.0.197
   Compiling hashbrown v0.14.3
   Compiling equivalent v1.0.1
   Compiling utf8parse v0.2.1
   Compiling winnow v0.5.40
   Compiling colorchoice v1.0.0
   Compiling pq-sys v0.4.8
   Compiling tinyvec_macros v0.1.1
   Compiling anstyle v1.0.6
   Compiling anstyle-query v1.0.2
   Compiling anstyle-parse v0.2.3
   Compiling autocfg v1.1.0
   Compiling memchr v2.7.1
   Compiling tinyvec v1.6.0
   Compiling anstream v0.6.13
   Compiling clap_lex v0.7.0
   Compiling num-traits v0.2.18
   Compiling indexmap v2.2.5
   Compiling aho-corasick v1.1.2
   Compiling strsim v0.11.0
   Compiling regex-syntax v0.8.2
   Compiling unicode-normalization v0.1.23
   Compiling clap_builder v4.5.1
   Compiling core-foundation-sys v0.8.6
   Compiling itoa v1.0.10
   Compiling percent-encoding v2.3.1
   Compiling byteorder v1.5.0
   Compiling bitflags v2.4.2
   Compiling overload v0.1.1
   Compiling unicode-bidi v0.3.15
   Compiling nu-ansi-term v0.46.0
   Compiling iana-time-zone v0.1.60
   Compiling form_urlencoded v1.2.1
   Compiling dotenvy v0.15.7
   Compiling diffy v0.3.0
   Compiling idna v0.5.0
   Compiling heck v0.4.1
   Compiling regex-automata v0.4.5
   Compiling url v2.5.0
   Compiling clap v4.5.1
   Compiling clap_complete v4.5.1
   Compiling quote v1.0.35
   Compiling syn v2.0.52
   Compiling chrono v0.4.34
   Compiling regex v1.10.3
   Compiling diesel_table_macro_syntax v0.1.0
   Compiling serde_derive v1.0.197
   Compiling diesel_derives v2.1.2
   Compiling diesel v2.1.4
   Compiling serde_spanned v0.6.5
   Compiling toml_datetime v0.6.5
   Compiling toml_edit v0.19.15
   Compiling serde_regex v1.1.0
   Compiling toml v0.7.8
   Compiling migrations_internals v2.1.0
   Compiling migrations_macros v2.1.0
   Compiling diesel_migrations v2.1.0
   Compiling diesel_cli v2.1.1
    Finished release [optimized] target(s) in 1m 08s
   Replacing /Users/ksnowlv/.cargo/bin/diesel
    Replaced package `diesel_cli v2.1.1` with `diesel_cli v2.1.1` (executable `diesel`)
# 重新创建数据库    
ksnowlv@MacBook-Pro-3 diesel_demo_postgres % diesel setup                                                      
Creating database: diesel_demo
# 数据库表创建和丢弃的sql语句
ksnowlv@MacBook-Pro-3 diesel_demo_postgres % diesel migration generate create_posts
Creating migrations/2024-03-02-122653_create_posts/up.sql
Creating migrations/2024-03-02-122653_create_posts/down.sql
# 数据库表创建
ksnowlv@MacBook-Pro-3 diesel_demo_postgres % diesel migration run
Running migration 2024-03-02-122653_create_posts
ksnowlv@MacBook-Pro-3 diesel_demo_postgres % 
```


### 2..env文件

```text
DATABASE_URL=postgres://postgres:12345678@localhost/diesel_demo

```

### 3.models.rs

```rust
use diesel::prelude::*;

#[derive(Queryable, Selectable)]
#[diesel(table_name = crate::schema::posts)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct Post {
    pub id: i32,
    pub title: String,
    pub body: String,
    pub published: bool,
}


#[derive(Insertable)]
#[diesel(table_name = crate::schema::posts)]
pub struct NewPost<'a> {
    pub title: &'a str,
    pub body: &'a str,
}

```

### 4.diesel.toml文件

```toml

[print_schema]
file = "src/schema.rs"
custom_type_derives = ["diesel::query_builder::QueryId"]

[migrations_directory]
dir = "migrations"

```


### 5.schema.rs文件

```rust
// @generated automatically by Diesel CLI.

diesel::table! {
    posts (id) {
        id -> Int4,
        title -> Varchar,
        body -> Text,
        published -> Bool,
    }
}

```


### 6.migrations目录

#### 00000000000000_diesel_initial_setup

* up.sql

```sql
-- This file was automatically created by Diesel to setup helper functions
-- and other internal bookkeeping. This file is safe to edit, any future
-- changes will be added to existing projects as new migrations.




-- Sets up a trigger for the given table to automatically set a column called
-- `updated_at` whenever the row is modified (unless `updated_at` was included
-- in the modified columns)
--
-- # Example
--
-- ```sql
-- CREATE TABLE users (id SERIAL PRIMARY KEY, updated_at TIMESTAMP NOT NULL DEFAULT NOW());
--
-- SELECT diesel_manage_updated_at('users');
-- ```
CREATE OR REPLACE FUNCTION diesel_manage_updated_at(_tbl regclass) RETURNS VOID AS $$
BEGIN
    EXECUTE format('CREATE TRIGGER set_updated_at BEFORE UPDATE ON %s
                    FOR EACH ROW EXECUTE PROCEDURE diesel_set_updated_at()', _tbl);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION diesel_set_updated_at() RETURNS trigger AS $$
BEGIN
    IF (
        NEW IS DISTINCT FROM OLD AND
        NEW.updated_at IS NOT DISTINCT FROM OLD.updated_at
    ) THEN
        NEW.updated_at := current_timestamp;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

```

* down.sql

```sql

-- This file was automatically created by Diesel to setup helper functions
-- and other internal bookkeeping. This file is safe to edit, any future
-- changes will be added to existing projects as new migrations.

DROP FUNCTION IF EXISTS diesel_manage_updated_at(_tbl regclass);
DROP FUNCTION IF EXISTS diesel_set_updated_at();


```

#### 2024-03-02-122653_create_posts

* up.sql

```sql
CREATE TABLE posts (
                       id SERIAL PRIMARY KEY,
                       title VARCHAR NOT NULL,
                       body TEXT NOT NULL,
                       published BOOLEAN NOT NULL DEFAULT FALSE
)-- Your SQL goes here

```

* down.sql

```sql
DROP TABLE posts-- This file should undo anything in `up.sql`

```

### 7.keep文件

```text
cargo install diesel_cli --no-default-features --features postgres
```

### 7.效果
![image](/images/rust/actix-web使用基于postgres的diesel的安装及初始化/db_overview.png)

### 9.其它

基于postgres的diesel的安装及初始化，已完成；

后续是数据的增加，删除，更新，查找等操作。