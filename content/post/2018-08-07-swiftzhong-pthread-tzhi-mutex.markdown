---
title: "swift中pthread_t之mutex"
date: 2018-08-07
lastmod: 2018-08-07
categories:
  - "swift"
tags:
  - "多线程"
comment: true
toc: false
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

mutex类型有四种

*  PTHREAD_MUTEX_NORMAL
* PTHREAD_MUTEX_ERRORCHECK
* PTHREAD_MUTEX_RECURSIVE
* PTHREAD_MUTEX_DEFAULT


##### 1.mutex初始化。
```objective-c
     var mutex = pthread_mutex_t()
     var attr: pthread_mutexattr_t = pthread_mutexattr_t()
     pthread_mutexattr_init(&attr)
     pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE)
     pthread_mutex_init(&mutex, &attr)
```

##### 2.mutex使用。```objective-c
     pthread_mutex_trylock(&mutex)
        //执行代码块
     pthread_mutex_unlock(&mutex)
```

##### 3.mutex释放。```objective-c
    pthread_mutex_destroy(&mutex)
```
