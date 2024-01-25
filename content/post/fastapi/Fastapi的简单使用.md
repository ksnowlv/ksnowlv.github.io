---
title: "fastapi的简单使用"
date: 2023-10-17T11:19:49+08:00
lastmod: 2023-10-17T11:19:49+08:00
keywords: ["python", "fastapi", "后端开发"]
tags: ["python", "fastapi", "后端开发"]
categories: ["python", "fastapi", "后端开发"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## 一.fastapi的简单使用

### 1.fastapi安装

```shell
 pip3 install fastapi 
Collecting fastapi
  Obtaining dependency information for fastapi from https://files.pythonhosted.org/packages/4d/d2/3ad038a2365fefbac19d9a046cab7ce45f4c7bfa81d877cbece9707de9ce/fastapi-0.103.2-py3-none-any.whl.metadata
  Using cached fastapi-0.103.2-py3-none-any.whl.metadata (24 kB)
Collecting anyio<4.0.0,>=3.7.1 (from fastapi)
  Obtaining dependency information for anyio<4.0.0,>=3.7.1 from https://files.pythonhosted.org/packages/19/24/44299477fe7dcc9cb58d0a57d5a7588d6af2ff403fdd2d47a246c91a3246/anyio-3.7.1-py3-none-any.whl.metadata
  Using cached anyio-3.7.1-py3-none-any.whl.metadata (4.7 kB)
  ...

```

### 2.安装uvicorn

```shell
 
(venv) (base) lvwei@lvweideMacBook-Pro fastapitest % pip3 install "uvicorn[standard]"
WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/uvicorn/
Collecting uvicorn[standard]
  Obtaining dependency information for uvicorn[standard] from https://files.pythonhosted.org/packages/79/96/b0882a1c3f7ef3dd86879e041212ae5b62b4bd352320889231cc735a8e8f/uvicorn-0.23.2-py3-none-any.whl.metadata
  Downloading uvicorn-0.23.2-py3-none-any.whl.metadata (6.2 kB)
  ...

```

## 二.示例代码

```python
from typing import Union
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def read_root():
    return {"Hello": "World"}

@app.get("/items/{item_id}")
async def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

## 三.启动服务并测试


使用uvicorn main:app --reload启动服务




打开swagger交互API文档[http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)进行API测试

![image](/images/post/fastapi的简单使用/api_overview.png)

![image](/images/post/fastapi的简单使用/api_test.png)

测试情况

```shell
(venv) (base) lvwei@lvweideMacBook-Pro fastapitest % uvicorn main:app --reload      
INFO:     Will watch for changes in these directories: ['/Users/lvwei/Documents/python_projects/fastapitest']
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
INFO:     Started reloader process [1675] using WatchFiles
INFO:     Started server process [1677]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     127.0.0.1:51078 - "GET / HTTP/1.1" 200 OK
INFO:     127.0.0.1:51186 - "GET /apple-touch-icon-precomposed.png HTTP/1.1" 404 Not Found
INFO:     127.0.0.1:51187 - "GET /apple-touch-icon.png HTTP/1.1" 404 Not Found
INFO:     127.0.0.1:51188 - "GET /favicon.ico HTTP/1.1" 404 Not Found
INFO:     127.0.0.1:51198 - "GET /apple-touch-icon-precomposed.png HTTP/1.1" 404 Not Found
INFO:     127.0.0.1:51199 - "GET /apple-touch-icon.png HTTP/1.1" 404 Not Found
INFO:     127.0.0.1:51200 - "GET /favicon.ico HTTP/1.1" 404 Not Found
INFO:     127.0.0.1:51210 - "GET / HTTP/1.1" 200 OK
INFO:     127.0.0.1:51312 - "GET / HTTP/1.1" 200 OK
INFO:     127.0.0.1:51312 - "GET /docs HTTP/1.1" 200 OK
INFO:     127.0.0.1:51312 - "GET /openapi.json HTTP/1.1" 200 OK
INFO:     127.0.0.1:51517 - "GET /items/1?q=hello HTTP/1.1" 200 OK
INFO:     127.0.0.1:51831 - "GET /items/2?q=ksnowlv HTTP/1.1" 200 OK

```


