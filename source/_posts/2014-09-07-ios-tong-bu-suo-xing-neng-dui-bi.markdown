---
layout: post
title: "iOS同步对象性能对比"
date: 2014-09-07 10:42
comments: true
categories: iOS-多线程
---

在iOS开发中，支持多种同步方法，我们从耗时角度出发，评估各种同步对象的性能。

``` objective-c

 1.@synchronized 
 2.NSLock
 3.NSCondition
 4.NSConditionLock
 5.NSRecursiveLock
 6.pthread_mutex_t
 7.OSSpinLock
 8.dispatch_barrier_async
```
示例代码如下：

``` objective-c
  const NSInteger KRunTimes = 1000 * 1000;

  double curTime, lastTime;

  // 1.同步synchronized
  id obj = [NSObject new];

  lastTime = CFAbsoluteTimeGetCurrent();
  for (NSInteger i = 0; i < KRunTimes; ++i) {
    @synchronized(obj) {
    }
  }
  curTime = CFAbsoluteTimeGetCurrent();
  NSLog(@"@synchronized: %f ms", (curTime - lastTime) * 1000);

  // 2.NSLock
  NSLock *myLock = [NSLock new];

  lastTime = CFAbsoluteTimeGetCurrent();
  for (NSInteger i = 0; i < KRunTimes; ++i) {
    [myLock lock];
    [myLock unlock];
  }
  curTime = CFAbsoluteTimeGetCurrent();
  NSLog(@"NSLock: %f ms", (curTime - lastTime) * 1000);

  // NSLock IMP
  typedef void (*func)(id, SEL);
  SEL lockSEL = @selector(lock);
  SEL unlockSEL = @selector(unlock);
  func lockFunc = (void (*)(id, SEL))[myLock methodForSelector : lockSEL];
  func unlockFunc = (void (*)(id, SEL))[myLock methodForSelector : unlockSEL];

  lastTime = CFAbsoluteTimeGetCurrent();
  for (NSInteger i = 0; i < KRunTimes; ++i) {
    lockFunc(myLock, lockSEL);
    unlockFunc(myLock, unlockSEL);
  }

  curTime = CFAbsoluteTimeGetCurrent();
  NSLog(@"NSLock + IMP: %f ms", (curTime - lastTime) * 1000);

  // 3.NSCondition
  NSCondition *condition = [[NSCondition alloc] init];
  lastTime = CFAbsoluteTimeGetCurrent();
  for (NSInteger i = 0; i < KRunTimes; ++i) {
    [condition lock];
    [condition unlock];
  }
  curTime = CFAbsoluteTimeGetCurrent();
  NSLog(@"NSCondition: %f ms", (curTime - lastTime) * 1000);

  // 4.NSConditionLock
  NSConditionLock *conditionLock = [[NSConditionLock alloc] init];
  lastTime = CFAbsoluteTimeGetCurrent();
  for (NSInteger i = 0; i < KRunTimes; ++i) {
    [conditionLock lock];
    [conditionLock unlock];
  }
  curTime = CFAbsoluteTimeGetCurrent();
  NSLog(@"NSConditionLock: %f ms", (curTime - lastTime) * 1000);

  // 5.NSRecursiveLock
  NSRecursiveLock *recursiveLock = [[NSRecursiveLock alloc] init];
  lastTime = CFAbsoluteTimeGetCurrent();
  for (NSInteger i = 0; i < KRunTimes; ++i) {
    [recursiveLock lock];
    [recursiveLock unlock];
  }
  curTime = CFAbsoluteTimeGetCurrent();
  NSLog(@"NSRecursiveLock: %f ms", (curTime - lastTime) * 1000);

  // 6.pthread_mutex_t
  pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

  lastTime = CFAbsoluteTimeGetCurrent();
  for (NSInteger i = 0; i < KRunTimes; ++i) {
    pthread_mutex_lock(&mutex);
    pthread_mutex_unlock(&mutex);
  }

  curTime = CFAbsoluteTimeGetCurrent();
  NSLog(@"pthread_mutex: %f ms", (curTime - lastTime) * 1000);
  pthread_mutex_destroy(&mutex);

  // 7.OSSpinLock 自旋锁;
  OSSpinLock spinlock = OS_SPINLOCK_INIT;
  lastTime = CFAbsoluteTimeGetCurrent();
  for (NSInteger i = 0; i < KRunTimes; ++i) {
    OSSpinLockLock(&spinlock);
    OSSpinLockUnlock(&spinlock);
  }

  curTime = CFAbsoluteTimeGetCurrent();
  NSLog(@"OSSpinlock: %f ms", (curTime - lastTime) * 1000);

  // 8 dispatch_barrier_async
  dispatch_queue_t queue =
      dispatch_queue_create("com.qq.ksnow", DISPATCH_QUEUE_CONCURRENT);

  lastTime   = CFAbsoluteTimeGetCurrent();
  for (NSInteger i = 0; i < KRunTimes; ++i) {
    dispatch_barrier_async(queue, ^{});
  }
  curTime = CFAbsoluteTimeGetCurrent();
  NSLog(@"@dispatch_barrier_async: %f ms", (curTime - lastTime) * 1000);
  
```

###一.模拟器/iOS7/XCode6下性能对比
####日志情况:

     2014-09-07 11:26:48.071 LockTest[2713:98107] @synchronized: 232.551038 ms
    
    2014-09-07 11:26:48.173 LockTest[2713:98107] NSLock: 100.879967 ms
    2014-09-07 11:26:48.263 LockTest[2713:98107] NSLock + IMP: 89.570999 ms
    2014-09-07 11:26:48.353 LockTest[2713:98107] NSCondition: 89.850008 ms
    2014-09-07 11:26:48.587 LockTest[2713:98107] NSConditionLock: 233.431995 ms
    2014-09-07 11:26:48.677 LockTest[2713:98107] NSRecursiveLock: 89.230001 ms
    2014-09-07 11:26:48.740 LockTest[2713:98107] pthread_mutex: 62.326968 ms
    2014-09-07 11:26:48.750 LockTest[2713:98107] OSSpinlock: 10.430992 ms
    2014-09-07 11:26:49.985 LockTest[2713:98107] dispatch_barrier_async: 1234.429002 ms



####总结对比

![image](/images/post/2014-09-07-ios-tong-bu-suo-xing-neng-dui-bi/syn_compared_simulate.png)

####二.iPad Mini2/iOS7/XCode6下性能对比

    2014-09-07 13:32:47.720 LockTest[3494:60b] @synchronized: 499.736011 ms
    2014-09-07 13:32:47.948 LockTest[3494:60b] NSLock: 227.194011 ms
    2014-09-07 13:32:48.170 LockTest[3494:60b] NSLock + IMP: 221.384048 ms
    2014-09-07 13:32:48.393 LockTest[3494:60b] NSCondition: 221.689999 ms
    2014-09-07 13:32:49.030 LockTest[3494:60b] NSConditionLock: 636.340976 ms
    2014-09-07 13:32:49.260 LockTest[3494:60b] NSRecursiveLock: 229.423046 ms
    2014-09-07 13:32:49.431 LockTest[3494:60b] pthread_mutex: 170.615971 ms
    2014-09-07 13:32:49.495 LockTest[3494:60b] OSSpinlock: 63.916981 ms
    2014-09-07 13:32:49.826 LockTest[3494:60b] dispatch_barrier_async: 329.769015 ms

![image](/images/post/2014-09-07-ios-tong-bu-suo-xing-neng-dui-bi/syn_compared_ipad_mini2.png)

###总结

* 耗时方面：
    
  - OSSpinlock耗时最少;
  - pthread_mutex其次。
  - NSLock/NSCondition/NSRecursiveLock 耗时接近，220ms上下居中。  
  - NSConditionLock最差，我们常用synchronized倒数第二。
  - dispatch_barrier_async也许，性能并不像我们想象中的那么好.推测与线程同步调度开销有关。单独block耗时在1ms以下基本上可以忽略不计的。
* 在访问次数比较多的情况下,IMP访问耗时要比消息发送略小。
  参看`NSLock`与`NSLock + IMP`对比。
  
* 为什么不直接使用**IMP**而使用直接声明函数指针的方式?
  XCode6下IMP不能指定参数，报错如下：
  ![image](/images/post/2014-09-07-ios-tong-bu-suo-xing-neng-dui-bi/error_overview.png) 
  如何解决呢？修改LLVM预处理设置即可。详情见[XCode6下Too many arguments to function call, expected 0, have 2解决办法](http://ksnowlv.gitcafe.com/blog/2014/09/07/xcode6-too-many-arguments-to-function-call-expected-0-have-2/)
  
###原因分析

####1.synchronized 

    会创建一个异常捕获handler和一些内部的锁。所以，使用@synchronized替换普通锁的代价是，你付出更多的时间消耗。
####2.NSConditionLock
    
    条件锁，与特定的，用户定义的条件有关。可以确保一个线程可以获取满足一定条件的锁。
    内部会涉及到信号量机制，一旦一个线程获得锁后，它可以放弃锁并设置相关条件;其它线程竞争该锁。
    线程之间的竞争激烈，涉及到条件锁检测，线程间通信。系统调用，上下切换方切换比较频繁。
####3.OSSpinLock

    自旋锁几乎不进入内核，仅仅是重新加载自旋锁。
    如果自旋锁被占用时间是几十，上百纳秒，性能还是挺高的。减少了代价较高的系统调用和一系列上下文言切换。
    但是，该锁不是万能的;如果该锁抢占比较多的时候，不要使用该锁。会占用较多cpu,导致耗电较多。
    这种情况下使用pthread_mutex虽然耗时多一点，但是，避免了电量过多的消耗。是不错的选择。
    
####4.pthread_mutex

    底层的API还是性能比较高啊，在各种同步对象中，性能属于佼佼者。

  
