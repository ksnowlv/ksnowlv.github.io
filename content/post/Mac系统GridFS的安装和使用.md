---
title: "Mac系统GridFS的安装和使用"
date: 2023-11-21T14:02:27+08:00
lastmod: 2023-11-21T14:02:27+08:00
keywords: ["Python", "GridFS", "存储"]
tags: ["Python", "存储"]
categories: ["Python", "存储"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## GridFS的安装和使用

### 1.安装MongoDB。
打开终端，并执行以下命令安装 MongoDB：

```terminal
arch -arm64 brew tap mongodb/brew
arch -arm64 brew install mongodb-community

```


### 2.安装 pymongo 和 gridfs 包
```terminal
arch -arm64 pip3 install pymongo
```

### 3.启动MongoDB 服务
```terminal
brew services start mongodb-community
```

### 4.MongoDB可视化工具

[https://www.mongodb.com/try/download/shell](https://www.mongodb.com/try/download/shell
)选择合适的版本下载安装

### 5.GridFS的使用

```python
from bson import ObjectId
from pymongo import MongoClient
import gridfs
from typing import Any

g_gridfs = None


class XGridFS(object):

    def __init__(self):
        self.fs = None

    def init_gridfs(self):
        # 连接到 MongoDB 数据库
        client = MongoClient('mongodb://localhost:27017/')
        db = client['my_database']
        self.fs = gridfs.GridFS(db, 'fs')

    def put_file(self, file_content: Any, file_name: str):
        file_id = self.fs.put(file_content, filename=file_name)
        return file_id

    def find_file(self, file_id: str):
        return self.fs.get(ObjectId(file_id))

    def find_one(self, d: dict):
        file = self.fs.find_one(d)
        if file:
            return file

        return None

    def gridfs(self):
        return self.fs

    @staticmethod
    def shared_gridfs():
        global g_gridfs
        if not g_gridfs:
            g_gridfs = XGridFS()
            g_gridfs.init_gridfs()

        return g_gridfs

```

### 6.FastAPI上传单个文件

```python

router.post("/uploadFile", response_model=ResponseBaseModel)
async def upload_file(file: UploadFile = None):
    if not file:
        return ResponseBaseModel(code=http.HTTPStatus.NOT_ACCEPTABLE, message=f"文件为空，上传失败", data={
            "file_id": 0,
        })

    f = XGridFS.shared_gridfs().find_one({'filename': file.filename})
    # 如果文件存在，则返回文件id；如果不存在，则写入GridFS
    file_content = None
    if f:
        gridfs_file_content = XGridFS.shared_gridfs().gridfs().get(f._id).read()
        file_content = await file.read()
        # 比较文件是否相同
        if md5_by_data(file_content) == md5_by_data(gridfs_file_content):
            return ResponseBaseModel(message=f"文件{file.filename}已经存在", data={
                "file_id": str(f._id),
            })

    if not file_content:
        file_content = await file.read()
    # 将文件写入 GridFS 中
    file_id = XGridFS.shared_gridfs().put_file(file_content, file.filename)

    if not file_id:
        return ResponseBaseModel(message=f"文件{file.filename}上传失败", data={
            "file_id": 0,
        })

    return ResponseBaseModel(message=f"文件{file.filename}上传成功", data={
        "file_id": str(file_id),
    })


```

### 7.执行效果

![image](/images/post/Mac系统GridFS的安装和使用/mogodb_my_database_overview.png)

![image](/images/post/Mac系统GridFS的安装和使用/mogodb_my_database_files.png)
