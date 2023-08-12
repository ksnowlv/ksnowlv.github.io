---
title: "为github博客添加license"
date: 2014-07-25
categories:
  - "github-博客"
tags:
  - "github-博客"
---
<!--more-->
如何为github博客添加license呢？

<!--more-->

#### 1.在source/_includes/post目录创建license.html,内容如下：
    <p> 
    <DIV >
    作者： <A href="http://ksnowlv.github.io">律威</A> <BR>
    出处： <A href="http://ksnowlv.github.io">http://    ksnowlv.github.io</A> 
    <BR>原创文章，版权声明：自由转载-非商用-非衍生-保持署名
    <a href= "http://creativecommons.org/licenses/by-nc-nd/3.0/deed.zh"> Creative Commons BY-NC-ND 3.0 </a>。 
    </DIV>
    </p>


#### 2.在source/_layouts/post.html为每篇文章添加license.html,在article->footer->p标签下，修改如下：  {% img /images/post/2014-07-25-wei-githubbo-ke-tian-jia-license/1.png %}

#### 3. 修改_config.yml文件，对license的支持.    # Post License
    post_license: true

效果如下：

 {% img /images/post/2014-07-25-wei-githubbo-ke-tian-jia-license/action_result.png %}