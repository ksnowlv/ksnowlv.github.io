---
title: "鸿蒙arkts如何使用多线程并发-TaskPool"
date: 2024-05-25T21:23:57+08:00
lastmod: 2024-05-25T21:23:57+08:00
keywords: ["HMOS"]
tags: ["HMOS"]
categories: ["HMOS"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 1. TaskPool简介
任务池（TaskPool）作用是为应用程序提供一个多线程的运行环境，降低整体资源的消耗、提高系统的整体性能，且您无需关心线程实例的生命周期。


TaskPool支持开发者在主线程封装任务抛给任务队列，系统选择合适的工作线程，进行任务的分发及执行，再将结果返回给主线程。


系统默认会启动一个任务工作线程，当任务较多时会扩容，工作线程数量上限跟当前设备的物理核数相关，具体数量内部管理，保证最优的调度及执行效率，长时间没有任务分发时会缩容，减少工作线程数量。

### 2.TaskPool注意事项

* 实现任务的函数需要使用装饰器@Concurrent标注，且仅支持在.ets文件中使用。

* 任务函数在TaskPool工作线程的执行耗时不能超过3分钟（不包含Promise和async/await异步调用的耗时，例如网络下载、文件读写等I/O任务的耗时），否则会被强制退出。

* 实现任务的函数入参需满足序列化支持的类型，详情请参见TaskPool和Worker支持的序列化类型。

* ArrayBuffer参数在TaskPool中默认转移，需要设置转移列表的话可通过接口setTransferList()设置。

* 由于不同线程中上下文对象是不同的，因此TaskPool工作线程只能使用线程安全的库，例如UI相关的非线程安全库不能使用。

* 序列化传输的数据量大小限制为16MB。

### 3.使用场景

由于`TaskPool`的工作线程会绑定系统的调度优先级，并且支持负载均衡（自动扩缩容），而`Worker`需要开发者自行创建，存在创建耗时以及不支持设置调度优先级，故在性能方面使用`TaskPool`会优于`Worker`，因此大多数场景推荐使用`TaskPool`。

* 需要设置优先级的任务。例如数据在后台计算，计算完成后的数据，在前台界面需要尽快显示，影响用户体验，需要高优先级处理，需要使用TaskPool。

* 需要频繁取消的任务。例如大图浏览场景，为提升体验，图片缓存策略，需要使用TaskPool。

* 大量或者调度分散的任务。例如大型应用的多个模块包含多个耗时任务，推荐采用`TaskPool`。


### 4.使用限制

TaskPool偏向独立任务维度，该任务在线程中执行，无需关注线程的生命周期，超长任务（大于3分钟）会被系统自动回收。

### 5.示例

`MyTask.ets`文件，通过`taskpool`执行异步任务，读取文件中的内容。

```js
import taskpool from '@ohos.taskpool';


@Concurrent
function readFile(num: number): string {
	return 'hello taskpool '
}


export class MyTask {
	static async handleReadFile(): Promise<string> {
		// 创建Task对象时，传递一个函数引用

		let task = new taskpool.Task(readFile, 2)
		try {
			// 等待 taskpool.execute(task) 解析并获取结果
			let res = await taskpool.execute(task) as string
			console.info(`MyTask handleReadFile ${res}`)
			return res
		} catch (error) {
			// 处理可能出现的错误
			console.error('MyTask execution failed:', error);
			throw error; // 重新抛出错误，或根据需要处理
		}
	}
}
```

在执行任务时，可以指定任务优先级

```js
   function execute(task: Task, priority?: Priority): Promise<unknown>
```

优先级分为三种

```js
enum Priority {
    HIGH,
    MEDIUM,
    LOW
}
```

优先级默认为`MEDIUM`，如上述代码需要提升任务优先级

```js
	let res = await taskpool.execute(task, taskpool.Priority.HIGH) as string
```

在页面中的调用

```js

Text('当任务不需要长时间（3分钟）占据后台线程，而是一个个独立的任务时，推荐使用TaskPool，反之推荐使用Worker。')
    .width('80%')

Text(`MyTask.handleReadFile:${this.taskRes}`)
    .width('80%')
    .fontColor(Color.Green)

Button('TaskPool-CPU密集型任务')
    .width('80%')
    .onClick(async () => {
        let res = await MyTask.handleReadFile()
        if (typeof res === 'string') {
            this.taskRes = res
        } else {
            this.taskRes = 'error'
        }
    })
```

### 6.效果

![image](/images/hmos/hmos-arkts如何使用多线程并发-TaskPool/result.png)
