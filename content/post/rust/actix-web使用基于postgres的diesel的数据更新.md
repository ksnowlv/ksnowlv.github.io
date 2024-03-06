---
title: "Actix Web使用基于postgres的diesel的数据更新"
date: 2024-03-03T12:43:44+08:00
lastmod: 2024-03-03T12:43:44+08:00
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


## postgres数据更新

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

//更新发布状态
pub fn db_update_post(connection: &mut PgConnection, post_id: i32) {
    let post = diesel::update(posts.find(post_id))
        .set(published.eq(true))
        .returning(Post::as_returning())
        .get_result(connection).optional();

    match post {
        Ok(Some(result)) => { println!("Published post {}", result.title); }
        Ok(None) => { println!("unable fo find post {}", post_id) }
        Err(error) => { println!("db_update_post:{}", error) }
    }
}

```

### 2.publish_post.rs文件

```rust

use diesel::prelude::*;
use crate::postgres_db::db_update_post;

pub fn publish_post(connection : &mut PgConnection, post_id: i32) {
    db_update_post(connection, post_id);
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

    publish_post(connection, 34);
    publish_post(connection, 35);
    show_posts(connection);
    // get_post(connection);
    // show_all_posts(connection);
    // delete_post(connection);
}

```

### 4.效果

```shell
/Users/ksnowlv/.cargo/bin/cargo run --color=always --package diesel_demo_postgres --bin diesel_demo_postgres

warning: `diesel_demo_postgres` (bin "diesel_demo_postgres") generated 5 warnings (run `cargo fix --bin "diesel_demo_postgres"` to apply 2 suggestions)
    Finished dev [unoptimized + debuginfo] target(s) in 0.07s
     Running `target/debug/diesel_demo_postgres`
What would you like your title to be?
flutter

Ok! Let's write flutter if you input end,input is terminal 
1end
body:1
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
Published post world
Published post winter
---show_posts---
Displaying 8 posts
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


进程已结束，退出代码为 0



```