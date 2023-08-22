---
title: "Python线程间的通信-条件变量(Condition)"
date: 2023-08-22T14:45:42+08:00
lastmod: 2023-08-22T14:45:42+08:00
keywords: ["Python", "多线程", "条件变量"]
tags: ["Python", "多线程"]
categories: ["Python", "多线程"]
comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Python 条件变量

**Python** 中的 **Condition** 类可以被称为条件变量 (condition variable)。

条件变量是一个线程同步的工具，可以在一个或多个线程等待特定条件的情况下允许线程挂起和恢复。条件变量有两个主要方法：

* wait: 线程可以使用 wait() 方法挂起自己并等待某个条件的发生
* notify: 当条件满足时，线程可以调用 notify() 方法来通知其他线程，从而唤醒等待该条件的线程。
* notify_all: 通知所有相关线程，并唤醒所有等待该条件变量的相关线程。
* acquire: 获取锁
* release: 释放锁


需要注意的是，Python 中的 Condition 类通过自动管理锁来确保了线程的安全，并且对线程的状态变化进行了封装和抽象。这样我们便可以专注于条件本身，而不必担心锁的管理和状态变化的细节，从而简化了线程编程。


### 1.生产者示例

```python

    def producer(self, data):
        print(f"---producer--- start")
        with self.condition:
            while self.ready:
                self.condition.wait()

            self.data = data
            print(f"---producer data---{self.data} ")
            self.ready = True
            self.condition.notify()

        print(f"---producer--- finish")
```

### 2.消费者示例

```python

    def consumer(self):
        print(f"---consumer--- start")
        with self.condition:
            while not self.ready:
                self.condition.wait()
            data = self.data
            print(f"consumer received data:{data}")
            self.ready = False
            self.condition.notify()
        print(f"---consumer--- finish")
```

### 3.ConditionTest其它代码


```python

    def __init__(self):
        self.ready = False
        self.data = None
        self.condition = threading.Condition()
        self.producer_thread = threading.Thread(target=self.producer, args=("Hello, I am comming!!!", ))
        self.consumer_thread = threading.Thread(target=self.consumer)


    def start(self):
        self.producer_thread.start()
        self.consumer_thread.start()

        self.producer_thread.join()
        self.consumer_thread.join()    

```

### 4.执行情况



```terminal

---producer--- start
---consumer--- start

---producer data---Hello, I am comming!!! 
---producer--- finish
consumer received data:Hello, I am comming!!!
---consumer--- finish

```