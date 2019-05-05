---
layout: post
title: "Android通过jni间接调用c++"
date: 2019-04-22 11:23
comments: true
categories: Android-JNI
---

本篇重点内容，C如何调用C++类，思路是JAVA通过JNI直接调用C，C调用C++相关的类。

####1.JAVA层接口Person类相关接口

```objective-c
public class JavaCallJNI {

	static  {
	    System.loadLibrary("JNITest");
	}
	
	
	public static native int showValue(int value);
	
	public static native long  createPerson();
	public static native void destroyPerson(long person);
	public static native void setPersonAge(long person,  int age);
	public static native int personAge(long person);
	public static native void setPersonName(long person, String name);
	public static native String  personName(long person);

}

```


###2.C接口及实现

`com_ksnowlv_hellojniforjava_JavaCallJNI.h`内容如下

```objective-c

	#include <jni.h>
	/* Header for class com_ksnowlv_hellojniforjava_JavaCallJNI */
	
	#ifndef _Included_com_ksnowlv_hellojniforjava_JavaCallJNI
	#define _Included_com_ksnowlv_hellojniforjava_JavaCallJNI
	#ifdef __cplusplus
	extern "C" {
	#endif
	/*
	 * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
	 * Method:    showValue
	 * Signature: (I)I
	 */
	JNIEXPORT jint JNICALL Java_com_ksnowlv_hellojniforjava_JavaCallJNI_showValue
	  (JNIEnv *, jclass, jint);
	
	/*
	 * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
	 * Method:    createPerson
	 * Signature: ()J
	 */
	JNIEXPORT jlong JNICALL Java_com_ksnowlv_hellojniforjava_JavaCallJNI_createPerson
	  (JNIEnv *, jclass);
	
	/*
	 * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
	 * Method:    destroyPerson
	 * Signature: (J)V
	 */
	JNIEXPORT void JNICALL Java_com_ksnowlv_hellojniforjava_JavaCallJNI_destroyPerson
	  (JNIEnv *, jclass, jlong);
	
	/*
	 * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
	 * Method:    setPersonAge
	 * Signature: (JI)V
	 */
	JNIEXPORT void JNICALL Java_com_ksnowlv_hellojniforjava_JavaCallJNI_setPersonAge
	  (JNIEnv *, jclass, jlong, jint);
	
	/*
	 * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
	 * Method:    personAge
	 * Signature: (J)I
	 */
	JNIEXPORT jint JNICALL Java_com_ksnowlv_hellojniforjava_JavaCallJNI_personAge
	  (JNIEnv *, jclass, jlong);
	
	/*
	 * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
	 * Method:    setPersonName
	 * Signature: (JLjava/lang/String;)V
	 */
	JNIEXPORT void JNICALL Java_com_ksnowlv_hellojniforjava_JavaCallJNI_setPersonName
	  (JNIEnv *, jclass, jlong, jstring);
	
	/*
	 * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
	 * Method:    personName
	 * Signature: (J)Ljava/lang/String;
	 */
	JNIEXPORT jstring JNICALL Java_com_ksnowlv_hellojniforjava_JavaCallJNI_personName
	  (JNIEnv *, jclass, jlong);
	
	#ifdef __cplusplus
	}
	#endif
	#endif
	
```	
	
`com_ksnowlv_hellojniforjava_JavaCallJNI.c`内容如下

```objective-c
	
	#include "com_ksnowlv_hellojniforjava_JavaCallJNI.h"
	#include "PersonExtension.hpp"
	#include "JNILog.h"
	#include <stdlib.h>
	#include <string.h>
	
	JNIEXPORT jint JNICALL Java_com_ksnowlv_hellojniforjava_JavaCallJNI_showValue
	  (JNIEnv * enc, jclass cls , jint value) {
	
	    LOGI("jni value = %d",value);
		value = value + 1;
		LOGI("jni value +1 = %d",value);
	    return value;
	  }
	
	
	/*
	 * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
	 * Method:    createPerson
	 * Signature: ()Ljava/lang/Object;
	 */
	JNIEXPORT jlong JNICALL Java_com_ksnowlv_hellojniforjava_JavaCallJNI_createPerson
	  (JNIEnv *env, jclass cls) {
	
	
	    void *p = createPerson();
	
	    return (jlong)p;
	  }
	
	/*
	 * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
	 * Method:    destroyPerson
	 * Signature: (Ljava/lang/Object;)V
	 */
	JNIEXPORT void JNICALL Java_com_ksnowlv_hellojniforjava_JavaCallJNI_destroyPerson
	  (JNIEnv *env, jclass cls, jlong o) {
	
	      destroyPerson((void*)o);
	  }
	
	/*
	 * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
	 * Method:    setPersonAge
	 * Signature: (Ljava/lang/Object;I)V
	 */
	JNIEXPORT void JNICALL Java_com_ksnowlv_hellojniforjava_JavaCallJNI_setPersonAge
	  (JNIEnv *env, jclass cls, jlong o, jint value) {
	    setPersonAge((void*)o,value);
	  }
	
	/*
	 * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
	 * Method:    personAge
	 * Signature: (Ljava/lang/Object;)I
	 */
	JNIEXPORT jint JNICALL Java_com_ksnowlv_hellojniforjava_JavaCallJNI_personAge
	  (JNIEnv *env, jclass cls, jlong o) {
	   return personAge((void*)o);
	  }
	
	/*
	 * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
	 * Method:    setPersonName
	 * Signature: (Ljava/lang/Object;Ljava/lang/String;)V
	 */
	JNIEXPORT void JNICALL Java_com_ksnowlv_hellojniforjava_JavaCallJNI_setPersonName
	  (JNIEnv *env, jclass cls, jlong o, jstring string) {
	
	    int length1 = (*env)->GetStringLength(env, string);
	    const jchar * jcstr = (*env)->GetStringChars(env, string, NULL);
	
	
	     jclass   clsstring   =   (*env)->FindClass(env,"java/lang/String");  //String
	     jstring   code   =   (*env)->NewStringUTF(env,"UTF-8"); //"UTF-8"
	     jmethodID   methodID   =   (*env)->GetMethodID(env,clsstring,   "getBytes",   "(Ljava/lang/String;)[B"); //getBytes();
	     jbyteArray   byteArray =   (jbyteArray)(*env)->CallObjectMethod(env,string,methodID,code);
	     jsize   length   =   (*env)->GetArrayLength(env,byteArray);
	     jbyte*   bytes   =   (*env)->GetByteArrayElements(env,byteArray,JNI_FALSE);
	
	
	     if( length > 0){
	
	        char* buf =   (char*)malloc(length+1);         //"\0"
	        memcpy(buf,bytes,length);
	        buf[length]=0;
	        setPersonName((void*)o, buf);
	        LOGI("set name = %s",buf);
	        free(buf);
	     }else{
	        setPersonName((void*)o, NULL);
	     }
	
	     (*env)->ReleaseByteArrayElements(env,byteArray,bytes,0);  //释放内存空间
	  }
	
	/*
	 * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
	 * Method:    personName
	 * Signature: (Ljava/lang/Object;)Ljava/lang/String;
	 */
	JNIEXPORT jstring JNICALL Java_com_ksnowlv_hellojniforjava_JavaCallJNI_personName
	  (JNIEnv *env, jclass cls, jlong o) {
	
	    LOGI("jni get name");
	    const char *name = personName((void*)o);
	
	    if ( name != NULL ) {
	        LOGI("jni name = %s",name);
	        return  (*env)->NewStringUTF(env,name);
	    }else {
	        return (*env)->NewStringUTF(env,"");
	    }
	  }
```

###3.JAVA调用

```objective-c
    int value =  JavaCallJNI.showValue(1);
    Log.i("------Android ","" + value);

    long p =  JavaCallJNI.createPerson();
    JavaCallJNI.setPersonAge(p,10);
    int age = JavaCallJNI.personAge(p);
    Log.i("------Android ","" + age);
    JavaCallJNI.setPersonName(p,"ksnowlv(律威)");
    String name = JavaCallJNI.personName(p);
    Log.i("------Android ",name);
    JavaCallJNI.destroyPerson(p);
    
```    
    
###4.日志输出

	28410-28410/com.ksnowlv.hellojniforjava I/------JNITest: jni value = 1
	2019-04-24 16:42:40.759 28410-28410/com.ksnowlv.hellojniforjava I/------JNITest: jni value +1 = 2
	2019-04-24 16:42:40.759 28410-28410/com.ksnowlv.hellojniforjava I/------Android: 2
	2019-04-24 16:42:40.759 28410-28410/com.ksnowlv.hellojniforjava I/------Android: 10
	2019-04-24 16:42:40.759 28410-28410/com.ksnowlv.hellojniforjava I/------JNITest: set name = ksnowlv(律威)
	2019-04-24 16:42:40.759 28410-28410/com.ksnowlv.hellojniforjava I/------JNITest: jni get name
	2019-04-24 16:42:40.759 28410-28410/com.ksnowlv.hellojniforjava I/------JNITest: jni name = ksnowlv(律威)
	2019-04-24 16:42:40.759 28410-28410/com.ksnowlv.hellojniforjava I/------Android: ksnowlv(律威)