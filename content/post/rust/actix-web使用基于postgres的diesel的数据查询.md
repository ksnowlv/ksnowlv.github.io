---
title: "Actix Web使用基于postgres的diesel的数据查询"
date: 2024-03-03T12:54:35+08:00
lastmod: 2024-03-03T12:54:35+08:00
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


## postgres数据查询

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

// 查询指定id的数据
pub fn db_get_post(connection: &mut PgConnection, post_id: i32) {
    let post = posts
        .find(post_id)
        .select(Post::as_select())
        .first(connection)
        .optional(); // This allows for returning an Option<Post>, otherwise it will throw an error

    match post {
        Ok(Some(post)) => println!("Post with id: {} has a title: {}", post.id, post.title),
        Ok(None) => println!("Unable to find post {}", post_id),
        Err(_) => println!("An error occured while fetching post {}", post_id),
    }
}

// 查询发布状态的数据
pub fn db_show_posts(connection: &mut PgConnection, limit: i64) -> Vec<Post> {
    let results = posts
        .filter(published.eq(true))
        .limit(limit)
        .select(Post::as_select())
        .load::<Post>(connection)
        .expect("Error loading posts");

    println!("Displaying {} posts", results.len());
    for post in &results {
        println!("id:{}", post.id);
        println!("title:{}", post.title);
        println!("------body-----\n");
        println!("{}", post.body);
    }

    results
}

// 查询最多10000条数据，并作为数组返回
pub fn db_show_all_posts(connection: &mut PgConnection) -> Vec<Post> {
    let results = posts
        .limit(10000)
        .select(Post::as_select())
        .load::<Post>(connection)
        .expect("Error loading posts");

    println!("Displaying {} posts", results.len());
    for post in &results {
        println!("id:{}", post.id);
        println!("title:{}", post.title);
        println!("------body-----\n");
        println!("{}", post.body);
    }

    results
}

```

### 2.show_posts.rs文件

```rust
use diesel::prelude::*;
use crate::postgres_db::{db_get_post, db_show_all_posts, db_show_posts};

pub fn get_post(connection: &mut PgConnection) {

    println!("---get_post （find id = 2的数据项）---");
    db_get_post(connection, 2);
}

pub fn show_posts(connection: &mut PgConnection) {
    println!("---show_posts---");
    db_show_posts(connection, 10);
}

pub fn show_all_posts(connection: &mut PgConnection) {
    println!("---show_all_posts---");
    db_show_all_posts(connection);
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
mod delete_post;

use crate::show_posts::{show_posts, show_all_posts, get_post};
use crate::create_post::create_post;
use crate::publish_post::publish_post;
use crate::delete_post::delete_post;
use crate::postgres_db::db_establish_connection;

fn main() {

    let connection = &mut db_establish_connection();

    create_post(connection);
    show_all_posts(connection);

    publish_post(connection, 34);
    publish_post(connection, 35);
    show_posts(connection);

    get_post(connection);
    show_all_posts(connection);

    // delete_post(connection);
}
```

### 4.效果

```shell
/Users/ksnowlv/.cargo/bin/cargo run --color=always --package diesel_demo_postgres --bin diesel_demo_postgres
warning: unused import: `crate::delete_post::delete_post`
  --> src/main.rs:13:5
   |
13 | use crate::delete_post::delete_post;
   |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   |
   = note: `#[warn(unused_imports)]` on by default

warning: function `delete_post` is never used
 --> src/delete_post.rs:4:8
  |
4 | pub fn delete_post(connection: &mut PgConnection) {
  |        ^^^^^^^^^^^
  |
  = note: `#[warn(dead_code)]` on by default

warning: `diesel_demo_postgres` (bin "diesel_demo_postgres") generated 2 warnings (run `cargo fix --bin "diesel_demo_postgres"` to apply 1 suggestion)
    Finished dev [unoptimized + debuginfo] target(s) in 0.03s
     Running `target/debug/diesel_demo_postgres`
What would you like your title to be?
my first blog

Ok! Let's write my first blog if you input end,input is terminal 
nothing to say!end
body:nothing to say!
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

---get_post （find id = 2的数据项）---
Post with id: 2 has a title: 主题
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

进程已结束，退出代码为 0



```