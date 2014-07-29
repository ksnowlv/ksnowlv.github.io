---
layout: post
title: "rake-aborted"
date: 2014-07-08 15:52
comments: true
categories: github博客
---
****当时使用octopress生成网页时，报错如下****
{% img /images/post/2014-07-18-rake-aborted/rake-aborted-1.png %}

###方法1：
****直接把最新版本rake卸载即可。如下图:****
{% img /images/post/2014-07-18-rake-aborted/rake-aborted-2.png %}

如果卸载不了呢？看方法2

####方法2：
打开`Gemfile`
把
    
    gem 'rake', '~> 0.9'
修改为
    
    gem 'rake', '~> 10.3'

即可。

如果还有问题，尝试下

    bundle update rake
    bundle install   
    