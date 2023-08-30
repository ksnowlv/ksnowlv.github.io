---
title: "Python线程沲"
date: 2023-08-24T17:45:50+08:00
lastmod: 2023-08-24T17:45:50+08:00
keywords: ["Python", "多线程", "线程沲"]
tags: ["Python", "多线程"]
categories: ["Python", "多线程"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->
## Python线程沲

线程沲是对象池，也是一种常用的并发处理方式，它可以提高程序的效率和性能。


### 1.向线程池提交单个任务

```python
    future = self.executor.submit(self.task_work, "single task")
    print(future.result())
```

### 2.向线程池提交多个任务


```python
    futures = [self.executor.submit(self.task_work, "mutitask-" + str(i)) for i in range(10)]
    results = [future.result() for future in concurrent.futures.as_completed(futures)]

    res = '\n'.join(str(x) for x in results)
    print(f"{res}")
```

### 3.map方法提交多个任务


```python
    tasks = [str(i) for i in range(5)]
    results = self.executor.map(self.task_work, tasks)

    res = '\n'.join(str(x) for x in results)
    print(f"{res}")
```

### 4.线程池关闭


```python
    self.executor.shutdown()
```

### 5.线程池开启也可以使用with方式

```python
    # 创建一个线程池，大小默认
    with ThreadPoolExecutor() as executor:
        # 在 with 语句块中使用线程池
        pass
```

### 6.完整代码

```python
import threading
import time
import concurrent.futures
from  concurrent.futures import ThreadPoolExecutor


class ThreadPoolTest(object):
    def __init__(self):
        self.executor = ThreadPoolExecutor()
        pass

    def __del__(self):
        self.executor.shutdown()
        print(f"executor.shutdown {threading.get_ident()}")

    def task_work(self, task_name):
        time.sleep(2)
        print(f"thread id = {threading.get_ident()}, task_name:{task_name}")

        return task_name

    def start(self):
        # 提交单个任务到线程沲
        print(f"---提交单个任务---")
        future = self.executor.submit(self.task_work, "single task")
        print(future.result())

        # 批量提交多个任务到线程池
        print(f"---提交多个个任务---")
        futures = [self.executor.submit(self.task_work, "mutitask-" + str(i)) for i in range(10)]
        results = [future.result() for future in concurrent.futures.as_completed(futures)]

        res = '\n'.join(str(x) for x in results)
        print(f"{res}")

        # 使用 map 方法可以同时提交多个任务，其中 function 是需要执行的任务函数，iterable 是任务的参数迭代器。
        # map 方法会顺序地将参数迭代器中的每个元素传递给任务函数，并返回结果的生成器。
        print(f"---map方法提交多个任务---")

        tasks = [str(i) for i in range(5)]
        results = self.executor.map(self.task_work, tasks)

        res = '\n'.join(str(x) for x in results)
        print(f"{res}")

```

### 7.执行情况

```terminal
---提交单个任务---
thread id = 13006442496, task_name:single task
single task
---提交多个个任务---
thread id = 13023232000, task_name:mutitask-1
thread id = 13157548032, task_name:mutitask-9
thread id = 13073600512, task_name:mutitask-4
thread id = 13107179520, task_name:mutitask-6
thread id = 13006442496, task_name:mutitask-0
thread id = 13140758528, task_name:mutitask-8
thread id = 13056811008, task_name:mutitask-3
thread id = 13040021504, task_name:mutitask-2
thread id = 13123969024, task_name:mutitask-7
thread id = 13090390016, task_name:mutitask-5
mutitask-1
mutitask-9
mutitask-4
mutitask-6
mutitask-0
mutitask-8
mutitask-3
mutitask-2
mutitask-7
mutitask-5
---map方法提交多个任务---
thread id = 13073600512, task_name:2
thread id = 13006442496, task_name:4
thread id = 13157548032, task_name:1
thread id = 13107179520, task_name:3
thread id = 13023232000, task_name:0
0
1
2
3
4
executor.shutdown 8635171456

Process finished with exit code 0
```