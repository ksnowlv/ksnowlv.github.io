---
title: "FastAPI读取生产或测试环境配置文件"
date: 2024-01-07T20:37:03+08:00
lastmod: 2024-01-07T20:37:03+08:00
keywords: ["fastapi", "后端开发"]
tags: ["fastapi", "后端开发"]
categories: ["fastapi", "后端开发"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## FastAPI通过dotenv读取生产或测试环境配置

### 1.pycharm中的Run/Debug Configurations设置中配置环境变量

![image](/images/post/Fastapi读取生产或测试环境配置文件/pycharm_setting.jpg)


### 2.读取环境变量

```python

    print(os.environ.get('PYTHONUNBUFFERED'))
    print(os.environ.get('ENVTYPE'))

    env_type = os.environ.get("ENVTYPE")
    if env_type == "prod":
        config_file = "prod.env"
    elif env_type == "test":
        config_file = "test.env"

```

### 3.创建env文件及配置类

```python

from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    REDIS_URL: str
    MYSQL_DATABASE_URL: str
    GRIDFS_URL: str
    DEBUG: bool
```

test.env文件

```env
REDIS_URL="redis://127.0.0.1:6379/0?encoding=utf-8"
MYSQL_DATABASE_URL = "mysql+pymysql://root:111111@127.0.0.1:3306/mydatabase?charset=utf8mb4"
GRIDFS_URL="mongodb://localhost:27017/"
DEBUG=True

```

prod.env文件类似

这样很容易配置测试，生产等不同的环境了。


