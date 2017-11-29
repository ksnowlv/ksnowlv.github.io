---
layout: post
title: "octopress博客继续阅读"
date: 2014-07-26 20:56
comments: true
categories: github博客
---



如果正文太长，不希望在首页直接显示完整内容，如何显示部分内容呢?

<!--more-->

####1.在_config.yml文件中，添加显示部分内容的支持。

    excerpt_link: "阅读全文&rarr;"  
    excerpt_separator: "<!--more-->"

####2.在博客适当的位置加上一句
     
     <!--more-->

####后面的内容就会被按钮Read on→所替代，点击继续阅读。