---
layout: post
title: "mac下git基本命令"
date: 2014-07-27 11:34
comments: true
categories: git
---

##持续整理中...

####git本地仓库由 git 维护的三棵“树”组成。

#####第一棵是 `工作目录`：它持有实际文件；

#####第二棵是 `暂存区(Index)`：它像个缓存区域，临时保存你的改动；

####第三棵是 `HEAD`:它指向你最后一次提交的结果。

###git 基本命令

####1.git help
    git --help              #git相关帮助
    git                     #git相关帮助
    git help -a             #available git commands in '/Applications/Xcode.app/Contents/Developer/usr/libexec/git-core'
    git help -g             #git使用指南
    git help <command>      #查看某一git命令的帮助

####2.git init
    git init         #初始化一个版本库
    
####3.git remote
    git remote             #列出已经存在的远程分支  
    git remote -v          #列出远程详细信息，每一个名字后面列出其远程url及动作
    git remote show origin #显示远程信息
    
    git remote add origin <url>                   #关联名称为origin的远程服务器代码库
    git remote set-url --push [name] [newUrl]     #修改远程仓库

####4.git add    

    git add .              #添加当前修改的文件到暂存区ut切换
    git add --all          #添加当前修改的文件到暂存区
    git add *              #添加当前目录所有修改的文件到暂存区
    git add <filename>     #添加filename文件到暂存区 
    
####5.git commit

    git commit –m "注释"        #提交修改
    git commit -a –m "注释"     #提交所有的修改
    
####6.git push 
    git push origin <branchname>            #推送你的更新到远程分支
    git push -u origin <branchname>         #将本地分支推到远程(如无远程分支则创建，用于初始化远程仓库)
    git push origin :<branchname>           #删除远程某一分支，某些情况下无效的。
    git push origin --delete <branchname>   #删除远程某一分支
    
    
####7.git branch

    git branch                   #列出本地所有的分支，若分支名前有*，则表示此分支为当前分支
    git branch <branchname>      #创建分支，不会切换到新分支，需要使用git checkout brannmae
    git checout –b <branchname>  #创建了分支，自动从当前工作分支切换到了该分支上。
    git branch –D  <branchname>  #删除本地分支
    git merge <branchname>       #自动合并分支改动，但是，可能会出现冲突。
    git checkout <branchname>    #切换到新分支，需要确保本地新分支是存在的
    git branch  --all            #本地所有的本地和远程对应的分支

####8.git pull
    git pull origin <branchname>  #获取(fetch)并且合并（merge）远端的改动。
    
####9.git clone
        
        git clone <filepath>  #创建一个本地仓库的克隆版本 
        git clone <url>       #克隆远端服务器上的仓库。
        
####10.git status
    git status    #当前的GIT状态，会指出当前没有可更新的，或者需要添加提交修改等
    
####11.git reset

    git reset                  #相当于git reset –mixed HEAD  
    git reset --hard HEAD      #回到上次提交时的状态 
    git reset HEAD <filepath>  #取消已经在暂存区里面等待被commit的文件
    


           
    
    
    
    