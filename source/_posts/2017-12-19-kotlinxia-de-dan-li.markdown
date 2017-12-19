---
layout: post
title: "Kotlin下的单例"
date: 2017-12-19 17:01
comments: true
categories: Kotlin
---

单例不同的语言下的要求大体一致。
<!--more-->

Kotlin下的单例是通过companion实现的。

```objective-c
class KCacheMgr private constructor (){


    companion object {
        @Volatile
        var sharedCacheMgr: KCacheMgr? = null

        fun getInstance(): KCacheMgr {
            if (sharedCacheMgr == null) {
                synchronized(KCacheMgr::class) {
                    if (sharedCacheMgr == null) {
                        sharedCacheMgr = KCacheMgr()
                    }
                }
            }
            return sharedCacheMgr!!
        }
    }
}
```
