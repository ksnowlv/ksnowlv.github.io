---
title: "Android通过jni调用c++"
date: 2019-04-18
categories:
  - "Android"
tags:
  - "jni"
---
<!--more-->


本篇重点内容在于如何把C++的类通过JNI转换为JAVA的类


### 1.创建JAVA类：`JavaPerson`

	public class JavaPerson {


    private long mNativePerson;

    public JavaPerson()
    {
        mNativePerson = init();
    }

    public int getAge()
    {
        return this.native_getAge(mNativePerson);
    }

    public void setAge(int age)
    {
        native_setAge(mNativePerson, age);
    }

    public String getName() {
        return native_getName(mNativePerson);
    }

    public void setName(String name) {
        native_setName(mNativePerson, name);
    }


    @Override
    protected void finalize() throws Throwable {

        if (mNativePerson != 0) {
            finalizer(mNativePerson);
        }

        super.finalize();
    }

    	static {
        	System.loadLibrary("jniPerson");
    	}

    	private native long  init();
    	private native void finalizer(long aPerson);
   	 	private native int native_getAge(long aPerson);
   		private native void native_setAge(long aPerson, int age);
    	private native String native_getName(long aPerson);
    	private native void native_setName(long aPerson, String name);
	}


### 2.通过Terminal生成c++头文件：`com_ksnowlv_jnicallc_JavaPerson.h`
	#ifndef _Included_com_ksnowlv_jnicallc_JavaPerson
	#define _Included_com_ksnowlv_jnicallc_JavaPerson
	#ifdef __cplusplus
	extern "C" {
	#endif
	/*
	 * Class:     com_ksnowlv_jnicallc_JavaPerson
	 * Method:    init
	 * Signature: ()J
	 */
	JNIEXPORT jlong JNICALL Java_com_ksnowlv_jnicallc_JavaPerson_init
	  (JNIEnv *, jobject);
	
	/*
	 * Class:     com_ksnowlv_jnicallc_JavaPerson
	 * Method:    finalizer
	 * Signature: (J)V
	 */
	JNIEXPORT void JNICALL Java_com_ksnowlv_jnicallc_JavaPerson_finalizer
	  (JNIEnv *, jobject, jlong);
	
	/*
	 * Class:     com_ksnowlv_jnicallc_JavaPerson
	 * Method:    native_getAge
	 * Signature: (J)I
	 */
	JNIEXPORT jint JNICALL Java_com_ksnowlv_jnicallc_JavaPerson_native_1getAge
	  (JNIEnv *, jobject, jlong);
	
	/*
	 * Class:     com_ksnowlv_jnicallc_JavaPerson
	 * Method:    native_setAge
	 * Signature: (JI)V
	 */
	JNIEXPORT void JNICALL Java_com_ksnowlv_jnicallc_JavaPerson_native_1setAge
	  (JNIEnv *, jobject, jlong, jint);
	
	/*
	 * Class:     com_ksnowlv_jnicallc_JavaPerson
	 * Method:    native_getName
	 * Signature: (J)Ljava/lang/String;
	 */
	JNIEXPORT jstring JNICALL Java_com_ksnowlv_jnicallc_JavaPerson_native_1getName
	  (JNIEnv *, jobject, jlong);
	
	/*
	 * Class:     com_ksnowlv_jnicallc_JavaPerson
	 * Method:    native_setName
	 * Signature: (JLjava/lang/String;)V
	 */
	JNIEXPORT void JNICALL Java_com_ksnowlv_jnicallc_JavaPerson_native_1setName
	  (JNIEnv *, jobject, jlong, jstring);
	
	#ifdef __cplusplus
	}
	#endif
	#endif
	
	
### 3.添加c++实现文件：`com_ksnowlv_jnicallc_JavaPerson.cpp`

	//
	// Created by ksnowlv on 2019-04-18.
	//
	
	#include"com_ksnowlv_jnicallc_JavaPerson.h"
	#include "Person.hpp"
	#include "JNILog.h"
	#include <string.h>
	
	extern "C"
	{
	
	/*
	 * Class:     com_ksnowlv_jnicallc_JavaPerson
	 * Method:    init
	 * Signature: ()I
	 */
	JNIEXPORT jlong JNICALL Java_com_ksnowlv_jnicallc_JavaPerson_init
	  (JNIEnv *, jobject) {
	
	      LOGE("JNI Java_com_ksnowlv_jnicallc_JavaPerson_init");
	      Person *person = new Person();
	      return (jlong)person;
	
	  }
	
	/*
	 * Class:     com_ksnowlv_jnicallc_JavaPerson
	 * Method:    finalizer
	 * Signature: (J)V
	 */
	JNIEXPORT void JNICALL Java_com_ksnowlv_jnicallc_JavaPerson_finalizer
	  (JNIEnv *, jobject cls, jlong thisObject) {
	
	    LOGE("JNI Java_com_ksnowlv_jnicallc_JavaPerson_finalizer");
	
	    Person *person = (Person *)thisObject;
	
	    if (NULL != person) {
	        delete person;
	        person = NULL;
	    }
	
	  }
	
	/*
	 * Class:     com_ksnowlv_jnicallc_JavaPerson
	 * Method:    native_getAge
	 * Signature: (J)I
	 */
	JNIEXPORT jint JNICALL Java_com_ksnowlv_jnicallc_JavaPerson_native_1getAge
	  (JNIEnv *evn, jobject cls, jlong thisObject ) {
	
	    Person *person = (Person *)thisObject;
	
	    LOGE("JNI Java_com_ksnowlv_jnicallc_JavaPerson_native_1getAge= %d", person->age());
	
	    if (NULL != person) {
	
	        return person->age();
	    }
	
	    return -1;
	  }
	
	/*
	 * Class:     com_ksnowlv_jnicallc_JavaPerson
	 * Method:    native_setAge
	 * Signature: (JI)V
	 */
	JNIEXPORT void JNICALL Java_com_ksnowlv_jnicallc_JavaPerson_native_1setAge
	  (JNIEnv *env, jobject cls, jlong thisObject, jint age ) {
	
	      LOGE("JNI Java_com_ksnowlv_jnicallc_JavaPerson_native_1setAge = %d", age);
	
	      Person *person = (Person *)thisObject;
	
	      if ( NULL != person ) {
	        person->setAge(age);
	      }
	  }
	
	/*
	 * Class:     com_ksnowlv_jnicallc_JavaPerson
	 * Method:    native_getName
	 * Signature: (J)I
	 */
	JNIEXPORT jstring JNICALL Java_com_ksnowlv_jnicallc_JavaPerson_native_1getName
	  (JNIEnv *env, jobject cls, jlong thisObject) {
	      LOGE("JNI Java_com_ksnowlv_jnicallc_JavaPerson_native_1getName");
	
	      Person *person = (Person *)thisObject;
	
	      if ( NULL != person ) {
	          const char *name = person->name();
	          if ( name != NULL ) {
	               // LOGI("JNI name = %s",name);
	                return  env->NewStringUTF(name);
	           }
	       }
	
	    return env->NewStringUTF("");
	  }
	
	/*
	 * Class:     com_ksnowlv_jnicallc_JavaPerson
	 * Method:    native_setName
	 * Signature: (JLjava/lang/String;)V
	 */
	JNIEXPORT void JNICALL Java_com_ksnowlv_jnicallc_JavaPerson_native_1setName
	  (JNIEnv *env, jobject cls, jlong thisObject, jstring string) {
	
	    LOGE("JNI Java_com_ksnowlv_jnicallc_JavaPerson_native_1setName");
	
	     jclass   clsstring   =   env->FindClass("java/lang/String");  //String
	     jstring   code   =   env->NewStringUTF("UTF8"); //"UTF8"
	     jmethodID   methodID   =   env->GetMethodID(clsstring, "getBytes", "(Ljava/lang/String;)[B"); //getBytes(String);
	     jbyteArray   byteArray =   (jbyteArray)env->CallObjectMethod(string,methodID,code); // String .getByte("UTF8");
	     jsize   length   =   env->GetArrayLength(byteArray);
	     jbyte*   bytes   =   env->GetByteArrayElements(byteArray,JNI_FALSE);
	
	    Person *person = (Person *)thisObject;
	
	    if ( NULL != person ) {
	       if( length > 0){
	            char* buf =   new char[length+1];
	            memset(buf,0,length+1);
	            memcpy(buf,bytes,length);
	            person->setName(buf);
	            LOGE("JNI set name = %s",buf);
	            delete []buf;
	         }else{
	            person->setName(NULL);
	         }
	    }
	
	
	
	     env->ReleaseByteArrayElements(byteArray,bytes,0);  //释放内存空间
	  }
	
	}
	
	static  JNINativeMethod methods[] = {
	
	        {"init", "()J", (void *)Java_com_ksnowlv_jnicallc_JavaPerson_init},
	        {"finalizer", "(J)V", (void *)Java_com_ksnowlv_jnicallc_JavaPerson_finalizer},
	        {"native_getAge", "(J)I", (void *)Java_com_ksnowlv_jnicallc_JavaPerson_native_1getAge},
	        {"native_setAge", "(JI)V", (void *)Java_com_ksnowlv_jnicallc_JavaPerson_native_1setAge},
	        {"native_getName", "(J)Ljava/lang/String;", (void *)Java_com_ksnowlv_jnicallc_JavaPerson_native_1getName},
	        {"native_setName", "(JLjava/lang/String;)V", (void *)Java_com_ksnowlv_jnicallc_JavaPerson_native_1setName},
	};
	
	
	
	
	
	static const char * classPathName = "com/ksnowlv/jnicallc/JavaPerson";
	/*
	 * Register several native methods for one class.
	 */
	static int registerNativeMethods(JNIEnv* env, const char* className,
	                                 JNINativeMethod* gMethods, int numMethods)
	{
	    jclass clazz;
	    clazz = env->FindClass(className);
	    if (clazz == NULL) {
	        LOGE("JavaPerson Native registration unable to find class '%s'", className);
	        return JNI_FALSE;
	    }
	    if (env->RegisterNatives(clazz, gMethods, numMethods) < 0) {
	        LOGE("JavaPerson RegisterNatives failed for '%s'", className);
	        return JNI_FALSE;
	    }
	
	    LOGE("JavaPerson registerNativeMethods OK");
	    return JNI_TRUE;
	}
	/*
	 * Register native methods for all classes we know about.
	 *
	 * returns JNI_TRUE on success.
	 */
	static int registerNatives(JNIEnv* env)
	{
	    if (!registerNativeMethods(env, classPathName,
	                               methods, sizeof(methods) / sizeof(methods[0]))) {
	        LOGE("JavaPerson class registerNatives FAIL");
	        return JNI_FALSE;
	    }
	
	    LOGE("JavaPerson registerNatives OK");
	    return JNI_TRUE;
	}
	// ----------------------------------------------------------------------------
	/*
	 * This is called by the VM when the shared library is first loaded.
	 */
	
	typedef union {
	    JNIEnv* env;
	    void* venv;
	} UnionJNIEnvToVoid;
	
	jint JNI_OnLoad(JavaVM* vm, void* reserved)
	{
	    UnionJNIEnvToVoid uenv;
	    uenv.venv = NULL;
	    jint result = -1;
	    JNIEnv* env = NULL;
	
	    LOGE("JNI_OnLoad");
	    if (vm->GetEnv(&uenv.venv, JNI_VERSION_1_4) != JNI_OK) {
	        LOGE("ERROR: GetEnv failed");
	        goto bail;
	    }
	    env = uenv.env;
	    if (registerNatives(env) != JNI_TRUE) {
	        LOGE("ERROR: registerNatives failed");
	        goto bail;
	    }
	
	    result = JNI_VERSION_1_4;
	
	    LOGE("JNI_OnLoad OK");
	    bail:
	    return result;
	}
	
#### 4.在Android中的调用
	   JavaPerson person = new JavaPerson();
	    person.setAge(10);
	    Log.i("------JNICallC++: Android person age =  ","" + person.getAge());
	    person.setName("ksnowlv(律威)");
	    Log.i("------JNICallC++: Android person name =  ","" + person.getName());	

#### 5.输出	
	2019-04-19 17:02:27.114 30422-30422/? E/------JNICallC++: JNI_OnLoad
	2019-04-19 17:02:27.115 30422-30422/? E/------JNICallC++: JavaPerson registerNativeMethods OK
	2019-04-19 17:02:27.115 30422-30422/? E/------JNICallC++: JavaPerson registerNatives OK
	2019-04-19 17:02:27.115 30422-30422/? E/------JNICallC++: JNI_OnLoad OK
	2019-04-19 17:02:27.115 30422-30422/? E/------JNICallC++: JNI Java_com_ksnowlv_jnicallc_JavaPerson_init
	2019-04-19 17:02:27.115 30422-30422/? E/------JNICallC++: JNI Java_com_ksnowlv_jnicallc_JavaPerson_native_1setAge = 10
	2019-04-19 17:02:27.115 30422-30422/? E/------JNICallC++: JNI Java_com_ksnowlv_jnicallc_JavaPerson_native_1getAge= 10
	2019-04-19 17:02:27.115 30422-30422/? I/------JNICallC++: Android person age =: 10
	2019-04-19 17:02:27.115 30422-30422/? E/------JNICallC++: JNI Java_com_ksnowlv_jnicallc_JavaPerson_native_1setName
	2019-04-19 17:02:27.116 30422-30422/? E/------JNICallC++: JNI set name = ksnowlv(律威)
	2019-04-19 17:02:27.116 30422-30422/? E/------JNICallC++: JNI Java_com_ksnowlv_jnicallc_JavaPerson_native_1getName
	2019-04-19 17:02:27.116 30422-30422/? I/------JNICallC++: Android person name =: ksnowlv(律威)
	
	
#### 6.说明* C++`Person`类同上一工程	。
* 注意JNI调用C++和C的区别。
	* JNI_OnLoad相关：像JNINativeMethod methods注意函数映射参数，classPathName类路径等
	* env调用方式
	* C++对象回收内存

	
