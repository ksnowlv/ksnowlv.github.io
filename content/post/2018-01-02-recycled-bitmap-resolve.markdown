---
title: "trying to use a recycled bitmap android.graphics.Bitmap@bffc9a0解决方案"
date: 2018-01-02
categories:
  - "Android"
tags:
  - "Android"
---
<!--more-->

最近项目中出现了一批“trying to use a recycled bitmap android.graphics.Bitmap@bffc9a0”异常，是什么原因导致的呢？
<!--more-->

原因：图片在回收后，依然有一些地方引用该Bitmap.

解决方案：可以在使用Bitmap的地方解除对Bitmap引用后再回收。

如果使用的是ImageView,可以在回收时，先解除ImageView对Bitmap的使用，再回收Bitmap。例如：

```objective-c
 protected void onDestroy() {
    
        mStarterImageView.setImageBitmap(null);
        if (null  != mStartBitmap&& !mStartBitmap.isRecycled()) {
            mStartBitmap.recycle();
            mStartBitmap = null;
        }
        
        super.onDestroy();
   }
```