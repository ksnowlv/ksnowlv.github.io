---
title: "Fastapi开启文件下载"
date: 2023-11-24T22:29:04+08:00
lastmod: 2023-11-24T22:29:04+08:00
keywords: ["python", "fastapi"]
tags: ["python", "fastapi", "后端开发"]
categories: ["python", "fastapi", "后端开发"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->
## fastapi搭建文件服务进行文件下载

### 1.文件下载

如何实现文件下载呢？通过get请求指定文件id，获取文件的内容。暂时不考虑大文件断点续传。
文件存储采用前文GriadFS存储

### 2.示例代码

```python
@router.get("/fileId/{file_id}")
async def get_file_content(file_id: str, response: Response):
    try:
        file = XGridFS.shared_gridfs().find_file(file_id)

        if file:
            content = file.read()
            # 解决文件名称为中文的情况,不然文件乱码
            encoded_filename = urllib.parse.quote(file.filename)
            response.headers["Content-Disposition"] = f'attachment; filename="{encoded_filename}"'
            return Response(content, media_type='application/octet-stream', headers=response.headers)

            # 返回上述Response或下面StreamingResponse都可以
            # file_stream = io.BytesIO(content)
            # return StreamingResponse(file_stream, media_type='application/octet-stream', headers=response.headers)
        else:
            return ResponseBaseModel(code=http.HTTPStatus.NOT_FOUND, message=f"找不到文件{file_id}")
    except:
        return ResponseBaseModel(code=http.HTTPStatus.SERVICE_UNAVAILABLE, message="存储服务异常")

```

### 3.执行效果

![image](/images/post/fastapi开启文件下载/test_file_download.jpg)

