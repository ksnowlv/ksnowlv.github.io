---
title: "Android线程池"
date: 2015-04-28
lastmod: 2015-04-28
categories:
  - "Android"
tags:
  - "多线程"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

**ExecutorService**继承**Executor**，是线程池的一个服务，可以随时关闭线程池。

**Executors**是个工厂类，专门创建各种线程池。


## 一.Android常用的线程池有以下四种
### 1.newFixedThreadPool
	创建一个定长线程池，可控制线程最大并发数，超出的线程会在队列中等待.

### 2.newSingleThreadExecutor
	创建一个单线程化的线程池，它只会用唯一的工作线程来执行任务，保证所有任务按照指定顺序(FIFO, LIFO, 优先级)执行
	
### 3.newScheduledThreadPool
	创建一个定长线程池，支持定时及周期性任务执行
	
### 4.newCachedThreadPool
	创建一个可缓存线程池，如果线程池长度超过处理需要，可灵活回收空闲线程，若无可回收，则新建线程.
	
	
## 二.new Thread的缺点：
### 1.性能变差	

每次new Thread新建线程，导致性能变差。
### 2.线程缺乏统一调度，造成资源浪费
	
可能无节制的频繁创建线程，无法复用；相互之间竞争，及可能占用过多系统资源导致死机或oom。

## 三.Executors线程池优点
### 1.重用线程对象	减少线程对象创建、销毁的开销。
### 2.有效控制线程的系统开销* 可以根据需要控制线程数最大并发数。
* 提高系统资源的使用率，降低内存/CPU占用，避免过多资源竞争，避免堵塞。

### 3.提供定时执行、定期执行、单线程、并发数控制等功能。
## 四.线程沲实质：一种特殊的对象池

	
	
	
