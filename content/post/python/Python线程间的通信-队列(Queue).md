---
title: "Python线程间的通信-队列(Queue)"
date: 2023-08-23T09:38:12+08:00
lastmod: 2023-08-23T09:38:12+08:00
keywords: ["Python", "多线程", "队列"]
tags: ["Python", "多线程"]
categories: ["Python", "多线程"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Python线程间的通信-队列(Queue)

 Python多线程场景下，线程间的通信可以使用Queue，分为
 * FIFO（先入先出)队列Queue: Queue.Queue:队列顺序为先进先出
 * LIFO（后入先出）队列LifoQueue: 队列顺序为后进先出
 * 优先级队列PriorityQueue:队列会自动根据元素的优先级进行排序，优先级数字越小，代表优先级越高，排在队列的最前面.

### 1.FIFO（先入先出)队列Queue示例

```python

    def work(self):

        while True:
            try:
                item = self.queue.get()
                print(f"---work---item:{item}")
                self.queue.task_done()
            except self.queue.empty():
                print(f"queue empty")

            time.sleep(2)

            with self.lock:
                if self.exit_flag:
                    break
```


### 2.LIFO（后入先出）队列LifoQueue示例


```python

    def lifo_work(self):

        while True:
            try:
                item = self.lifo_queue.get()
                print(f"---lifo_work---item:{item}")
                self.lifo_queue.task_done()
            except self.lifo_queue.empty():
                print(f"lifo_queue empty")

            time.sleep(2)

            with self.lock:
                if self.exit_flag:
                    break  

```

### 3.优先级队列PriorityQueue示例


```python

    def priority_work(self):

        while True:
            try:
                item = self.priority_queue.get()
                print(f"---priority_queue---item:{item}")
                self.priority_queue.task_done()
            except self.priority_queue.empty():
                print(f"priority_queue empty")

            time.sleep(2)

            with self.lock:
                if self.exit_flag:
                    break

```

### 4.其它代码示例


```python

    MAX_THREAD_NUM = 3
    MAX_QUEUE_NUM = 10

    def __init__(self):
        self.exit_flag = False
        self.lock = threading.Lock()
        self.queue = queue.Queue(QueueTest.MAX_QUEUE_NUM)
        self.lifo_queue = queue.LifoQueue(QueueTest.MAX_QUEUE_NUM)
        self.priority_queue = queue.PriorityQueue(QueueTest.MAX_QUEUE_NUM)

    def start(self):

        threads = []

        print(f"---queue---")
        # 先入先出
        for i in range(QueueTest.MAX_THREAD_NUM):
            t = threading.Thread(target=self.work)
            threads.append(t)
            t.start()

        for i in range(QueueTest.MAX_QUEUE_NUM):
            self.queue.put(i)

        self.queue.join()

        with self.lock:
            self.exit_flag = True

        for i in range(QueueTest.MAX_THREAD_NUM):
            threads[i].join(timeout=10)

        threads.clear()

        print(f"---lifo_queue---")
        # 后入先出
        self.exit_flag = False

        for i in range(QueueTest.MAX_THREAD_NUM):
            t = threading.Thread(target=self.lifo_work)
            threads.append(t)
            t.start()

        for i in range(QueueTest.MAX_QUEUE_NUM):
            self.lifo_queue.put(i)

        self.lifo_queue.join()

        with self.lock:
            self.exit_flag = True

        for i in range(QueueTest.MAX_THREAD_NUM):
            threads[i].join(timeout=10)

        threads.clear()

        print(f"---priority_queue---")

        self.exit_flag = False

        for i in range(QueueTest.MAX_THREAD_NUM):
            t = threading.Thread(target=self.priority_work)
            threads.append(t)
            t.start()

        for i in range(QueueTest.MAX_QUEUE_NUM):
            self.priority_queue.put((QueueTest.MAX_QUEUE_NUM - i, "hello priority_queue" + str(QueueTest.MAX_QUEUE_NUM - i)))

        self.priority_queue.join()

        with self.lock:
            self.exit_flag = True

        for i in range(QueueTest.MAX_THREAD_NUM):
            threads[i].join(timeout=10)

        threads.clear()

        print(f"---all finish---")
    

```


### 5.执行情况


```shell

---queue---
---work---item:0
---work---item:1
---work---item:2
---work---item:4
---work---item:3
---work---item:5
---work---item:6
---work---item:7
---work---item:8
---work---item:9
---lifo_queue---
---lifo_work---item:9
---lifo_work---item:8
---lifo_work---item:7
---lifo_work---item:6
---lifo_work---item:5
---lifo_work---item:4
---lifo_work---item:3
---lifo_work---item:2
---lifo_work---item:1
---lifo_work---item:0
---priority_queue---
---priority_queue---item:(1, 'hello priority_queue1')
---priority_queue---item:(2, 'hello priority_queue2')
---priority_queue---item:(3, 'hello priority_queue3')
---priority_queue---item:(4, 'hello priority_queue4')
---priority_queue---item:(5, 'hello priority_queue5')
---priority_queue---item:(6, 'hello priority_queue6')
---priority_queue---item:(7, 'hello priority_queue7')
---priority_queue---item:(8, 'hello priority_queue8')
---priority_queue---item:(9, 'hello priority_queue9')
---priority_queue---item:(10, 'hello priority_queue10')
---all finish---

```

