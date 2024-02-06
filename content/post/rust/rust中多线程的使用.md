---
title: "Rust中多线程并发编程-补充"
date: 2024-02-06T13:29:11+08:00
lastmod: 2024-02-06T13:29:11+08:00
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

## Rust中多线程并发编程


### 1.Arc和Mutex

使用Arc和Mutex来创建并发安全的共享数据结构。这里通过Arc（原子引用计数指针）将Mutex包装成可跨线程共享的数据结构，并展示了如何在多个线程间进行安全的数据写入和读取操作。
```rust
fn mutex_test() {
	println!("---mutex_test---");
	//当使用 Rust 的 Mutex 智能指针时，一般情况下会将内部数据封装在 Arc 和 Mutex 中，以确保多线程下的安全性
	let shared_data = Arc::new(Mutex::new(0));
	let threads: Vec<_> = (0..6).map(|i| {
		let thread_data = Arc::clone(&shared_data);
		thread::spawn(move || {
			for j in 0..10  {
				let mut data = thread_data.lock().unwrap();
				*data += i *  j;
			}
		})

	}).collect();



	for t in threads  {
		t.join().unwrap();
	}

	println!("Final value: {}", *shared_data.lock().unwrap());
}


```

### 2.Arc和RwLock


使用Arc和RwLock实现读写锁，允许多个线程同时读取数据，但只有一个线程能写入数据。该函数还演示了如何使用Mutex作为条件变量来实现线程间的同步通信。

```rust

fn  rwlock_test() {
	// Rust 中的 RwLock（读写锁），可以使用 Arc 和 RwLock 结合起来，以实现多线程下的读写安全。
	println!("---rwlock_test---");
	let shared_data = Arc::new(RwLock::new(0));
	let exit_flag = Arc::new(Mutex::new(false));

	let read_threads:Vec<_> = (0..5).map(|_x| {
		let thread_data = Arc::clone(&shared_data);
		//let thread_flag = Arc::clone(&exit_flag);
		let thread_flag = Arc::clone(&exit_flag);
		thread::spawn(move || {
			loop {
				let  data = thread_data.read().unwrap();
				println!("read thread {:?}: data = {}", thread::current().id(), *data);
				let flag = thread_flag.lock().unwrap();
				if *flag {
					println!("read thread {:?}: flag = {}", thread::current().id(), *flag);
					break;
				}
			}

			println!("read thread end!");
		})
	}).collect();

	let write_threads: Vec<_> = (0..3).map(|_x| {
		let thread_data = Arc::clone(&shared_data);
		let thread_flag = Arc::clone(&exit_flag);
		thread::spawn(move || {
			for i in 0..3 {
				let  mut  data = thread_data.write().unwrap();
				*data = i;
				println!("write thread {:?}: data = {}", thread::current().id(), *data);
				thread::sleep(Duration::from_secs(2));
			}

			let mut flag_data = thread_flag.lock().unwrap();
			*flag_data = true;

			println!("write thread end!");
		})
	}).collect();


	//wait for write
	for write_t in write_threads  {
		write_t.join().unwrap();
	}

	//read
	for read_thread in read_threads  {
		read_thread.join().unwrap();
	}

	let final_value = shared_data.read().unwrap();
	println!("rwlock_test Final value: {}", *final_value);
}

```

### 3.Pin类型

它用于固定数据在堆上的内存位置，以防止数据被移动。这对于处理涉及异步操作或存在自引用数据结构的情况特别有用。
```rust
struct XData {
	value: i64,
}

impl XData {
	fn new(value: i64) -> Self {
		XData{value}
	}
}

fn pin_test() {

	//使用 as_ref 方法获取指向固定数据的引用。值得注意的是，一旦数据被固定，就无法再次移动它。
	println!("---pin_test---");
	let data = XData::new(100);
	let pin_data: Pin<Box<XData>> = Box::pin(data);
	let pin_data_ref = pin_data.as_ref();
	println!("pin data: {}", pin_data_ref.value);
}
```
#### 4 Mutex和Condvar

Mutex和Condvar来实现条件变量，主线程使用条件变量通知子线程结束，并等待子线程执行完毕。


```rust
fn cond_var_test() {
	println!("---cond_var_test---");
	let pair = Arc::new((Mutex::new(false), Condvar::new()));
	let pair_clone_data = Arc::clone(&pair);
	thread::spawn(move || {
		let (lock, cvar) = &*pair_clone_data;
		let mut exit_flag = lock.lock().unwrap();

		while !*exit_flag {
			println!("exit_flag = {}", *exit_flag);
			exit_flag = cvar.wait(exit_flag).unwrap();
		}
		println!("Thread end, exit_flag = {:?}", *exit_flag);
		thread::sleep(Duration::from_secs(1))
	});

	thread::sleep(Duration::from_micros(500));
	let (lock, cvar) = &*pair;
	let mut exit_flag = lock.lock().unwrap();
	*exit_flag = true;
	cvar.notify_one();
	println!("main thread exit_flag = {}", *exit_flag);
	// 等待子线程执行完毕，并添加一些延迟等待的时间
	//handle.join().unwrap();
	thread::sleep(Duration::from_secs(1));
	println!("cond_var_test end");
}

```

### 5.效果

```shell
---mutex_test---
Final value: 675
---rwlock_test---
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(16): data = 0
read thread ThreadId(17): data = 0
read thread ThreadId(18): data = 0
read thread ThreadId(19): data = 0
write thread ThreadId(20): data = 0
write thread ThreadId(21): data = 0
write thread ThreadId(22): data = 0
read thread ThreadId(15): data = 0
read thread ThreadId(19): data = 0
read thread ThreadId(16): data = 0
read thread ThreadId(17): data = 0
read thread ThreadId(18): data = 0
write thread ThreadId(20): data = 1
write thread ThreadId(21): data = 1
write thread ThreadId(22): data = 1
read thread ThreadId(15): data = 1
read thread ThreadId(19): data = 1
read thread ThreadId(16): data = 1
read thread ThreadId(17): data = 1
read thread ThreadId(18): data = 1
write thread ThreadId(20): data = 2
write thread end!
write thread ThreadId(21): data = 2
write thread end!
write thread ThreadId(22): data = 2
write thread end!
read thread ThreadId(15): data = 2
read thread ThreadId(15): flag = true
read thread end!
read thread ThreadId(19): data = 2
read thread ThreadId(19): flag = true
read thread end!
read thread ThreadId(16): data = 2
read thread ThreadId(16): flag = true
read thread end!
read thread ThreadId(17): data = 2
read thread ThreadId(17): flag = true
read thread end!
read thread ThreadId(18): data = 2
read thread ThreadId(18): flag = true
read thread end!
rwlock_test Final value: 2
---pin_test---
pin data: 100
---cond_var_test---
exit_flag = false
main thread exit_flag = true
cond_var_test end

```
