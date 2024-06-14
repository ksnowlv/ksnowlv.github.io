---
title: "HMOS arkts如何使用异步并发"
date: 2024-05-25T15:43:59+08:00
lastmod: 2024-05-25T15:43:59+08:00
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


### 1.异步并发 (Promise和async/await)


Promise和async/await提供异步并发能力，是标准的JS异步语法。异步代码会被挂起并在之后继续执行，同一时间只有一段代码执行，适用于单次I/O任务的场景开发，例如一次网络请求、一次文件读写等操作。

异步语法是一种编程语言的特性，允许程序在执行某些操作时不必等待其完成，而是可以继续执行其他操作。

### 2.Promise

Promise是一种用于处理异步操作的对象，可以将异步操作转换为类似于同步操作的风格，以方便代码编写和维护。

Promise提供了一个状态机制来管理异步操作的不同阶段，并提供了一些方法来注册回调函数以处理异步操作的成功或失败的结果。

Promise有三种状态：pending（进行中）、fulfilled（已完成）和rejected（已拒绝）。Promise对象创建后处于pending状态，并在异步操作完成后转换为fulfilled或rejected状态。


最基本的用法是通过构造函数实例化一个Promise对象，同时传入一个带有两个参数的函数，通常称为executor函数。executor函数接收两个参数：resolve和reject，分别表示异步操作成功和失败时的回调函数。

示例代码

```js
	handlePromise() {
		const promise = new Promise((resolve, reject) => {
			setTimeout(() => {
				const num = Math.random()
				console.info(`handlePromise: ${num}}`)

				if (num > 0.3) {
					resolve(num)
				} else {
					reject(new Error('数据不符合预期'))
				}
			}, 1000)
		})

		promise.then((result: number) => {
			this.state = result
			
		}).catch((error) => {
			this.state = -1
		})
	}
```

### 3.async/await

`async/await`是一种用于处理异步操作的`Promise`语法糖，使得编写异步代码变得更加简单和易读。通过使用`async`关键字声明一个函数为异步函数，并使用`await`关键字等待`Promise`的解析（完成或拒绝），以同步的方式编写异步操作的代码。

`async`函数是一个返回`Promise`对象的函数，用于表示一个异步操作。


```js
	async fetchUseResult(): Promise<string> {
		return new Promise((resolve: Function) => {
			setTimeout(() => {
				resolve('Hello, world!');
			}, 1000);
		},)
	}

```

调用如下

```js
    try {
        this.userResult = await this.fetchUseResult()
    } catch (error) {
        console.info(`error:${error}`)
    }
    
```

### 4.async内的await

`async`函数是一个返回`Promise`对象的函数，用于表示一个异步操作。

在`async`函数内部，可以使用`await`关键字等待一个`Promise`对象的解析，并返回其解析值。如果一个`async`函数抛出异常，那么该函数返回的`Promise`对象将被拒绝，并且异常信息会被传递给`Promise`对象的`onRejected()`方法。

示例代码

```js
	async fetchUserContent(): Promise<string> {

		try {
			const result: string = await new Promise((resolve: Function) => {
				setTimeout(() => {
					resolve('Hello, world! I am coming');
				}, 1000);
			},);
			return result

		} catch (error) {
			console.info(`fetchUserContent error: ${error}`)
			throw error;
		} finally {
			console.info(`fetchUserContent done`)
		}
	}
```

调用如下

```js
 Click(async () => {
    this.userContent = await this.fetchUserContent()
```

5.效果

![image](/images/hmos/hmos-arkts如何使用异步并发/result.png)






