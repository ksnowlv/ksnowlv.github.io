---
title: "Rust线程沲"
date: 2024-01-29T23:20:17+08:00
lastmod: 2024-01-29T23:20:17+08:00
keywords: ["rust","线程沲", "rayon"]
tags: ["rust","线程沲"]
categories: ["rust","线程沲"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## rust线程沲

### 1.背景
如果在rust中使用线程沲,因rust自身没有ThreadPool,需要使用第三方库；例如：知名的[rayon](https://github.com/rayon-rs/rayon)

### 2.解决方案

在Cargo.toml中添加**rayon**的配置，最新版本为1.8

```toml
[dependencies]
rayon = "1.8.0"
```

### 3.使用示例

```rust
use rayon::prelude::*;
pub fn thread_pool_test() {

	let mut  v = Box::new(Vec::new());
    //注意别越界了
	let v_size: u64 = 10000000;
	v.reserve(v_size.try_into().unwrap());
	for i in 0..v_size  {
		v.push(i);
	}

	let sum:  u64 = v.into_par_iter().map(|i| {
			i
		})
		.sum();

	println!("v sum:{}", sum);
}
```

### 4.效果

```shell
v sum:49999995000000
```
