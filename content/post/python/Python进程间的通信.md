---
title: "Python进程间的通信"
date: 2023-08-24T15:38:19+08:00
lastmod: 2023-08-24T15:38:19+08:00
keywords: ["Python", "多进程", "队列", "信号量", "进程池"]
tags: ["Python"]
categories: ["Python"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->
## Python进程间的通信

在 Python 中，有几种常用的方式用于实现进程间通信

### 1.管道 (Pipe)

管道是一种常用的进程间通信机制，它可以在父进程和子进程之间传递数据。通过 multiprocessing 模块中的 Pipe() 函数可以创建一个双向管道，其中一个连接可以用于父进程向子进程发送数据，另一个连接可以用于子进程向父进程发送数据。


示例代码
```python
    def work_with_pipe(self, connection):

        while True:
            data = connection.recv()
            print(f"child_process recv {data}")
            if data == "close":
                break
            elif type(data) in [int, float]:
                result = data * 3
                connection.send(result)

        try:
            connection.close()
        except Exception as e:
            print(f"error = {e}")

```

调用示例
```python
    def start_with_pipe(self):
        parent_connection, child_connection = Pipe()
        child_process = Process(target=self.work_with_pipe, args=(child_connection,))
        child_process.start()

        for i in range(1, 5):
            parent_connection.send(i)
            res = parent_connection.recv()
            print(f"parent_connection recv {res}")

        parent_connection.send("close")

        child_process.join()
        print(f"process finish")
```

执行情况
```python

child_process recv 1
parent_connection recv 3
child_process recv 2
parent_connection recv 6
child_process recv 3
parent_connection recv 9
child_process recv 4
parent_connection recv 12
child_process recv close
process finish

```


### 2.队列 (Queue)

队列是在多个进程之间安全传递消息的一种简单方式。multiprocessing 模块中的 Queue 类实现了进程安全的队列，可以用于在多个进程之间传递数据。

示例代码
```python

    def work_with_queue_produce(self):

        for i in range(5):
            self.queue.put(i)
            time.sleep(1)

        self.queue.put(None)

    def work_with_queue_consume(self):

        while True:
            try:
                item = self.queue.get()
                if item is None:
                    print(f"---consume--- finish")
                    break
                print(f"---consume--- item:{item}")
            except Exception as e:
                print(f"---consume--- error:{e}")

```

调用示例
```python

    def start_with_queue(self):
        producer = Process(target=self.work_with_queue_produce)
        consumer = Process(target=self.work_with_queue_consume)
        producer.start()
        consumer.start()
        producer.join()
        consumer.join()

```

执行情况
```python
---consume--- item:0
---consume--- item:1
---consume--- item:2
---consume--- item:3
---consume--- item:4
---consume--- finish
```

### 3.共享内存 (Shared Memory)

共享内存提供了一种进程间数据共享的机制，多个进程可以直接访问共享内存中的数据。multiprocessing 模块中的 Value 和 Array 类可以用于创建在多个进程之间共享的变量和数组，并确保它们的访问是进程安全的。

示例代码
```python

   def work_with_shared_memory1(self):
        self.shared_value.value += 1

        for i in range(len(self.shared_array)):
            self.shared_array[i] += 1

        print(
            f"---process_data_shared_memory1---"
            f"shared_value:{self.shared_value.value}, "
            f"shared_array:{self.shared_array[:]}")

    def work_with_shared_memory2(self):
        self.shared_value.value += 5

        for i in range(len(self.shared_array)):
            self.shared_array[i] += 5

        print(
            f"---process_data_shared_memory2---"
            f"shared_value:{self.shared_value.value}, "
            f"shared_array:{self.shared_array[:]}")

```

调用示例
```python

    def start_with_shared_memory(self):
        p1 = Process(target=self.work_with_shared_memory1)
        p2 = Process(target=self.work_with_shared_memory2)
        p1.start()
        p2.start()
        p1.join()
        p2.join()

        print(
            f"---start_with_shared_memory---"
            f"shared_value:{self.shared_value.value}, "
            f"shared_array:{self.shared_array[:]}")

```

其中shared_value，shared_array声明
```python
    self.shared_value = Value('i', 0)
    self.shared_array = Array('i', [1, 2, 3, 4, 5])

```

可共享的基本类型如下

* 'i'：有符号整型（int）
* 'd'：双精度浮点型（double）
* 'f'：单精度浮点型（float）
* 'c'：字符型（char）
* 'b'：有符号字节型（byte）
* 'B'：无符号字节型（byte）

执行情况
```python

---process_data_shared_memory2---shared_value:5, shared_array:[6, 7, 8, 9, 10]
---process_data_shared_memory1---shared_value:6, shared_array:[7, 8, 9, 10, 11]
---start_with_shared_memory---shared_value:6, shared_array:[7, 8, 9, 10, 11]

```

### 4.信号量 (Semaphore)

信号量是一种通信机制，用于在多个进程之间控制共享资源的访问。multiprocessing 模块中的 Semaphore 类实现了进程间的信号量机制，可以用于多个进程之间的同步和互斥访问控制。

示例代码
```python
    def work_with_semaphore(self, num):

        self.semaphore.acquire()
        print(f"---进程:{num} work_with_semaphore start---")
        time.sleep(1)
        print(f"---进程:{num} work_with_semaphore finish---")
        self.semaphore.release()
```

调用示例
```python
    def start_with_semaphore(self):

        procs = [Process(target=self.work_with_semaphore, args=(i,)) for i in range(5)]

        for p in procs:
            p.start()

        for p in procs:
            p.join()

```

执行情况
```python
---进程:0 work_with_semaphore start---
---进程:0 work_with_semaphore finish---
---进程:2 work_with_semaphore start---
---进程:2 work_with_semaphore finish---
---进程:3 work_with_semaphore start---
---进程:3 work_with_semaphore finish---
---进程:1 work_with_semaphore start---
---进程:1 work_with_semaphore finish---
---进程:4 work_with_semaphore start---
---进程:4 work_with_semaphore finish---

```

### 5.进程池 (Pool)

进程池是一种用于调度和管理进程的方式，使得可以方便地进行进程间通信。multiprocessing 模块中的 Pool 类可以用于创建一个进程池，并通过它来进行进程间的任务分发和结果收集。

示例代码
```python
    @staticmethod
    def work_with_pool(num):
        print(f'work_with_pool---进程名{multiprocessing.current_process().name}，进程号{os.getpid()}')
        num += 10
        print(f"work_with_pool = num:{num}")

        time.sleep(2)
        return num
```

调用示例
```python
    def start_with_pool(self):

        with Pool(5) as pool:
            res = pool.map(ProcessTest.work_with_pool, [1, 2, 3, 4, 5])
            print(f"---start_with_pool---res:{res}")

        results = []
        with Pool(3) as pool:

            for i in range(1, 10):
                result = pool.apply_async(func=ProcessTest.work_with_pool, args=(i,))
                results.append(result)

            pool.close()
            pool.join()

            res = [result.get() for result in results]
            print(f"---start_with_pool---res = {res}")
```

执行情况
```python
work_with_pool---进程名SpawnPoolWorker-12，进程号94978
work_with_pool = num:11
work_with_pool---进程名SpawnPoolWorker-11，进程号94977
work_with_pool = num:12
work_with_pool---进程名SpawnPoolWorker-13，进程号94979
work_with_pool = num:13
work_with_pool---进程名SpawnPoolWorker-14，进程号94980
work_with_pool = num:14
work_with_pool---进程名SpawnPoolWorker-15，进程号94981
work_with_pool = num:15
---start_with_pool---res:[11, 12, 13, 14, 15]
work_with_pool---进程名SpawnPoolWorker-16，进程号94985
work_with_pool = num:11
work_with_pool---进程名SpawnPoolWorker-17，进程号94986
work_with_pool = num:12
work_with_pool---进程名SpawnPoolWorker-18，进程号94987
work_with_pool = num:13
work_with_pool---进程名SpawnPoolWorker-17，进程号94986
work_with_pool = num:14
work_with_pool---进程名SpawnPoolWorker-18，进程号94987
work_with_pool = num:15
work_with_pool---进程名SpawnPoolWorker-16，进程号94985
work_with_pool = num:16
work_with_pool---进程名SpawnPoolWorker-17，进程号94986
work_with_pool = num:17
work_with_pool---进程名SpawnPoolWorker-16，进程号94985
work_with_pool = num:18
work_with_pool---进程名SpawnPoolWorker-18，进程号94987
work_with_pool = num:19
---start_with_pool---res = [11, 12, 13, 14, 15, 16, 17, 18, 19]

```

### 6.注意事项

* 进程池指定func时，务必注意是静态方法,不是类方法或对象方法!!!
