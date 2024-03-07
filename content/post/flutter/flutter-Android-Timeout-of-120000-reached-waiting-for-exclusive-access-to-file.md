---
title: "Flutter Android Timeout of 120000 Reached Waiting for Exclusive Access to File"
date: 2024-03-06T22:59:30+08:00
lastmod: 2024-03-06T22:59:30+08:00
keywords: ["flutter"]
tags: ["flutter"]
categories: ["flutter"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 问题

在搭建flutter android环境时，有时会报错如下：

```shell
Launching lib/main.dart on AOSP on IA Emulator in debug mode...
Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
Exception in thread "main" java.lang.RuntimeException: Timeout of 120000 reached waiting for exclusive access to file: /Users/ksnowlv/.gradle/wrapper/dists/gradle-7.6.3-all/aocdy2d2z8kodnny3rsumj8i8/gradle-7.6.3-all.zip
	at org.gradle.wrapper.ExclusiveFileAccessManager.access(ExclusiveFileAccessManager.java:61)
	at org.gradle.wrapper.Install.createDist(Install.java:48)
	at org.gradle.wrapper.WrapperExecutor.execute(WrapperExecutor.java:128)
	at org.gradle.wrapper.GradleWrapperMain.main(GradleWrapperMain.java:61)
[!] Gradle threw an error while downloading artifacts from the network.
Retrying Gradle Build: #1, wait time: 100ms
Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
```

### 解决方案

#### 1.国内的镜像源加速gradle构建
build.gradle 和 settings.gradle添加国内的镜像源加速gradle构建。

build.gradle如下
```gradle
allprojects {

    repositories {
        //国内镜像源
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/jcenter' }
        google()
        mavenCentral()
        maven { url "https://jitpack.io" }
    }
}

```

#### 2.清理Gradle缓存文件

执行以下命令清理Gradle缓存，然后重新构建项目

```shell
cd android
./gradlew clean
```

#### 3.下载gradle文件

在[gradle](https://services.gradle.org/distributions/)
找到可用的gradle文件，笔者环境使用gradle-7.4.2-all。链接为https://services.gradle.org/distributions/gradle-7.4.2-all.zip

更新gradle-wrapper.properties中的distributionUrl

```text
distributionUrl=https://services.gradle.org/distributions/gradle-7.4.2-all.zip
```
重新同步。

若同步不下来，则从上述链接下载zip包。

![image](/images/flutter/flutter-Android-Timeout-of-120000-reached-waiting-for-exclusive-access-to-file/gradle_offline.jpg)

把zip压缩包放到1所示目录，然后，解压同步即可。

#### 4.VSCode下效果

```shell
ksnowlv@MacBook-Pro-3 android % cd android     
./gradlew clean
cd: no such file or directory: android
Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
Downloading https://services.gradle.org/distributions/gradle-7.5.1-all.zip
........................................................................................................................................................................................................................^C%                                                                                   
ksnowlv@MacBook-Pro-3 android % cd android
./gradlew clean
cd: no such file or directory: android
Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
Unzipping /Users/ksnowlv/.gradle/wrapper/dists/gradle-7.5.1-all/1ehga6e77gqps5uk2kc5kf1vc/gradle-7.5.1-all.zip to /Users/ksnowlv/.gradle/wrapper/dists/gradle-7.5.1-all/1ehga6e77gqps5uk2kc5kf1vc
Set executable permissions for: /Users/ksnowlv/.gradle/wrapper/dists/gradle-7.5.1-all/1ehga6e77gqps5uk2kc5kf1vc/gradle-7.5.1/bin/gradle

Welcome to Gradle 7.5.1!

Here are the highlights of this release:
 - Support for Java 18
 - Support for building with Groovy 4
 - Much more responsive continuous builds
 - Improved diagnostics for dependency resolution

For more details see https://docs.gradle.org/7.5.1/release-notes.html

Starting a Gradle Daemon (subsequent builds will be faster)

> Task :gradle:compileGroovy
Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8

BUILD SUCCESSFUL in 1m 40s
6 actionable tasks: 5 executed, 1 up-to-date
ksnowlv@MacBook-Pro-3 android % 

```


