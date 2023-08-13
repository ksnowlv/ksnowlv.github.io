---
title: "基于octopress的github博客使用git管理源代码和网页代码"
date: 2014-08-07
lastmod: 2014-08-07
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

#### 基于octopress的github/gitcafe博客，都会涉及到源代码管理。对于git,github/gitcafe的初学者而言，可能容易走弯路。

先看下博客目录:
 ![image](/images/post/2014-08-07-ji-yu-octopress-de-github-bo-ke-shi-yong-gitguan-li-yuan-dai-ma-he-wang-ye-dai-ma/github-blog-dir.png) 

    lvweigithubblog和_deploy两个目录下，是不同的git版本库，对应不同分支。一定不能搞乱。
    在lvweigithubblog目录下,操作目录始终是在lvweigithubblog目录:
    使用git命令操作远程source分支;
    使用rake generate/deploy/new_post/...操作的是远程master分支。


#### 1.静态网页代码版本管理   
#### 网页生成，rake generate 是生成本地博客pulic目录下静态网页, rake deploy 是把public目录下的静态网页文件拷贝到_deploy目录下，并自动调用git命令把_deploy目录下网页文件上传到远程分支master.    
    _deploy下的git版本库，管理的是是网页文件，操作的是master分支

详情参考下图:

 ![image](/images/post/2014-08-07-ji-yu-octopress-de-github-bo-ke-shi-yong-gitguan-li-yuan-dai-ma-he-wang-ye-dai-ma/git-for-master-github-pages.png)    
    
#### 2.网页源代码版本管理#### lvweigithubblog下的源文件管理，可以通过git相关命令，也可以使用sourcetree等工具进行管理。可以通过`git status`查看当前所在分支
    lvweigithubblog根目录下的git版本库实际上只管理除了public,_deploy两个主要目录以外所有的文件，octopress的配置自动忽略这两个目录。只处理这两个目录以外的版本变化情况。

    该git版本库处理的是远程source分支，你可以随便命名该分支，比如a都行，只要不和master分支重名即可。所以，这个git版本库必须切换到source分支，一定不能是master分支。

详情参考下图:

 ![image](/images/post/2014-08-07-ji-yu-octopress-de-github-bo-ke-shi-yong-gitguan-li-yuan-dai-ma-he-wang-ye-dai-ma/git-for-source-code.png)    
