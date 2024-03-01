---
title: "Actix Web在GridFS重命名文件"
date: 2024-02-20T18:41:17+08:00
lastmod: 2024-02-20T18:41:17+08:00
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


Actix-web框架下，GridFS存储系统，如何重命名文件呢？


### 1.gridfs重命名文件

在xgridfs.rs中新增文件重命名函数

```rust
pub async fn rename_file_from_gridfs(file_id: &str, new_filename: &str, client: &Client) -> Result<GridFSFileRenameInfo, Box<dyn std::error::Error>> {
	let db = client.database("mydb");
	let mut bucket = GridFSBucket::new(db.clone(), Some(Default::default()));
	let file_id_obj = ObjectId::parse_str(file_id)?;
	let mut update_result = bucket.rename(file_id_obj, new_filename).await?;

	println!("matched_count:{}, modified_count: {}, upserted_id:{:?}",
			 update_result.matched_count,
			 update_result.modified_count, update_result.upserted_id);
	let info = GridFSFileRenameInfo {
		modified_count:update_result.modified_count
	};

	Ok(info)
}
```
### 2.GridFSFileRenameInfo

```rust

#[derive(Debug, Serialize)]
pub struct GridFSFileRenameInfo {
	pub modified_count: u64,
}

```

### 3.http重命名接口

```rust
// 定义从GridFS重命名文件的处理函数
pub async fn rename_file_from_gridfs(info: web::Path<(String, String)>, client: web::Data<Client>) -> Result<HttpResponse, Error> {
	match xgridfs::rename_file_from_gridfs(info.0.as_str(), info.1.as_str(), &client).await {
		Ok(info) => {
			// 返回文件下载成功的响应
			api_response::ok_handler(Some(info), Some("文件重命名成功".to_string())).await
		}
		Err(err) => {
			api_response::error_handler::<String>(err.to_string().as_str()).await
		}
	}
}
```

### 4.测试

curl命令测试


```shell
(base) lvwei@lvweideMacBook-Pro Documents % curl -i -k -X POST  https://127.0.0.1:8080/api/file/rename_file_from_gridfs/65d43d160f661065fb0a2998/3.txt
HTTP/2 200 
content-length: 74
content-type: application/json
date: Tue, 20 Feb 2024 08:00:49 GMT

{"code":200,"message":"文件重命名成功","data":{"modified_count":1}}%                                                           
 
 (base) lvwei@lvweideMacBook-Pro Documents
```

### 5.其它

如果采用json数据作为body数据进行http请求,

#### 主要代码

```rust

#[derive(Deserialize)]
pub struct GridFSFileRenameRequest {
	pub file_id: String,
	pub file_name: String,
}

// 定义从GridFS重命名文件的处理函数
pub async fn rename_file_from_gridfs_with_json(req: web::Json<GridFSFileRenameRequest>, client: web::Data<Client>) -> Result<HttpResponse, Error> {
	match xgridfs::rename_file_from_gridfs(&req.file_id, &req.file_name, &client).await {
		Ok(info) => {
			// 返回文件下载成功的响应
			api_response::ok_handler(Some(info), Some("文件重命名成功".to_string())).await
		}
		Err(err) => {
			api_response::error_handler::<String>(err.to_string().as_str()).await
		}
	}
}

```

#### curl命令测试


```shell
(base) lvwei@lvweideMacBook-Pro Documents % curl -i -k -X POST https://127.0.0.1:8080/api/file/rename_file_from_gridfs_with_json \
-H "Content-Type: application/json" \
-d '{"file_id": "65d43d160f661065fb0a2996", "file_name": "456.png"}'
HTTP/2 200 
content-length: 74
content-type: application/json
date: Tue, 20 Feb 2024 11:02:13 GMT

{"code":200,"message":"文件重命名成功","data":{"modified_count":1}}
                                                                
(base) lvwei@lvweideMacBook-Pro Documents % 

```


