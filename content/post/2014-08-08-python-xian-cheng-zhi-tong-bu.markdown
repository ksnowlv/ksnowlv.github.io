---
title: "python线程之同步"
date: 2014-08-08
categories:
  - "python"
tags:
  - "python"
---
<!--more-->

如果多个线程共同对某个数据修改访问，为了保证数据的正确性，需要对多个线程进行同步。

<!--more-->

使用Thread对象的Lock和Rlock可以实现简单的线程同步，
    
    acquire:请求锁,成功则返回true.
    release:释放锁.
    
对于需要每次只允许一个线程操作的数据，可以使用上述锁来实现互斥访问。  

代码示例如下:

``` python

#!/usr/bin/python

import threading
import time

class QThread (threading.Thread):
    
    """ QThread class"""
    def __init__(self, threadID, name, counter):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.counter = counter

    def run(self):#线程的run函数

        print "%s running" % self.name 
       # 获得锁，成功获得锁定后返回True
       # 可选的timeout参数不填时将一直阻塞直到获得锁定
       # 否则超时后将返回False

        threadLock.acquire()
        showThreadMessage(self.name, self.counter, 3)
        # 释放锁
        threadLock.release()

def showThreadMessage(threadName, delay, counter):
    while counter > 0:
        time.sleep(delay)
        print "%s showThreadMessage" % (threadName)
        counter -= 1

threadLock = threading.Lock()
threads = []

# 创建新线程
thread1 = QThread(1, "KSnow", 1)
thread2 = QThread(2, "KAir", 2)

# 线程开始执行
thread1.start()
thread2.start()

# 添加线程到线程列表
threads.append(thread1)
threads.append(thread2)

# 等待所有线程完成
for t in threads:
    t.join()
print "Exiting From Main Thread"


```

运行情况如下:
    
    ksnowlv@ksnowlvdeMacBook-Pro~/Documents/lvwei projects/python$python thread_synchronization.py
    KSnow running
    KAir running
    KSnow showThreadMessage
    KSnow showThreadMessage
    KSnow showThreadMessage
    KAir showThreadMessage
    KAir showThreadMessage
    KAir showThreadMessage
    Exiting From Main Thread



