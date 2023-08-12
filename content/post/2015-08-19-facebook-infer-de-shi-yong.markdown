---
title: "FaceBook-infer的使用"
date: 2015-08-19
categories:
  - "iOS-基础"
tags:
  - "iOS-基础"
---
<!--more-->

**Facebook**推出潜在一款**bug**扫描工具([http://fbinfer.com](http://fbinfer.com))，可以检查 **iOS/Android** App.

<!--more-->

MAC上的安装

### 一.环境要求
* 1.Python版本大于等于2.7
* 2.[opam](https://opam.ocaml.org/doc/Install.html#OSX)
* 3.对C/Objective-C分析要求
	*  XCode <= 6.3, >= 6.1
	* clang (in XCode command line tools. You can install them with the command xcode-select --install)
	
	
### 二.安装步骤#### 1.安装opam。
```objective-c 
brew install opam   # Homebrew, OSX Mavericks or later

opam init --comp=4.01.0  # (answer 'y' to the question)

eval \`opam config env\` #去掉前面\

opam install extlib.1.5.4 atdgen.1.6.0 javalib.2.3.1 sawja.1.5.1

```	

#### 2.对C/Objective-C的分析支持。如果你既想支持Java,也想支持C/Objective-C,那么换下面的方式执行

```objective-c 

cd infer
./update-fcp.sh && ../facebook-clang-plugin/clang/setup.sh && ./compile-fcp.sh # go have a coffee :)
make -C infer
export PATH=\`pwd\`/infer/bin:$PATH #去掉前面\


```	