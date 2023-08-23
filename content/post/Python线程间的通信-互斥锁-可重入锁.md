---
title: "Python线程间的通信-互斥锁/可重入锁"
date: 2023-08-23T09:13:58+08:00
lastmod: 2023-08-23T09:13:58+08:00
keywords: ["Python", "多线程", "锁"]
tags: ["Python", "多线程"]
categories: ["Python", "多线程"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Python 互斥锁/可重入锁

 Python多线程场景下，数据在不同线程下互斥访问，会涉及到同步锁
 * 互斥锁: threading.Lock()
 * 可重入锁: threading.RLock()

### 1.同步锁示例

```python

    def count_increment(self):
        with self.lock:
            for i in range(5):
                SharedData._count += i
            print(f"count:{SharedData._count}")
```


### 2.SharedData其它代码


```python

    def __init__(self):
        # self.lock = threading.RLock()
        self.lock = threading.Lock()
        self.threads = []

    def start(self):

        for i in range(5):
            self.threads.append(threading.Thread(target=self.count_increment))
            self.threads[i].start()

        for i in range(5):
            self.threads[i].join()   

```

### 3.执行情况



```terminal

count:10
count:20
count:30
count:40
count:50

```
