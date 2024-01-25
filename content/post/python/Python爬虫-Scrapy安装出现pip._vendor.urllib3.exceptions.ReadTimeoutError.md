---
title: "Python爬虫-scrapy安装时ReadTimeoutError问题解决"
date: 2023-08-24T20:27:05+08:00
lastmod: 2023-08-24T20:27:05+08:00
keywords: ["Python", "Scrapy"]
tags: ["Python"]
categories: ["Python"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## 一.问题

在Mac上安装Scrapy时出现“ReadTimeoutError”时，如何解决呢？

```shell

  File "/Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages/pip/_vendor/urllib3/response.py", line 443, in _error_catcher
    raise ReadTimeoutError(self._pool, None, "Read timed out.")
pip._vendor.urllib3.exceptions.ReadTimeoutError: HTTPSConnectionPool(host='files.pythonhosted.org', port=443): Read timed out.
```

## 二.原因

从"HTTPSConnectionPool"，"Read timed out"可以看出是因为网络比较慢造成异常

## 三.解决方案

###  换个网络或换个网络快的时间段
### 使用pip --default-timeout=1000 install -U 模块名 修改超时时间


```shell
pip --default-timeout=1000 install -U 模块名

