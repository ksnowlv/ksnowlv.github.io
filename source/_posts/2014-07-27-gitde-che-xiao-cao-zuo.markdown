---
layout: post
title: "git的撤消操作"
date: 2014-07-27 19:41
comments: true
categories: git
---


####1.撤消add:撤消提交到暂存区的文件

先添加一个文件

    ksnowlvdeMacBook-Pro:gittest ksnowlv$ vim b.text
    ksnowlvdeMacBook-Pro:gittest ksnowlv$ git add .

查看当前git状态
   
    ksnowlvdeMacBook-Pro:gittest ksnowlv$ git status
    On branch master
    Changes to be committed:
      (use "git reset HEAD <file>..." to unstage)

	new file:   b.text
	
使用`git reset`或`git reset b.text`撤消

    ksnowlvdeMacBook-Pro:gittest ksnowlv$ git reset
此时查看git状态

    ksnowlvdeMacBook-Pro:gittest ksnowlv$ git status
    On branch master
    Untracked files:
      (use "git add <file>..." to include in what will be committed)

	    b.text

    nothing added to commit but untracked files present (use "git add" to track)
    
####2.撤消commit:撤消commit到本地版本库的文件

先创建并添加c.txt文件

    ksnowlvdeMacBook-Pro:gittest ksnowlv$ vim c.txt
    ksnowlvdeMacBook-Pro:gittest ksnowlv$ git add c.txt
    ksnowlvdeMacBook-Pro:gittest ksnowlv$ git commit -a -m "add c.txt"
    [master 66b155f] add c.txt
     1 file changed, 1 insertion(+)
     create mode 100644 c.txt
使用git log查看提交日志

    ksnowlvdeMacBook-Pro:gittest ksnowlv$ git log
    commit 66b155f5f76ae0b48129638d082432fa2fcd62c8
    Author: xxxx
    Date:   Sun Jul 27 20:10:04 2014 +0800

    add c.txt

    commit 5320bdfd1d64f24fdcc2a9edbd056e56fbbf13b7
    Author:  xxxx
    Date:   Sun Jul 27 19:31:22 2014 +0800

    add b.text

    commit 5636eace1f76c6fa548cb126324f9ec8ad8a4f04
    Author: xxxx
    Date:   Sun Jul 27 19:21:48 2014 +0800

    add new file
 撤消commit操作   

    ksnowlvdeMacBook-Pro:gittest ksnowlv$ git reset --hard 5636eace1f76c6fa548cb126324f9ec8ad8a4f04
    HEAD is now at 5636eac add new file
    
本地回退到该版本，如果想远程分支也回退到该版本，再强制推送到远程分支即可，    
   
    git push -f origin master
    
    
 ####3.将本地的状态回退到和远程的一样
 先将本地文件b.text修改下，观察是否回退到的远程.
 
    ksnowlvdeMacBook-Pro:gittest ksnowlv$ vim b.text 
    ksnowlvdeMacBook-Pro:gittest ksnowlv$ git reset --hard origin/master
    HEAD is now at 804b9f4 modify b
   
b.text是和远程的相同的

