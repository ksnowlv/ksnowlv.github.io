---
title: "git revert"
date: 2014-07-29
lastmod: 2014-07-29
categories:
  - "git"
tags:
  - "git"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---


## git revert操作命令

如何使用git的撤消操作呢？


 `git revert`撤销某次操作，此次操作之前的commit都会被保留。    
因此revert 只會使commit继续往前,优点是可以针对某個 commit 進行还原 并且留下还原记录

    git revert -n <commit id>     #撤销某次操作，commit id为提交号
    git revert -n HEAD~<number>   #撤销某个版本，number为向前数的版本号。 
    
    
 `git reset` 是撤销某次提交，但是此次之后的修改都会被退回到暂存区。
### 1.撤销到某一个提交号的版
```terminal
    git revert -n 08a94d26db3e7678d615625eb6c839729a21ac3f
    ksnowlv@ksnowlvdeMacBook-Pro~/Music/gittest$git status
    On branch master
    You are currently reverting commit 08a94d2.
      (all conflicts fixed: run "git revert --continue")
      (use "git revert --abort" to cancel the revert operation)

    Changes to be committed:
      (use "git reset HEAD <file>..." to unstage)

	deleted:    1.txt

    ksnowlv@ksnowlvdeMacBook-Pro~/Music/gittest$
```
### 2.撤销到某个版本

```terminal
    ksnowlv@ksnowlvdeMacBook-Pro~/Music/gittest$git revert -n HEAD~2
    ksnowlv@ksnowlvdeMacBook-Pro~/Music/gittest$ls
    a     a.txt
    ksnowlv@ksnowlvdeMacBook-Pro~/Music/gittest$git status
    On branch master
    You are currently reverting commit d5527c7.
      (all conflicts fixed: run "git revert --continue")
      (use "git revert --abort" to cancel the revert operation)

    Changes to be committed:
      (use "git reset HEAD <file>..." to unstage)

	deleted:    1.txt
	new file:   a.txt
	new file:   a/a.txt

    ksnowlv@ksnowlvdeMacBook-Pro~/Music/gittest$

```