---
title: "Actix Web使用基于postgres的diesel完整示例"
date: 2024-03-03T15:07:44+08:00
lastmod: 2024-03-03T15:07:44+08:00
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

### 1.数据库数据文件models.rs

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

### 2.数据库配置diesel.toml文件

```toml

[print_schema]
file = "src/schema.rs"
custom_type_derives = ["diesel::query_builder::QueryId"]

[migrations_directory]
dir = "migrations"

```

### 3.schema.rs文件

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


### 4.migrations目录

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


### 5.postgres_db.rs数据库操作文件

```rust

use crate::schema::posts::{published, title};
use crate::schema::posts::dsl::posts;
use crate::models::{NewPost, Post};
use diesel::pg::PgConnection;
use diesel::prelude::*;
use dotenvy::dotenv;
use std::env;


// 获取数据库连接
pub fn db_establish_connection() -> PgConnection {
    dotenv().ok();

    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    PgConnection::establish(&database_url)
        .unwrap_or_else(|_| panic!("Error connecting to {}", database_url))
}

// 增加NewPost数据
pub fn db_create_post(connection: &mut PgConnection, blog_title: &str, blog_body: &str) -> Post {
    use crate::schema::posts;

    let new_post = NewPost { title:blog_title, body:blog_body };

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

//删除标题中含有某个字符串的数据
pub fn db_delete_post(connection: &mut PgConnection, pattern: &str) {

    let num_deleted = diesel::delete(posts.filter(title.like(pattern)))
        .execute(connection)
        .expect("Error deleting posts");

    println!("Deleted {} posts", num_deleted);
}

```


### 6.create_post.rs 文件

```rust

use diesel::PgConnection;
use crate::postgres_db::{db_create_post};
use std::io::{stdin};

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

### 7.publish_post.rs文件

```rust
use diesel::prelude::*;
use crate::postgres_db::db_update_post;

pub fn publish_post(connection : &mut PgConnection, post_id: i32) {
    db_update_post(connection, post_id);
}
```

### 8.show_post.rs文件

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

### 9.delete_post.rs文件

```rust
use diesel::prelude::*;
use crate::postgres_db::db_delete_post;

pub fn delete_post(connection: &mut PgConnection) {

    println!("---delete_post---");
    let target = "ff";
    let pattern = format!("%{}%", target);

    db_delete_post(connection, pattern.as_str());
}

```

### 10.main.rs文件

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

    delete_post(connection);
}

```

### 11.效果

```shell

bin/cargo run --color=always --package diesel_demo_postgres --bin diesel_demo_postgres
    Finished dev [unoptimized + debuginfo] target(s) in 0.06s
     Running `target/debug/diesel_demo_postgres`
What would you like your title to be?
ff

Ok! Let's write ff if you input end,input is terminal 
1 

Saved draft ff with id 37
What would you like your title to be?
--ff--

Ok! Let's write --ff-- if you input end,input is terminal 
2

Saved draft --ff-- with id 38
What would you like your title to be?
-----ffff---

Ok! Let's write -----ffff--- if you input end,input is terminal 
3

Saved draft -----ffff--- with id 39
What would you like your title to be?
ffff

Ok! Let's write ffff if you input end,input is terminal 
4

Saved draft ffff with id 40
What would you like your title to be?
f 

Ok! Let's write f if you input end,input is terminal 
fend
body:f
---show_all_posts---
Displaying 17 posts
id:33
title:hello
------body-----

1234567890111

id:36
title:my first blog
------body-----

12345

id:34
title:world
------body-----

12334

id:35
title:winter
------body-----

1

id:37
title:ff
------body-----

1

id:38
title:--ff--
------body-----

2

id:39
title:-----ffff---
------body-----

3

id:40
title:ffff
------body-----

4

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
Displaying 17 posts
id:33
title:hello
------body-----

1234567890111

id:36
title:my first blog
------body-----

12345

id:37
title:ff
------body-----

1

id:38
title:--ff--
------body-----

2

id:39
title:-----ffff---
------body-----

3

id:40
title:ffff
------body-----

4

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
---delete_post---
Deleted 4 posts

进程已结束，退出代码为 0

```
