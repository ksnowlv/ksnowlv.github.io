---
title: "Xcode下条件断点"
date: 2013-05-14
lastmod: 2013-05-14
categories:
  - "iOS"
tags:
  - "xcode"
comment: true
toc: false
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

![image](/images/post/2013-05-14-xcodexia-tiao-jian-duan-dian/1.png) 
首先在46行下个断点，在弹出选择菜单，如上图，点击“Edit Breakpoint”菜单，弹出如下提示框

![image](/images/post/2013-05-14-xcodexia-tiao-jian-duan-dian/2.png) 
 
在"condition"中设置条件，在action中，，我们选取“Debugger Command”，然后，我们执行：print i的动作。点击完成，条件断点就设置好了。
