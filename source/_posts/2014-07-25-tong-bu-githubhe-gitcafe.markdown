---
layout: post
title: "同步github和gitcafe"
date: 2014-07-25 16:22
comments: true
categories: github
---

####1.在博客目录(例如：_config.yml所在目录)，找到Rakefile文件并打开，在

    .....
    message = "Site updated at #{Time.now.utc}"
    system "git commit -m \"#{message}\""
    puts "\n## Pushing generated #{deploy_dir} website"
    system "git push origin #{deploy_branch} --force"
    puts "\n## Github Pages deploy complete"
    
  
末尾追回两行，如下所示：

    system "git remote add <gitcafe项目url> >> /dev/null 2>&1"
    system  "git push -u gitcafe master:gitcafe-pages"
    
这样，在向github推送博客时，会同时向gitcafe推送最新博客。

    rake generate
    rake deploy
    
成功推送。

####2.在博客目录(例如：_config.yml所在目录)进入到.git目录，打开config文件，添加向gitcafe推送源代码文件的支持，完整的文件内容如下：

    [core]
	    repositoryformatversion = 0
	    filemode = true
	    bare = false
	    logallrefupdates = true
	    ignorecase = true
	    precomposeunicode = true
    [remote "origin"]
	    url = https://github.com/xxx/xxx.github.io.git
	    url = git@gitcafe.com:xxx/xxx.git
	    fetch = +refs/heads/*:refs/remotes/origin/*
    [remote "gitcafe"]
	    url = git@gitcafe.com:xxx/xxx.git
	    fetch = +refs/heads/*:refs/remotes/origin/*

    [remote "github"]
        url = https://github.com/xxx/xxx.github.io.git
	    fetch = +refs/heads/*:refs/remotes/origin/*

    [branch "source"]
	    remote = origin
	    merge = refs/heads/source
	    
在向github推送博客源代码的时，地同时向gitcafe推送最新博客源代码。

创建一新博客
    
    rake new_post[同步github和gitcafe]
    
编辑完成后
    
    git add --all
    git commit -a -m "new blog"
    git push origin source

成功推送。