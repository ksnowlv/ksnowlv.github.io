---
layout: post
title: "Objective-C的文档生成工具-Appledoc"
date: 2014-09-06 08:36
comments: true
categories: Xcode
---
[Appledoc](https://github.com/tomaz/appledoc)默认生成的文档风格与苹果的官方文档是一致的,生成docset，可以集成到xcode中。在源码中按住option再单击就可以调出相应方法的帮助。

<!--more-->

####1.Appledoc安装.

    git clone git://github.com/tomaz/appledoc.git
    cd appledoc
    sudo sh install-appledoc.sh
    
 或者在安装[Homebrew](http://brew.sh)后，使用Homebrew安装也可。
     
     brew install appledoc
     
####2.Appledoc生成。

我使用曾经做的[iOS腾讯地图API](http://open.map.qq.com/ios_v1/index.html)为例，把**API**的**inc**文件拷贝到目录**QQMapAPI**.指定工程名为**QQMapAPI**，公司名为**tencent**

    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/QQMapAPI$appledoc    -p QQMapAPI -c  tencent -v 1.0  -o  /Users/ksnowlv/Movies/QQMapAPI/inc  /Users/ksnowlv/Movies/QQMapAPI
    appledoc version: 2.2 (build 963)
    ...
  
 使用`appledoc --help`查看相关命令
 
     ksnowlv@ksnowlvdeMacBook-Pro~/Movies/QQMapAPI$appledoc --help
    Usage: appledoc [OPTIONS] <paths to source dirs or files>

    PATHS
      -o, --output <path>                     Output path
      -t, --templates <path>                  Template files path
      --docset-install-path <path>        DocSet installation path
      -s, --include <path>                    Include static doc(s) at path
      -i, --ignore <path>                     Ignore given path
      -x, --exclude-output <path>             Exclude given path from output
      --index-desc <path>                 File including main index description

    PROJECT INFO
      -p, --project-name <string>             Project name
      -v, --project-version <string>          Project version
      -c, --project-company <string>          Project company
      --company-id <string>               Company UTI (i.e. reverse DNS name)
   
    
####简单解释下:    

* -p:工程名称
* -c:公司名称
* `-v`:版本号
* `/Users/ksnowlv/Movies/QQMapAPI/`:生成结果输出路径。成功以后,appledoc会新建一个文本文件来记录生成情况.
* `/Users/ksnowlv/Movies/QQMapAPI/inc`:扫描目标的目录所有文件。

####3.文档查看。
   在苹果帮助文档目录：`/Users/ksnowlv/Library/Developer/Shared/Documentation/DocSets`查看**QQMapAPI**生成的文档。
   ![image](/images/post/2014-09-06-objective-c-de-wen-dang-sheng-cheng-gong-ju-appledoc/qqmapapi_path.png)
   
   在xcode帮助文档中查看**QQMapAPI文档**
   ![image](/images/post/2014-09-06-objective-c-de-wen-dang-sheng-cheng-gong-ju-appledoc/qqmapapi_in_xcode_help.png)
   
