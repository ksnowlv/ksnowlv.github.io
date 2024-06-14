---
title: "Python爬虫关于DrissionPage的使用"
date: 2024-06-07T09:41:12+08:00
lastmod: 2024-06-07T09:41:12+08:00
keywords: ["python", "爬虫"]
tags: ["python", "爬虫"]
categories: ["python", "爬虫"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 1.DrissionPage的安装

```shell
 pip3 install DrissionPage
```

如果无法安装，可以试下国内镜像

```shell
pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple/ --upgrade  DrissionPage
```


### 2.DrissionPage

#### 2.1.简介
DrissionPage(http://drissionpage.cn)是一个基于 python 的网页自动化工具。

它既能控制浏览器，也能收发数据包，还能把两者合而为一。

可兼顾浏览器自动化的便利性和 requests 的高效率。

它功能强大，内置无数人性化设计和便捷功能。

它的语法简洁而优雅，代码量少，对新手友好。

#### 2.2.版本及支持情况

* 最新版本：4.0.4.24
* 支持系统：Windows、Linux、Mac
* python 版本：3.6 及以上
* 支持应用：Chromium 内核浏览器（如 Chrome、Edge），electron 应用

### 3.使用示例

一般情况下，如果针对多个不同页面进行处理，定义个页面处理模板`BaseDrissionPage`

```python
import csv
import os
from DrissionPage import ChromiumPage, ChromiumOptions

class BaseDrissionPage(object):
    
    def __init__(self):
        self.file_name = None
        self.url = None
        self.page = None

    def set_city_page_info(self, file_name, url):

        self.file_name = file_name
        self.url = url
        self.__load_csv()
        self.__load_city_page()


    def __load_city_page(self):

        if not self.url:
            return

        co = ChromiumOptions().auto_port()
        self.page = ChromiumPage(co)
        self.page.get(self.url)
        self.page.wait.load_complete()
        self.parse_page()
        self.page.close()

    def parse_page(self):
        # 解析页面
        pass
```

其子类负责处理页面及数据存取即可

#### 3.1.ChromiumPage配置
`co = ChromiumOptions().auto_port()`确保新启浏览器窗口，并分配端口，可以正常访问。

若无该配置，是在同一个浏览器窗口中

#### 3.2. 为什么`self.page.get(self.url)`之后，

要添加要`self.page.wait.load_complete()`

确保页面加载完成，页面内的元素是存在的；不然，可能出现页面元素缺失造成元素定位失败。


#### 3.3.页面关闭

`self.page.close()`关闭浏览器标签页面或窗口,回收资源

如果是点击某个页面新元素，触发打开新页面，例如：

```python
    link_element.click()
    self.page.wait.load_complete()
    # 确保页面是打开了，不然，不做处理。
    if self.page.tabs_count > 1:
        city_names = self.get_city_names_from_new_page(name)

```
`get_city_names_from_new_page`的实现

```python
 def get_city_names_from_new_page(self, name):
        new_page = self.page.get_tab(self.page.latest_tab)
        info_element = new_page.ele('·城市：')

        if info_element is None:
            print(f'info_element NONE')
            return None

        city_names = None

        if info_element:
            info_text = info_element.text
            ...
            
        new_page.close()
        return city_names

```

确保打开新页面和关闭是配对的。

### 4.页面处理

官方文档写的很细致，全面，下面只介绍些常用的，感兴趣的可以了解下；

#### 4.1.页面交互

* 页面跳转

```python
    page.get('url')
```

* 页面后退

```python
    page.back(3)  # 后退三个网页
```

* 页面刷新

```python
    page.refresh()  # 刷新页面
```

#### 4.2.元素查找

* id查找

```python

# page内查找id属性为city_id的元素
ele = page.ele('#city_id')  

```

* class查找
```python

# page内查找class属性city_id的元素
ele = page.ele('#city_id')
```

* 类型匹配符 tag

```python
# 定位div元素
ele2 = ele1.ele('tag:div')

# 定位class属性为city_id的p元素
ele2 = ele1.ele('tag:p@class=city_id')

```

如果查找的元素是数组，由`ele`更换为`eles`

* 父级元素查找
```python
# 获取 ele1 的第二层父元素
ele2 = ele1.parent(2)

# 获取 ele1 父元素中 id 为 id1 的元素
ele2 = ele1.parent('#id1')
```

* 子级元素查找
    * child
    * children


* 同级元素查找
  * next
  * nexts
  * prev
  * prevs

### 5.其它

以上可以满足多数页面处理需求，仅仅只做学习展示使用。

除了上面关于`ChromiumPage`的使用，单纯用于操作浏览器的页面对象，还有
像`WebPage`(整合浏览器控制和收发数据包于一体的页面对象) ， `SessionPage`(单纯用于收发数据包的页面对象)可以了解下






