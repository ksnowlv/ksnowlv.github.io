---
title: "Flutter模块嵌入Android-使用缓存引擎跳转FlutterActivity"
date: 2024-04-21T20:20:00+08:00
lastmod: 2024-04-21T20:20:00+08:00
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

### 1.背景

上文从Android原生页面跳转FlutterActivity页面时，出现慢或卡的情况，如何解决呢？

使用flutter缓存引擎的方式解决。


### 2.创建Application

```kotlin

package com.example.flutterlibtest

import android.app.Application
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class App : Application() {
    companion object{
        const val flutterEngineId = "flutterEngineId"
    }

    lateinit var flutterEngine :FlutterEngine

    override fun onCreate() {
        super.onCreate()

        flutterEngine = FlutterEngine(this)
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        FlutterEngineCache.getInstance().put(flutterEngineId, flutterEngine)
    }
}

```

### 3.AndroidManifest添加Application

```xml
    <application
        android:name=".App"
        tools:targetApi="31">
        ....
        <activity
            android:name="io.flutter.embedding.android.FlutterActivity"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize" >
        </activity>

    </application>
```

### 4.使用flutter缓存引擎跳转Flutter页面

```kotlin
//新增按钮及跳转FlutterActivity
@Composable
fun ButtonWithClickEvent(context: Context) {

    Box(
        contentAlignment = Alignment.Center,
        modifier = Modifier.fillMaxSize()
    ) {
        Button(
            onClick  = {
                //使用flutter缓存引擎跳转Flutter页面
                context.startActivity(FlutterActivity.withCachedEngine(flutterEngineId).build(context))
            },
        )
        {
            Text(text = "点击跳转FlutterActivity")
        }
    }
}

```

至此，Android原生页面跳转FlutterActivity页面，慢或卡的情况圆满解决~




