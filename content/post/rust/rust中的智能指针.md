---
title: "Rust中的智能指针"
date: 2024-02-04T22:23:26+08:00
lastmod: 2024-02-04T22:23:26+08:00
keywords: ["rust","智能指针"]
tags: ["rust"]
categories: ["rust"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->
### Rust中的智能指针
Rust中的智能指针使用时，需要考虑到内存管理和并发访问的情况。

Rust提供了几种不同的智能指针类型，如Box，Rc，Arc，RefCell和Cell，每种都有特定的使用场景和适用性。

#### 1.Box 智能指针

Box 是用于在堆上分配内存的智能指针，常用于需要在编译时无法确定大小或需要在多个位置共享所有权的情况。

示例代码展示了 Box 的基本用法，包括对不同类型的数据进行包装和访问。

```rust
fn box_pointer_test() {
	//用于在堆上分配内存，并在编译时保证数据的所有权唯一。适用于在编译时无法确定大小或需要在多个位置共享所有权的情况。

	let x = Box::new(10.0);
	println!("x:{}", x);

	let y = Box::new("hello Box");
	println!("y:{}", y);

	let vec = Box::new(vec![1, 2, 3, 4, 5, 6]);

	println!("vec:{:?}", vec);
}
```

#### 2.Rc 智能指针

Rc（Reference Counting）智能指针用于在 Rust 中进行引用计数共享所有权。它允许对数据进行多次所有权共享，且可以动态跟踪当前的引用计数。

示例代码展示了如何在多线程环境中使用 Arc 来创建引用计数的数据，并通过 Mutex 来实现内部数据的可变性控制。
```rust
fn rc_pointer_test()  {
	//需要在 Rust 中进行引用计数共享所有权时，可以使用 Rc<T> 智能指针
	let data = Rc::new("hello");
	println!("data Rc count:{}", Rc::strong_count(&data));
	let clone_data = Rc::clone(&data);
	println!("clone_data Rc count:{}", Rc::strong_count(&clone_data));

	{
		let d = Rc::clone(&data);
		println!("data Rc count:{}, d1 rc count:{}", Rc::strong_count(&data), Rc::strong_count(&d));
	}

	println!("data res Rc count:{}", Rc::strong_count(&data));
}
```

#### 3.Arc 智能指针

Arc（Atomic Reference Counting）智能指针是 Rc 的线程安全版本，适用于多线程环境中对数据进行共享所有权。

示例代码展示了如何在多线程环境中使用 Arc 来创建引用计数的数据，并通过 Mutex 来实现内部数据的可变性控制。

```rust
fn arc_pointer_test() {
	//在 Rust 中进行跨线程共享所有权时，可以使用 Arc<T> 智能指针。
	// 示例代码，如何使用 Arc<T> 来创建引用计数的数据，以便在多线程环境中共享：
	// 同时需要使用 Mutex 或 RwLock 来实现内部数据的可变性控制。

	let data = Arc::new(Mutex::new(vec![1, 2, 3]));
	let data_clone = Arc::clone(&data);

	let handle = thread::spawn(move || {
		let mut data = data_clone.lock().unwrap();
		println!("child thread data {:?}", data);

		for i in data.iter_mut() {
			*i += 5;
		}

		println!("child thread update data {:?}", data);
	});

	handle.join().unwrap();
	let res = data.lock().unwrap();
	println!("main thread data:{:?} ", res);
}

```

#### 4.RefCell 智能指针

RefCell 提供了内部可变性，允许在不可变引用的同时对数据进行修改。它适用于在编译时无法确定是否需要可变性的场景。

示例代码展示了如何使用 RefCell 来获取可变和不可变借用，并在不同条件下对数据进行修改和访问。

```rust
fn refcell_pointer_test() {

	//RefCell: 提供了内部可变性，允许在不可变引用的同时对数据进行修改。适用于在编译时无法确定是否需要可变性的场景
	let data = RefCell::new(vec![1, 2, 3, 4, 5, 6]);

	// 获取可变借用
	{
		let mut borrowed_data = data.borrow_mut();
		for i in 100..110  {
			borrowed_data.push(i);
		}
	}

	// 获取不可变借用
	let borrowed_data = data.borrow();
	for i in borrowed_data.iter() {
		println!("Data: {}", i);
	}
}
```

#### 5.Cell 智能指针

Cell 是一个轻量级的可变容器，适用于需要在不可变引用中进行数据更新的场景。

示例代码展示了如何使用 Cell 来在多线程中对数据进行原子性更新操作，并获取最终的数据值。

```rust
fn cell_test() {
	let data = Arc::new(Mutex::new(Cell::new(0)));

	let threads: Vec<_> = (0..6).map(|_| {
		let thread_data = Arc::clone(&data);
		thread::spawn(move || {
			for  _ in 0..10 {
				let value = thread_data.lock().unwrap();
				let cur_value = value.get();
				value.set(cur_value + 100);
			}
		})
	}).collect();

	for thread_item in threads  {
		thread_item.join().unwrap();
	}

	println!("Final data value: {}", data.lock().unwrap().get());
}
```

#### 6.效果

```shell
---smart_pointer_test---
x:10
y:hello Box
vec:[1, 2, 3, 4, 5, 6]
data Rc count:1
clone_data Rc count:2
data Rc count:3, d1 rc count:3
data res Rc count:2
child thread data [1, 2, 3]
child thread update data [6, 7, 8]
main thread data:[6, 7, 8] 
Data: 1
Data: 2
Data: 3
Data: 4
Data: 5
Data: 6
Data: 100
Data: 101
Data: 102
Data: 103
Data: 104
Data: 105
Data: 106
Data: 107
Data: 108
Data: 109
Final data value: 6000
```