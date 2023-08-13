---
title: "Kotlin通过jni间接调用c++"
date: 2019-04-25
lastmod: 2019-04-25
categories:
  - "Android"
tags:
  - "jni"
comment: true
toc: false
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---


本篇重点内容，Kotlin通过JNI直接调用C，C调用C++相关的类。实际上只是JAVA换成Kotlin的写法而已。

### 一.添加Kotlin类`KotlinPerson````kotlin

class KotlinPerson {

    var mPerson: Long = 0

    init {
        mPerson = createPerson()
    }

    fun setPersonName(name: String) {
        setName(mPerson, name)
    }

    fun personName(): String {
        return name(mPerson)
    }


    fun setPersonAge(age: Int) {
        setAge(mPerson,age)
    }

    fun personAge() : Int {
        return age(mPerson)
    }

    companion object {
        init {
            System.loadLibrary("JNIPerson")
        }
    }

    external fun createPerson(): Long
    external fun destroyPerson(person: Long)
    external fun setName(person: Long, name: String)
    external fun name(person: Long): String
    external fun setAge(person: Long, age: Int)
    external fun age(person: Long): Int
}

```

### 二.添加JNI接口及实现`JNIPerson.c`内容如下：

```objective-c

	#include "JNIPerson.h"
	#include "PersonExtension.hpp"
	#include "JNILog.h"
	#include <stdlib.h>
	#include <string.h>
	
	
	  /*
	   * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
	   * Method:    createPerson
	   * Signature: ()Ljava/lang/Object;
	   */
	JNIEXPORT jlong JNICALL Java_com_ksnowlv_kotlinjni_KotlinPerson_createPerson
	    (JNIEnv *env, jobject cls) {
	
	
	      void *p = createPerson();
	
	      return (jlong)p;
	    }
	
	  /*
	   * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
	   * Method:    destroyPerson
	   * Signature: (Ljava/lang/Object;)V
	   */
	  JNIEXPORT void JNICALL Java_com_ksnowlv_kotlinjni_KotlinPerson_destroyPerson
	    (JNIEnv *env, jobject cls, jlong o) {
	
	        destroyPerson((void*)o);
	    }
	
	  /*
	   * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
	   * Method:    setPersonAge
	   * Signature: (Ljava/lang/Object;I)V
	   */
	  JNIEXPORT void JNICALL Java_com_ksnowlv_kotlinjni_KotlinPerson_setAge
	    (JNIEnv *env, jobject cls, jlong o, jint value) {
	      setPersonAge((void*)o,value);
	    }
	
	  /*
	   * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
	   * Method:    personAge
	   * Signature: (Ljava/lang/Object;)I
	   */
	  JNIEXPORT jint JNICALL Java_com_ksnowlv_kotlinjni_KotlinPerson_age
	    (JNIEnv *env, jobject cls, jlong o) {
	     return personAge((void*)o);
	    }
	
	
	  JNIEXPORT void JNICALL Java_com_ksnowlv_kotlinjni_KotlinPerson_setName
	    (JNIEnv *env, jobject cls, jlong o, jstring string) {
	
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
	  JNIEXPORT jstring JNICALL Java_com_ksnowlv_kotlinjni_KotlinPerson_name
	    (JNIEnv *env, jobject cls, jlong o) {
	
	      LOGI("jni get name");
	      const char *name = personName((void*)o);
	
	      if ( name != NULL ) {
	          LOGI("jni name = %s",name);
	          return  (*env)->NewStringUTF(env,name);
	      }else {
	          return (*env)->NewStringUTF(env,"");
	      }
	    }
	#include "JNIPerson.h"
#include "PersonExtension.hpp"
#include "JNILog.h"
#include <stdlib.h>
#include <string.h>


  /*
   * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
   * Method:    createPerson
   * Signature: ()Ljava/lang/Object;
   */
JNIEXPORT jlong JNICALL Java_com_ksnowlv_kotlinjni_KotlinPerson_createPerson
    (JNIEnv *env, jobject cls) {


      void *p = createPerson();

      return (jlong)p;
    }

  /*
   * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
   * Method:    destroyPerson
   * Signature: (Ljava/lang/Object;)V
   */
  JNIEXPORT void JNICALL Java_com_ksnowlv_kotlinjni_KotlinPerson_destroyPerson
    (JNIEnv *env, jobject cls, jlong o) {

        destroyPerson((void*)o);
    }

  /*
   * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
   * Method:    setPersonAge
   * Signature: (Ljava/lang/Object;I)V
   */
  JNIEXPORT void JNICALL Java_com_ksnowlv_kotlinjni_KotlinPerson_setAge
    (JNIEnv *env, jobject cls, jlong o, jint value) {
      setPersonAge((void*)o,value);
    }

  /*
   * Class:     com_ksnowlv_hellojniforjava_JavaCallJNI
   * Method:    personAge
   * Signature: (Ljava/lang/Object;)I
   */
  JNIEXPORT jint JNICALL Java_com_ksnowlv_kotlinjni_KotlinPerson_age
    (JNIEnv *env, jobject cls, jlong o) {
     return personAge((void*)o);
    }


  JNIEXPORT void JNICALL Java_com_ksnowlv_kotlinjni_KotlinPerson_setName
    (JNIEnv *env, jobject cls, jlong o, jstring string) {

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
  JNIEXPORT jstring JNICALL Java_com_ksnowlv_kotlinjni_KotlinPerson_name
    (JNIEnv *env, jobject cls, jlong o) {

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

### 三.调用
```kotlin
	
	var person = KotlinPerson()
	person.setPersonAge(10)
	
	Log.i("----Android age = ", "" + person.personAge())
	person.setPersonName("ksnowlv(律威)")
	
	Log.i("----Android name = ", person.personName())

```

### 四.日志输出
