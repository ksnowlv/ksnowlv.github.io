---
title: "Python中协程"
date: 2023-08-19T16:31:49+08:00
lastmod: 2023-08-19T16:31:49+08:00
keywords: ["Python", "协程", "并发"]
tags: ["Python", "协程", "并发"]
categories: ["Python", "协程", "并发"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Python协程用法 

### 1.使用 async 和 await 定义协程函数

```python
async def my_coroutine_test(self):
    print(f"my_coroutine_test start")
    await asyncio.sleep(2)
    print(f"my_coroutine_test finish")
    
```

调用

```python 
    asyncio.run(self.my_coroutine_test())
```

执行情况

```terminal
my_coroutine_test start
my_coroutine_test finish
```

### 2.创建和调度多个协程任务


```python

    async def my_task(self, number):
        print(f"task:{number}")

    async def coroutine_tasks(self):

        my_tasks = [self.my_task(i) for i in range(10)]
        await asyncio.gather(*my_tasks)

```

调用

```python 
    asyncio.run(self.coroutine_tasks())
```

执行情况

```terminal
task:0
task:1
task:2
task:3
task:4
task:5
task:6
task:7
task:8
task:9
```

### 3.使用 asyncio.wait() 等待一组协程任务完成

```python
    async def wait_my_task(self):
        print(f"wait_my_task start")
        await asyncio.sleep(2)
        print(f"wait_my_task end")

    async def wait_coroutine_task(self):
        mytask = [asyncio.create_task(self.wait_my_task()) for _ in range(5)]
        (done, pending) = await asyncio.wait(mytask)
        for task in done:
            print(task.result())
```

调用

```python 

    asyncio.run(self.wait_coroutine_task())
```

执行情况

```terminal
wait_my_task start
wait_my_task start
wait_my_task start
wait_my_task start
wait_my_task start
wait_my_task end
wait_my_task end
wait_my_task end
wait_my_task end
wait_my_task end
None
None
None
None
None

```

### 4.协程间通过queue进行数据传递


```python
    async def coroutine_data_communication(self):
        queue = asyncio.Queue()
        producer = asyncio.create_task(self.producer(queue))
        consumer = asyncio.create_task(self.consumer(queue))
        await asyncio.gather(producer, consumer)
        print(f"---coroutine_data_communication finish---")

    async def producer(self, queue):
        print(f"---produce coroutine---")
        for i in range(10):
            await queue.put(i)
            print(f"produce:{i}")
            await asyncio.sleep(1)

    async def consumer(self, queue):
        print(f"---consumer coroutine---")
        while True:

            if not queue.empty():
                item = await queue.get()
                print(f"Consumed:{item}")
                self.count = 0
            else:
                self.count += 1
                if self.count >= 3:
                    break

            await asyncio.sleep(1)
```

调用
```python 
     asyncio.run(self.coroutine_data_communication())
```

执行情况

```terminal
---produce coroutine---
produce:0
---consumer coroutine---
Consumed:0
produce:1
Consumed:1
produce:2
Consumed:2
produce:3
Consumed:3
produce:4
Consumed:4
produce:5
Consumed:5
produce:6
Consumed:6
produce:7
Consumed:7
produce:8
Consumed:8
produce:9
Consumed:9


```

### 5.使用 asyncio.Event 进行协程间的通信


```python
    async def event_send(self, event):
        print(f"event event_send---1")
        await asyncio.sleep(2)
        event.set()
        print(f"event event_send---2")

    async def event_rev(self, event):
        print(f"event_rev---1")
        await event.wait()
        print(f"event_rev---2")

    async def event_test(self):
        print(f"event_test---1")
        event = asyncio.Event()
        await asyncio.gather(self.event_send(event), self.event_rev(event))
        print(f"event_test---2")

```

调用
```python 
     asyncio.run(self.coroutine_data_communication())
```

执行情况
```terminal
使用 asyncio.Event 进行通信
event_test---1
event event_send---1
event_rev---1
event event_send---2
event_rev---2
event_test---2

```