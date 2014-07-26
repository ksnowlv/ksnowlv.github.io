---
layout: post
title: "octopress搭建github博客相关概念"
date: 2014-07-26 15:21
comments: true
categories: 
---

目前项目开发版本管理工具使用sourcetree，之前对git不太了解，所以，使用octopress搭建个github博客体验一把。

那都会涉及到哪些内容呢？先了解下以下概念：

####[ruby](https://www.ruby-lang.org/zh_cn/):是一种面向对象、命令式、函数式、动态的通用编程语言,参见维基百科的解释：[http://zh.wikipedia.org/zh/Ruby](http://zh.wikipedia.org/zh/Ruby)

####[rvm](https://rvm.io/):全称 ruby version manager：用于管理 Ruby 的版本的工具。
    便于安装Ruby环境，管理多个Ruby环境，管理开发的每个Ruby应用使用机器上哪个Ruby环境。
    Ruby环境不仅仅是Ruby本身，还包括依赖的第三方Ruby插件。都由RVM管理

####[RubyGem](http://rubygems.org/)：是一个用于对 Ruby组件进行打包的 Ruby 打包系统。 它提供一个分发 Ruby 程序和库的标准格式，还提供一个管理程序包安装的工具。

    RubyGems的功能类似于Linux下的apt-get。使用它可以方便第从远程服务器下载并安装Rails。
    打开命令行窗口(cmd)，输入执行命令 
    gem install rails --remote 
    或　gem install rails--include-dependencies。
    
####[Bundler](http://bundler.io/)：通过管理一个Ruby项目中的各个 Gem来管理整个项目的工具
    相当于多个RubyGems批处理运行。
    在配置文件gemfilel里说明你的应用依赖哪些第三方包。
    它自动帮你下载安装多个包，并且会下载这些包依赖的包
 
####[YAML](http://www.ibm.com/developerworks/cn/xml/x-cn-yamlintro/):YAML 是一种比 XML 更敏捷的半结构化数据格式。

    YAML可以基于流来处理；
    YAML表达能力强，扩展性好。

   Octopress 使用 yaml 做配置文件.
    
####[Octopress](http://octopress.org/):是一个静态站点生成工具，不需要使用动态的数据库和相关处理.可以用来搭建博客。

####[Git](http://git-scm.com/)：Git是一个分布式版本控制／软件配置管理软件。参见维基百科的解释：[http://zh.wikipedia.org/zh/Git](http://zh.wikipedia.org/zh/Git)

####[Markdown](http://)：是一种轻量级标记语言。“使用易读易写的纯文本格式编写文档，然后转换成有效的XHTML(或者HTML)文档”。见维基百科解释：[http://zh.wikipedia.org/wiki/Markdown](http://zh.wikipedia.org/wiki/Markdown)

在mac上可以选择使用[Mou](http://mouapp.com/)

####[Github](https://github.com/):是一个共享虚拟主机服务，用于存放使用Git版本控制的软件代码和内容项目。见维基百科解释：[http://zh.wikipedia.org/zh/GitHub](http://zh.wikipedia.org/zh/GitHub)

####github pages:Github推出的静态网页，支持 Jekyll，也支持封装Jekyll的Octopress。
