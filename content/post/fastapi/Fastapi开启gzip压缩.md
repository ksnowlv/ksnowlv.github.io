---
title: "Fastapi开启gzip压缩"
date: 2023-11-24T22:11:42+08:00
lastmod: 2023-11-24T22:11:42+08:00
keywords: ["python", "fastapi", "解压缩"]
tags: ["python", "fastapi", "解压缩", "后端开发"]
categories: ["python", "fastapi", "解压缩", "后端开发"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## fastapi开启gzip

### 1.fastapi通过GZipMiddleware内置中间件开启gzip

```python
from fastapi.middleware.gzip import GZipMiddleware

# 开启gzip压缩
# 当请求的头信息 Accept-Encoding 字段带有"gzip"时，GZipMiddleware负责完成相应的返回结果处理。
# GZipMiddleware 支持 minimum_size 参数：当返回结果大小小于指定值时不启用压缩。(单位为字节，默认值为500)
# Accept-Encoding: gzip
app.add_middleware(GZipMiddleware, minimum_size=100)

```

### 2.接口添加Accept-Encoding请求头
接口请求时，添加**Accept-Encoding：gzip**请求头

### 3.执行效果

```shell
curl -X 'POST' \
  'http://127.0.0.1:8081/user/login' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -H 'Accept-Encoding: gzip' \
  -d '{
  "name": "1",
  "age": 20,
  "phone": "12",
  "verification_code": "1"
    }'
   -o out.txt
```

可以通过Reqable或charles模块接口请求

![image](/images/post/fastapi开启gzip压缩/charles_overview1.jpg)
![image](/images/post/fastapi开启gzip压缩/charles_overview2.jpg)
![image](/images/post/fastapi开启gzip压缩/charles_overview3.jpg)
