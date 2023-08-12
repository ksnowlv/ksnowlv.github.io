---
title: "python调试之pdb"
date: 2014-08-09
categories:
  - "python"
tags:
  - "python"
---
<!--more-->

#### 学习python调试可参考官方文档的[pdb](https://docs.python.org/2/library/pdb.html).
<!--more-->

#### 一.在python中,在调试模块添加pdb调试支持. 
``` python   

    import pdb; 
    pdb.set_trace()
 
```  
 
#### 不然，会遇见类似如下的错误:
    (Pdb) n
    > /Users/ksnowlv/Documents/lvwei projects/python/thread_queue.py(38)<module>()
    -> nameList = ["One", "Two", "Three", "Four", "Five"]
    (Pdb) a
    (Pdb) p namelist
    *** NameError: NameError("name 'namelist' is not defined",)


#### 二.一些常用命令：
#### 查看帮助
    help
    (Pdb) 
    Documented commands (type help <topic>):
    ========================================
    EOF    bt         cont      enable  jump  pp       run      unt   
    a      c          continue  exit    l     q        s        until 
    alias  cl         d         h       list  quit     step     up    
    args   clear      debug     help    n     r        tbreak   w     
    b      commands   disable   ignore  next  restart  u        whatis
    break  condition  down      j       p     return   unalias  where 

解释如下:

    b/break  <linenumber>   #断点设置在本py的第linenumber行
    b/break  <functionname> #断点设置在本py的functionname
    b/break                 #列举当前所有的断点
    cl/clear                #清除所有断点
    cl/clear  <number>      #清除第number个断点 
    n/next        #单步运行到下一步
    s/step        #进入到函数内部
    c/continue    #继续运行
    p             #查看当前变量值
    l/list        #查看运行到某处代码
    a             #查看全部栈内变量
    w             #列出目前call stack 中的所在层
    d             #在call stack中往下移一层
    disable       #取消所有断点的功能,但仍然保留这些断点 
    enable        #恢复断点的功能  
    j/jump        #跳转到某行执行 
        

#### 代码示例如下:
``` python

#!/usr/bin/python

import Queue
import threading
import time
import pdb; 
pdb.set_trace()

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

#### 调试示例如下：
    ksnowlv@ksnowlvdeMacBook-Pro~/Documents/lvwei projects/python$python thread_queue.py 
    > /Users/ksnowlv/Documents/lvwei projects/python/thread_queue.py(9)<module>()
    -> exitFlag = 0
    (Pdb) b process_data
    Breakpoint 1 at /Users/ksnowlv/Documents/lvwei projects/python/thread_queue.py:27
    (Pdb) b 45
    Breakpoint 2 at /Users/ksnowlv/Documents/lvwei projects/python/thread_queue.py:45
    (Pdb) b 33
    Breakpoint 3 at /Users/ksnowlv/Documents/lvwei projects/python/thread_queue.py:33
    (Pdb) b
    Num Type         Disp Enb   Where
    1   breakpoint   keep yes   at /Users/ksnowlv/Documents/lvwei projects/python/thread_queue.py:27
    2   breakpoint   keep yes   at /Users/ksnowlv/Documents/lvwei projects/python/thread_queue.py:45
    3   breakpoint   keep yes   at /Users/ksnowlv/Documents/lvwei projects/python/thread_queue.py:33
    (Pdb) cl 3
    Deleted breakpoint 3
    (Pdb) b
    Num Type         Disp Enb   Where
    1   breakpoint   keep yes   at /Users/ksnowlv/Documents/lvwei projects/python/thread_queue.py:27
    2   breakpoint   keep yes   at /Users/ksnowlv/Documents/lvwei projects/python/thread_queue.py:45
    (Pdb) b 33
    Breakpoint 4 at /Users/ksnowlv/Documents/lvwei projects/python/thread_queue.py:33
    (Pdb) c
    > /Users/ksnowlv/Documents/lvwei projects/python/thread_queue.py(45)<module>()
    -> threadID = 1
    (Pdb) p threadList
    ['ksnow', 'kair', 'baby']
    (Pdb) pp nameList
    ['One', 'Two', 'Three', 'Four', 'Five']
    (Pdb) n
    > /Users/ksnowlv/Documents/lvwei projects/python/thread_queue.py(48)<module>()
    -> for tName in threadList:
    (Pdb) n
    > /Users/ksnowlv/Documents/lvwei projects/python/thread_queue.py(49)<module>()
    -> thread = QThread(threadID, tName, workQueue)
    (Pdb) s
    --Call--
    > /Users/ksnowlv/Documents/lvwei projects/python/thread_queue.py(14)__init__()
    -> def __init__(self, threadID, name, queue):
    (Pdb) s
    > /Users/ksnowlv/Documents/lvwei projects/python/thread_queue.py(15)__init__()
    -> threading.Thread.__init__(self)
    (Pdb) s
    --Call--
    > /System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/threading.py(654)__init__()
    -> def __init__(self, group=None, target=None, name=None,
    (Pdb) c
    Starting ksnow
    Starting kair
    Starting baby
    ksnow processing One
    baby processing Two
     kair processing Three
    ksnow processing Four
    kair processing Five
    Exiting baby
    Exiting ksnow
    Exiting kair
    Exiting Main Thread
    Exception AttributeError: "'NoneType' object has no attribute 'path'" in <function _remove at 0x10fb59b18> ignored
    ksnowlv@ksnowlvdeMacBook-Pro~/Documents/lvwei projects/python$


    
    
   