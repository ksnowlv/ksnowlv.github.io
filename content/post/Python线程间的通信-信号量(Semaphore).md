---
title: "Python线程间的通信-信号量(Semaphore)"
date: 2023-08-22T09:12:08+08:00
lastmod: 2023-08-22T09:12:08+08:00
keywords: ["多线程", "Python", "信号量"]
tags: ["多线程", "Python"]
categories: ["多线程", "Python"]

comment: true
toc: true
autoCollapseToc: true
reward: true

---

<!--more-->

## Python Semaphore

如何在Python中使用信号量进行线程间通信？

生产者/消费者是典型的应用场景.

### 1.生产者示例

```python
    def producer(self):

        while True:
            self.semaphore.acquire()
            try:
                print(f"producer is working!!!")
            except Exception as e:
                print(f"producer发生异常:{e}")
            finally:
                self.semaphore.release()

            time.sleep(1)

            with self.lock:
                if self.exit_flag:
                    break

```


### 2.消费者示例

```python
    def consumer(self):

        while True:
            self.semaphore.acquire()
            try:
                 print(f"consumer is working!!!")
            except Exception as e:
                print(f"consumer发生异常:{e}")
            finally:
                self.semaphore.release()

            time.sleep(1)

            with self.lock:
                if self.exit_flag:
                    break

```

### 3.SemaphoreTest其它代码

```python
    # 初始化
    def __init__(self):
        self.semaphore = threading.Semaphore(1)
        self.lock = threading.Lock()
        self.exit_flag = False
        self.producer_thread = threading.Thread(target=self.producer)
        self.consumer_thread = threading.Thread(target=self.consumer)

    def start_thread(self):

        self.producer_thread.start()
        self.consumer_thread.start()  

    def stop_thread(self):

        time.sleep(5)
        with self.lock:
            self.exit_flag = True

        self.producer_thread.join()
        self.consumer_thread.join()      
```

### 4.调用示例

```python

    st = SemaphoreTest()
    st.start_thread()
    st.stop_thread()
```

### 5.执行情况
```shell
producer is working!!!
consumer is working!!!
producer is working!!!
consumer is working!!!
producer is working!!!
consumer is working!!!
producer is working!!!
consumer is working!!!
producer is working!!!
consumer is working!!!

```

### 6.注意事项

```python

     # 信号量初始化为1，确保当前有一个线程可执行；
     # 如果当前信号量的计数器大于 0，那么线程将成功获取信号量，并将信号量计数器减1。
     # 如果当前信号量计数器等于 0，那么线程将会被阻塞，直到有其他线程释放信号量
    self.semaphore = threading.Semaphore(1)
    
    # self.producer,self.consumer不要带()!!!
    threading.Thread(target=self.producer)
    threading.Thread(target=self.consumer)

```python