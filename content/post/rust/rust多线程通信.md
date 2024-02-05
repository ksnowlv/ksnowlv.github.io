---
title: "Rust多线程通信小结"
date: 2024-02-05T23:26:36+08:00
lastmod: 2024-02-05T23:26:36+08:00
keywords: ["rust", "多线程"]
tags: ["rust", "多线程"]
categories: ["rust", "多线程"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Rust多线程通信

Rust提供了多种多样的工具和机制来支持多线程编程。

包括使用Mutex进行共享数据访问、使用mpsc::channel进行消息传递、使用Condvar和Mutex进行线程间同步和通知，以及使用Arc和Mutex实现共享内存的消息传递。

示例代码将演示如何在 Rust 中使用这些方法来实现线程间通信。


### 1.Mutex共享数据访问

如何使用Mutex进行线程间共享数据的访问。代码创建了一个共享的Mutex，并在一个子线程中修改数据，然后主线程再次访问这个数据。

```rust
fn mutex_test() {
	//Mutex 进行线程间共享数据访问
	println!("---mutex_test---");
	let shared_data = Arc::new(Mutex::new(0));
	let shared_data_clone = Arc::clone(&shared_data);

	let handle = thread::spawn(move || {
		let mut thread_data = shared_data_clone.lock().unwrap();
		*thread_data = 1000;
		println!("thread id= {:?}, thread_data: {}", thread::current().id(), *thread_data);
	});

	// wait for child thread
	handle.join().unwrap();

	let res = shared_data.lock().unwrap();
	println!("Final data value:{}", *res);
}

```

### 2.mpsc::channel进行消息传递

如何使用mpsc::channel进行线程间消息传递。代码通过创建发送端和接收端，并在子线程中发送消息，主线程中接收消息。

```rust

fn channel_communication_test() {
	let (tx, rx) = mpsc::channel();
	let handle = thread::spawn(move || {
		let data = "I am  a child thread";
		tx.send(data).unwrap();
	});

	let received_data = rx.recv().unwrap();
	println!("main thread received data value:{}", received_data);
	handle.join().unwrap();
}
```

### 3.Condvar和Mutex线程间同步和通知

如何使用Condvar和Mutex进行线程间的同步和通知。代码创建了一个共享的Condvar和Mutex，并在一个子线程中修改状态，并通过notify_one()通知主线程。

```rust
fn condvar_mutex_test() {
	//使用 Condvar 和 Mutex 进行线程间同步和通知
	println!("---condvar_mutex_test---");
	let pair = Arc::new((Mutex::new(false), Condvar::new()));
	let pair_clone = Arc::clone(&pair);

	let handle = thread::spawn(move || {
		thread::sleep(Duration::from_secs(2));
		let (lock, cvar) = &*pair_clone;
		let mut exit_flag = lock.lock().unwrap();

		*exit_flag = true;
		cvar.notify_one();
	});

	let (lock, cvar) = &*pair;
	let mut exit_flag = lock.lock().unwrap();
	while !*exit_flag {
		println!("main thread exit_flag:{}", *exit_flag);
		exit_flag = cvar.wait(exit_flag).unwrap();
	}

	println!("main thread receive exit_flag status:{}", *exit_flag);
	handle.join().unwrap();
	println!("---condvar_mutex_test---end ");
}
```

### 4.Arc和Mutex实现共享内存的消息传递

如何使用Arc和Mutex实现共享内存的消息传递。代码创建了一个共享的消息队列，一个子线程向队列中插入消息，另一个子线程从队列中读取消息。

```rust
fn shared_memory_test() {
	//在 Rust 中，可以使用共享内存进行消息传递，一种常见的方式是使用 Arc (原子引用计数) 和 Mutex 来实现共享内存和线程安全的消息传递
	println!("---shared_memory_test---");
	let message_queue = Arc::new(Mutex::new(Vec::new()));

	let message_queue_producer = Arc::clone(&message_queue);

	let producer_handle = thread::spawn(move || {
		for i in 0..10 {
			let mut queue = message_queue_producer.lock().unwrap();
			queue.push(format!(" producer handle message:{}", i));
			println!("producer thread Message {}", i);
		}
	});

	let message_queue_consumer = Arc::clone(&message_queue);
	let consumer_handle = thread::spawn(move || {
		for _i in 0..10 {

			let message = {
				let mut queue = message_queue_consumer.lock().unwrap();
				queue.pop()
			};

			if let Some (msg) = message {
				println!("consumer_handle consumer:{}", msg);
			}
		}
	});

	producer_handle.join().unwrap();
	consumer_handle.join().unwrap();
}
```

### 6.效果

```shell
---thread_communication_test---
---mutex_test---
thread id= ThreadId(24), thread_data: 1000
Final data value:1000
main thread received data value:I am  a child thread
---condvar_mutex_test---
main thread exit_flag:false
main thread receive exit_flag status:true
---condvar_mutex_test---end 
---shared_memory_test---
producer thread Message 0
producer thread Message 1
producer thread Message 2
producer thread Message 3
producer thread Message 4
producer thread Message 5
producer thread Message 6
producer thread Message 7
producer thread Message 8
producer thread Message 9
consumer_handle consumer: producer handle message:9
consumer_handle consumer: producer handle message:8
consumer_handle consumer: producer handle message:7
consumer_handle consumer: producer handle message:6
consumer_handle consumer: producer handle message:5
consumer_handle consumer: producer handle message:4
consumer_handle consumer: producer handle message:3
consumer_handle consumer: producer handle message:2
consumer_handle consumer: producer handle message:1
consumer_handle consumer: producer handle message:0

```

