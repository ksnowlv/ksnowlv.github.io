---
title: "Kotlin下的单例"
date: 2017-12-19
lastmod: 2017-12-19
categories:
  - "Android"
tags:
  - "Kotlin"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

单例不同的语言下的要求大体一致。

Kotlin下的单例是通过companion实现的。

```kotlin
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
