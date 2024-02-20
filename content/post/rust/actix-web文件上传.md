---
title: "Actix Web文件上传"
date: 2024-02-18T18:56:35+08:00
lastmod: 2024-02-18T18:56:35+08:00
keywords: ["rust", "Actix Web", "后端开发"]
tags: ["rust", "Actix Web", "后端开发"]
categories: ["rust", "Actix Web", "后端开发"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Actix Web多文件上传

### 1.实现思路

通过Multipart参数获取表单数据，根据表单域获取文件名，并创建空文件，将表单域数据写入空文件；直到所有的数据处理完毕；

### 2.详细过程：

Multipart参数，用于处理多部分表单数据的流；

* 表单域中获取文件名，并使用标准库中的env::temp_dir()函数获取临时目录的路径，在这个路径后面拼接文件名，得到了文件的完整路径，
* 创建了一个文件，并将表单域的数据写入该文件，直到所有的数据都被处理完毕。
* 最后，返回一个成功的HTTP响应，表示文件上传成功。

### 3.实现代码

```rust

use std::env;
use std::fs::File;
use std::io::Write;
use actix_web::{web, HttpResponse, post};
use actix_multipart::Multipart;
use futures_util::{StreamExt, TryStreamExt};
use actix_web::Error;
use crate::models::{api_response};

pub fn file_routes(cfg: &mut web::ServiceConfig) {
	cfg.service(web::scope("/api/file")
					.route("/upload_file", web::post().to(upload_file))
					.route("/index_file", web::post().to(index_file))
	);
}

async fn upload_file(mut payload: Multipart) -> Result<HttpResponse, Error> {
	println!("\n---upload_file---\n");

	while let Ok(Some(mut field)) = payload.try_next().await {
		let content_disposition = field.content_disposition();
		let file_name = content_disposition.get_filename().unwrap();

		// 获取临时目录路径
		let mut file_path = env::temp_dir();
		file_path.push(file_name);
		println!("---full file_path:{}, file_name:{}", file_path.display(), file_name);

		let mut file = File::create(file_path)?;
		while let Some(chunk) = field.next().await {
			let data = chunk?;
			file.write_all(&data)?;
		}
	}

	api_response::ok_handler::<String>(None, Some("文件上传成功!!!".to_string())).await
}

```

### 4.测试

#### 终端中通过cul命令测试

```shell
(base) lvwei@lvweideMacBook-Pro Documents % curl -i -k -X POST -H "Content-Type: multipart/form-data" \
     -F "file1=@123.png" \
     -F "file2=@1.txt" \
     https://127.0.0.1:8080/api/file/upload_file
HTTP/2 200 
content-length: 58
content-type: application/json
date: Sun, 18 Feb 2024 11:11:49 GMT

{"code":200,"message":"文件上传成功!!!","data":null}

```

curl命令中，
* -i参数来输出HTTP头信息，包括状态码；
* -k选项的含义是--insecure，它的作用是告诉curl忽略对SSL证书的校验，从而允许通过HTTPS连接请求不受信任的SSL证书的网站；在开发和测试阶段，-k选项可能会用到，但在生产环境中建议不要使用。


#### clion 日志输出

```shell
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=Settings { flags: (0x0) }
2024-02-18 19:16:29 DEBUG [ h2::proto::connection ] Connection; peer=Server
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Settings { flags: (0x0), enable_push: 0, max_concurrent_streams: 100, initial_window_size: 10485760 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=Settings { flags: (0x1: ACK) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=WindowUpdate { stream_id: StreamId(0), size_increment: 1048510465 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Headers { stream_id: StreamId(1), flags: (0x4: END_HEADERS) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Settings { flags: (0x1: ACK) }
2024-02-18 19:16:29 DEBUG [ h2::proto::settings ] received settings ACK; applying Settings { flags: (0x0) }

---upload_file---

---full file_path:/var/folders/69/0hr7ggx95cxdk8d6y3pdb5fh0000gn/T/123.png, file_name:123.png
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(0), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(1), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(0), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(1), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
---full file_path:/var/folders/69/0hr7ggx95cxdk8d6y3pdb5fh0000gn/T/1.txt, file_name:1.txt
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(0), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(1), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(0), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(1), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(0), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(1), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(0), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(1), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(0), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(1), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(0), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(1), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(0), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(1), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(0), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(1), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(0), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_write ] send frame=WindowUpdate { stream_id: StreamId(1), size_increment: 65535 }
2024-02-18 19:16:29 DEBUG [ h2::codec::framed_read ] received frame=Data { stream_id: StreamId(1), flags: (0x1: END_STREAM) }
2024-02-18 19:16:30 INFO [ actix_web::middleware::logger ] 127.0.0.1 "POST /api/file/upload_file HTTP/2.0" 200 58 "-" "curl/8.5.0" 0.024824
2024-02-18 19:16:30 DEBUG [ h2::codec::framed_write ] send frame=Headers { stream_id: StreamId(1), flags: (0x4: END_HEADERS) }
2024-02-18 19:16:30 DEBUG [ h2::codec::framed_write ] send frame=Data { stream_id: StreamId(1) }
2024-02-18 19:16:30 DEBUG [ h2::codec::framed_write ] send frame=Data { stream_id: StreamId(1), flags: (0x1: END_STREAM) }


```
既支持多文件上传，也支持单个文件上传，文件存储在服务器上的临时目录中

### 5.其它
 * 注意慎用第三方工具，例如apipost等，需要设置证书及http2的支持。
 * 昨天z4176从武昌到北京的车，凌晨2：50准时到北京站，只可惜打车太困难，排队排到200多；后来在北京站和老婆坐夜班公交4路在宣武门倒夜5路到清河火车站，到家已经6点有余；
 * 睡了会，和老婆看了个电影飞驰人生2，还能看。


