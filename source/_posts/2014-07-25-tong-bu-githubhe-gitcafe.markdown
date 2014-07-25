---
layout: post
title: "同步github和gitcafe"
date: 2014-07-25 16:22
comments: true
categories: github
---

####1.找到Rakefile文件并打开，在

    .....
    message = "Site updated at #{Time.now.utc}"
    system "git commit -m \"#{message}\""
    puts "\n## Pushing generated #{deploy_dir} website"
    system "git push origin #{deploy_branch} --force"
    puts "\n## Github Pages deploy complete"
    
  
####末尾追回两行，如下所示：

    system "git remote add <gitcafe项目url> >> /dev/null 2>&1"
    system  "git push -u gitcafe master:gitcafe-pages"
    
####这样，在向github推送博客时，会同时向gitcafe推送最新博客。

####2.找到config
