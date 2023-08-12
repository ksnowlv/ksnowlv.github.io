---
title: "synchronized到objc_sync_enter/objc_sync_exit"
date: 2018-08-07
categories:
  - "swift-基础"
tags:
  - "swift-基础"
---
<!--more-->


`synchronized`->`objc_sync_enter/objc_sync_exit`

`objc_sync_enter`：递归锁，与objc_sync_exit配合使用，注意死锁

* Begin synchronizing on 'obj'. Allocates recursive pthread_mutex associated with 'obj' if needed.
* Parameters	
	obj	
	The object to begin synchronizing on.
* Returns	
OBJC_SYNC_SUCCESS once lock is acquired.

`objc_sync_exit`

* End synchronizing on 'obj'.
* Parameters	
	obj	
	The object to end synchronizing on.
* Returns	
OBJC_SYNC_SUCCESS or OBJC_SYNC_NOT_OWNING_THREAD_ERROR

示例如下：

 ```objective-c
   let lockValue = 0
   objc_sync_enter(lockValue)
        //执行代码块
   objc_sync_exit(lockValue)
 ```
 
 
