---
title: "Actix Web使用基于postgres的diesel的数据增加"
date: 2024-03-03T12:25:29+08:00
lastmod: 2024-03-03T12:25:29+08:00
keywords: ["Actix Web", "后端开发", "数据库"]
tags: ["Actix Web", "后端开发", "数据库"]
categories: ["Actix Web", "后端开发", "数据库"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## postgres数据增加

### 1.postgres_db.rs数据库文件

```rust

use crate::schema::posts::published;
use crate::models::{NewPost, Post};
use diesel::pg::PgConnection;
use diesel::prelude::*;
use dotenvy::dotenv;
use std::env;

use crate::schema::posts::dsl::posts;

// 获取数据库连接
pub fn db_establish_connection() -> PgConnection {
    dotenv().ok();

    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    PgConnection::establish(&database_url)
        .unwrap_or_else(|_| panic!("Error connecting to {}", database_url))
}


// 增加NewPost数据
pub fn db_create_post(connection: &mut PgConnection, title: &str, body: &str) -> Post {
    use crate::schema::posts;

    let new_post = NewPost { title, body };

    diesel::insert_into(posts::table)
        .values(&new_post)
        .returning(Post::as_returning())
        .get_result(connection)
        .expect("Error saving new post")
}

```

### 2.create_post.rs文件

```rust

use diesel::PgConnection;
use crate::postgres_db::{db_create_post};
use std::io::{stdin};

//循环输入标题和内容，并在数据库中插入标题和内容；当在内容末尾输入end时，结束输入。
pub fn create_post(connection: &mut PgConnection) {

    loop {
        let mut title = String::new();
        let mut body = String::new();

        println!("What would you like your title to be?");
        stdin().read_line(&mut title).unwrap();
        let title = title.trim_end();

        println!("\nOk! Let's write {title} if you input end,input is terminal ",);
        stdin().read_line(&mut body).unwrap();

        if body.contains("end") {
            if let Some(index) = body.rfind("end") {
                body = body[..index].to_string(); // 使用切片操作来截取需要的部分
                println!("body:{}", body);
            }
            break;
        }

        let post = db_create_post(connection, title, &body);
        println!("\nSaved draft {title} with id {}", post.id);
    }
}

```

### 3.main.rs文件

```rust

mod models;
mod postgres_db;
mod publish_post;
mod show_posts;
mod create_post;
mod schema;
mod get_post;
mod delete_post;

use crate::show_posts::{show_posts, show_all_posts };
use crate::create_post::create_post;
use crate::publish_post::publish_post;
use crate::get_post::get_post;
use crate::delete_post::delete_post;
use crate::postgres_db::db_establish_connection;

fn main() {

    let connection = &mut db_establish_connection();

    create_post(connection);
    show_all_posts(connection);
}
```

### 4.效果

```shell
/Users/ksnowlv/.cargo/bin/cargo run --color=always --package diesel_demo_postgres --bin diesel_demo_postgres

warning: `diesel_demo_postgres` (bin "diesel_demo_postgres") generated 11 warnings (run `cargo fix --bin "diesel_demo_postgres"` to apply 4 suggestions)
    Finished dev [unoptimized + debuginfo] target(s) in 0.07s
     Running `target/debug/diesel_demo_postgres`
What would you like your title to be?
hello

Ok! Let's write hello if you input end,input is terminal 
1234567890111

Saved draft hello with id 33
What would you like your title to be?
world

Ok! Let's write world if you input end,input is terminal 
12334

Saved draft world with id 34
What would you like your title to be?
winter

Ok! Let's write winter if you input end,input is terminal 
1

Saved draft winter with id 35
What would you like your title to be?
spring 

Ok! Let's write spring if you input end,input is terminal 
2end
body:2
---show_all_posts---
Displaying 12 posts
id:33
title:hello
------body-----

1234567890111

id:34
title:world
------body-----

12334

id:35
title:winter
------body-----

1

id:1
title:标题1
------body-----

你是谁



id:2
title:主题
------body-----

where are you going?

id:3
title:test1111
------body-----

123456

id:4
title:test
------body-----

测试

id:5
title:ni
------body-----

aaa

id:6
title:示例
------body-----

bbbbb

id:7
title:cccc
------body-----

ccccccccc end

id:8
title:dddd
------body-----

1234end

id:9
title:e
------body-----

1


```