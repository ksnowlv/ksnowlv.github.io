---
title: "python线程之队列Queue"
date: 2014-08-08
lastmod: 2014-08-08
categories:
  - "python"
tags:
  - "python"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

## 一.Python Queue
Python的Queue模块中提供了同步的、线程安全的队列类.

* 1.FIFO（先入先出)队列Queue，
* 2.LIFO（后入先出）队列LifoQueue，
* 3.优先级队列PriorityQueue。

这些队列都实现了锁原语，能够在多线程中直接使用。可以使用队列来实现线程间的同步。

## 二.代码示例

``` python

#!/usr/bin/python

import Queue
import threading
import time

exitFlag = 0

class QThread (threading.Thread):

    "QThread class"
    def __init__(self, threadID, name, queue):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.queue = queue
    
    #线程函数
    def run(self):
        print "Starting " + self.name
        process_data(self.name, self.queue)
        print "Exiting " + self.name

#处理数据
def process_data(threadName, q):
    while not exitFlag:
        queueLock.acquire()
        if not workQueue.empty():
            data = q.get()
            queueLock.release()
            print "%s processing %s" % (threadName, data)
        else:
            queueLock.release()
        time.sleep(1)


threadList = ["ksnow", "kair", "baby"]
nameList = ["One", "Two", "Three", "Four", "Five"]
queueLock = threading.Lock()

#创建FIFO（先入先出)队列Queue
workQueue = Queue.Queue(5)
threads = []
threadID = 1

# 创建新线程
for tName in threadList:
    thread = QThread(threadID, tName, workQueue)
    thread.start()
    threads.append(thread)
    threadID += 1

# 填充队列
queueLock.acquire()
for word in nameList:
    workQueue.put(word)
queueLock.release()

# 等待队列清空
while not workQueue.empty():
    pass

# 通知线程是时候退出
exitFlag = 1

# 等待所有线程完成
for t in threads:
    t.join()
print "Exiting Main Thread"

```

## 三.运行结果
```terminal
    ksnowlv@ksnowlvdeMacBook-Pro~/Documents/lvwei projects/python$python thread_queue.py
    Starting ksnow
    Starting kair
    Starting baby
    kair processing One
    ksnow processing Two
    baby processing Three
    ksnow processing Four
    kair processing Five
    Exiting baby
    Exiting ksnow
    Exiting kair
    Exiting Main Thread
```

## 四.注意

*  此处仅仅为了演示Queue的使用，exitFlag在真实场景下，需要考虑多线程同步。
