---
layout: post
title: "给iOS应用打补丁"
date: 2014-11-13 14:55
comments: true
categories: iOS
---

当iOS App出现bug时，由于不能很快上架，如何紧急修复bug呢？

**可以通过Lua给app打补丁**。
    
    将脚本放到后台服务器，App从服务器下载Lua代码，并在本地执行，实现了动态替换oc代码,快速修复bug。
    
>建议尽量少用，或不用。非紧急bug尽量不用。
   
###示例代码
####1.[Create-a-More-Flexible-App](https://github.com/mmin18/Create-a-More-Flexible-App)
####2.[Wax项目](http://github.com/probablycorey/wax)
####3.[WaxPatch](https://github.com/mmin18/WaxPatch)