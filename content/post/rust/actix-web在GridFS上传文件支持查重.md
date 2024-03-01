---
title: "actix web在GridFS上传文件支持查重"
date: 2024-02-22T19:29:29+08:00
lastmod: 2024-02-22T19:29:29+08:00
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

## Actix Web在GridFS上传文件支持查重

接上一篇文章[
Actix Web通过GridFS上传和下载文件
](https://mp.weixin.qq.com/s?__biz=MzU4NDA1MTU5MA==&mid=2247484141&idx=1&sn=d38d6f041807d1590b4bc0de00cd01e1&chksm=fd9efc04cae975127c3a79339d8e25841baa84e5dd1419f14b5f8cf226d97cf5cab4ccfb9f29#rd)

文件上传时支持去重，通过文件名及文件md5，查询文件是否已存在？如果已存在，不再上传，返回对应文件信息；如果不存在，上传该文件；

### 1.文件查询

```rust

#[derive(Debug, Serialize)]
pub struct GridFSDocumentInfo {
	pub objectid: String,
	pub filename: String,
	pub chunk_size: i32,
	pub length: i64,
	pub upload_date: Option<DateTime>,
}

pub async  fn  find_file_in_gridfs(bucket: &mut GridFSBucket, file_name: &str, file_data: &Vec<u8>) -> Result<GridFSDocumentInfo, Box<dyn std::error::Error>> {

	let mut cursor = bucket
		.find(doc! {"filename":file_name}, GridFSFindOptions::default())
		.await?;

	let mut is_found = false;
	let mut info = GridFSDocumentInfo{objectid: "".to_string(),
									  filename: "".to_string() ,
									  chunk_size: 0,
									  length: 0,
									  upload_date:None};
	// 遍历 Cursor<Document> 并获取 Document 信息
	while let Some(doc) = cursor.next().await {
		match doc {
			Ok(document) => {
				// 处理查询到的文档
				println!("Found document: {:?}", document);

				if let Some(_id) = document.get("_id").and_then(|v| v.as_object_id()) {
					println!("File objectid: {}", _id.to_hex());
					info.objectid = _id.to_hex();
				}

				if let Some(file_name) = document.get("filename").and_then(|v| v.as_str()) {
					println!("File Name: {}", file_name);
					info.filename = file_name.to_string();
				}

				if let Some(chunk_size) = document.get("chunkSize").and_then(|v| v.as_i32()) {
					println!("File chunkSize: {}", chunk_size);
					info.chunk_size = chunk_size;
				}

				if let Some(length) = document.get("length").and_then(|v| v.as_i64()) {
					println!("File length: {}", length);
					info.length = length;
				}

				if let Some(upload_date) = document.get("uploadDate").and_then(|v| v.as_datetime()) {
					println!("Upload Date: {}", upload_date);
					info.upload_date = Some(*upload_date);
				}
				if let Some(length) = document.get("length").and_then(|v| v.as_i64()) {
					println!("File Size: {} bytes", length);
				}

				if let Some(file_md5) = document.get("md5").and_then(|v| v.as_str()) {
					println!("File md5:{}", file_md5);
					let md5_string = md5_data(&file_data);
					let result = md5_string.ok_or_else(||
						actix_web::error::ErrorBadRequest("MD5 string is missing")
					)?;

					if result == file_md5 {
						//actix_web::error::ErrorNotFound("MD5 not match")
						is_found = true;
					}
				}
			}
			Err(err) => {
				println!("Error while iterating cursor: {}", err);
				return Err(Box::new(err));
			}
		}
	}

	if is_found {
		Ok(info)
	} else {
		Err(Box::new(actix_web::error::ErrorNotFound("File not found")))
	}
}

```


### 2.文件上传

```rust

pub async fn upload_file_to_gridfs(mut payload: Multipart, client: &Client) -> Result<GridFSFileData, actix_web::Error> {
	let db = client.database("mydb");
	let mut bucket = GridFSBucket::new(db.clone(), Some(GridFSBucketOptions::default()));

	let mut gridfs_file_data = GridFSFileData::new();

	while let Ok(Some(mut field)) = payload.try_next().await {
		let file_name = {
			let content_disposition = field.content_disposition();
			content_disposition.get_filename().unwrap().clone()
		};

		let mut file_info = GridFSFileInfo::new_default();

		file_info.set_file_name(file_name.to_string());

		let content_type = field.content_type().unwrap().to_string();
		file_info.set_file_type(content_type);

		let mut file_data = Vec::new();

		while let Some(chunk) = field.next().await {
			let data = chunk?;
			file_data.extend_from_slice(&data);
		}

		let res = find_file_in_gridfs(&mut  bucket, &file_info.file_name, &file_data).await;

		match res {
			Ok(info) => {
				// 处理文件找到的情况
				println!(" file info:{:?} ", info);
				file_info.uploaded = true;
				file_info.set_file_id(info.objectid);
			}
			Err(err) => {
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
			}
		}

		gridfs_file_data.push_file_entry(file_info);
	}

	Ok(gridfs_file_data)
}
```

### 3.http接口文件上传

```rust

pub async fn upload_file_to_gridfs(payload: Multipart, client: web::Data<Client>) -> Result<HttpResponse, Error> {
	// 调用xgridfs模块中的上传函数
	match xgridfs::upload_file_to_gridfs(payload, &client).await {
		Ok(file_data) => {
			api_response::ok_handler::<GridFSFileData>(
				Some(file_data),
				Some("文件上传处理完成".to_string()),
			).await
		}
		Err(err) => {
			// 返回文件上传失败的响应
			api_response::error_handler::<String>(err.to_string().as_str()).await
		}
	}
}

```

### 4.测试

curl命令测试

```shell
(base) lvwei@lvweideMacBook-Pro Documents % curl -i -k -X POST -H "Content-Type: multipart/form-data" \
-F "file1=@123.png" \
-F "file2=@点位经营.zip" \
https://127.0.0.1:8080/api/file/upload_file_to_gridfs
HTTP/2 200
content-length: 330
content-type: application/json
date: Thu, 22 Feb 2024 11:24:40 GMT

{"code":200,"message":"文件上传处理完成","data":{"file_list":[{"file_name":"123.png","file_type":"image/png","file_id":"65d72e08eafab6be5dd23f40","success":false,"uploaded":true},{"file_name":"点位经营.zip","file_type":"application/octet-stream","file_id":"65d72ef855080d8fa482c57b","success":true,"uploaded":false}]}}%                                                                            

(base) lvwei@lvweideMacBook-Pro Documents %

```
