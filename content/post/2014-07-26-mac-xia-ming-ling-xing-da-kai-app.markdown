---
title: "Mac下命令行打开App"
date: 2014-07-26
lastmod: 2014-07-26
categories:
  - "Mac"
tags:
  - "Mac"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

### mac下如何使用命令行打开App呢？

可以使用***open***命令。

例如：

    open -a /Applications/mou.app

### 可以查看下open都支持哪些参数    
    ksnowlvdeMacBook-Pro:lvweigithubblog ksnowlv$ open
    Usage: open [-e] [-t] [-f] [-W] [-R] [-n] [-g] [-h] [-b <bundle identifier>] [-a <application>] [filenames] [--args arguments]
    Help: Open opens files from a shell.
      By default, opens each file using the default application for that file.  
      If the file is in the form of a URL, the file will be opened as a URL.
    Options: 
      -a                Opens with the specified application.
      -b                Opens with the specified application bundle identifier.
      -e                Opens with TextEdit.
      -t                Opens with default text editor.
      -f                Reads input from standard input and opens with TextEdit.
      -F  --fresh       Launches the app fresh, that is, without restoring windows. Saved persistent state is lost, excluding Untitled documents.
      -R, --reveal      Selects in the Finder instead of opening.
      -W, --wait-apps   Blocks until the used applications are closed (even if they were already running).
          --args        All remaining arguments are passed in argv to the application's main() function instead of opened.
      -n, --new         Open a new instance of the application even if one is already running.
      -j, --hide        Launches the app hidden.
      -g, --background  Does not bring the application to the foreground.
      -h, --header      Searches header file locations for headers matching the given filenames, and opens them.
      
      
### 如何使用mou打开markdown文件呢？    
    open -a /Applications/mou.app /Users/ksnowlv/Movies/lvweigithubblog/source/_posts/2014-07-26-macxia-ming-ling-xing-da-kai-app.markdown
    
### 正常打开，你可以定义一个脚本来做这件事。

