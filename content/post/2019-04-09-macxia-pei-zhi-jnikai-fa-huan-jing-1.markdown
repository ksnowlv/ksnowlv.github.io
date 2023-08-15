---
title: Mac配置jni开发环境(一)
date: 2019-04-09
lastmod: 2019-04-09
categories:
  - "Android"
tags:
  - "jni"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

Mac机器上，在进行jni开发之前，android studio 3.3.2，需要配置java环境与ndk环境。

## 一.配置java环境参数

### 1.jdk安装目录

使用*which java*查看jdk安装目录

```terminal
	ksnowlvdeMacBook-Pro:~ ksnowlv$ which java
 	/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home/bin/java

```

![image](/images/post/2019-04-09-macxia-pei-zhi-jnikai-fa-huan-jing-1/jdk-path.png) 


### 2.在.bash_profile文件配置java环境

```terminal
	JAVA_HOME=/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home
	PATH=$JAVA_HOME/bin:$PATH:.
	CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:.

	export JAVA_HOME
	export PATH
	export CLASSPATH
	
```

### 3.保存.bash_profile，并使之生效。

```terminal

	ksnowlvdeMacBook-Pro:~ ksnowlv$ source .bash_profile
	
	ksnowlvdeMacBook-Pro:~ ksnowlv$ echo $JAVA_HOME
	/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home
	
	ksnowlvdeMacBook-Pro:~ ksnowlv$ java -version
	Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
	java version "1.6.0_65"
	Java(TM) SE Runtime Environment (build 1.6.0_65-b14-468)
	Java HotSpot(TM) 64-Bit Server VM (build 20.65-b04-468, mixed mode)
	
```	
	
## 二.配置ndk

### 1..bash_profile文件配置ndk路径
```terminal

 	export ANDROID_NDK_ROOT=/Users/ksnowlv/Library/Android/sdk/ndk-bundle 
 	export ANDROID_SDK_ROOT=/Users/ksnowlv/Library/Android/sdk

 	export PATH=$PATH:$ANDROID_SDK_ROOT  
 	export PATH=$PATH:$ANDROID_NDK_ROOT 
```
	
ndk路径，sdk路径一定要与实际目录一致，参考下图	
![image](/images/post/2019-04-09-macxia-pei-zhi-jnikai-fa-huan-jing-1/jdk-path.png) 

### 2.保存.bash_profile，并使之生效。	
```terminal

ksnowlvdeMacBook-Pro:~ ksnowlv$ source .bash_profile
	ksnowlvdeMacBook-Pro:~ ksnowlv$ echo $ANDROID_NDK_ROOT
	/Users/ksnowlv/Library/Android/sdk/ndk-bundle
	ksnowlvdeMacBook-Pro:~ ksnowlv$ echo $ANDROID_SDK_ROOT
	/Users/ksnowlv/Library/Android/sdk
	ksnowlvdeMacBook-Pro:~ ksnowlv$ 
	
```	

## 三.其它

### 1.关于jdk版本

Q：为什么不使用jdk-12.jdk？而使用了旧版jdk？

A：javah命令在旧版有效。新版可使用javac -h

