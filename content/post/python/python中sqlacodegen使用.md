---
title: "Python中sqlacodegen使用"
date: 2024-06-11T20:01:07+08:00
lastmod: 2024-06-11T20:01:07+08:00
keywords: ["Python"]
tags: ["Python"]
categories: ["Python"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


### 1.sqlacodegen

官方链接：https://pypi.org/project/sqlacodegen/

作用：根据已有数据库(表)结构生成对应SQLAlchemy模型

### 2.sqlacodegen安装

```shell
 pip3 install sqlacodegen
```


### 3.数据库表示例

```sql

mysql> desc users;
+-------------------+--------------+------+-----+-------------------+-------------------+
| Field             | Type         | Null | Key | Default           | Extra             |
+-------------------+--------------+------+-----+-------------------+-------------------+
| id                | int          | NO   | PRI | NULL              | auto_increment    |
| userid            | varchar(64)  | NO   | MUL |                   |                   |
| name              | varchar(64)  | NO   | MUL |                   |                   |
| age               | int          | NO   |     | 0                 |                   |
| phone             | varchar(20)  | NO   | MUL |                   |                   |
| verification_code | varchar(6)   | NO   |     |                   |                   |
| token             | varchar(64) | NO   | UNI |                   |                   |
| password          | varchar(64)  | NO   |     |                   |                   |
| email             | varchar(64)  | NO   |     |                   |                   |
| status            | tinyint      | NO   |     | 1                 |                   |
| created_time      | datetime     | NO   |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| updated_time      | datetime     | NO   |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| delete_time       | datetime     | NO   |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
+-------------------+--------------+------+-----+-------------------+-------------------+
```


### 4.使用sqlacodegen转换

```shell
snowlv@MacBook-Pro-3 ~ % sqlacodegen mysql+pymysql://root:12345678@127.0.0.1:3306/fastapitest --outfile models.py
Traceback (most recent call last):
  File "/Library/Frameworks/Python.framework/Versions/3.11/bin/sqlacodegen", line 5, in <module>
    from sqlacodegen.main import main
  File "/Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages/sqlacodegen/main.py", line 11, in <module>
    from sqlacodegen.codegen import CodeGenerator
  File "/Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages/sqlacodegen/codegen.py", line 9, in <module>
    from inspect import ArgSpec
ImportError: cannot import name 'ArgSpec' from 'inspect' (/Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/inspect.py)
```

#### 4.1.如何解决上述错误呢？

找到`\site-packages\sqlacodegen\codegen.py`文件，在`line 9`

```python
# from inspect import ArgSpec
换为下面判断
if not hasattr(inspect, 'getfullargspec'):
    from inspect import ArgSpec

```

#### 4.2.转换


```shell
ksnowlv@MacBook-Pro-3 Sites % sqlacodegen mysql+pymysql://root:12345678@127.0.0.1:3306/fastapitest --outfile models.py
ksnowlv@MacBook-Pro-3 Sites % ls
models.py
ksnowlv@MacBook-Pro-3 Sites % cat models.py 
# coding: utf-8
from sqlalchemy import Column, DateTime, Integer, String, text
from sqlalchemy.dialects.mysql import TINYINT
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()
metadata = Base.metadata


class User(Base):
    __tablename__ = 'users'
    __table_args__ = {'comment': '用户表'}

    id = Column(Integer, primary_key=True, index=True, comment='主键')
    userid = Column(String(64), nullable=False, index=True, server_default=text("''"), comment='用户userId')
    name = Column(String(50), nullable=False, index=True, server_default=text("''"), comment='用户姓名')
    age = Column(Integer, nullable=False, server_default=text("'0'"), comment='用户年龄')
    phone = Column(String(20), nullable=False, index=True, server_default=text("''"), comment='手机号')
    verification_code = Column(String(6), nullable=False, server_default=text("''"), comment='验证码')
    token = Column(String(256), nullable=False, unique=True, server_default=text("''"), comment='用户惟一token')
    password = Column(String(64), nullable=False, server_default=text("''"), comment='用户密码')
    email = Column(String(64), nullable=False, server_default=text("''"), comment='电子邮箱')
    status = Column(TINYINT, nullable=False, server_default=text("'1'"), comment='状态，1.正常 -1.黑名单')
    created_time = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"), comment='创建时间')
    updated_time = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"), comment='更新时间')
    delete_time = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"), comment='删除时间')

```

### 5.其它

* `sqlacodegen` 支持版本：`SQLAlchemy` 0.8.x - 1.3.x
* 适用场景
  * 从数据库中导出类模型，特别是数据库表特别多的情况，很好用。

