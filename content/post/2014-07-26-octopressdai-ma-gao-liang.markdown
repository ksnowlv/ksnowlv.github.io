---
title: "Octopress代码高亮"
date: 2014-07-26
lastmod: 2014-07-26
categories:
  - "github-博客"
tags:
  - "github-博客"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

如何使用markdown文本中的代码高亮呢？


### 1.反引号代码块   可以指定代码标题，语言，链接等等。语法格式如下：

    ``` [language] [title] [url] [link text]
     代码块
    ```
以objective-c为例：

    ··· objective-c 
        oc代码
    ···

效果如下：

``` objective-c 

self.backgroundColor = [UIColor redColor];

```

### 2.Code Block代码块   可以指定代码标题，语言，链接等等。语法格式如下：

     { % codeblock [title] [lang:language] [url] [link text] % }
      代码块
     { % endcodeblock % }
 以objective-c为例：
 
    { % codeblock lang:objective-c  %} 
        oc代码
    { % endcodeblock  %} 
#### 注意:##### 1.{或}与%不要有空格，不然，不起作用。##### 2.如果上面语法中没有空格，会导致rake generate时出错.    
效果如下：

{% codeblock lang:objective-c %} 
self.backgroundColor = [UIColor redColor];

{% endcodeblock %}

### 3.更多代码高亮方式见：[http://octopress.org/docs/blogging/code/](http://octopress.org/docs/blogging/code/)