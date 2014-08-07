---
layout: post
title: "Python线程之Threading"
date: 2014-08-07 22:05
comments: true
categories: python
---


####接上文，介绍下`类包装线程对象方式`使用线程

####python通过两个标准库thread和threading提供对线程的支持。thread提供了低级别的、原始的线程以及一个简单的锁。


####样例会使用Threading模块创建线程，涉及到线程启动和运行
    
    run(): 用以表示线程活动的方法。
    start():启动线程活动。


我们的QThread类会从threading.Thread继承，然后重写__init__方法和run方法。

示例代码如下

```  python

#!/usr/bin/python

import threading
import time

exitFlag = 0

class QThread(threading.Thread):#

	"""QThread class"""

	def __init__(self, threadID, name, counter):
		threading.Thread.__init__(self)
		self.__threadID = threadID
		self.__name = name
		self.__counter = counter


	def run(self):#线程在创建后会直接运行run函数 
		print "%s start" % (self.__name)
		showMessage(self.__name, self.__counter, 6)
		print "Exit from" + self.__name
	
	
#定义函数
def showMessage(threadName, delayTime, counter):

		while counter:

			if exitFlag:
				thread.exit()

			time.sleep(delayTime)
			print "%s : %s" % (threadName, time.ctime(time.time()) )
			counter -= 1

#创建线程
t1 = QThread(1,"ksnow", 2)
t2 = QThread(2,"kair", 3)
t3 = QThread(3,"baby", 3)

#开启线程
t1.start()
t2.start()
t3.start()

print "exit from Main Thread"


```

运行结果如下：

    ksnowlv@ksnowlvdeMacBook-Pro~/Documents/lvwei projects/python$python python_threading.py 
    ksnow start
    kair start
    baby start
    exit from Main Thread
    ksnow : Thu Aug  7 22:41:42 2014
    kair : Thu Aug  7 22:41:43 2014
    baby : Thu Aug  7 22:41:43 2014
    ksnow : Thu Aug  7 22:41:44 2014
    kair : Thu Aug  7 22:41:46 2014
    baby : Thu Aug  7 22:41:46 2014
    ksnow : Thu Aug  7 22:41:46 2014
    ksnow : Thu Aug  7 22:41:48 2014
    kair : Thu Aug  7 22:41:49 2014
    baby : Thu Aug  7 22:41:49 2014
    ksnow : Thu Aug  7 22:41:50 2014
    kair : Thu Aug  7 22:41:52 2014
    baby : Thu Aug  7 22:41:52 2014
    ksnow : Thu Aug  7 22:41:52 2014
    Exit fromksnow
    baby : Thu Aug  7 22:41:55 2014
     kair : Thu Aug  7 22:41:55 2014
    baby : Thu Aug  7 22:41:58 2014
     Exit frombaby
    kair : Thu Aug  7 22:41:58 2014
    Exit fromkair