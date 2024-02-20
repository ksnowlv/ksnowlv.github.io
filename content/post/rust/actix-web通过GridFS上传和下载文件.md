---
title: "Actix Web通过GridFS上传和下载文件"
date: 2024-02-20T11:26:47+08:00
lastmod: 2024-02-20T11:26:47+08:00
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
## GridFS上传和下载文件


Actix-web框架下，如何通过异步编程（通过 async/await）和 MongoDB 的 GridFS 存储系统，来实现文件的上传和下载呢？

### 1.思路
#### 上传文件
* HTTP请求的 multipart payload 中获取文件内容。
* 使用 GridFSBucket 将文件上传至GridFS。
* 文件全部上传后，将上传后的文件信息返回。
* 最后，返回http响应结果。

#### 下载文件
* 从 HTTP请求的 web::Path中获取文件id。
* 使用 GridFSBucket 从GridFS获取文件数据。
* 文件获取后，将相关信息文件返回。
* 最后，返回http响应结果。

### 2.gridfs配置
```toml
[dependencies]
mongodb = "2.8"
mongodb-gridfs = "0.2"

```

### 3.gridfs上传/下载模块

新增xgridfs.rs

```rust

use actix_multipart::Multipart;
use actix_web::Error;
use futures_util::{StreamExt, TryStreamExt};
use mongodb::{
	bson::doc,
	Client,
	bson::oid::ObjectId,
};
use mongodb_gridfs::{
	GridFSBucket,
	options::{GridFSBucketOptions, GridFSFindOptions},
};
use crate::models::{
	file_model::{GridFSFileDownloadInfo, GridFSFileData, GridFSFileRenameInfo, GridFSFileInfo}
};

pub async fn upload_file_to_gridfs(mut payload: Multipart, client: &Client) -> Result<GridFSFileData, Error> {
	let db = client.database("mydb");
	let mut bucket = GridFSBucket::new(db.clone(), Some(GridFSBucketOptions::default()));

	let mut gridfs_file_data = GridFSFileData::new();

	while let Ok(Some(mut field)) = payload.try_next().await {
		let file_name = {
			let content_disposition = field.content_disposition();
			content_disposition.get_filename().unwrap()
		};

		let mut file_info = GridFSFileInfo::new_default();

		let upload_file_name: String = String::from(file_name);
		file_info.set_file_name(upload_file_name);

		let content_type = field.content_type().unwrap().to_string();// 获取文件的内容类型
		file_info.set_file_type(content_type);

		let mut file_data = Vec::new();

		while let Some(chunk) = field.next().await {
			let data = chunk?;
			file_data.extend_from_slice(&data);
		}

		let upload_file_data: &[u8] = &file_data;

		let upload_res = bucket.upload_from_stream(&file_info.file_name, upload_file_data, None).await;

		match upload_res {
			Ok(objectid) => {
				println!("objectid = {}", objectid.to_hex());
				file_info.set_file_id(objectid.to_hex());
				file_info.set_success(true);
			}
			Err(err) => {
				println!("upload error = {:?}", err);
			}
		}

		gridfs_file_data.push_file_entry(file_info);
	}

	Ok(gridfs_file_data)
}

pub async fn download_file_from_gridfs(file_id: &str, client: &Client) -> Result<GridFSFileDownloadInfo, Box<dyn std::error::Error>> {
	let db = client.database("mydb");
	let mut bucket = GridFSBucket::new(db.clone(), Some(Default::default()));
	let file_id_obj = ObjectId::parse_str(file_id)?;
	let (mut file, filename) = bucket.open_download_stream_with_filename(file_id_obj).await?;

	let buffer = file.next().await.unwrap();

	let info = GridFSFileDownloadInfo {
		filename: filename,
		content_type: "to do".to_string(),
		data: buffer,
	};

	Ok(info)
}


```

### 4.上传和下载数据体(GridFSFileData/FileData)

```rust

use serde_derive::Serialize;

#[derive(Debug, Serialize)]
pub struct GridFSFileData {
	pub file_list: Vec<GridFSFileInfo>,
}

impl GridFSFileData {

	pub fn new() -> Self {
		GridFSFileData {
			file_list:Vec::new()
		}
	}

	pub fn push_file_entry(& mut self, file_info: GridFSFileInfo) {
		self.file_list.push(file_info);
	}
}

#[derive(Debug, Serialize)]
pub struct GridFSFileInfo {
	pub file_name: String,
	pub file_type: String,
	pub file_id: String,
	pub success: bool,
}

impl GridFSFileInfo {
	pub fn new_default() -> Self {
		GridFSFileInfo {
			file_name: "".to_string(),
			file_type: "".to_string(),
			file_id: "".to_string(),
			success: false,
		}
	}

	pub fn set_file_name(&mut self, file_name: String) {
		self.file_name = file_name;
	}

	pub fn set_file_type(&mut self, file_type: String) {
		self.file_type = file_type;
	}

	pub fn set_file_id(&mut self, file_id: String) {
		self.file_id = file_id;
	}

	pub fn set_success(&mut self, success: bool) {
		self.success = success;
	}
}

#[derive(Debug, Serialize)]
pub struct GridFSFileDownloadInfo {
	pub filename: String,
	pub content_type: String,
	pub data: Vec<u8>,
}

```

### 5.http上传和下载接口

```rust
use std::{env, io};
use std::fs::File;
use std::io::Write;
use actix_web::{web, HttpResponse, post, Error};
use actix_multipart::Multipart;
use futures_util::{StreamExt, TryStreamExt};
use mongodb::Client;
use crate::models::{
	api_response,
	file_model::{ GridFSFileInfo, GridFSFileData},
};

use crate::xgridfs;

pub fn file_routes(cfg: &mut web::ServiceConfig) {
	cfg.service(web::scope("/api/file")
		.route("/upload_file_to_gridfs", web::post().to(upload_file_to_gridfs))
		.route("/download_file_from_gridfs/{file_id}", web::post().to(download_file_from_gridfs))
	);
}

// 定义上传文件到GridFS的处理函数
pub async fn upload_file_to_gridfs(payload: Multipart, client: web::Data<Client>) -> Result<HttpResponse, Error> {
	// 调用xgridfs模块中的上传函数
	match xgridfs::upload_file_to_gridfs(payload, &client).await {
		Ok(file_data) => {
			// 返回文件上传成功的响应
			api_response::ok_handler::<GridFSFileData>(
				Some(file_data),
				Some("文件上传成功!!!".to_string()),
			).await
		}
		Err(err) => {
			// 返回文件上传失败的响应
			api_response::error_handler::<String>(err.to_string().as_str()).await
		}
	}
}

// 定义从GridFS下载文件的处理函数
pub async fn download_file_from_gridfs(file_id: web::Path<String>, client: web::Data<Client>) -> Result<HttpResponse, Error> {
	match xgridfs::download_file_from_gridfs(&file_id.to_string(), &client).await {
		Ok(file_data) => {
			// 返回文件下载成功的响应
			api_response::ok_handler(Some(file_data), Some("下载成功".to_string())).await
		}
		Err(err) => {
			// 返回文件下载失败的响应
			api_response::error_handler::<String>(err.to_string().as_str()).await
		}
	}
}

```

### 6.测试

#### 上传

curl命令测试

```shell
(base) lvwei@lvweideMacBook-Pro Documents % curl -i -k -X POST -H "Content-Type: multipart/form-data" \
     -F "file1=@123.png" \
     -F "file2=@1.txt" \
     https://127.0.0.1:8080/api/file/upload_file_to_gridfs
HTTP/2 200 
content-length: 271
content-type: application/json
date: Tue, 20 Feb 2024 05:49:05 GMT

{"code":200,"message":"文件上传成功!!!","data":{"file_entries":[{"file_name":"123.png","file_type":"image/png","file_id":"65d43d510f661065fb0a299a","success":true},{"file_name":"1.txt","file_type":"text/plain","file_id":"65d43d510f661065fb0a299c","success":true}]}

(base) lvwei@lvweideMacBook-Pro Documents % 

```

clion日志

```shell
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_write ] send frame=Settings { flags: (0x0) }
2024-02-20 13:49:05 DEBUG [ h2::proto::connection ] Connection; peer=Server
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Settings { flags: (0x0), enable_push: 0, max_concurrent_streams: 100, initial_window_size: 10485760 }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_write ] send frame=Settings { flags: (0x1: ACK) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Settings { flags: (0x1: ACK) }
2024-02-20 13:49:05 DEBUG [ h2::proto::settings ] received settings ACK; applying Settings { flags: (0x0) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=WindowUpdate { stream_id: StreamId(0), size_increment: 1048510465 }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Headers { stream_id: StreamId(1), flags: (0x4: END_HEADERS) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-20 13:49:05 DEBUG [ actix_web_app::middlewares::logging_middleware ] request path: /api/file/upload_file_to_gridfs, 
header:HeaderMap { inner: {"content-length": Value { inner: ["188781"] }, "accept": Value { inner: ["*/*"] }, "content-type": Value { inner: ["multipart/form-data; boundary=------------------------kiNEDvjHsicidfMxKhOXLy"] }, "user-agent": Value { inner: ["curl/8.5.0"] }} }, 
query_params: 
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(0), size_increment: 65535 }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(1), size_increment: 65535 }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(0), size_increment: 65535 }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(1), size_increment: 65535 }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1), flags: (0x1: END_STREAM) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(0), size_increment: 57711 }
objectid = 65d43d510f661065fb0a299a
objectid = 65d43d510f661065fb0a299c
2024-02-20 13:49:05 DEBUG [ actix_web_app::middlewares::logging_middleware ] Status Code: 200 OK
2024-02-20 13:49:05 DEBUG [ actix_web_app::middlewares::logging_middleware ] Headers: HeaderMap { inner: {"content-type": Value { inner: ["application/json"] }} }
2024-02-20 13:49:05 INFO [ actix_web::middleware::logger ] 127.0.0.1 "POST /api/file/upload_file_to_gridfs HTTP/2.0" 200 271 "-" "curl/8.5.0" 0.031869
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_write ] send frame=Headers { stream_id: StreamId(1), flags: (0x4: END_HEADERS) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_write ] send frame=Data { stream_id: StreamId(1) }
2024-02-20 13:49:05 DEBUG [ h2::codec::framed_write ] send frame=Data { stream_id: StreamId(1), flags: (0x1: END_STREAM) }

```

#### 下载

选取上面上传的1.txt作为下载的样例，暂时不考虑断点续传。

curl命令测试

```shell
(base) lvwei@lvweideMacBook-Pro Documents % curl -i -k -X POST  https://127.0.0.1:8080/api/file/download_file_from_gridfs/65d43d160f661065fb0a2998            
HTTP/2 200 
content-length: 193
content-type: application/json
date: Tue, 20 Feb 2024 05:50:42 GMT

{"code":200,"message":"下载成功","data":{"filename":"1.txt","content_type":"to do","data":[114,117,115,116,32,97,99,116,105,120,45,119,101,98,32,117,112,108,111,97,100,32,102,105,108,101]}}%                                                                          (base) lvwei@lvweideMacBook-Pro Documents % 

```

clion日志

```shell
2024-02-20 13:50:42 DEBUG [ h2::codec::framed_write ] send frame=Settings { flags: (0x0) }
2024-02-20 13:50:42 DEBUG [ h2::proto::connection ] Connection; peer=Server
2024-02-20 13:50:42 DEBUG [ h2::codec::framed_read ] received frame=Settings { flags: (0x0), enable_push: 0, max_concurrent_streams: 100, initial_window_size: 10485760 }
2024-02-20 13:50:42 DEBUG [ h2::codec::framed_write ] send frame=Settings { flags: (0x1: ACK) }
2024-02-20 13:50:42 DEBUG [ h2::codec::framed_read ] received frame=Settings { flags: (0x1: ACK) }
2024-02-20 13:50:42 DEBUG [ h2::proto::settings ] received settings ACK; applying Settings { flags: (0x0) }
2024-02-20 13:50:42 DEBUG [ h2::codec::framed_read ] received frame=WindowUpdate { stream_id: StreamId(0), size_increment: 1048510465 }
2024-02-20 13:50:42 DEBUG [ h2::codec::framed_read ] received frame=Headers { stream_id: StreamId(1), flags: (0x5: END_HEADERS | END_STREAM) }
2024-02-20 13:50:42 DEBUG [ actix_web_app::middlewares::logging_middleware ] request path: /api/file/download_file_from_gridfs/65d43d160f661065fb0a2998, 
header:HeaderMap { inner: {"user-agent": Value { inner: ["curl/8.5.0"] }, "accept": Value { inner: ["*/*"] }} }, 
query_params: 
2024-02-20 13:50:42 DEBUG [ actix_web_app::middlewares::logging_middleware ] Status Code: 200 OK
2024-02-20 13:50:42 DEBUG [ actix_web_app::middlewares::logging_middleware ] Headers: HeaderMap { inner: {"content-type": Value { inner: ["application/json"] }} }
2024-02-20 13:50:42 INFO [ actix_web::middleware::logger ] 127.0.0.1 "POST /api/file/download_file_from_gridfs/65d43d160f661065fb0a2998 HTTP/2.0" 200 193 "-" "curl/8.5.0" 0.006376
2024-02-20 13:50:42 DEBUG [ h2::codec::framed_write ] send frame=Headers { stream_id: StreamId(1), flags: (0x4: END_HEADERS) }
2024-02-20 13:50:42 DEBUG [ h2::codec::framed_write ] send frame=Data { stream_id: StreamId(1) }
2024-02-20 13:50:42 DEBUG [ h2::codec::framed_write ] send frame=Data { stream_id: StreamId(1), flags: (0x1: END_STREAM) }


```

### 7.其它

* 1.大文件断点续传需要添加；
* 2.下载文件时，文件类型目前没有找到合适的方式获取，试了几种未果；
* 3.基于GridFS的文件重命名，文件删除，待添加；
