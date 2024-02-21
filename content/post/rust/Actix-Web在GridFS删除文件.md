---
title: "Actix Web在GridFS删除文件"
date: 2024-02-20T19:18:15+08:00
lastmod: 2024-02-20T19:18:15+08:00
keywords: ["rust", "Actix Web", "后端开发", "存储"]
tags: ["rust", "Actix Web", "后端开发", "存储"]
categories: ["rust", "Actix Web", "后端开发", "存储"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## GridFS重命名文件


Actix-web框架下，GridFS存储系统，如何删除文件呢？


### 1.gridfs删除文件

在xgridfs.rs中新增文件删除函数

```rust
pub async fn delete_file_from_gridfs(file_id: &str, client: &Client) -> Result<(), Box<dyn std::error::Error>> {
	let db = client.database("mydb");
	let mut bucket = GridFSBucket::new(db.clone(), Some(Default::default()));
	let file_id_obj = ObjectId::parse_str(file_id)?;
	let result = bucket.delete(file_id_obj).await?;
	println!("File deleted successfully");
	Ok(())
}
```


### 2.http重命名接口

```rust
pub async fn delete_file_from_gridfs(info: web::Path<(String,)>, client: web::Data<Client>) -> Result<HttpResponse, Error> {
	match xgridfs::delete_file_from_gridfs(info.0.as_str(), &client).await {
		Ok(info) => {
			// 返回文件下载成功的响应
			api_response::ok_handler(Some(info), Some("文件删除成功".to_string())).await
		}
		Err(err) => {
			api_response::error_handler::<String>(err.to_string().as_str()).await
		}
	}
}
```

### 3.测试

curl命令测试


```shell
(base) lvwei@lvweideMacBook-Pro Documents % curl -i -k -X POST  https://127.0.0.1:8080/api/file/delete_file_from_gridfs/65d43d160f661065fb0a2998
HTTP/2 200 
content-length: 58
content-type: application/json
date: Tue, 20 Feb 2024 09:39:28 GMT

{"code":200,"message":"文件删除成功","data":null} 

```

### 4.其它

* 删除操作较为轻量，实际项目中，可以返回删除的file_id,文件名等信息。此处仅为演示用法
