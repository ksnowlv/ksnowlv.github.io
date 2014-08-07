---
layout: post
title: "python线程之start_new_thread"
date: 2014-08-07 21:13
comments: true
categories: python
---

####Python中使用线程有两种方式：
    1.函数式方式
    2.类包装线程对象方式。

下面使用`函数式方式`，调用thread模块中的start_new_thread()函数来产生新线程。

语法格式如下:

    thread.start_new_thread ( function, args[, kwargs] )
    
    
代码示例如下:

``` python

#!/usr/bin/python

import thread
import time

#为线程定义一个函数

def  showTime(threadName,delayTime):
	countTime = 0

	while countTime < 5:
		time.sleep(delayTime)
		countTime += 1
		print "%s : %s" % (threadName, time.ctime(time.time()) )



#创建线程
try:
	thread.start_new_thread (showTime, ("ksnow thread", 2 ) )
	thread.start_new_thread (showTime, ("kair thread", 3 ) )
	thread.start_new_thread (showTime, ("baby thread", 5 ) )


except:
	print "Error: unable to start thread"

while 1:
   pass
   
```运行结果如下：
    ksnowlv@ksnowlvdeMacBook-Pro~/Documents/lvwei projects/python$python thread_start_new_thread.py 
    ksnow thread : Thu Aug  7 21:11:33 2014
    kair thread : Thu Aug  7 21:11:34 2014
    ksnow thread : Thu Aug  7 21:11:35 2014
    baby thread : Thu Aug  7 21:11:36 2014
    kair thread : Thu Aug  7 21:11:37 2014
    ksnow thread : Thu Aug  7 21:11:37 2014
    ksnow thread : Thu Aug  7 21:11:39 2014
    kair thread : Thu Aug  7 21:11:40 2014
    baby thread : Thu Aug  7 21:11:41 2014
    ksnow thread : Thu Aug  7 21:11:41 2014
    kair thread : Thu Aug  7 21:11:43 2014
    baby thread : Thu Aug  7 21:11:46 2014
    kair thread : Thu Aug  7 21:11:46 2014
    baby thread : Thu Aug  7 21:11:51 2014
    baby thread : Thu Aug  7 21:11:56 2014
    
    
####注意事项
    1.线程的结束一般依靠线程函数的自然结束；
    2.可以在线程函数中调用thread.exit()，
    抛出SystemExit exception，达到退出线程的目的。