---
title: "鸿蒙Arkts如何使用多线程并发-Worker"
date: 2024-05-25T21:51:41+08:00
lastmod: 2024-05-25T21:51:41+08:00
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

### 1.Worker简介
Worker主要作用是为应用程序提供一个多线程的运行环境，可满足应用程序在执行过程中与主线程分离，在后台线程中运行一个脚本操作耗时操作，极大避免类似于计算密集型或高延迟的任务阻塞主线程的运行。

创建Worker的线程称为宿主线程（不一定是主线程，工作线程也支持创建Worker子线程），Worker自身的线程称为Worker子线程（或Actor线程、工作线程）。每个Worker子线程与宿主线程拥有独立的实例，包含基础设施、对象、代码段等。Worker子线程和宿主线程之间的通信是基于消息传递的，Worker通过序列化机制与宿主线程之间相互通信，完成命令及数据交互。

### 2.Worker注意事项

* 创建Worker时，传入的Worker.ts路径在不同版本有不同的规则，详情请参见文件路径注意事项。

* Worker创建后需要手动管理生命周期，且最多同时运行的Worker子线程数量为8个，详情请参见生命周期注意事项。

* Ability类型的Module支持使用Worker，Library类型的Module不支持使用Worker。

* 创建Worker不支持使用其他Module的Worker.ts文件，即不支持跨模块调用Worker。

* 由于不同线程中上下文对象是不同的，因此Worker线程只能使用线程安全的库，例如UI相关的非线程安全库不能使用。

* 序列化传输的数据量大小限制为16MB。

* 使用Worker模块时，需要在主线程中注册onerror接口，否则当worker线程出现异常时会发生jscrash问题。

* 不支持跨HAP使用Worker线程文件。

### 3.生命周期注意事项

Worker的创建和销毁耗费性能，建议开发者合理管理已创建的Worker并重复使用。Worker空闲时也会一直运行，因此当不需要Worker时，可以调用terminate()接口或parentPort.close()方法主动销毁Worker。若Worker处于已销毁或正在销毁等非运行状态时，调用其功能接口，会抛出相应的错误。

Worker存在数量限制，支持最多同时存在8个Worker。

在API version 8及之前的版本，当Worker数量超出限制时，会抛出“Too many workers, the number of workers exceeds the maximum.”错误。
从API version 9开始，当Worker数量超出限制时，会抛出“Worker initialization failure, the number of workers exceeds the maximum.”错误。

### 4.示例


`DevEco Studio 4.0 Release`中，通过`File->New->Worker`,创建MyWorker，效果如图

![image](/images/hmos/hmos-arkts如何使用多线程并发-Worker/worker_create.jpg)

![image](/images/hmos/hmos-arkts如何使用多线程并发-Worker/woker_dir.png)


#### 4.1 `MyWorker.ts`文件

```js
import worker, { ThreadWorkerGlobalScope, MessageEvents, ErrorEvent } from '@ohos.worker';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessage = function (e: MessageEvents) {
  let oldArr = e.data;
  let newArr = strSort(oldArr);
  workerPort.postMessage(newArr);

}

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessageerror = function (e: MessageEvents) {
  console.log("onmessageerror worker::error = " + e.data);
}

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param e error message
 */
workerPort.onerror = function (e: ErrorEvent) {
  console.log("onerror worker::error ");
}

function strSort(inPutArr): string {
  let newArr = inPutArr.sort();
  for (let index = 0; index < newArr.length; index++) {
    const element = newArr[index];
    console.info(`ConcurrencyPage newArr js ${element}`)
  }
  return newArr;
}
```

#### 4.2.工作线程相关变量定义

```js
	myWorker: worker.ThreadWorker = new worker.ThreadWorker("entry/ets/workers/MyWorker.ts");
	jsWorkerInPutArr: string[] = [];
	@State jsWorkerOutPutStr: string = ''
	@State jsWorkerInPutStr: string = 'I am,go home,go,thank you,help me,wellcome,get out,I need your help,bye bye,good night'

```

#### 4.3.工作线程调度

工作线程根据输入的字符串数组，发送到工作线程中处理。处理完成后，使用jsWorkerOutPutStr接收处理结果。

```js
	async executeWorkerFunc(inPutArr: string[]): Promise<void> {
		if (!this.jsWorkerInPutStr.length) {
			this.jsWorkerOutPutStr = "No input for the string to be sorted.\n";
			return;
		}

		for (let index = 0; index < inPutArr.length; index++) {
			console.log(`${this.TAG}, jsWorkerInPutStr:${inPutArr[index]}`)
		}

		this.myWorker.postMessage(inPutArr);
		let strFlag = false;
		let outPutStr = '';
		this.myWorker.onmessage = (e) => {
			outPutStr = e.data.toString();
			console.log(`${this.TAG}, onmessage outPutStr:${outPutStr}`)
			strFlag = true;
		}
		while (!strFlag) {
			await this.promiseCase();
		}
		this.jsWorkerOutPutStr = outPutStr;
	}

	async promiseCase(): Promise<Object | void> {
		let p: Promise<Object | void> = new Promise<Object>((resolve: Function, reject: Function) => {
			setTimeout(() => {
				resolve(1)
			}, 100)
		}).then(undefined, () => {
		})
		return p;
	}
```

#### 4.4.UI线程中的调用

```js
    Text('Worker主要作用是为应用程序提供一个多线程的运行环境，可满足应用程序在执行过程中与主线程分离，在后台线程中运行一个脚本操作耗时操作，极大避免类似于计算密集型或高延迟的任务阻塞主线程的运行')
                .width('80%')
    Text('Worker创建后需要手动管理生命周期，且最多同时运行的Worker子线程数量为8个，详情请参见生命周期注意事项。\nAbility类型的Module支持使用Worker，Library类型的Module不支持使用Worker。\n创建Worker不支持使用其他Module的Worker.ts文件，即不支持跨模块调用Worker。\n由于不同线程中上下文对象是不同的，因此Worker线程只能使用线程安全的库，例如UI相关的非线程安全库不能使用。\n序列化传输的数据量大小限制为16MB。\n使用Worker模块时，需要在主线程中注册onerror接口，否则当worker线程出现异常时会发生jscrash问题。')
        .width('80%')

    Text(this.jsWorkerInPutStr)
        .width('80%').fontColor(Color.Green)

    Text(`Worker 字符串排序后:${this.jsWorkerOutPutStr}`)
        .width('80%')

    Button('Worker分割字符串')
        .width('80%')
        .onClick(() => {
            this.jsWorkerInPutArr = this.jsWorkerInPutStr.trim().split(',');
            this.jsWorkerOutPutStr = '';
            this.executeWorkerFunc(this.jsWorkerInPutArr);
        })
```


### 5.效果

![image](/images/hmos/hmos-arkts如何使用多线程并发-Worker/result.png)

