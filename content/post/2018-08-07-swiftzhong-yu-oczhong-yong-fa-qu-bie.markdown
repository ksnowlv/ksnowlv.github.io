---
title: "synchronized到objc_sync_enter/objc_sync_exit"
date: 2018-08-07
lastmod: 2018-08-07
categories:
  - "swift"
tags:
  - "多线程"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---


`synchronized`->`objc_sync_enter/objc_sync_exit`

### `objc_sync_enter`：

递归锁，与`objc_sync_exit`配合使用，注意死锁

* Begin synchronizing on 'obj'. Allocates recursive pthread_mutex associated with 'obj' if needed.
* Parameters	
	obj	
	The object to begin synchronizing on.
* Returns	
OBJC_SYNC_SUCCESS once lock is acquired.

### `objc_sync_exit`

* End synchronizing on 'obj'.
* Parameters	
	obj	
	The object to end synchronizing on.
* Returns	
OBJC_SYNC_SUCCESS or OBJC_SYNC_NOT_OWNING_THREAD_ERROR

### 三.示例

 ```swift
   let lockValue = 0
   objc_sync_enter(lockValue)
        //执行代码块
   objc_sync_exit(lockValue)
 ```
 
 
