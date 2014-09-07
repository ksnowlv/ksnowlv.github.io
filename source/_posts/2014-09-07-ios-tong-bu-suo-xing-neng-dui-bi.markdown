---
layout: post
title: "iOS同步锁性能对比"
date: 2014-09-07 10:42
comments: true
categories: iOS-多线程
---

线程间调度经常会涉及到同步。
在iOS开发中，各种各样同步方法。

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
  
