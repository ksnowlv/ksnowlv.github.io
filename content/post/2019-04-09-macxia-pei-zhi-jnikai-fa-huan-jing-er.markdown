---
title: "”mac下配置jni开发环境(二)“"
date: 2019-04-09
categories:
  - "Android"
tags:
  - "jni"
---
<!--more-->

创建android基础工程

#### 1.JNI java文件创建
```objective-c

public class JavaCallJNI {

    static  {
        System.loadLibrary("JniTest");
    }

    public static native int showValue(int value);
}

```

![image](/images/post/2019-04-09-macxia-pei-zhi-jnikai-fa-huan-jing-er/jni-files.png) 


#### 2.在`app/scr/main/`目录下，创建目录`jni`#### 3.在jni目录下，创建`Android.mk`文件文件内容如下：


	LOCAL_PATH := $(call my-dir)
	include $(CLEAR_VARS)


	LOCAL_MODULE := jniTest
	LOCAL_SRC_FILES := com_ksnowlv_hellojniforjava_JavaCallJNI.c

	include $(BUILD_SHARED_LIBRARY)
	
其中

* LOCAL_MODULE := JniTest 
	
		这里JniTest，是将要生成的`.so`库的名字，会自动加上 lib前缀，
		最终生成库文件：libJniTest.so
		如果要引用该库：System.loadLibrary("JniTest")

* LOCAL_SRC_FILES := com_ksnowlv_hellojniforjava_JavaCallJNI 

		JNI头文件com_ksnowlv_hellojniforjava_JavaCallJNI.h对应的.c文件
		命名方式：包名+类名+.c

在`terminal`中生成com_ksnowlv_hellojniforjava_JavaCallJNI.h头文件

	ksnowlvdeMacBook-Pro:java ksnowlv$ javac com/ksnowlv/	hellojniforjava/JavaCallJNI.java 
	Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
	ksnowlvdeMacBook-Pro:java ksnowlv$ javah -d ../jni 	com.ksnowlv.hellojniforjava.JavaCallJNI
	Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
	ksnowlvdeMacBook-Pro:java ksnowlv$ cd ..

![image](/images/post/2019-04-09-macxia-pei-zhi-jnikai-fa-huan-jing-er/jni_header_create.png) 

实现文件中内容如下

	#include "com_ksnowlv_hellojniforjava_JavaCallJNI.h"
	
	JNIEXPORT jint JNICALL 	Java_com_ksnowlv_hellojniforjava_JavaCallJNI_showValue(JNIEnv * enc, jclass cls , jint value) {
		value = value + 1;
    	return value;
  	}
		

#### 4.在jni目录下，创建`Application.mk`文件内容如下：

	APP_ABI := all	
	
会生成所有主流 ABI 类型的 .so 库


#### 5.更新在当前模块下build.gradle文件* `defaultConfig`下增加ndk配置

		ndk {
    		moduleName "JniTest" //System.loadLibrary("JniTest");
		}
	
 
* 在buildTypes上面添加`jni.srcDirs`的配置

    	sourceSets {
           main {//建议这里直接使用'libs'目录，
           //因为当使用其他包有.so文件时，一般习惯也是直接拷贝进入libs目录
            jni.srcDirs = ['libs']
          }
    	}



![image](/images/post/2019-04-09-macxia-pei-zhi-jnikai-fa-huan-jing-er/build-gradle.png) 

#### 5.在终端进入jni路径:app/src/main/jni,输入`ndk-build`即生成各种版本的so
	ksnowlvdeMacBook-Pro:java ksnowlv$ javac com/ksnowlv/	hellojniforjava/JavaCallJNI.java 
	Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
	ksnowlvdeMacBook-Pro:java ksnowlv$ javah -d ../jni 	com.ksnowlv.hellojniforjava.JavaCallJNI
	Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
	ksnowlvdeMacBook-Pro:java ksnowlv$ cd ..
	ksnowlvdeMacBook-Pro:main ksnowlv$ cd jni
	ksnowlvdeMacBook-Pro:jni ksnowlv$ ndk-build


![image](/images/post/2019-04-09-macxia-pei-zhi-jnikai-fa-huan-jing-er/so.png) 




